part of ednet_core;

final Logger _queryLogger = Logger('ednet_core.cqrs.query');

/// Base class for all queries in CQRS architecture.
///
/// Queries represent requests for read-only data and are the "Q" side of CQRS.
/// They are optimized for data retrieval and work with read models to provide
/// fast, denormalized access to application data.
///
/// From the book Chapter 6: "Queries provide optimized read access to read models"
///
/// ## Key Characteristics:
/// - **Read-only**: Queries never modify application state
/// - **Optimized**: Designed for specific data access patterns
/// - **Typed**: Strongly typed with expected return types
/// - **Parameterized**: Support flexible filtering and paging
///
/// ## Usage:
/// ```dart
/// class GetOrdersQuery extends Query<List<OrderReadModel>> {
///   final String? status;
///   final int? customerId;
///   final int limit;
///
///   GetOrdersQuery({
///     this.status,
///     this.customerId,
///     this.limit = 50,
///   });
///
///   @override
///   String get queryName => 'GetOrders';
///
///   @override
///   Map<String, dynamic> get parameters => {
///     if (status != null) 'status': status,
///     if (customerId != null) 'customerId': customerId,
///     'limit': limit,
///   };
/// }
/// ```
///
/// ## EDNet Core Integration:
/// - Executed through QueryBus for consistent routing
/// - Handled by IQueryHandler implementations
/// - Works with ReadModel repositories for data access
/// - Supports caching and performance optimization
abstract class CqrsQuery<TResult> {
  /// The name of this query for identification and routing.
  ///
  /// Used by the QueryBus to route queries to appropriate handlers
  /// and for debugging and monitoring purposes.
  String get queryName;

  /// Parameters for this query execution.
  ///
  /// Contains all filtering, sorting, and paging parameters
  /// needed to execute the query. Should only include non-null
  /// values to optimize handling.
  ///
  /// ## Example:
  /// ```dart
  /// @override
  /// Map<String, dynamic> get parameters => {
  ///   if (status != null) 'status': status,
  ///   if (limit != null) 'limit': limit,
  ///   'includeDeleted': includeDeleted,
  /// };
  /// ```
  Map<String, dynamic> get parameters;

  /// Returns the query type for debugging and monitoring.
  ///
  /// Automatically inferred from the class name by default.
  String get queryType => runtimeType.toString();

  /// Indicates whether this query supports caching.
  ///
  /// Override to false for queries that must always return
  /// fresh data (e.g., real-time dashboards).
  bool get cacheable => true;

  /// Cache duration for this query type.
  ///
  /// Used by query handlers and caching layers to determine
  /// how long to cache query results.
  Duration get cacheDuration => const Duration(minutes: 5);

  @override
  String toString() => '$queryType(name: $queryName, parameters: $parameters)';
}

/// Interface for query handlers that execute queries.
///
/// Query handlers are responsible for executing specific query types
/// and returning the requested data. They work with read model repositories
/// to provide optimized data access.
///
/// ## EDNet Core Integration:
/// - Registered with QueryBus for automatic query routing
/// - Work with IReadModelRepository for data access
/// - Support caching strategies for performance
/// - Provide type-safe query execution
abstract class IQueryHandler<TQuery extends CqrsQuery<TResult>, TResult> {
  /// Determines if this handler can execute the given query.
  ///
  /// Used by the QueryBus to route queries to the correct handler.
  /// Should return true only for queries that this handler can process.
  ///
  /// ## Example:
  /// ```dart
  /// @override
  /// bool canHandle(Query query) {
  ///   return query is GetOrdersQuery;
  /// }
  /// ```
  bool canHandle(CqrsQuery query);

  /// Executes the query and returns the result.
  ///
  /// This is the core method where query handlers access read models
  /// and return the requested data. The implementation should be
  /// optimized for the specific query pattern.
  ///
  /// ## Guidelines:
  /// - Use appropriate indexes and filters
  /// - Implement pagination for large datasets
  /// - Cache results when appropriate
  /// - Handle missing data gracefully
  ///
  /// ## Example:
  /// ```dart
  /// @override
  /// Future<List<OrderReadModel>> handle(GetOrdersQuery query) async {
  ///   final criteria = <String, dynamic>{};
  ///
  ///   if (query.status != null) {
  ///     criteria['status'] = query.status;
  ///   }
  ///
  ///   return await _repository.query(criteria);
  /// }
  /// ```
  Future<TResult> handle(TQuery query);

  /// Returns the handler type for debugging and monitoring.
  ///
  /// Automatically inferred from the class name by default.
  String get handlerType => runtimeType.toString();

  /// Priority for query handler selection.
  ///
  /// When multiple handlers can handle the same query type,
  /// the handler with the lower priority number is selected.
  ///
  /// Default priority is 100 (normal priority).
  int get priority => 100;
}

/// Query bus that routes queries to appropriate handlers.
///
/// The QueryBus is the central component that coordinates query execution
/// in the CQRS architecture. It routes queries to registered handlers
/// and provides monitoring and error handling.
///
/// ## Features:
/// - Automatic query routing to handlers
/// - Priority-based handler selection
/// - Performance monitoring and statistics
/// - Error handling and logging
/// - Type-safe query execution
///
/// ## Usage:
/// ```dart
/// final queryBus = QueryBus();
///
/// // Register handlers
/// queryBus.registerHandler(OrderQueryHandler(orderRepository));
/// queryBus.registerHandler(CustomerQueryHandler(customerRepository));
///
/// // Execute queries
/// final orders = await queryBus.execute(GetOrdersQuery(status: 'Active'));
/// final customer = await queryBus.execute(GetCustomerQuery(customerId: 123));
/// ```
///
/// ## EDNet Core Integration:
/// - Integrates with ReadModel repositories
/// - Supports caching strategies
/// - Provides monitoring capabilities
/// - Works with projection updates for consistency
class QueryBus {
  final List<IQueryHandler> _handlers = [];
  final Map<String, int> _queryCounts = {};
  final Map<String, int> _errorCounts = {};
  final Map<String, DateTime> _lastExecuted = {};
  int _totalQueries = 0;

