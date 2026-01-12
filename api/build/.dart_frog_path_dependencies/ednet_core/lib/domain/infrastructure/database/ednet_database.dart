part of ednet_core;

/// Database abstraction for EDNet Core
///
/// This interface provides a database abstraction that can be implemented
/// by different database providers, such as Drift, SQLite, Firebase, etc.
abstract class EDNetDatabase {
  /// Executes a custom SQL statement
  Future<void> customStatement(String sql);

  /// Executes a custom select query
  Future<QueryResult> customSelect(
    String sql, {
    required List<Variable> variables,
  });

  /// Executes a custom insert query
  Future<void> customInsert(String sql, {required List<Variable> variables});

  /// Executes a transaction
  Future<T> transaction<T>(Future<T> Function() action);
}

/// Query result from a select operation
abstract class QueryResult {
  /// Returns all rows from the query
  Future<List<QueryRow>> get();

  /// Returns a single row or null if no rows are found
  Future<QueryRow?> getSingleOrNull();

  /// Returns a single row or throws an exception if no rows are found
  Future<QueryRow> getSingle();
}

/// A row in a query result
abstract class QueryRow {
  /// Reads a value from the row
  T read<T>(String column);

  /// Reads a nullable value from the row
  T? readNullable<T>(String column);
}

/// A variable in a SQL query
class Variable {
  /// The value of the variable
  final dynamic value;

  /// Creates a new variable
  const Variable(this.value);
}
