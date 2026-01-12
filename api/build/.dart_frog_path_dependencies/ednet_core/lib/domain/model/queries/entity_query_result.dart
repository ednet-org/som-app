part of ednet_core;

/// Represents the result of an entity query operation
///
/// This class encapsulates the results of a query operation on entities,
/// including success/failure status, the result entities, and any metadata.
///
/// Type parameters:
/// - [T]: The entity type
class EntityQueryResult<T extends Entity<dynamic>> {
  /// Whether the query was successful
  final bool isSuccess;

  /// The list of entities returned by the query
  final List<T> entities;

  /// The concept these entities represent
  final Concept concept;

  /// Any error message if the query failed
  final String? errorMessage;

  /// Additional metadata about the query
  final Map<String, dynamic> metadata;

  /// Creates a new successful EntityQueryResult
  ///
  /// Parameters:
  /// - [entities]: The list of entities to include in the result
  /// - [concept]: The concept these entities represent
  /// - [metadata]: Optional metadata
  EntityQueryResult.success(
    this.entities, {
    required this.concept,
    Map<String, dynamic>? metadata,
  }) : isSuccess = true,
       errorMessage = null,
       this.metadata = metadata ?? {};

  /// Creates a new failed EntityQueryResult
  ///
  /// Parameters:
  /// - [errorMessage]: The error message
  /// - [concept]: The concept that was queried
  /// - [metadata]: Optional metadata
  EntityQueryResult.failure(
    String this.errorMessage, {
    required this.concept,
    Map<String, dynamic>? metadata,
  }) : isSuccess = false,
       entities = [],
       this.metadata = metadata ?? {};

  /// The total count of entities, if available
  int? get totalCount => metadata['totalCount'] as int?;

  /// The current page, if paginated
  int? get page => metadata['page'] as int?;

  /// The page size, if paginated
  int? get pageSize => metadata['pageSize'] as int?;

  /// Execution time in milliseconds, if available
  int? get executionTimeMs => metadata['executionTimeMs'] as int?;

  /// The first entity in the result, or null if there are no results
  T? get firstOrNull => entities.isNotEmpty ? entities.first : null;

  /// Maps the entities to a new type
  ///
  /// Type parameters:
  /// - [R]: The result type
  ///
  /// Parameters:
  /// - [mapper]: A function that maps a T to an R
  ///
  /// Returns:
  /// A new EntityQueryResult with the mapped entities
  EntityQueryResult<R> map<R extends Entity<dynamic>>(
    R Function(T entity) mapper,
  ) {
    if (!isSuccess) {
      return EntityQueryResult<R>.failure(
        errorMessage!,
        concept: concept,
        metadata: metadata,
      );
    }

    final mappedEntities = entities.map(mapper).toList();
    return EntityQueryResult<R>.success(
      mappedEntities,
      concept: concept,
      metadata: metadata,
    );
  }

  /// Converts the query result to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'isSuccess': isSuccess,
      'entities': entities.map((e) => e.toJson()).toList(),
      'concept': {'code': concept.code, 'entry': concept.entry},
      'errorMessage': errorMessage,
      'metadata': metadata,
    };
  }
}
