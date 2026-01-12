part of ednet_core;

/// Defines the interface for a query in the system
///
/// A query is responsible for retrieving entities or aggregates
/// based on specified criteria.
abstract class IQuery {
  /// The name of the query
  String get name;

  /// The concept this query targets
  Concept get concept;

  /// Parameters for the query
  Map<String, dynamic> get parameters;

  /// Executes the query against a repository
  ///
  /// Parameters:
  /// - [repository]: The repository to execute the query against
  ///
  /// Returns:
  /// A future that resolves to a query result
  Future<EntityQueryResult> execute(dynamic repository);

  /// Creates a copy of this query with updated parameters
  ///
  /// Parameters:
  /// - [parameters]: The parameters to update
  ///
  /// Returns:
  /// A new query with updated parameters
  IQuery withParameters(Map<String, dynamic> parameters);

  /// Adds pagination to the query
  ///
  /// Parameters:
  /// - [page]: The page number
  /// - [pageSize]: The number of items per page
  ///
  /// Returns:
  /// A new query with pagination parameters
  IQuery paginate(int page, int pageSize);
}

/// Base implementation of the IQuery interface
class Query implements IQuery {
  @override
  final String name;

  @override
  final Concept concept;

  @override
  final Map<String, dynamic> parameters;

  /// Creates a new Query
  ///
  /// Parameters:
  /// - [name]: The name of the query
  /// - [concept]: The concept this query targets
  /// - [parameters]: Parameters for the query
  Query(this.name, this.concept, [this.parameters = const {}]);

  @override
  Future<EntityQueryResult> execute(dynamic repository) async {
    try {
      final result = await repository.executeQuery(this);
      if (result is EntityQueryResult) {
        return result;
      }
      return EntityQueryResult.failure(
        'Repository returned an invalid query result for $name',
        concept: concept,
      );
    } on NoSuchMethodError {
      return EntityQueryResult.failure(
        'Repository does not support executeQuery for $name',
        concept: concept,
      );
    } catch (e) {
      return EntityQueryResult.failure(
        'Query execution failed for $name: $e',
        concept: concept,
      );
    }
  }

  @override
  IQuery withParameters(Map<String, dynamic> newParameters) {
    final mergedParameters = Map<String, dynamic>.from(parameters)
      ..addAll(newParameters);
    return Query(name, concept, mergedParameters);
  }

  @override
  IQuery paginate(int page, int pageSize) {
    return withParameters({'page': page, 'pageSize': pageSize});
  }
}
