#!/usr/bin/env python3
"""
Project-specific MCP setup wrapper for som-app
"""
import sys
from pathlib import Path

# Add global MCP scripts to path
global_mcp = Path("/Users/slavisam/projects/mcp")
sys.path.insert(0, str(global_mcp / "scripts"))

from setup_global_mcp import GlobalMCPSetup

if __name__ == "__main__":
    setup = GlobalMCPSetup()
    setup.setup_project("/Users/slavisam/projects/som-app", "flutter")
