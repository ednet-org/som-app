part of ednet_core;

/// Comparator for String values.
///
/// Performs lexicographic comparison using Dart's native String.compareTo().
/// Supports optional case-insensitive comparison.
class StringComparator with NullHandlingComparator<String> {
  /// Whether comparison should be case-sensitive.
  final bool caseSensitive;

  @override
  final NullOrdering nullOrdering;

  /// Creates a string comparator.
  ///
  /// [caseSensitive] - If false, comparison ignores case differences.
  /// [nullOrdering] - How null values should be ordered.
  const StringComparator({
    this.caseSensitive = true,
    this.nullOrdering = NullOrdering.nullsFirst,
  });

  @override
  int compare(String? value1, String? value2) {
    final nullResult = handleNulls(value1, value2);
    if (nullResult != null) return nullResult;

    if (caseSensitive) {
      return value1!.compareTo(value2!);
    } else {
      return value1!.toLowerCase().compareTo(value2!.toLowerCase());
    }
  }

  @override
  bool canCompare(dynamic value) => value == null || value is String;
}

/// Comparator for numeric values (int, double, num).
///
/// Handles all numeric types uniformly using Dart's native num.compareTo().
class NumericComparator with NullHandlingComparator<num> {
  @override
  final NullOrdering nullOrdering;

  /// Creates a numeric comparator.
  const NumericComparator({this.nullOrdering = NullOrdering.nullsFirst});

  @override
  int compare(num? value1, num? value2) {
    final nullResult = handleNulls(value1, value2);
    if (nullResult != null) return nullResult;

    return value1!.compareTo(value2!);
  }

  @override
  bool canCompare(dynamic value) => value == null || value is num;
}

/// Comparator for boolean values.
///
/// Uses the convention: false < true
/// This is the standard Dart convention where false sorts before true.
class BoolComparator with NullHandlingComparator<bool> {
  @override
  final NullOrdering nullOrdering;

  /// Creates a boolean comparator.
  const BoolComparator({this.nullOrdering = NullOrdering.nullsFirst});

  @override
  int compare(bool? value1, bool? value2) {
    final nullResult = handleNulls(value1, value2);
    if (nullResult != null) return nullResult;

    // Convention: false < true
    // Both false: 0, Both true: 0
    // false vs true: -1, true vs false: 1
    if (value1 == value2) return 0;
    return value1! ? 1 : -1;
  }

  @override
  bool canCompare(dynamic value) => value == null || value is bool;
}

/// Comparator for DateTime values.
///
/// Performs chronological comparison using Dart's native DateTime.compareTo().
/// Earlier dates sort before later dates.
class DateTimeComparator with NullHandlingComparator<DateTime> {
  @override
  final NullOrdering nullOrdering;

  /// Creates a DateTime comparator.
  const DateTimeComparator({this.nullOrdering = NullOrdering.nullsFirst});

  @override
  int compare(DateTime? value1, DateTime? value2) {
    final nullResult = handleNulls(value1, value2);
    if (nullResult != null) return nullResult;

    return value1!.compareTo(value2!);
  }

  @override
  bool canCompare(dynamic value) => value == null || value is DateTime;
}

/// Comparator for Duration values.
///
/// Performs duration comparison using Dart's native Duration.compareTo().
/// Shorter durations sort before longer durations.
class DurationComparator with NullHandlingComparator<Duration> {
  @override
  final NullOrdering nullOrdering;

  /// Creates a Duration comparator.
  const DurationComparator({this.nullOrdering = NullOrdering.nullsFirst});

  @override
  int compare(Duration? value1, Duration? value2) {
    final nullResult = handleNulls(value1, value2);
    if (nullResult != null) return nullResult;

    return value1!.compareTo(value2!);
  }

  @override
  bool canCompare(dynamic value) => value == null || value is Duration;
}

/// Comparator for Uri values.
///
/// Compares URIs by their string representation using lexicographic ordering.
class UriComparator with NullHandlingComparator<Uri> {
  @override
  final NullOrdering nullOrdering;

  /// Creates a Uri comparator.
  const UriComparator({this.nullOrdering = NullOrdering.nullsFirst});

  @override
  int compare(Uri? value1, Uri? value2) {
    final nullResult = handleNulls(value1, value2);
    if (nullResult != null) return nullResult;

    return value1!.toString().compareTo(value2!.toString());
  }

  @override
  bool canCompare(dynamic value) => value == null || value is Uri;
}
