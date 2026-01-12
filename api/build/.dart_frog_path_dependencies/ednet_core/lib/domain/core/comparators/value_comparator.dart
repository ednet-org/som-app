part of ednet_core;

/// Defines how null values should be ordered relative to non-null values.
enum NullOrdering {
  /// Null values sort before all non-null values (null < any_value).
  /// This is the default convention.
  nullsFirst,

  /// Null values sort after all non-null values (any_value < null).
  nullsLast,
}

/// Comparison strategy for entity references (concept-as-type).
enum ComparisonMode {
  /// Compare entities by their OID timestamp (default).
  /// Fast, always available, deterministic creation order.
  byOid,

  /// Compare entities by their code/name.
  /// Human-readable, lexicographic ordering.
  byCode,

  /// Compare entities by a specific attribute value.
  /// Requires attributeKey to be specified.
  byAttribute,
}

/// Comparison strategy for collections and other types.
enum ComparisonStrategy {
  /// Default comparison for the type.
  defaultStrategy,

  /// Element-by-element lexicographic comparison (for List, String).
  lexicographic,

  /// Compare by length/size only.
  byLength,

  /// Compare by size only (for Map).
  bySize,

  /// Sort elements first, then lexicographic (for Set).
  sortedLexicographic,

  /// Compare by sorted keys, then values (for Map).
  byKeys,

  /// Skip this attribute in comparison (always return 0).
  skip,

  /// Compare by OID (for entity references).
  byOid,

  /// Compare by entity code (for entity references).
  byCode,

  /// Compare by specific attribute (for entity references).
  byAttribute,

  /// Use custom comparator.
  custom,
}

/// Strategy interface for comparing values of a specific type.
///
/// Implementations of this interface provide type-specific comparison logic
/// with support for null handling and composable collection comparators.
///
/// Example:
/// ```dart
/// final comparator = StringComparator();
/// comparator.compare('apple', 'banana'); // returns negative (apple < banana)
/// comparator.compare(null, 'apple');     // returns -1 (null < any_value)
/// ```
abstract interface class ValueComparator<T> {
  /// Compares two values, returning:
  /// - A negative number if value1 < value2
  /// - Zero if value1 == value2
  /// - A positive number if value1 > value2
  ///
  /// Null values are handled according to [nullOrdering].
  int compare(T? value1, T? value2);

  /// Checks if this comparator can handle the given value.
  ///
  /// Returns true if the value is null or of the expected type.
  bool canCompare(dynamic value);

  /// The null ordering strategy for this comparator.
  NullOrdering get nullOrdering;
}

/// Base mixin providing common null handling logic for comparators.
mixin NullHandlingComparator<T> implements ValueComparator<T> {
  @override
  NullOrdering get nullOrdering => NullOrdering.nullsFirst;

  /// Handles null comparison according to nullOrdering.
  /// Returns null if both values are non-null (comparison should continue).
  int? handleNulls(T? value1, T? value2) {
    if (value1 == null && value2 == null) return 0;

    if (value1 == null) {
      return nullOrdering == NullOrdering.nullsFirst ? -1 : 1;
    }

    if (value2 == null) {
      return nullOrdering == NullOrdering.nullsFirst ? 1 : -1;
    }

    return null; // Continue with actual comparison
  }
}

/// A fallback comparator that uses toString() for comparison.
///
/// This is used for unknown types to ensure we never throw an exception
/// during comparison. Instead, we produce deterministic ordering based
/// on string representation.
class FallbackComparator with NullHandlingComparator<Object> {
  /// Creates a fallback comparator.
  const FallbackComparator();

  @override
  int compare(Object? value1, Object? value2) {
    final nullResult = handleNulls(value1, value2);
    if (nullResult != null) return nullResult;

    return value1.toString().compareTo(value2.toString());
  }

  @override
  bool canCompare(dynamic value) => true; // Can compare anything
}

/// A dynamic comparator that infers type and delegates to appropriate comparator.
///
/// This is used for heterogeneous collections (List<dynamic>) where
/// element types are not known at compile time.
class DynamicComparator with NullHandlingComparator<Object> {
  /// Creates a dynamic comparator.
  const DynamicComparator();

  /// Type precedence for heterogeneous comparison.
  /// Lower number = sorts earlier.
  static int _getTypePriority(dynamic value) {
    if (value is bool) return 1;
    if (value is num) return 2;
    if (value is String) return 3;
    if (value is DateTime) return 4;
    if (value is Duration) return 5;
    if (value is Uri) return 6;
    if (value is List) return 7;
    if (value is Set) return 8;
    if (value is Map) return 9;
    // Entity would be 10, but we can't check for it here without circular deps
    return 11; // Other/Unknown
  }

  @override
  int compare(Object? value1, Object? value2) {
    final nullResult = handleNulls(value1, value2);
    if (nullResult != null) return nullResult;

    // Get type priorities
    final p1 = _getTypePriority(value1);
    final p2 = _getTypePriority(value2);

    // Different type categories - use precedence
    if (p1 != p2) return p1.compareTo(p2);

    // Same category - type-specific comparison
    if (value1 is num && value2 is num) {
      return value1.compareTo(value2);
    }
    if (value1 is String && value2 is String) {
      return value1.compareTo(value2);
    }
    if (value1 is bool && value2 is bool) {
      return value1 == value2 ? 0 : (value1 ? 1 : -1);
    }
    if (value1 is DateTime && value2 is DateTime) {
      return value1.compareTo(value2);
    }
    if (value1 is Duration && value2 is Duration) {
      return value1.compareTo(value2);
    }

    // Fall back to string comparison for unknown types
    return value1.toString().compareTo(value2.toString());
  }

  @override
  bool canCompare(dynamic value) => true;
}
