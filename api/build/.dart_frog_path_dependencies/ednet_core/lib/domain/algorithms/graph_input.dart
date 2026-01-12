part of ednet_core;

/// Represents a node in a graph structure
class GraphNode<T> {
  final String id;
  final T data;
  final Map<String, dynamic> properties;

  GraphNode({
    required this.id,
    required this.data,
    Map<String, dynamic>? properties,
  }) : properties = properties ?? {};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GraphNode && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'GraphNode($id)';
}

/// Represents an edge in a graph structure
class GraphEdge<T> {
  final GraphNode<T> source;
  final GraphNode<T> target;
  final double weight;
  final String? type;
  final Map<String, dynamic> properties;

  GraphEdge({
    required this.source,
    required this.target,
    this.weight = 1.0,
    this.type,
    Map<String, dynamic>? properties,
  }) : properties = properties ?? {};

  @override
  String toString() =>
      'GraphEdge(${source.id} -> ${target.id}, weight: $weight)';
}

/// Input structure for graph algorithms
class GraphInput<T> {
  final Map<String, GraphNode<T>> _nodes = {};
  final List<GraphEdge<T>> _edges = [];
  final Map<String, List<GraphEdge<T>>> _adjacencyList = {};

  /// Add a node to the graph
  void addNode(GraphNode<T> node) {
    _nodes[node.id] = node;
    _adjacencyList.putIfAbsent(node.id, () => []);
  }

  /// Add an edge to the graph
  void addEdge(GraphEdge<T> edge) {
    // Ensure nodes exist
    if (!_nodes.containsKey(edge.source.id)) {
      addNode(edge.source);
    }
    if (!_nodes.containsKey(edge.target.id)) {
      addNode(edge.target);
    }

    _edges.add(edge);
    _adjacencyList[edge.source.id]!.add(edge);
  }

  /// Create edge between two nodes by ID
  void connect(
    String sourceId,
    String targetId, {
    double weight = 1.0,
    String? type,
    Map<String, dynamic>? properties,
  }) {
    final source = _nodes[sourceId];
    final target = _nodes[targetId];

    if (source == null || target == null) {
      throw ArgumentError('Both source and target nodes must exist');
    }

    addEdge(
      GraphEdge(
        source: source,
        target: target,
        weight: weight,
        type: type,
        properties: properties,
      ),
    );
  }

  /// Get node by ID
  GraphNode<T>? getNode(String id) => _nodes[id];

  /// Get all nodes
  List<GraphNode<T>> get nodes => _nodes.values.toList();

  /// Get all edges
  List<GraphEdge<T>> get edges => List.unmodifiable(_edges);

  /// Get neighbors of a node
  List<GraphNode<T>> getNeighbors(String nodeId) {
    return _adjacencyList[nodeId]?.map((edge) => edge.target).toList() ?? [];
  }

  /// Get edges from a node
  List<GraphEdge<T>> getEdgesFrom(String nodeId) {
    return _adjacencyList[nodeId] ?? [];
  }

  /// Check if graph contains a node
  bool hasNode(String id) => _nodes.containsKey(id);

  /// Check if there's an edge between two nodes
  bool hasEdge(String sourceId, String targetId) {
    return _adjacencyList[sourceId]?.any(
          (edge) => edge.target.id == targetId,
        ) ??
        false;
  }

  /// Get the number of nodes
  int get nodeCount => _nodes.length;

  /// Get the number of edges
  int get edgeCount => _edges.length;

  /// Create a graph from entities and their relationships
  static GraphInput<dynamic> fromEntities(Entities entities) {
    final graph = GraphInput<dynamic>();

    // Add all entities as nodes
    for (final entity in entities) {
      graph.addNode(
        GraphNode(
          id: entity.oid.toString(),
          data: entity,
          properties: {'concept': entity.concept.code, 'code': entity.code},
        ),
      );
    }

    // Add edges based on parent relationships
    for (final entity in entities) {
      for (final parent in entity.concept.parents) {
        final parentEntity = entity.getParent(parent.code);
        if (parentEntity != null && parentEntity is Entity) {
          graph.connect(
            entity.oid.toString(),
            parentEntity.oid.toString(),
            type: parent.code,
            properties: {'relationship': 'parent', 'required': parent.required},
          );
        }
      }

      // Add edges based on child relationships
      for (final child in entity.concept.children) {
        if (child is! Child) continue;
        final childEntities = entity.getChild(child.code);
        if (childEntities != null && childEntities is Entities) {
          for (final childEntity in childEntities) {
            graph.connect(
              entity.oid.toString(),
              childEntity.oid.toString(),
              type: child.code,
              properties: {'relationship': 'child', 'internal': child.internal},
            );
          }
        }
      }
    }

    return graph;
  }

  @override
  String toString() => 'GraphInput(nodes: $nodeCount, edges: $edgeCount)';
}
