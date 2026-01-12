part of ednet_core;

final Logger _projectionLogger = Logger('ednet_core.cqrs.projection');

/// Base class for all projections in CQRS architecture.
///
/// Projections are event handlers that maintain read models by processing
/// domain events. They implement the eventual consistency pattern by
/// asynchronously updating denormalized views when events occur.
///
/// From the book Chapter 6: "Projections are event handlers that update read models"
///
/// ## Key Characteristics:
/// - **Event-driven**: React to specific domain events
/// - **Idempotent**: Can safely process the same event multiple times
/// - **Rebuildable**: Can reconstruct read models from event history
/// - **Focused**: Each projection maintains specific read model types
///
/// ## Usage:
/// ```dart
/// class OrderSummaryProjection extends Projection {
///   final IReadModelRepository<OrderSummaryReadModel> _repository;
///
///   OrderSummaryProjection(this._repository);
///
///   @override
///   String get name => 'OrderSummaryProjection';
///
///   @override
///   bool canHandle(IDomainEvent event) => event.name == 'OrderPlaced';
///
///   @override
///   Future<void> handle(IDomainEvent event) async {
///     final readModel = OrderSummaryReadModel.fromEvent(event);
///     await _repository.save(readModel);
///   }
///
///   @override
///   Future<void> rebuild() async {
///     await _repository.clear();
///     // Replay events from event store
///   }
/// }
/// ```
///
/// ## EDNet Core Integration:
/// - Registers with ProjectionEngine for automatic event routing
/// - Integrates with IReadModelRepository for read model persistence
/// - Supports EventStore replay for projection rebuilding
/// - Works with EventBus for real-time event processing
abstract class Projection {
  /// Unique name identifying this projection.
  ///
  /// Used by the ProjectionEngine for routing and debugging.
  /// Should be descriptive and unique within the application.
  String get name;

  /// Determines if this projection can handle the given event.
  ///
  /// This method is called by the ProjectionEngine to route events
  /// to the appropriate projections. Return true if this projection
  /// should process the event.
  ///
  /// ## Example:
  /// ```dart
  /// @override
  /// bool canHandle(IDomainEvent event) {
  ///   return event.name == 'OrderPlaced' ||
  ///          event.name == 'OrderShipped';
  /// }
  /// ```
  bool canHandle(IDomainEvent event);

  /// Processes a domain event to update read models.
  ///
  /// This is the core method where projections react to events
  /// and update their corresponding read models. The implementation
  /// should be idempotent to handle event replay scenarios.
  ///
  /// ## Guidelines:
  /// - Make operations idempotent
  /// - Handle missing data gracefully
  /// - Use transactions for multiple read model updates
  /// - Log projection failures for debugging
  ///
  /// ## Example:
  /// ```dart
  /// @override
  /// Future<void> handle(IDomainEvent event) async {
  ///   switch (event.name) {
  ///     case 'OrderPlaced':
  ///       await _handleOrderPlaced(event);
  ///       break;
  ///     case 'OrderShipped':
  ///       await _handleOrderShipped(event);
  ///       break;
  ///   }
  /// }
  /// ```
  Future<void> handle(IDomainEvent event);

  /// Rebuilds this projection from scratch.
  ///
  /// This method is called during projection rebuilds, typically
  /// after schema changes or to recover from corruption. It should:
  /// 1. Clear all existing read models
  /// 2. Reset internal state
  /// 3. Optionally replay events from the event store
  ///
  /// ## Implementation Notes:
  /// - Clear read model repositories
  /// - Reset any cached state
  /// - Consider performance for large event histories
  /// - May be called by ProjectionEngine during rebuild operations
  ///
  /// ## Example:
  /// ```dart
  /// @override
  /// Future<void> rebuild() async {
  ///   await _repository.clear();
  ///   _processedEvents.clear();
  ///   // Optionally: replay events from event store
  ///   await _replayEventsFromStore();
  /// }
  /// ```
  Future<void> rebuild();

  /// Returns the projection type for debugging and monitoring.
  ///
  /// Automatically inferred from the class name by default.
  String get projectionType => runtimeType.toString();

  /// Indicates whether this projection supports rebuild operations.
  ///
  /// Override to false for projections that cannot be rebuilt
  /// (e.g., those that depend on external data sources).
  bool get supportsRebuild => true;

  /// Priority for projection processing order.
  ///
  /// Lower numbers indicate higher priority. Projections with
  /// higher priority are processed first when multiple projections
  /// handle the same event.
  ///
  /// Default priority is 100 (normal priority).
  int get priority => 100;

  @override
  String toString() => '$projectionType(name: $name)';
}

/// Interface for projection engines that coordinate projection execution.
///
/// The projection engine is responsible for routing domain events to
/// the appropriate projections and managing projection lifecycle.
///
/// ## EDNet Core Integration:
/// - Integrates with EventBus for automatic event processing
/// - Coordinates with EventStore for projection rebuilds
/// - Provides monitoring and error handling for projections
/// - Supports batch processing for high-throughput scenarios
abstract class IProjectionEngine {
  /// Registers a projection with the engine.
  ///
  /// Once registered, the projection will automatically receive
  /// events that it can handle.
  void registerProjection(Projection projection);

  /// Unregisters a projection from the engine.
  ///
  /// The projection will no longer receive events after being
  /// unregistered.
  bool unregisterProjection(String projectionName);

  /// Processes a single domain event through all applicable projections.
  ///
  /// The engine routes the event to all registered projections
  /// that can handle it, respecting priority ordering.
  Future<void> processEvent(IDomainEvent event);

  /// Processes multiple events in sequence.
  ///
  /// More efficient than processing events individually when
  /// dealing with large batches.
  Future<void> processEvents(List<IDomainEvent> events);

