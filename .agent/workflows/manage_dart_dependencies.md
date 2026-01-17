---
description: Manage Dart dependencies using MCP
---

1. Identify the package to add or remove.
2. If adding, verify the package name and compatibility on pub.dev.
3. Use the `pub` tool from the Dart MCP server to modify dependencies.
   - Command: `pub`
   - Arguments: `{"command": "add", "packageName": "<name>"}` or `{"command": "remove", "packageName": "<name>"}`
// turbo
4. Run `flutter pub get` or `dart pub get` to ensure `pubspec.lock` is updated (if not automatically handled).
5. Verify the `pubspec.yaml` and `pubspec.lock` changes.
