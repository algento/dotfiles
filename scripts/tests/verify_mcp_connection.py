#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = ["mcp==2.3.0"]
# ///
"""Opt-in MCP handshake/tool discovery only; never call service tools."""
import argparse
import asyncio
import json
import os
from pathlib import Path
import tempfile

from mcp import ClientSession, StdioServerParameters
from mcp.client.stdio import stdio_client


async def verify(name, config, cwd):
    try:
        async with asyncio.timeout(45):
            params = StdioServerParameters(command=config['command'], args=config.get('args', []), cwd=cwd)
            with open(os.devnull, 'w') as errors:
                async with stdio_client(params, errlog=errors) as (read, write):
                    async with ClientSession(read, write) as session:
                        initialized = await session.initialize()
                        listed = await session.list_tools()
                        if not listed.tools:
                            raise ValueError('empty tool list')
                        print(json.dumps({'server': name, 'connected': True,
                                          'version': initialized.server_info.version,
                                          'tool_count': len(listed.tools)}), flush=True)
                        return True
    except Exception as error:
        print(json.dumps({'server': name, 'connected': False,
                          'error_type': type(error).__name__}), flush=True)
        return False


async def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--config', type=Path, default=Path.home() / '.gemini/config/mcp_config.json')
    args = parser.parse_args()
    servers = json.loads(args.config.read_bytes())['mcpServers']
    with tempfile.TemporaryDirectory(prefix='sync-agents-mcp-', dir='/private/tmp') as cwd:
        results = await asyncio.gather(*(verify(name, servers[name], cwd)
                                        for name in ('devonthink', 'raindrop', 'zotero')))
    return 0 if all(results) else 1


if __name__ == '__main__':
    raise SystemExit(asyncio.run(main()))