  /// Registers a query handler with the bus.
  ///
  /// Once registered, the handler will automatically receive
  /// queries that it can handle.
  ///
  /// ## Example:
  /// ```dart
  /// queryBus.registerHandler(OrderQueryHandler(orderRepository));
  /// ```
  void registerHandler<TQuery extends CqrsQuery<TResult>, TResult>(
    IQueryHandler<TQuery, TResult> handler,
  ) {
    _handlers.add(handler);
    _queryCounts[handler.handlerType] = 0;
    _errorCounts[handler.handlerType] = 0;
  }

  /// Unregisters a query handler from the bus.
  ///
  /// The handler will no longer receive queries after being unregistered.
  /// Returns true if a handler was found and removed.
  bool unregisterHandler(String handlerType) {
    final handlerIndex = _handlers.indexWhere(
      (handler) => handler.handlerType == handlerType,
    );

    if (handlerIndex >= 0) {
      _handlers.removeAt(handlerIndex);
      _queryCounts.remove(handlerType);
      _errorCounts.remove(handlerType);
      _lastExecuted.remove(handlerType);
      return true;
    }

    return false;
  }

  /// Executes a query and returns the result.
  ///
  /// Routes the query to the appropriate handler based on the query type
  /// and handler capabilities. If multiple handlers can handle the query,
  /// the one with the highest priority (lowest number) is selected.
  ///
  /// ## Example:
  /// ```dart
  /// final orders = await queryBus.execute(GetOrdersQuery(status: 'Active'));
  /// final customer = await queryBus.execute(GetCustomerQuery(customerId: 123));
  /// ```
  ///
  /// Throws [StateError] if no handler can handle the query.
  Future<TResult> execute<TResult>(CqrsQuery<TResult> query) async {
    // Find handlers that can handle this query
    final applicableHandlers = _handlers
        .where((handler) => handler.canHandle(query))
        .toList();

    if (applicableHandlers.isEmpty) {
      throw StateError('No handler found for query: ${query.queryName}');
    }

    // Sort by priority (lower number = higher priority)
    applicableHandlers.sort((a, b) => a.priority.compareTo(b.priority));

    final selectedHandler = applicableHandlers.first;

    try {
      _totalQueries++;
      _lastExecuted[selectedHandler.handlerType] = DateTime.now();

      // Execute the query with proper type casting
      final result = await selectedHandler.handle(query as dynamic);

      _queryCounts[selectedHandler.handlerType] =
          (_queryCounts[selectedHandler.handlerType] ?? 0) + 1;

      return result as TResult;
    } catch (error) {
      _errorCounts[selectedHandler.handlerType] =
          (_errorCounts[selectedHandler.handlerType] ?? 0) + 1;

      _queryLogger.warning(
        'Query handler ${selectedHandler.handlerType} failed to execute query ${query.queryName}: $error',
      );
      rethrow;
    }
  }

  /// Returns all registered handler types.
  List<String> get registeredHandlers =>
      _handlers.map((h) => h.handlerType).toList();

  /// Returns statistics about query execution.
  ///
  /// Useful for monitoring and debugging query performance.
  ///
  /// ## Example Statistics:
  /// ```dart
  /// {
  ///   'totalHandlers': 3,
  ///   'totalQueriesExecuted': 150,
  ///   'handlers': {
  ///     'OrderQueryHandler': {
  ///       'handlerType': 'OrderQueryHandler',
  ///       'priority': 100,
  ///       'queriesHandled': 75,
  ///       'errors': 2,
  ///       'lastExecuted': '2024-12-07T14:30:00.000Z'
  ///     },
  ///     // ... other handlers
  ///   }
  /// }
  /// ```
  Map<String, dynamic> getStatistics() {
    final handlerStats = <String, dynamic>{};

    for (final handler in _handlers) {
      final handlerType = handler.handlerType;
      handlerStats[handlerType] = {
        'handlerType': handlerType,
        'priority': handler.priority,
        'queriesHandled': _queryCounts[handlerType] ?? 0,
        'errors': _errorCounts[handlerType] ?? 0,
        'lastExecuted': _lastExecuted[handlerType]?.toIso8601String(),
      };
    }

    return {
      'totalHandlers': _handlers.length,
      'totalQueriesExecuted': _totalQueries,
      'handlers': handlerStats,
    };
  }

  /// Clears all statistics (useful for testing).
  void clearStatistics() {
    _queryCounts.clear();
    _errorCounts.clear();
    _lastExecuted.clear();
    _totalQueries = 0;

    // Reset counters for existing handlers
    for (final handler in _handlers) {
      _queryCounts[handler.handlerType] = 0;
      _errorCounts[handler.handlerType] = 0;
    }
  }

  /// Returns the number of registered handlers.
  int get handlerCount => _handlers.length;

  /// Returns the total number of queries executed.
  int get totalQueriesExecuted => _totalQueries;
}
