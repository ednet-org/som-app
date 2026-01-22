
## 🧠 MANDATORY MEMORY COORDINATION PROTOCOL

### 🚨 CRITICAL: Every Agent MUST Write AND Read Memory

**EVERY spawned agent MUST follow this exact pattern:**

```javascript
// 1️⃣ IMMEDIATELY when agent starts - WRITE initial status
mcp__claude-flow__memory_usage {
  action: "store",
  key: "swarm/[agent-name]/status",
  namespace: "coordination",
  value: JSON.stringify({
    agent: "[agent-name]",
    status: "starting",
    timestamp: Date.now(),
    tasks: ["list", "of", "tasks"],
    progress: 0
  })
}

// 2️⃣ AFTER EACH MAJOR STEP - WRITE progress
mcp__claude-flow__memory_usage {
  action: "store",
  key: "swarm/[agent-name]/progress",
  namespace: "coordination",
  value: JSON.stringify({
    completed: ["task1", "task2"],
    current: "working on task3",
    progress: 35,
    files_created: ["file1.js"],
    interfaces: { "API": "definition" },
    dependencies_needed: []
  })
}

// 3️⃣ SHARE ARTIFACTS - WRITE for others
mcp__claude-flow__memory_usage {
  action: "store",
  key: "swarm/shared/[component]",
  namespace: "coordination",
  value: JSON.stringify({
    type: "interface",
    definition: "actual code here",
    created_by: "[agent-name]"
  })
}

// 4️⃣ CHECK DEPENDENCIES - READ then WAIT
const dep = mcp__claude-flow__memory_usage {
  action: "retrieve",
  key: "swarm/shared/[component]",
  namespace: "coordination"
}
if (!dep.found) {
  // Write waiting status
  mcp__claude-flow__memory_usage {
    action: "store",
    key: "swarm/[agent-name]/waiting",
    namespace: "coordination",
    value: JSON.stringify({
      waiting_for: "[component]",
      from: "[other-agent]"
    })
  }
}

// 5️⃣ SIGNAL COMPLETION
mcp__claude-flow__memory_usage {
  action: "store",
  key: "swarm/[agent-name]/complete",
  namespace: "coordination",
  value: JSON.stringify({
    status: "complete",
    deliverables: ["list"],
    integration_points: ["how to use"]
  })
}
```

### 📊 MEMORY KEY STRUCTURE
- Use namespace: "coordination" ALWAYS
- Keys: swarm/[agent]/status|progress|waiting|complete
- Shared: swarm/shared/[component]

### ❌ COMMON MISTAKES
1. Only reading, never writing
2. Wrong namespace
3. No progress updates
4. Missing shared artifacts

## 👑 QUEEN COORDINATOR SPECIAL RULES

**If you are the Queen Coordinator (hive-mind backlog depletion), use ONLY ONE KEY:**

```javascript
// SINGLE KEY for ALL queen progress - check on startup, update after each task
mcp__claude-flow__memory_usage({
  action: "retrieve",  // or "store"
  key: "swarm/queen-coordinator/progress",  // THE ONLY KEY!
  namespace: "coordination",
  value: JSON.stringify({
    progress: <percentage>,
    phase: "implementation",
    discovered: { "<task-id>": "implemented" },  // pre-implemented tasks found
    completedTasks: ["<task-id>", ...],
    timestamp: Date.now()
  })
})
```

**NEVER create separate keys** like `backlog/queen/discovered-complete`.
**ALWAYS merge** all data into `swarm/queen-coordinator/progress`.

This ensures continuity across context compaction and session restarts.


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
