part of ednet_core;

/// Registry for managing all available algorithms in EDNet Core
///
/// This is a singleton that provides access to all registered algorithms
/// and allows dynamic lookup and execution based on algorithm code.
class AlgorithmRegistry {
  static final AlgorithmRegistry _instance = AlgorithmRegistry._internal();

  factory AlgorithmRegistry() => _instance;

  AlgorithmRegistry._internal() {
    _registerDefaultAlgorithms();
  }

  final Map<String, Algorithm> _algorithms = {};

  /// Register default algorithms that come with EDNet Core
  void _registerDefaultAlgorithms() {
    // Graph algorithms
    register(DijkstraAlgorithm<dynamic>());
    register(BreadthFirstSearchAlgorithm<dynamic>());
    register(DepthFirstSearchAlgorithm<dynamic>());
    register(TopologicalSortAlgorithm<dynamic>());
    register(AStarAlgorithm<dynamic>());

    // Data structure algorithms
    register(BloomFilterAlgorithm());

    // Search algorithms (coming soon)
    // register(StringPatternMatchingAlgorithm());
    // register(ApproximateStringMatchingAlgorithm());
    // register(BinarySearchAlgorithm());

    // Dynamic programming algorithms (coming soon)
    // register(EditDistanceAlgorithm());
    // register(LongestCommonSubsequenceAlgorithm());
  }

  /// Register a new algorithm
  void register(Algorithm algorithm) {
    if (_algorithms.containsKey(algorithm.code)) {
      throw AlgorithmException(
        'Algorithm with code ${algorithm.code} is already registered',
      );
    }
    _algorithms[algorithm.code] = algorithm;
  }

  /// Unregister an algorithm
  void unregister(String code) {
    _algorithms.remove(code);
  }

  /// Get algorithm by code
  Algorithm? get(String code) => _algorithms[code];

  /// Get algorithm by code with type checking
  T? getTyped<T extends Algorithm>(String code) {
    final algorithm = _algorithms[code];
    return algorithm is T ? algorithm : null;
  }

  /// Check if algorithm is registered
  bool has(String code) => _algorithms.containsKey(code);

  /// Get all registered algorithms
  List<Algorithm> get all => _algorithms.values.toList();

  /// Clear all algorithms (for testing)
  void clear() {
    _algorithms.clear();
  }

  /// Reset to default algorithms (for testing)
  void resetToDefaults() {
    clear();
    _registerDefaultAlgorithms();
  }

  /// Get algorithms that can be applied to a concept
  List<Algorithm> getApplicableTo(Concept concept) {
    return _algorithms.values
        .where((algo) => algo.canApplyTo(concept))
        .toList();
  }

  /// Get algorithms that provide specific behaviors
  List<Algorithm> getProvidingBehaviors(List<String> behaviors) {
    return _algorithms.values.where((algo) {
      return behaviors.any(
        (behavior) => algo.providedBehaviors.contains(behavior),
      );
    }).toList();
  }

  /// Execute algorithm by code with dynamic input/output
  dynamic execute(String code, dynamic input) {
    final algorithm = _algorithms[code];
    if (algorithm == null) {
      throw AlgorithmException('Algorithm $code not found');
    }
    return algorithm.execute(input);
  }

  /// Get metrics for all algorithms
  Map<String, Map<String, dynamic>> getAllMetrics() {
    final metrics = <String, Map<String, dynamic>>{};
    for (final entry in _algorithms.entries) {
      metrics[entry.key] = entry.value.getMetrics();
    }
    return metrics;
  }

  /// Reset metrics for all algorithms
  void resetAllMetrics() {
    for (final algorithm in _algorithms.values) {
      algorithm.resetMetrics();
    }
  }
}

/// Extension to add algorithm capabilities to Concept
extension ConceptAlgorithms on Concept {
  /// Get all algorithms that can be applied to this concept
  List<Algorithm> get applicableAlgorithms {
    return AlgorithmRegistry().getApplicableTo(this);
  }

  /// Check if a specific algorithm can be applied
  bool canApplyAlgorithm(String algorithmCode) {
    final algorithm = AlgorithmRegistry().get(algorithmCode);
    return algorithm?.canApplyTo(this) ?? false;
  }
}

/// Extension to add algorithm capabilities to Entity
extension EntityAlgorithms on Entity {
  /// Apply an algorithm to this entity
  dynamic applyAlgorithm(String algorithmCode, dynamic input) {
    final algorithm = AlgorithmRegistry().get(algorithmCode);
    if (algorithm == null) {
      throw AlgorithmException('Algorithm $algorithmCode not found');
    }

    if (!algorithm.canApplyTo(concept)) {
      throw AlgorithmException(
        'Algorithm $algorithmCode cannot be applied to ${concept.code}',
      );
    }

    return algorithm.execute(input);
  }
}

/// Extension to add algorithm capabilities to Entities collection
extension EntitiesAlgorithms on Entities {
  /// Create a graph representation of this entities collection
  GraphInput<dynamic> toGraph() {
    return GraphInput.fromEntities(this);
  }

  /// Find shortest path between two entities using Dijkstra
  DijkstraResult<dynamic>? findShortestPath(Entity start, Entity end) {
    final graph = toGraph();
    final dijkstra = AlgorithmRegistry().getTyped<DijkstraAlgorithm<dynamic>>(
      'dijkstra',
    );

    if (dijkstra == null) return null;

    final input = DijkstraInput<dynamic>(
      graph: graph,
      startNodeId: start.oid.toString(),
      endNodeId: end.oid.toString(),
    );

    return dijkstra.execute(input);
  }

  /// Traverse entities in breadth-first order
  BFSResult<dynamic>? traverseBreadthFirst(Entity start, {int? maxDepth}) {
    final graph = toGraph();
    final bfs = AlgorithmRegistry()
        .getTyped<BreadthFirstSearchAlgorithm<dynamic>>('bfs');

    if (bfs == null) return null;

    final input = BFSInput<dynamic>(
      graph: graph,
      startNodeId: start.oid.toString(),
      maxDepth: maxDepth,
    );

    return bfs.execute(input);
  }
}
