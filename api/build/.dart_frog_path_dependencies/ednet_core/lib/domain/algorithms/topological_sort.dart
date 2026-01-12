part of ednet_core;

/// Input for Topological Sort algorithm
class TopologicalSortInput<T> {
  final GraphInput<T> graph;
  final int Function(GraphNode<T> a, GraphNode<T> b)? priorityComparator;

  TopologicalSortInput({required this.graph, this.priorityComparator});
}

/// Result of Topological Sort algorithm
class TopologicalSortResult<T> {
  final List<GraphNode<T>> sortedNodes;
  final bool hasCycle;
  final List<GraphNode<T>>? cycleNodes;
  final Map<String, int> levels;

  TopologicalSortResult({
    required this.sortedNodes,
    required this.hasCycle,
    this.cycleNodes,
    required this.levels,
  });
}

/// Topological Sort algorithm implementation using Kahn's algorithm
///
/// Orders nodes in a directed graph such that for every directed edge (u,v),
/// vertex u comes before v in the ordering. Essential for dependency resolution,
/// task scheduling, and workflow planning.
class TopologicalSortAlgorithm<T>
    extends Algorithm<TopologicalSortInput<T>, TopologicalSortResult<T>> {
  TopologicalSortAlgorithm()
    : super(
        code: 'topological_sort',
        name: 'Topological Sort',
        description:
            'Orders nodes based on dependencies using Kahn\'s algorithm',
        applicableToConcepts: [
          'Workflow',
          'Pipeline',
          'BuildSystem',
          'Task',
          'Process',
        ],
        providedBehaviors: [
          'dependency-resolution',
          'task-ordering',
          'workflow-planning',
          'cycle-detection',
          'scheduling',
          'prerequisite-management',
        ],
      );

  @override
  TopologicalSortResult<T> performExecution(TopologicalSortInput<T> input) {
    final graph = input.graph;
    final priorityComparator = input.priorityComparator;

    if (graph.nodes.isEmpty) {
      return TopologicalSortResult(
        sortedNodes: [],
        hasCycle: false,
        levels: {},
      );
    }

    // Calculate in-degrees for all nodes
    final inDegree = <String, int>{};
    final outEdges = <String, List<GraphEdge<T>>>{};

    // Initialize in-degrees and out-edges
    for (final node in graph.nodes) {
      inDegree[node.id] = 0;
      outEdges[node.id] = [];
    }

    // Calculate actual in-degrees and out-edges
    for (final edge in graph.edges) {
      inDegree[edge.target.id] = (inDegree[edge.target.id] ?? 0) + 1;
      outEdges[edge.source.id]!.add(edge);
    }

    // Find nodes with no incoming edges (starting points)
    var queue = graph.nodes.where((node) => inDegree[node.id] == 0).toList();

    // Sort by priority if comparator provided
    if (priorityComparator != null) {
      queue.sort(priorityComparator);
    }

    final sortedNodes = <GraphNode<T>>[];
    final levels = <String, int>{};
    var currentLevel = 0;

    // Kahn's algorithm
    while (queue.isNotEmpty) {
      final currentLevelNodes = List<GraphNode<T>>.from(queue);
      queue.clear();

      // Process all nodes at current level
      for (final node in currentLevelNodes) {
        sortedNodes.add(node);
        levels[node.id] = currentLevel;

        // Reduce in-degree for all neighbors
        for (final edge in outEdges[node.id]!) {
          final neighborId = edge.target.id;
          inDegree[neighborId] = inDegree[neighborId]! - 1;

          // If neighbor has no more incoming edges, add to next level
          if (inDegree[neighborId] == 0) {
            final neighborNode = graph.getNode(neighborId)!;
            queue.add(neighborNode);
          }
        }
      }

      // Sort next level by priority if provided
      if (priorityComparator != null && queue.isNotEmpty) {
        queue.sort(priorityComparator);
      }

      currentLevel++;
    }

    // Check for cycles
    final hasCycle = sortedNodes.length != graph.nodes.length;
    List<GraphNode<T>>? cycleNodes;

    if (hasCycle) {
      // Find nodes that are part of cycles (still have in-degree > 0)
      cycleNodes = graph.nodes.where((node) => inDegree[node.id]! > 0).toList();
    }

    return TopologicalSortResult(
      sortedNodes: hasCycle ? [] : sortedNodes,
      hasCycle: hasCycle,
      cycleNodes: cycleNodes,
      levels: levels,
    );
  }
}
