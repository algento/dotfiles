"""SDK model regression: handshake success must be reported as connected."""
import contextlib
import importlib.util
import io
import json
from pathlib import Path
from types import SimpleNamespace
import unittest
from unittest.mock import patch
from mcp import types

spec = importlib.util.spec_from_file_location('verify_mcp', Path(__file__).with_name('verify_mcp_connection.py'))
m = importlib.util.module_from_spec(spec)
spec.loader.exec_module(m)


class VerificationTests(unittest.IsolatedAsyncioTestCase):
    async def test_successful_sdk_initialize_reports_version(self):
        initialized = types.InitializeResult(protocol_version='2025-11-25',
                                            capabilities=types.ServerCapabilities(),
                                            server_info=types.Implementation(name='fixture', version='1.2.3'))
        class Session:
            async def initialize(self):
                return initialized
            async def list_tools(self):
                return SimpleNamespace(tools=[object()])
        @contextlib.asynccontextmanager
        async def transport(*args, **kwargs):
            yield object(), object()
        @contextlib.asynccontextmanager
        async def session(*args, **kwargs):
            yield Session()
        output = io.StringIO()
        with patch.object(m, 'stdio_client', transport), patch.object(m, 'ClientSession', session), contextlib.redirect_stdout(output):
            success = await m.verify('fixture', {'command': 'unused'}, '/private/tmp')
        self.assertTrue(success, output.getvalue())
        self.assertEqual(json.loads(output.getvalue()), {'server': 'fixture', 'connected': True, 'version': '1.2.3', 'tool_count': 1})
