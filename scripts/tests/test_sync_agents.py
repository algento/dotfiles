"""Integration checks against isolated homes; never use real user configurations."""
import copy
import importlib.machinery
import importlib.util
import json
import os
from pathlib import Path
import stat
import tempfile
import unittest
from unittest.mock import patch

loader = importlib.machinery.SourceFileLoader('sync_agents', str(Path(__file__).resolve().parents[1] / 'sync-agents'))
spec = importlib.util.spec_from_loader(loader.name, loader)
m = importlib.util.module_from_spec(spec)
loader.exec_module(m)


class SyncTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='sync-agents-test-')
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        # A space and a quote exercise shell quoting of the home variable.
        self.home = self.root / "home's space"
        self.home.mkdir()
        self.manifest = self.root / 'servers.json'
        self.sources = self.root / 'sources.json'
        self.data = {'schema_version': 1, 'servers': {
            'shared': {'transport': 'stdio', 'command': '/bin/bash', 'args': ['-c', 'true'],
                       'enabled': True, 'targets': list(m.TARGETS)}}}
        self.manifest.write_bytes(m.encode(self.data))
        self.sources.write_bytes(m.encode({'schema_version': 1, 'servers': {'shared': {'source': 'fixture'}}}))
        self.paths = {a: self.home / r for a, (r, _) in m.TARGETS.items()}
        for path in self.paths.values():
            path.parent.mkdir(parents=True, exist_ok=True)
        self.paths['codex'].write_text('# user header\nmodel = "keep" # comment\n\n[mcp_servers.private]\ncommand = "user-server" # private comment\n')
        self.paths['claude'].write_bytes(m.encode({'account': {'secret': 'DO-NOT-OUTPUT'}, 'projects': {'mine': True}, 'mcpServers': {'private': {'command': 'mine'}}}))
        self.paths['antigravity'].write_bytes(m.encode({'extra': [1, 2], 'mcpServers': {'private': {'url': 'https://example.invalid'}}}))
        self.sync = m.Sync(self.home, self.manifest, self.sources)

    def plan(self):
        return self.sync.build()[0]

    def apply(self):
        return self.sync.apply(self.plan())

    def test_preservation_idempotence_permissions_and_restore(self):
        originals = {a: p.read_bytes() for a, p in self.paths.items()}
        os.chmod(self.paths['codex'], 0o640)
        result = self.apply()
        self.assertEqual(set(result['changed_configs']), set(m.TARGETS))
        text = self.paths['codex'].read_text()
        self.assertIn('# user header', text)
        self.assertIn('model = "keep" # comment', text)
        self.assertIn('command = "user-server" # private comment', text)
        self.assertEqual(json.loads(self.paths['claude'].read_bytes())['account'], {'secret': 'DO-NOT-OUTPUT'})
        self.assertEqual(json.loads(self.paths['antigravity'].read_bytes())['extra'], [1, 2])
        after = {a: p.read_bytes() for a, p in self.paths.items()}
        self.assertEqual(self.apply(), {'status': 'unchanged'})
        self.assertEqual(after, {a: p.read_bytes() for a, p in self.paths.items()})
        self.assertNotIn('DO-NOT-OUTPUT', json.dumps(self.plan()))
        self.assertEqual(stat.S_IMODE(self.paths['codex'].stat().st_mode), 0o640)
        self.assertEqual(stat.S_IMODE(self.sync.directory.stat().st_mode), 0o700)
        for p in Path(result['backup']).iterdir():
            self.assertEqual(stat.S_IMODE(p.stat().st_mode), 0o600)
        self.sync.restore(result['backup'])
        self.assertEqual(originals, {a: p.read_bytes() for a, p in self.paths.items()})
        self.assertFalse(self.sync.state_path.exists())
        self.assertEqual(self.sync.restore(result['backup'])['status'], 'already-restored')

    def test_adoption_does_not_rewrite_files(self):
        self.apply()
        self.sync.state_path.unlink()
        before = {a: m.snapshot(p) for a, p in self.paths.items()}
        self.assertTrue(all(t['actions'][0]['action'] == 'adopt' for t in self.plan()['targets']))
        self.assertEqual(self.apply()['changed_configs'], [])
        self.assertEqual(before, {a: m.snapshot(p) for a, p in self.paths.items()})

    def test_check_is_read_only(self):
        before = {a: m.snapshot(p) for a, p in self.paths.items()}
        self.plan()
        self.assertFalse(self.sync.directory.exists())
        self.assertEqual(before, {a: m.snapshot(p) for a, p in self.paths.items()})

    def test_stale_config_manifest_sources_state_and_link(self):
        for kind in ('config', 'manifest', 'sources', 'state', 'link'):
            with self.subTest(kind=kind):
                plan = self.plan()
                path = {'config': self.paths['claude'], 'manifest': self.manifest, 'sources': self.sources}.get(kind)
                if path:
                    raw = path.read_bytes()
                    path.write_bytes(raw + b'\n')
                elif kind == 'state':
                    self.sync.directory.mkdir(parents=True, mode=0o700, exist_ok=True)
                    self.sync.state_path.write_bytes(m.encode(self.sync.state()))
                else:
                    path = self.paths['claude']
                    raw = path.read_bytes()
                    other = self.root / 'other.json'
                    other.write_bytes(raw)
                    path.unlink()
                    path.symlink_to(other)
                with self.assertRaisesRegex(m.SyncError, 'stale'):
                    self.sync.apply(plan)
                if kind == 'state':
                    self.sync.state_path.unlink()
                elif kind == 'link':
                    path.unlink()
                    path.write_bytes(raw)
                else:
                    path.write_bytes(raw)

    def test_unmanaged_conflict_and_extra_fields(self):
        data = json.loads(self.paths['claude'].read_bytes())
        data['mcpServers']['shared'] = {'command': 'different', 'args': []}
        self.paths['claude'].write_bytes(m.encode(data))
        before = {a: p.read_bytes() for a, p in self.paths.items()}
        with self.assertRaisesRegex(m.SyncError, 'conflicting'):
            self.apply()
        self.assertEqual(before, {a: p.read_bytes() for a, p in self.paths.items()})
        data['mcpServers']['shared'] = {'command': '/bin/bash', 'args': ['-c', 'true'], 'env': {'TOKEN': 'SECRET'}}
        self.paths['claude'].write_bytes(m.encode(data))
        with self.assertRaisesRegex(m.SyncError, 'conflicting'):
            self.apply()
        self.assertNotIn('SECRET', json.dumps(self.plan()))

    def test_managed_change_remove_and_user_edit_conflict(self):
        self.apply()
        self.data['servers']['shared']['args'] = ['-c', 'echo new']
        self.manifest.write_bytes(m.encode(self.data))
        self.assertTrue(all(t['actions'][0]['action'] == 'change' for t in self.plan()['targets']))
        self.apply()
        data = json.loads(self.paths['claude'].read_bytes())
        data['mcpServers']['shared']['args'] = ['user-edit']
        self.paths['claude'].write_bytes(m.encode(data))
        self.data['servers']['shared']['enabled'] = False
        self.manifest.write_bytes(m.encode(self.data))
        with self.assertRaisesRegex(m.SyncError, 'conflicting'):
            self.apply()
        data['mcpServers']['shared']['args'] = ['-c', 'echo new']
        self.paths['claude'].write_bytes(m.encode(data))
        self.apply()
        for a, p in self.paths.items():
            parsed = m.parse(p.read_bytes(), a)
            self.assertNotIn('shared', parsed[m.TARGETS[a][1]])
            self.assertIn('private', parsed[m.TARGETS[a][1]])

    def test_symlinks_preserved(self):
        path = self.paths['codex']
        target = self.root / 'config.toml'
        path.rename(target)
        path.symlink_to(target)
        result = self.apply()
        self.assertTrue(path.is_symlink())
        self.assertIn('[mcp_servers.shared]', target.read_text())
        self.sync.restore(result['backup'])
        self.assertTrue(path.is_symlink())
        self.assertNotIn('[mcp_servers.shared]', target.read_text())

    def test_partial_failure_recovery(self):
        originals = {a: p.read_bytes() for a, p in self.paths.items()}
        real_write = m.atomic_write
        def fail_claude(path, *args):
            if path == self.paths['claude'].resolve():
                raise OSError('injected failure')
            return real_write(path, *args)
        with patch.object(m, 'atomic_write', side_effect=fail_claude):
            with self.assertRaisesRegex(m.SyncError, 'partial apply'):
                self.apply()
        with self.assertRaisesRegex(m.SyncError, 'unfinished'):
            self.plan()
        backup = next((self.sync.directory / 'backups').iterdir())
        self.assertEqual(list(self.sync.state()['managed']['codex']), ['shared'])
        self.sync.restore(backup)
        self.assertEqual(originals, {a: p.read_bytes() for a, p in self.paths.items()})
        self.apply()

    def test_corrupt_state_invalid_config_and_schema(self):
        self.apply()
        self.sync.state_path.write_text('{broken')
        with self.assertRaises(m.SyncError):
            self.plan()
        self.sync.state_path.unlink()
        self.paths['codex'].write_text('[broken')
        with self.assertRaises(m.SyncError):
            self.plan()
        self.data['servers']['shared']['transport'] = 'http'
        self.manifest.write_bytes(m.encode(self.data))
        with self.assertRaisesRegex(m.SyncError, 'unsupported'):
            self.plan()

    def test_restore_refuses_drift_and_corrupt_backup(self):
        result = self.apply()
        path = self.paths['claude']
        original = path.read_bytes()
        path.write_bytes(original + b'\n')
        with self.assertRaisesRegex(m.SyncError, 'changed since backup'):
            self.sync.restore(result['backup'])
        path.write_bytes(original)
        (Path(result['backup']) / 'claude.before').write_bytes(b'{}')
        with self.assertRaisesRegex(m.SyncError, 'backup content hash'):
            self.sync.restore(result['backup'])
        self.assertEqual(path.read_bytes(), original)

    def test_missing_auth_and_shell_quoting(self):
        server = self.data['servers']['shared']
        server['command'] = 'bash'
        server['args'] = ['-c', 'source ${HOME}/auth.env && true']
        server['auth_file'] = '${HOME}/auth.env'
        self.manifest.write_bytes(m.encode(self.data))
        plan = self.plan()
        self.assertIn("'", plan['targets'][0]['managed']['shared']['args'][1])
        with self.assertRaisesRegex(m.SyncError, 'missing prerequisite'):
            self.sync.apply(plan)
        auth = self.home / 'auth.env'
        auth.write_text('TOKEN=DO-NOT-READ')
        os.chmod(auth, 0o644)
        with self.assertRaisesRegex(m.SyncError, 'non-private'):
            self.apply()
        os.chmod(auth, 0o600)
        self.apply()

    def test_target_removal_and_manifest_removal(self):
        self.apply()
        self.data['servers']['shared']['targets'].remove('claude')
        self.manifest.write_bytes(m.encode(self.data))
        self.apply()
        self.assertNotIn('shared', json.loads(self.paths['claude'].read_bytes())['mcpServers'])
        self.data['servers'] = {}
        self.manifest.write_bytes(m.encode(self.data))
        self.apply()
        self.assertTrue(all(not x for x in self.sync.state()['managed'].values()))

    def test_lock_contention_and_private_state(self):
        with self.sync.lock():
            with self.assertRaisesRegex(m.SyncError, 'another'):
                self.apply()
        os.chmod(self.sync.directory, 0o755)
        with self.assertRaisesRegex(m.SyncError, 'private directory'):
            self.apply()

    def test_duplicate_keys_empty_json_and_invalid_server_shape(self):
        for raw in (b'{"mcpServers": {}, "mcpServers": {}}', b'', b'{"mcpServers":{"shared":"bad"}}'):
            with self.subTest(raw=raw):
                self.paths['claude'].write_bytes(raw)
                with self.assertRaises(m.SyncError):
                    self.plan()

    def test_missing_configuration_and_parent_preflight(self):
        self.paths['claude'].unlink()
        result = self.apply()
        self.assertIn('shared', json.loads(self.paths['claude'].read_bytes())['mcpServers'])
        self.sync.restore(result['backup'])
        self.assertFalse(self.paths['claude'].exists())
        self.paths['codex'].unlink()
        self.paths['codex'].parent.rmdir()
        before = self.paths['antigravity'].read_bytes()
        with self.assertRaisesRegex(m.SyncError, 'missing config parent'):
            self.apply()
        self.assertEqual(before, self.paths['antigravity'].read_bytes())

    def test_link_detachment_is_reported(self):
        with patch.dict(m.MANAGED_LINKS, {'codex': self.paths['codex']}):
            self.assertEqual(self.plan()['targets'][0]['link_status'], 'unlinked')
            original = self.root / 'managed.toml'
            self.paths['codex'].rename(original)
            self.paths['codex'].symlink_to(original)
            with patch.dict(m.MANAGED_LINKS, {'codex': original}):
                self.assertEqual(self.plan()['targets'][0]['link_status'], 'managed-link')

    def test_restore_interruption_can_be_retried(self):
        originals = {a: p.read_bytes() for a, p in self.paths.items()}
        result = self.apply()
        real_write = m.atomic_write
        def fail_claude(path, *args):
            if path == self.paths['claude'].resolve():
                raise OSError('injected restore failure')
            return real_write(path, *args)
        with patch.object(m, 'atomic_write', side_effect=fail_claude):
            with self.assertRaises(OSError):
                self.sync.restore(result['backup'])
        with self.assertRaisesRegex(m.SyncError, 'unfinished'):
            self.plan()
        self.sync.restore(result['backup'])
        self.assertEqual(originals, {a: p.read_bytes() for a, p in self.paths.items()})


if __name__ == '__main__':
    unittest.main()
