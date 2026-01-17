# Agents & MCP Servers

## Dart MCP Server
**Status**: Active & Verified
**Protocol Version**: 2024-11-05
**Server Version**: 0.1.0

### Server Location
The server is available as a Dart AOT snapshot included with the Flutter SDK:
- **Snapshot Path**: `/Users/slavisam/bin/flutter/bin/cache/dart-sdk/bin/snapshots/dart_mcp_server_aot.dart.snapshot`
- **Execution Command**: 
  ```bash
  /Users/slavisam/bin/flutter/bin/cache/dart-sdk/bin/dartaotruntime /Users/slavisam/bin/flutter/bin/cache/dart-sdk/bin/snapshots/dart_mcp_server_aot.dart.snapshot
  ```

### Capabilities (Tools)
The server exposes the following tools for AI assistance:

1.  **`test_run`**
    -   Runs tests with support for filtering, tagging, and platform selection (vm, chrome, node).
2.  **`create_project`**
    -   Creates new Dart/Flutter projects from templates.
3.  **`pub`**
    -   Manages packages: `add`, `get`, `remove`, `upgrade`.
    -   Use this for adding dependencies instead of editing `pubspec.yaml` manually when possible.
4.  **`analyze_files`**
    -   Performs project-wide static analysis.
5.  **`resolve_workspace_symbol`**
    -   Fuzzy searches for symbols (classes, functions) across the workspace.
6.  **`signature_help` / `hover`**
    -   Provides code intelligence and documentation at specific file positions.

### Resources
-   Currently, no direct **resources** (read-only data streams) are exposed by this server.

### Usage
When working with Dart/Flutter:
-   Prefer using the **`pub`** tool for dependency management.
-   Use **`test_run`** for executing test suites.
-   Use **`analyze_files`** to check for errors after significant changes.
