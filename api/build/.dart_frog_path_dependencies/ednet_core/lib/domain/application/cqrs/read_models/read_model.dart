part of ednet_core;

/// Base class for all read models in CQRS architecture.
///
/// Read models are optimized for query operations and represent denormalized
/// views of the domain data. They are updated asynchronously through projections
/// that listen to domain events.
///
/// From the book Chapter 6: "Read models are optimized projections for queries"
///
/// ## Key Characteristics:
/// - **Immutable**: Read models should not be directly modified
/// - **Optimized**: Structured for specific query patterns
/// - **Eventually Consistent**: Updated through event projections
/// - **Serializable**: Support JSON serialization for storage and transmission
///
/// ## Usage:
/// ```dart
/// class OrderSummaryReadModel extends ReadModel {
///   final String orderId;
///   final double totalAmount;
///
///   OrderSummaryReadModel({
///     required this.orderId,
///     required this.totalAmount,
///   }) : super(id: orderId);
///
///   @override
///   Map<String, dynamic> toJson() => {
///     'id': id,
///     'orderId': orderId,
///     'totalAmount': totalAmount,
///     'lastUpdated': lastUpdated.toIso8601String(),
///   };
/// }
/// ```
///
/// ## EDNet Core Integration:
/// - Integrates with ProjectionEngine for automatic updates
/// - Supports QueryBus for optimized query handling
/// - Works with EventStore for event replay and rebuild capabilities
/// - Aligns with the meta-modeling framework for dynamic behavior
abstract class ReadModel {
  /// Unique identifier for this read model instance.
  ///
  /// This should correspond to the aggregate root ID or a derived key
  /// that uniquely identifies this projection.
  final String id;

  /// Timestamp indicating when this read model was last updated.
  ///
  /// This is crucial for eventual consistency tracking and
  /// debugging projection update issues.
  final DateTime lastUpdated;

  /// Creates a new read model with required identification and timestamp.
  ///
  /// [id] must be unique within the read model type
  /// [lastUpdated] defaults to current time if not provided
  ReadModel({required this.id, DateTime? lastUpdated})
    : lastUpdated = lastUpdated ?? DateTime.now();

  /// Serializes the read model to JSON for storage or transmission.
  ///
  /// Implementations should include all relevant data for queries
  /// and must include the [id] and [lastUpdated] fields.
  ///
  /// ## Example:
  /// ```dart
  /// @override
  /// Map<String, dynamic> toJson() => {
  ///   'id': id,
  ///   'customField': customField,
  ///   'lastUpdated': lastUpdated.toIso8601String(),
  /// };
  /// ```
  Map<String, dynamic> toJson();

  /// Indicates whether this read model can be cached.
  ///
  /// Override to false for highly dynamic read models that
  /// change frequently.
  bool get cacheable => true;

  /// Cache duration for this read model type.
  ///
  /// Used by query handlers and caching layers to determine
  /// how long to cache query results.
  Duration get cacheDuration => const Duration(minutes: 5);

  /// Returns the read model type for debugging and routing.
  ///
  /// Automatically inferred from the class name by default.
  String get readModelType => runtimeType.toString();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReadModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => '$readModelType(id: $id, lastUpdated: $lastUpdated)';
}

/// Interface for read model repositories that provide query capabilities.
///
/// Read model repositories are optimized for query operations and typically
/// use denormalized storage structures like document stores or specialized
/// read databases.
///
/// ## EDNet Core Integration:
/// - Works with QueryBus for routing queries to appropriate handlers
/// - Integrates with ProjectionEngine for automatic read model updates
/// - Supports caching strategies for high-performance queries
abstract class IReadModelRepository<T extends ReadModel> {
  /// Retrieves a read model by its unique identifier.
  ///
  /// Returns null if the read model is not found.
  Future<T?> getById(String id);

  /// Saves or updates a read model.
  ///
  /// This is typically called by projection handlers when
  /// processing domain events.
  Future<void> save(T readModel);

  /// Deletes a read model by its identifier.
  ///
  /// Used when the corresponding aggregate is deleted
  /// or when the read model is no longer relevant.
  Future<bool> delete(String id);

  /// Queries read models based on criteria.
  ///
  /// [criteria] is implementation-specific and could be:
  /// - SQL WHERE clauses for relational stores
  /// - MongoDB query documents for document stores
  /// - Elasticsearch queries for search-optimized stores
  /// - In-memory predicates for simple implementations
  Future<List<T>> query(Map<String, dynamic> criteria);

  /// Returns all read models of this type.
  ///
  /// Use with caution for large datasets. Consider implementing
  /// pagination in the criteria-based query method instead.
  Future<List<T>> getAll();

  /// Returns the count of read models matching the criteria.
  ///
  /// Useful for pagination and dashboard metrics without
  /// loading all data.
  Future<int> count([Map<String, dynamic>? criteria]);

  /// Clears all read models of this type.
  ///
  /// Typically used during projection rebuilds or
  /// for testing purposes.
  Future<void> clear();
}

/// In-memory implementation of read model repository for testing and development.
///
/// This implementation provides full functionality for development and testing
/// but is not suitable for production use with large datasets.
///
/// ## Features:
/// - Fast in-memory operations
/// - Full query support with Dart predicates
/// - Automatic sorting and filtering
/// - Perfect for unit testing and development
class InMemoryReadModelRepository<T extends ReadModel>
    implements IReadModelRepository<T> {
  final Map<String, T> _store = {};

  @override
  Future<T?> getById(String id) async {
    return _store[id];
  }

  @override
  Future<void> save(T readModel) async {
    _store[readModel.id] = readModel;
  }

  @override
  Future<bool> delete(String id) async {
    return _store.remove(id) != null;
  }

  @override
  Future<List<T>> query(Map<String, dynamic> criteria) async {
    // Simple implementation - could be enhanced with more sophisticated filtering
    var results = _store.values.toList();

    // Apply basic filtering based on criteria
    for (final entry in criteria.entries) {
      final key = entry.key;
      final value = entry.value;

      if (key == 'orderBy') {
        // Handle sorting
        if (value == 'lastUpdated') {
          results.sort((a, b) => a.lastUpdated.compareTo(b.lastUpdated));
        }
      } else if (key == 'limit') {
        // Handle limiting
        final limit = value as int;
        if (results.length > limit) {
          results = results.take(limit).toList();
        }
      }
      // Additional criteria can be implemented as needed
    }

    return results;
  }

  @override
  Future<List<T>> getAll() async {
    return _store.values.toList();
  }

  @override
  Future<int> count([Map<String, dynamic>? criteria]) async {
    if (criteria == null) {
      return _store.length;
    }
    final filtered = await query(criteria);
    return filtered.length;
  }

  @override
  Future<void> clear() async {
    _store.clear();
  }

  /// Additional method for testing - check if repository contains a read model
  bool contains(String id) => _store.containsKey(id);

  /// Additional method for testing - get all IDs
  List<String> get allIds => _store.keys.toList();
}
