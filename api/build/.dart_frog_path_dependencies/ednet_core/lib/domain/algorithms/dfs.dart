part of ednet_core;

/// Input for Depth-First Search algorithm
class DFSInput<T> {
  final GraphInput<T> graph;
  final String startNodeId;
  final bool exploreAllComponents;
  final bool findStronglyConnectedComponents;
  final void Function(GraphNode<T> node)? onDiscovery;
  final void Function(GraphNode<T> node)? onFinish;

  DFSInput({
    required this.graph,
    required this.startNodeId,
    this.exploreAllComponents = false,
    this.findStronglyConnectedComponents = false,
    this.onDiscovery,
    this.onFinish,
  });
}

/// Result of Depth-First Search algorithm
class DFSResult<T> {
  final List<GraphNode<T>> visitedNodes;
  final Map<String, int> discoveryTimes;
  final Map<String, int> finishTimes;
  final List<GraphEdge<T>> treeEdges;
  final List<GraphEdge<T>> backEdges;
  final List<GraphEdge<T>> forwardEdges;
  final List<GraphEdge<T>> crossEdges;
  final bool hasCycle;
  final List<List<GraphNode<T>>>? stronglyConnectedComponents;

  DFSResult({
    required this.visitedNodes,
    required this.discoveryTimes,
    required this.finishTimes,
    required this.treeEdges,
    required this.backEdges,
    required this.forwardEdges,
    required this.crossEdges,
    required this.hasCycle,
    this.stronglyConnectedComponents,
  });
}

/// Depth-First Search algorithm implementation
///
/// Explores as far as possible along each branch before backtracking.
/// Can detect cycles, classify edges, and find strongly connected components.
class DepthFirstSearchAlgorithm<T>
    extends Algorithm<DFSInput<T>, DFSResult<T>> {
  DepthFirstSearchAlgorithm()
    : super(
        code: 'dfs',
        name: 'Depth-First Search',
        description:
            'Traverses graph depth-first, exploring branches fully before backtracking',
        applicableToConcepts: [
          'Network',
          'Graph',
          'Tree',
          'Hierarchy',
          'Workflow',
        ],
        providedBehaviors: [
          'traversal',
          'exploration',
          'cycle-detection',
          'edge-classification',
          'topological-ordering',
          'strongly-connected-components',
        ],
      );

  @override
  DFSResult<T> performExecution(DFSInput<T> input) {
    final graph = input.graph;
    final startId = input.startNodeId;

    // Validate start node exists
    if (!graph.hasNode(startId)) {
      throw AlgorithmException('Start node $startId not found in graph');
    }

    // Initialize data structures
    final visitedNodes = <GraphNode<T>>[];
    final discoveryTimes = <String, int>{};
    final finishTimes = <String, int>{};
    final colors = <String, _Color>{};
    final treeEdges = <GraphEdge<T>>[];
    final backEdges = <GraphEdge<T>>[];
    final forwardEdges = <GraphEdge<T>>[];
    final crossEdges = <GraphEdge<T>>[];

    var time = 0;
    var hasCycle = false;

    // Initialize all nodes as white (unvisited)
    for (final node in graph.nodes) {
      colors[node.id] = _Color.white;
    }

    // DFS visit function
    void dfsVisit(String nodeId) {
      final node = graph.getNode(nodeId)!;

      // Mark as gray (being processed)
      colors[nodeId] = _Color.gray;
      discoveryTimes[nodeId] = time++;
      visitedNodes.add(node);

      // Call discovery visitor
      input.onDiscovery?.call(node);

      // Explore neighbors
      final edges = graph.getEdgesFrom(nodeId);
      for (final edge in edges) {
        final neighborId = edge.target.id;
        final neighborColor = colors[neighborId]!;

        if (neighborColor == _Color.white) {
          // Tree edge - leads to unvisited node
          treeEdges.add(edge);
          dfsVisit(neighborId);
        } else if (neighborColor == _Color.gray) {
          // Back edge - leads to ancestor (cycle detected)
          backEdges.add(edge);
          hasCycle = true;
        } else {
          // Black node - already finished
          if (discoveryTimes[nodeId]! < discoveryTimes[neighborId]!) {
            // Forward edge - leads to descendant
            forwardEdges.add(edge);
          } else {
            // Cross edge - leads to non-ancestor/descendant
            crossEdges.add(edge);
          }
        }
      }

      // Mark as black (finished)
      colors[nodeId] = _Color.black;
      finishTimes[nodeId] = time++;

      // Call finish visitor
      input.onFinish?.call(node);
    }

    // Start DFS from the start node
    dfsVisit(startId);

    // Explore all components if requested
    if (input.exploreAllComponents) {
      for (final node in graph.nodes) {
        if (colors[node.id] == _Color.white) {
          dfsVisit(node.id);
        }
      }
    }

    // Find strongly connected components if requested
    List<List<GraphNode<T>>>? sccs;
    if (input.findStronglyConnectedComponents) {
      sccs = _findStronglyConnectedComponents(graph, finishTimes);
    }

    return DFSResult(
      visitedNodes: visitedNodes,
      discoveryTimes: discoveryTimes,
      finishTimes: finishTimes,
      treeEdges: treeEdges,
      backEdges: backEdges,
      forwardEdges: forwardEdges,
      crossEdges: crossEdges,
      hasCycle: hasCycle,
      stronglyConnectedComponents: sccs,
    );
  }

  /// Find strongly connected components using Kosaraju's algorithm
  List<List<GraphNode<T>>> _findStronglyConnectedComponents(
    GraphInput<T> graph,
    Map<String, int> finishTimes,
  ) {
    // Create reversed graph
    final reversedGraph = GraphInput<T>();
    for (final node in graph.nodes) {
      reversedGraph.addNode(node);
    }
    for (final edge in graph.edges) {
      reversedGraph.connect(
        edge.target.id,
        edge.source.id,
        weight: edge.weight,
      );
    }

    // Sort nodes by finish time (descending)
    final sortedNodes = graph.nodes.toList()
      ..sort(
        (a, b) => (finishTimes[b.id] ?? 0).compareTo(finishTimes[a.id] ?? 0),
      );

    // DFS on reversed graph in order of decreasing finish time
    final visited = <String>{};
    final sccs = <List<GraphNode<T>>>[];

    void dfsCollect(String nodeId, List<GraphNode<T>> component) {
      visited.add(nodeId);
      component.add(reversedGraph.getNode(nodeId)!);

      final edges = reversedGraph.getEdgesFrom(nodeId);
      for (final edge in edges) {
        if (!visited.contains(edge.target.id)) {
          dfsCollect(edge.target.id, component);
        }
      }
    }

    for (final node in sortedNodes) {
      if (!visited.contains(node.id)) {
        final component = <GraphNode<T>>[];
        dfsCollect(node.id, component);
        sccs.add(component);
      }
    }

    return sccs;
  }
}

/// Node colors for DFS
enum _Color { white, gray, black }
