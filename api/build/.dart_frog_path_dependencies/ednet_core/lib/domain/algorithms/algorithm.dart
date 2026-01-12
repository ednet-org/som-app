part of ednet_core;

/// Base abstract class for all algorithms in the EDNet Core framework.
///
/// Algorithms are first-class citizens that provide dynamic behavioral scaffolding
/// for domain models. They can be applied to concepts and entities to add
/// intelligent behaviors like navigation, search, optimization, etc.
///
/// Each algorithm:
/// - Has a unique code identifier
/// - Can be applied to specific concept types
/// - Provides semantic behaviors that adapt to domain context
/// - Maintains execution history and metrics
///
abstract class Algorithm<T, R> {
  /// Unique identifier for this algorithm
  final String code;

  /// Human-readable name
  final String name;

  /// Description of what this algorithm does
  final String description;

  /// List of concept codes this algorithm can be applied to
  /// Empty list means it can be applied to any concept
  final List<String> applicableToConcepts;

  /// Semantic behaviors this algorithm provides
  final List<String> providedBehaviors;

  /// Execution metrics
  int _executionCount = 0;
  Duration _totalExecutionTime = Duration.zero;
  Duration? _lastExecutionTime;

  Algorithm({
    required this.code,
    required this.name,
    required this.description,
    this.applicableToConcepts = const [],
    this.providedBehaviors = const [],
  });

  /// Execute the algorithm with input of type T and return result of type R
  R execute(T input) {
    final stopwatch = Stopwatch()..start();
    try {
      final result = performExecution(input);
      stopwatch.stop();
      _executionCount++;
      _lastExecutionTime = stopwatch.elapsed;
      _totalExecutionTime += stopwatch.elapsed;
      return result;
    } catch (e) {
      stopwatch.stop();
      throw AlgorithmException('Algorithm $code failed: $e');
    }
  }

  /// Actual algorithm implementation - to be overridden by subclasses
  R performExecution(T input);

  /// Check if this algorithm can be applied to a given concept
  bool canApplyTo(Concept concept) {
    if (applicableToConcepts.isEmpty) return true;
    return applicableToConcepts.contains(concept.code) ||
        applicableToConcepts.contains(concept.category);
  }

  /// Get execution metrics
  Map<String, dynamic> getMetrics() {
    return {
      'code': code,
      'executionCount': _executionCount,
      'totalExecutionTime': _totalExecutionTime.inMicroseconds,
      'averageExecutionTime': _executionCount > 0
          ? (_totalExecutionTime.inMicroseconds / _executionCount).round()
          : 0,
      'lastExecutionTime': _lastExecutionTime?.inMicroseconds ?? 0,
    };
  }

  /// Reset execution metrics
  void resetMetrics() {
    _executionCount = 0;
    _totalExecutionTime = Duration.zero;
    _lastExecutionTime = null;
  }

  @override
  String toString() => '$name ($code)';
}

/// Exception thrown when algorithm execution fails
class AlgorithmException implements Exception {
  final String message;
  AlgorithmException(this.message);

  @override
  String toString() => 'AlgorithmException: $message';
}
