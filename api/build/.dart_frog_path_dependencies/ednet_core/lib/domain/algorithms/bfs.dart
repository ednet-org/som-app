part of ednet_core;

/// Input for Breadth-First Search algorithm
class BFSInput<T> {
  final GraphInput<T> graph;
  final String startNodeId;
  final String? targetNodeId; // If provided, search stops when target is found
  final int? maxDepth; // Maximum depth to explore
  final void Function(GraphNode<T> node, int level)?
  visitor; // Custom visitor function

  BFSInput({
    required this.graph,
    required this.startNodeId,
    this.targetNodeId,
    this.maxDepth,
    this.visitor,
  });
}

/// Result of Breadth-First Search algorithm
class BFSResult<T> {
  final List<GraphNode<T>> visitedNodes;
  final Map<String, int> levels;
  final bool found;
  final List<GraphNode<T>>? pathToTarget;

  BFSResult({
    required this.visitedNodes,
    required this.levels,
    required this.found,
    this.pathToTarget,
  });
}

/// Breadth-First Search algorithm implementation
///
/// Explores nodes level by level, visiting all nodes at distance k
/// before visiting nodes at distance k+1.
class BreadthFirstSearchAlgorithm<T>
    extends Algorithm<BFSInput<T>, BFSResult<T>> {
  BreadthFirstSearchAlgorithm()
    : super(
        code: 'bfs',
        name: 'Breadth-First Search',
        description:
            'Traverses graph level by level, exploring all neighbors before going deeper',
        applicableToConcepts: [
          'Network',
          'Graph',
          'Tree',
          'Hierarchy',
          'Navigation',
        ],
        providedBehaviors: [
          'traversal',
          'exploration',
          'level-order',
          'shortest-path-unweighted',
          'connectivity',
          'component-discovery',
        ],
      );

  @override
  BFSResult<T> performExecution(BFSInput<T> input) {
    final graph = input.graph;
    final startId = input.startNodeId;
    final targetId = input.targetNodeId;
    final maxDepth = input.maxDepth;
    final visitor = input.visitor;

    // Validate start node exists
    if (!graph.hasNode(startId)) {
      throw AlgorithmException('Start node $startId not found in graph');
    }

    // Initialize data structures
    final visitedNodes = <GraphNode<T>>[];
    final levels = <String, int>{};
    final visited = <String>{};
    final queue = <String>[];
    final parent = <String, String>{};

    // Start BFS from the start node
    final startNode = graph.getNode(startId)!;
    queue.add(startId);
    visited.add(startId);
    levels[startId] = 0;

    // Apply visitor to start node
    visitor?.call(startNode, 0);

    // Main BFS loop
    while (queue.isNotEmpty) {
      final currentId = queue.removeAt(0);
      final currentNode = graph.getNode(currentId)!;
      final currentLevel = levels[currentId]!;

      // Add to visited nodes list
      visitedNodes.add(currentNode);

      // Check if we've reached the target
      if (targetId != null && currentId == targetId) {
        final path = _reconstructPath(graph, parent, startId, targetId);
        return BFSResult(
          visitedNodes: visitedNodes,
          levels: levels,
          found: true,
          pathToTarget: path,
        );
      }

      // Skip if we've reached max depth
      if (maxDepth != null && currentLevel >= maxDepth) {
        continue;
      }

      // Explore neighbors
      final edges = graph.getEdgesFrom(currentId);
      for (final edge in edges) {
        final neighborId = edge.target.id;

        // Skip if already visited
        if (visited.contains(neighborId)) {
          continue;
        }

        // Mark as visited and add to queue
        visited.add(neighborId);
        queue.add(neighborId);
        levels[neighborId] = currentLevel + 1;
        parent[neighborId] = currentId;

        // Apply visitor
        if (visitor != null &&
            (maxDepth == null || levels[neighborId]! <= maxDepth)) {
          visitor(edge.target, levels[neighborId]!);
        }
      }
    }

    // Build result
    if (targetId != null) {
      // Target was not found
      return BFSResult(
        visitedNodes: visitedNodes,
        levels: levels,
        found: false,
        pathToTarget: null,
      );
    } else {
      // General traversal completed
      return BFSResult(visitedNodes: visitedNodes, levels: levels, found: true);
    }
  }

  /// Reconstruct path from start to target using parent map
  List<GraphNode<T>> _reconstructPath(
    GraphInput<T> graph,
    Map<String, String> parent,
    String startId,
    String targetId,
  ) {
    final path = <GraphNode<T>>[];

    // Build path backwards from target to start
    String? currentId = targetId;
    while (currentId != null) {
      final node = graph.getNode(currentId);
      if (node != null) {
        path.insert(0, node);
      }

      if (currentId == startId) {
        break;
      }

      currentId = parent[currentId];
    }

    return path;
  }
}
