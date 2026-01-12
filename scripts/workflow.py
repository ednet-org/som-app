#!/usr/bin/env python3
"""
Project workflow wrapper for som-app
"""
import sys
import asyncio
from pathlib import Path

# Add global MCP scripts to path
global_mcp = Path("/Users/slavisam/projects/mcp")
sys.path.insert(0, str(global_mcp / "scripts"))

from dev_workflow import DevWorkflow

async def main():
    if len(sys.argv) < 2:
        print("Usage: python3 workflow.py <workflow_type> [options]")
        print("Available workflows: pre-commit, feature-start, code-review, translation-sync, domain-analysis, asset-optimization, full-check")
        sys.exit(1)
    
    workflow = DevWorkflow("/Users/slavisam/projects/som-app")
    workflow_type = sys.argv[1]
    
    # Parse additional arguments
    kwargs = {}
    for i in range(2, len(sys.argv), 2):
        if i + 1 < len(sys.argv):
            key = sys.argv[i].lstrip('--').replace('-', '_')
            value = sys.argv[i + 1]
            kwargs[key] = value
    
    success = await workflow.run_workflow(workflow_type, **kwargs)
    sys.exit(0 if success else 1)

if __name__ == "__main__":
    asyncio.run(main())
