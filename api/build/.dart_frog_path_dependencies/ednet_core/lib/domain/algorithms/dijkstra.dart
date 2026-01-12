part of ednet_core;

/// Input for Dijkstra's algorithm
class DijkstraInput<T> {
  final GraphInput<T> graph;
  final String startNodeId;
  final String? endNodeId; // If null, finds paths to all nodes

  DijkstraInput({
    required this.graph,
    required this.startNodeId,
    this.endNodeId,
  });
}

/// Result of Dijkstra's algorithm
class DijkstraResult<T> {
  final bool found;
  final double distance;
  final List<GraphNode<T>> path;
  final Map<String, double> distances;
  final Map<String, String?> previousNodes;

  DijkstraResult({
    required this.found,
    required this.distance,
    required this.path,
    required this.distances,
    required this.previousNodes,
  });
}

/// Dijkstra's shortest path algorithm implementation
///
/// Finds the shortest path between nodes in a weighted graph.
/// Can find shortest path to a specific node or to all nodes from source.
class DijkstraAlgorithm<T>
    extends Algorithm<DijkstraInput<T>, DijkstraResult<T>> {
  DijkstraAlgorithm()
    : super(
        code: 'dijkstra',
        name: 'Dijkstra Shortest Path',
        description:
            'Finds shortest paths in weighted graphs using Dijkstra\'s algorithm',
        applicableToConcepts: ['Network', 'Graph', 'Route', 'Workflow'],
        providedBehaviors: [
          'pathfinding',
          'optimization',
          'navigation',
          'route-planning',
          'cost-minimization',
        ],
      );

  @override
  DijkstraResult<T> performExecution(DijkstraInput<T> input) {
    final graph = input.graph;
    final startId = input.startNodeId;
    final endId = input.endNodeId;

    // Validate start node exists
    if (!graph.hasNode(startId)) {
      throw AlgorithmException('Start node $startId not found in graph');
    }

    // Initialize distances and previous nodes
    final distances = <String, double>{};
    final previousNodes = <String, String?>{};
    final unvisited = <String>{};

    // Initialize all distances to infinity
    for (final node in graph.nodes) {
      distances[node.id] = double.infinity;
      previousNodes[node.id] = null;
      unvisited.add(node.id);
    }

    // Distance to start node is 0
    distances[startId] = 0;

    // Main algorithm loop
    while (unvisited.isNotEmpty) {
      // Find unvisited node with minimum distance
      String? currentId;
      double minDistance = double.infinity;

      for (final nodeId in unvisited) {
        if (distances[nodeId]! < minDistance) {
          currentId = nodeId;
          minDistance = distances[nodeId]!;
        }
      }

      // If no reachable nodes remain, break
      if (currentId == null || minDistance == double.infinity) {
        break;
      }

      // If we've reached the target node, we can stop early
      if (endId != null && currentId == endId) {
        break;
      }

      // Mark current node as visited
      unvisited.remove(currentId);

      // Update distances to neighbors
      final edges = graph.getEdgesFrom(currentId);
      for (final edge in edges) {
        final neighborId = edge.target.id;

        // Skip if already visited
        if (!unvisited.contains(neighborId)) {
          continue;
        }

        // Calculate alternative distance
        final altDistance = distances[currentId]! + edge.weight;

        // Update if shorter path found
        if (altDistance < distances[neighborId]!) {
          distances[neighborId] = altDistance;
          previousNodes[neighborId] = currentId;
        }
      }
    }

    // Build result
    if (endId != null) {
      // Specific target node
      final distance = distances[endId] ?? double.infinity;
      final path = _reconstructPath(graph, previousNodes, startId, endId);

      return DijkstraResult(
        found: distance != double.infinity,
        distance: distance,
        path: path,
        distances: distances,
        previousNodes: previousNodes,
      );
    } else {
      // All nodes from source
      return DijkstraResult(
        found: true,
        distance: 0,
        path: [graph.getNode(startId)!],
        distances: distances,
        previousNodes: previousNodes,
      );
    }
  }

  /// Reconstruct path from start to end using previous nodes map
  List<GraphNode<T>> _reconstructPath(
    GraphInput<T> graph,
    Map<String, String?> previousNodes,
    String startId,
    String endId,
  ) {
    final path = <GraphNode<T>>[];

    // Check if path exists
    if (previousNodes[endId] == null && startId != endId) {
      return path; // No path exists
    }

    // Build path backwards from end to start
    String? currentId = endId;
    while (currentId != null) {
      final node = graph.getNode(currentId);
      if (node != null) {
        path.insert(0, node);
      }

      if (currentId == startId) {
        break;
      }

      currentId = previousNodes[currentId];
    }

    return path;
  }
}
