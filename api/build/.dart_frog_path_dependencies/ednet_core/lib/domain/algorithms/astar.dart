part of ednet_core;

/// Input for A* algorithm
class AStarInput<T> {
  final GraphInput<T> graph;
  final String startNodeId;
  final String goalNodeId;
  final double Function(GraphNode<T> node, GraphNode<T> goal) heuristic;

  AStarInput({
    required this.graph,
    required this.startNodeId,
    required this.goalNodeId,
    required this.heuristic,
  });
}

/// Result of A* algorithm
class AStarResult<T> {
  final bool found;
  final double distance;
  final List<GraphNode<T>> path;
  final List<GraphNode<T>> exploredNodes;
  final Map<String, double> gScore;
  final Map<String, double> fScore;

  AStarResult({
    required this.found,
    required this.distance,
    required this.path,
    required this.exploredNodes,
    required this.gScore,
    required this.fScore,
  });
}

/// Node entry for A* priority queue
class _AStarNode<T> {
  final GraphNode<T> node;
  final double fScore;

  _AStarNode(this.node, this.fScore);
}

/// A* Heuristic Search algorithm implementation
///
/// Uses a heuristic function to guide search toward the goal,
/// making it more efficient than Dijkstra for pathfinding.
/// Combines actual cost g(n) with heuristic estimate h(n).
class AStarAlgorithm<T> extends Algorithm<AStarInput<T>, AStarResult<T>> {
  AStarAlgorithm()
    : super(
        code: 'astar',
        name: 'A* Heuristic Search',
        description:
            'Intelligent pathfinding using heuristic guidance for optimal exploration',
        applicableToConcepts: [
          'Navigation',
          'Pathfinding',
          'Workflow',
          'DomainGuide',
          'UserGuidance',
        ],
        providedBehaviors: [
          'intelligent-pathfinding',
          'heuristic-search',
          'guided-exploration',
          'optimal-guidance',
          'semantic-navigation',
          'user-assistance',
        ],
      );

  @override
  AStarResult<T> performExecution(AStarInput<T> input) {
    final graph = input.graph;
    final startId = input.startNodeId;
    final goalId = input.goalNodeId;
    final heuristic = input.heuristic;

    // Validate nodes exist
    if (!graph.hasNode(startId)) {
      throw AlgorithmException('Start node $startId not found in graph');
    }
    if (!graph.hasNode(goalId)) {
      throw AlgorithmException('Goal node $goalId not found in graph');
    }

    final startNode = graph.getNode(startId)!;
    final goalNode = graph.getNode(goalId)!;

    // Initialize data structures
    final openSet = <_AStarNode<T>>[];
    final closedSet = <String>{};
    final cameFrom = <String, String>{};
    final gScore = <String, double>{};
    final fScore = <String, double>{};
    final exploredNodes = <GraphNode<T>>[];

    // Initialize scores
    for (final node in graph.nodes) {
      gScore[node.id] = double.infinity;
      fScore[node.id] = double.infinity;
    }

    gScore[startId] = 0.0;
    fScore[startId] = heuristic(startNode, goalNode);

    // Add start node to open set
    openSet.add(_AStarNode(startNode, fScore[startId]!));

    while (openSet.isNotEmpty) {
      // Find node with lowest fScore in open set
      openSet.sort((a, b) => a.fScore.compareTo(b.fScore));
      final current = openSet.removeAt(0);
      final currentNode = current.node;
      final currentId = currentNode.id;

      exploredNodes.add(currentNode);

      // Goal reached
      if (currentId == goalId) {
        final path = _reconstructPath(graph, cameFrom, startId, goalId);
        return AStarResult(
          found: true,
          distance: gScore[goalId]!,
          path: path,
          exploredNodes: exploredNodes,
          gScore: Map.from(gScore),
          fScore: Map.from(fScore),
        );
      }

      closedSet.add(currentId);

      // Examine neighbors
      final edges = graph.getEdgesFrom(currentId);
      for (final edge in edges) {
        final neighborId = edge.target.id;
        final neighborNode = edge.target;

        // Skip if already evaluated
        if (closedSet.contains(neighborId)) {
          continue;
        }

        // Calculate tentative gScore
        final tentativeGScore = gScore[currentId]! + edge.weight;

        // Check if this path to neighbor is better
        if (tentativeGScore < gScore[neighborId]!) {
          // This path is the best until now
          cameFrom[neighborId] = currentId;
          gScore[neighborId] = tentativeGScore;
          fScore[neighborId] =
              tentativeGScore + heuristic(neighborNode, goalNode);

          // Add to open set if not already present
          final existingIndex = openSet.indexWhere(
            (n) => n.node.id == neighborId,
          );
          if (existingIndex == -1) {
            openSet.add(_AStarNode(neighborNode, fScore[neighborId]!));
          } else {
            // Update existing entry with new fScore
            openSet[existingIndex] = _AStarNode(
              neighborNode,
              fScore[neighborId]!,
            );
          }
        }
      }
    }

    // No path found
    return AStarResult(
      found: false,
      distance: double.infinity,
      path: [],
      exploredNodes: exploredNodes,
      gScore: Map.from(gScore),
      fScore: Map.from(fScore),
    );
  }

  /// Reconstruct path from start to goal using cameFrom map
  List<GraphNode<T>> _reconstructPath(
    GraphInput<T> graph,
    Map<String, String> cameFrom,
    String startId,
    String goalId,
  ) {
    final path = <GraphNode<T>>[];
    String? currentId = goalId;

    while (currentId != null) {
      final node = graph.getNode(currentId);
      if (node != null) {
        path.insert(0, node);
      }

      if (currentId == startId) {
        break;
      }

      currentId = cameFrom[currentId];
    }

    return path;
  }
}
