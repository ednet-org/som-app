part of ednet_core;

/// Comparator for List values.
///
/// Performs lexicographic element-by-element comparison:
/// - Elements are compared in order from index 0
/// - First differing element determines the result
/// - If all compared elements are equal, shorter list < longer list
///
/// Example:
/// ```dart
/// [1, 2, 3] < [1, 2, 4]   // 3 < 4 at index 2
/// [1, 2] < [1, 2, 3]      // [1,2] is prefix of [1,2,3]
/// [] < [1]                 // empty < non-empty
/// ```
class ListComparator<T> with NullHandlingComparator<List<T>> {
  /// The comparator to use for element comparison.
  final ValueComparator<T>? elementComparator;

  @override
  final NullOrdering nullOrdering;

  /// Creates a list comparator.
  ///
  /// [elementComparator] - Comparator for list elements. If null, uses dynamic comparison.
  /// [nullOrdering] - How null values should be ordered.
  const ListComparator({
    this.elementComparator,
    this.nullOrdering = NullOrdering.nullsFirst,
  });

  @override
  int compare(List<T>? value1, List<T>? value2) {
    final nullResult = handleNulls(value1, value2);
    if (nullResult != null) return nullResult;

    final list1 = value1!;
    final list2 = value2!;

    final minLength = list1.length < list2.length ? list1.length : list2.length;

    for (var i = 0; i < minLength; i++) {
      final cmp = _compareElements(list1[i], list2[i]);
      if (cmp != 0) return cmp;
    }

    // All compared elements are equal; shorter list comes first
    return list1.length.compareTo(list2.length);
  }

  int _compareElements(T e1, T e2) {
    if (elementComparator != null) {
      return elementComparator!.compare(e1, e2);
    }
    // Fall back to dynamic comparison
    return const DynamicComparator().compare(e1, e2);
  }

  @override
  bool canCompare(dynamic value) => value == null || value is List;
}

/// Comparator for Set values.
///
/// Converts sets to sorted lists, then performs lexicographic comparison:
/// 1. Sort both sets using the element comparator
/// 2. Compare as sorted lists
///
/// Example:
/// ```dart
/// {3, 1, 2} == {1, 2, 3}  // Same elements, order doesn't matter
/// {1, 2} < {1, 2, 3}      // Fewer elements
/// {1, 2, 3} < {1, 2, 4}   // 3 < 4 after sorting
/// ```
class SetComparator<T> with NullHandlingComparator<Set<T>> {
  /// The comparator to use for element comparison.
  final ValueComparator<T>? elementComparator;

  @override
  final NullOrdering nullOrdering;

  /// Creates a set comparator.
  ///
  /// [elementComparator] - Comparator for set elements. If null, uses dynamic comparison.
  /// [nullOrdering] - How null values should be ordered.
  const SetComparator({
    this.elementComparator,
    this.nullOrdering = NullOrdering.nullsFirst,
  });

  @override
  int compare(Set<T>? value1, Set<T>? value2) {
    final nullResult = handleNulls(value1, value2);
    if (nullResult != null) return nullResult;

    // Convert to sorted lists
    final sorted1 = _toSortedList(value1!);
    final sorted2 = _toSortedList(value2!);

    // Compare as lists
    return ListComparator<T>(
      elementComparator: elementComparator,
    ).compare(sorted1, sorted2);
  }

  List<T> _toSortedList(Set<T> set) {
    final list = set.toList();
    list.sort((a, b) => _compareElements(a, b));
    return list;
  }

  int _compareElements(T e1, T e2) {
    if (elementComparator != null) {
      return elementComparator!.compare(e1, e2);
    }
    return const DynamicComparator().compare(e1, e2);
  }

  @override
  bool canCompare(dynamic value) => value == null || value is Set;
}

/// Comparator for Map values.
///
/// Compares maps by sorted keys, then by values:
/// 1. Sort keys of both maps
/// 2. Compare keys as sorted lists
/// 3. If keys are equal, compare values in key order
///
/// Example:
/// ```dart
/// {'a': 1, 'b': 2} == {'b': 2, 'a': 1}  // Same entries, order doesn't matter
/// {'a': 1} < {'b': 1}                    // 'a' < 'b'
/// {'a': 1} < {'a': 2}                    // Same key, 1 < 2
/// {'a': 1} < {'a': 1, 'b': 2}            // Fewer entries
/// ```
class MapComparator<K, V> with NullHandlingComparator<Map<K, V>> {
  /// The comparator to use for key comparison.
  final ValueComparator<K>? keyComparator;

  /// The comparator to use for value comparison.
  final ValueComparator<V>? valueComparator;

  @override
  final NullOrdering nullOrdering;

  /// Creates a map comparator.
  ///
  /// [keyComparator] - Comparator for map keys. If null, uses dynamic comparison.
  /// [valueComparator] - Comparator for map values. If null, uses dynamic comparison.
  /// [nullOrdering] - How null values should be ordered.
  const MapComparator({
    this.keyComparator,
    this.valueComparator,
    this.nullOrdering = NullOrdering.nullsFirst,
  });

  @override
  int compare(Map<K, V>? value1, Map<K, V>? value2) {
    final nullResult = handleNulls(value1, value2);
    if (nullResult != null) return nullResult;

    final map1 = value1!;
    final map2 = value2!;

    // Sort keys
    final keys1 = _sortedKeys(map1);
    final keys2 = _sortedKeys(map2);

    // Compare keys first
    final keysComparator = ListComparator<K>(elementComparator: keyComparator);
    final keysCmp = keysComparator.compare(keys1, keys2);
    if (keysCmp != 0) return keysCmp;

    // Keys are equal, compare values in key order
    for (final key in keys1) {
      final cmp = _compareValues(map1[key], map2[key]);
      if (cmp != 0) return cmp;
    }

    return 0;
  }

  List<K> _sortedKeys(Map<K, V> map) {
    final keys = map.keys.toList();
    keys.sort((a, b) => _compareKeys(a, b));
    return keys;
  }

  int _compareKeys(K k1, K k2) {
    if (keyComparator != null) {
      return keyComparator!.compare(k1, k2);
    }
    return const DynamicComparator().compare(k1, k2);
  }

  int _compareValues(V? v1, V? v2) {
    if (valueComparator != null) {
      return valueComparator!.compare(v1, v2);
    }
    return const DynamicComparator().compare(v1, v2);
  }

  @override
  bool canCompare(dynamic value) => value == null || value is Map;
}