  /// Rebuilds all registered projections.
  ///
  /// This clears all read models and optionally replays events
  /// from the event store to reconstruct the projections.
  Future<void> rebuildAll([bool replayEvents = true]);

  /// Rebuilds a specific projection by name.
  ///
  /// Useful for rebuilding individual projections without
  /// affecting others.
  Future<void> rebuildProjection(
    String projectionName, [
    bool replayEvents = true,
  ]);

  /// Returns all registered projection names.
  List<String> get registeredProjections;

  /// Returns statistics about projection processing.
  ///
  /// Useful for monitoring and debugging projection performance.
  Map<String, dynamic> getStatistics();
}

/// Default implementation of projection engine.
///
/// This implementation provides full projection coordination functionality
/// with error handling, monitoring, and performance optimization.
///
/// ## Features:
/// - Automatic event routing to projections
/// - Priority-based projection ordering
/// - Error isolation (one projection failure doesn't affect others)
/// - Performance monitoring and statistics
/// - Batch processing optimization
class ProjectionEngine implements IProjectionEngine {
  final Map<String, Projection> _projections = {};
  final Map<String, int> _eventCounts = {};
  final Map<String, int> _errorCounts = {};
  final Map<String, DateTime> _lastProcessed = {};

  @override
  void registerProjection(Projection projection) {
    _projections[projection.name] = projection;
    _eventCounts[projection.name] = 0;
    _errorCounts[projection.name] = 0;
  }

  @override
  bool unregisterProjection(String projectionName) {
    final removed = _projections.remove(projectionName);
    _eventCounts.remove(projectionName);
    _errorCounts.remove(projectionName);
    _lastProcessed.remove(projectionName);
    return removed != null;
  }

  @override
  Future<void> processEvent(IDomainEvent event) async {
    // Find all projections that can handle this event
    final applicableProjections = _projections.values
        .where((projection) => projection.canHandle(event))
        .toList();

    // Sort by priority (lower number = higher priority)
    applicableProjections.sort((a, b) => a.priority.compareTo(b.priority));

    // Process event through each projection
    for (final projection in applicableProjections) {
      try {
        await projection.handle(event);
        _eventCounts[projection.name] =
            (_eventCounts[projection.name] ?? 0) + 1;
        _lastProcessed[projection.name] = DateTime.now();
      } catch (error) {
        _errorCounts[projection.name] =
            (_errorCounts[projection.name] ?? 0) + 1;
        // Log error but continue processing other projections
        _projectionLogger.warning(
          'Projection ${projection.name} failed to process event ${event.name}: $error',
        );
      }
    }
  }

  @override
  Future<void> processEvents(List<IDomainEvent> events) async {
    for (final event in events) {
      await processEvent(event);
    }
  }

  @override
  Future<void> rebuildAll([bool replayEvents = true]) async {
    for (final projection in _projections.values) {
      if (projection.supportsRebuild) {
        try {
          await projection.rebuild();
          _projectionLogger.fine('Rebuilt projection: ${projection.name}');
        } catch (error) {
          _projectionLogger.warning(
            'Failed to rebuild projection ${projection.name}: $error',
          );
        }
      }
    }

    // Reset statistics
    _eventCounts.clear();
    _errorCounts.clear();
    _lastProcessed.clear();

    for (final projectionName in _projections.keys) {
      _eventCounts[projectionName] = 0;
      _errorCounts[projectionName] = 0;
    }
  }

  @override
  Future<void> rebuildProjection(
    String projectionName, [
    bool replayEvents = true,
  ]) async {
    final projection = _projections[projectionName];
    if (projection == null) {
      throw ArgumentError('Projection not found: $projectionName');
    }

    if (!projection.supportsRebuild) {
      throw StateError('Projection does not support rebuild: $projectionName');
    }

    try {
      await projection.rebuild();
      _eventCounts[projectionName] = 0;
      _errorCounts[projectionName] = 0;
      _lastProcessed.remove(projectionName);
      _projectionLogger.fine('Rebuilt projection: $projectionName');
    } catch (error) {
      throw Exception('Failed to rebuild projection $projectionName: $error');
    }
  }

  @override
  List<String> get registeredProjections => _projections.keys.toList();

  @override
  Map<String, dynamic> getStatistics() {
    final stats = <String, dynamic>{};

    for (final entry in _projections.entries) {
      final name = entry.key;
      final projection = entry.value;

      stats[name] = {
        'projectionType': projection.projectionType,
        'priority': projection.priority,
        'supportsRebuild': projection.supportsRebuild,
        'eventsProcessed': _eventCounts[name] ?? 0,
        'errors': _errorCounts[name] ?? 0,
        'lastProcessed': _lastProcessed[name]?.toIso8601String(),
      };
    }

    return {
      'totalProjections': _projections.length,
      'totalEventsProcessed': _eventCounts.values.fold(
        0,
        (sum, count) => sum + count,
      ),
      'totalErrors': _errorCounts.values.fold(0, (sum, count) => sum + count),
      'projections': stats,
    };
  }

  /// Clears all statistics (useful for testing)
  void clearStatistics() {
    _eventCounts.clear();
    _errorCounts.clear();
    _lastProcessed.clear();
  }
}

/// Extension to add data accessor to IDomainEvent for projection convenience.
///
/// This extension allows projections to access event data in a type-safe way
/// while maintaining compatibility with the existing IDomainEvent interface.
extension ProjectionEventData on IDomainEvent {
  /// Accesses event data in a projection-friendly way.
  ///
  /// This provides a convenient way for projections to access event data
  /// without needing to parse JSON or deal with implementation details.
  ///
  /// Uses the standardized eventData method from IDomainEvent interface
  /// to ensure consistent behavior across all implementations.
  Map<String, dynamic> get data => eventData;
}
