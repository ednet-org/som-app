part of ednet_core;

/// Registry for type-specific comparators.
///
/// This singleton manages the mapping between type codes and their comparators.
/// It supports:
/// - Primitive types (String, int, double, bool, DateTime, Duration, Uri)
/// - Generic collection types (List<T>, Set<T>, Map<K,V>)
/// - Custom type registration for domain-specific comparisons
///
/// Example:
/// ```dart
/// // Get comparator for a simple type
/// final comparator = ComparatorRegistry.instance.getComparator('String');
///
/// // Get comparator for a generic type
/// final listComparator = ComparatorRegistry.instance.createFor('List<String>');
///
/// // Register a custom comparator
/// ComparatorRegistry.instance.register('CustomType', MyCustomComparator());
/// ```
class ComparatorRegistry {
  /// The singleton instance.
  static final ComparatorRegistry instance = ComparatorRegistry._();

  /// Map of type codes to their comparators.
  final Map<String, ValueComparator> _comparators = {};

  /// Private constructor that registers default comparators.
  ComparatorRegistry._() {
    _registerDefaults();
  }

  /// Registers all default comparators for primitive types.
  void _registerDefaults() {
    // Primitive types
    register('String', const StringComparator());
    register('int', const NumericComparator());
    register('double', const NumericComparator());
    register('num', const NumericComparator());
    register('bool', const BoolComparator());
    register('DateTime', const DateTimeComparator());
    register('Duration', const DurationComparator());
    register('Uri', const UriComparator());
    register('dynamic', const DynamicComparator());
    register('Object', const DynamicComparator());

    // EDNet semantic types (all string-based)
    register('Email', const StringComparator());
    register('Telephone', const StringComparator());
    register('Phone', const StringComparator());
    register('PostalCode', const StringComparator());
    register('ZipCode', const StringComparator());
    register('Name', const StringComparator());
    register('Description', const StringComparator());
    register('Currency', const StringComparator());
    register('UUID', const StringComparator());
    register('Url', const StringComparator());

    // Money is double-based
    register('Money', const NumericComparator());

    // Boolean alias
    register('Boolean', const BoolComparator());

    // Collection base types (without element type)
    register('List', const ListComparator());
    register('Set', const SetComparator());
    register('Map', const MapComparator());

    // OID comparison (timestamp-based)
    register('Oid', const DateTimeComparator());
  }

  /// Registers a comparator for a type code.
  ///
  /// [typeCode] - The type identifier (e.g., 'String', 'CustomType').
  /// [comparator] - The comparator to use for this type.
  void register(String typeCode, ValueComparator comparator) {
    _comparators[typeCode] = comparator;
  }

  /// Gets the registered comparator for a type code.
  ///
  /// Returns null if no comparator is registered for the type.
  ValueComparator? getComparator(String typeCode) {
    return _comparators[typeCode];
  }

  /// Checks if a comparator is registered for a type code.
  bool hasComparator(String typeCode) {
    return _comparators.containsKey(typeCode);
  }

  /// Unregisters the comparator for a type code.
  void unregister(String typeCode) {
    _comparators.remove(typeCode);
  }

  /// Creates a comparator for a type string, handling generics.
  ///
  /// This method parses generic type strings like "List<String>" or
  /// "Map<String, int>" and creates appropriate composite comparators.
  ///
  /// [typeString] - The full type string (e.g., 'List<String>', 'Map<K, V>').
  /// [metadata] - Optional comparison metadata for customization.
  ///
  /// Returns a comparator that can handle values of the specified type.
  ValueComparator createFor(String typeString, [ComparisonMetadata? metadata]) {
    // Check if it's a generic type
    final genericStart = typeString.indexOf('<');
    if (genericStart > 0) {
      return _createGenericComparator(typeString, genericStart, metadata);
    }

    // Check for registered comparator
    final registered = getComparator(typeString);
    if (registered != null) {
      return registered;
    }

    // Fall back to dynamic comparator for unknown types
    return const FallbackComparator();
  }

  /// Creates a comparator for a generic type.
  ValueComparator _createGenericComparator(
    String typeString,
    int genericStart,
    ComparisonMetadata? metadata,
  ) {
    final containerName = typeString.substring(0, genericStart).trim();
    final genericEnd = typeString.lastIndexOf('>');

    if (genericEnd < genericStart) {
      // Malformed - return fallback
      return const FallbackComparator();
    }

    final genericContent = typeString
        .substring(genericStart + 1, genericEnd)
        .trim();
    final typeArgs = _splitTypeArguments(genericContent);

    switch (containerName.toLowerCase()) {
      case 'list':
        final elementComparator = typeArgs.isNotEmpty
            ? createFor(typeArgs[0], metadata)
            : const DynamicComparator();
        return ListComparator(elementComparator: elementComparator);

      case 'set':
        final elementComparator = typeArgs.isNotEmpty
            ? createFor(typeArgs[0], metadata)
            : const DynamicComparator();
        return SetComparator(elementComparator: elementComparator);

      case 'map':
        final keyComparator = typeArgs.isNotEmpty
            ? createFor(typeArgs[0], metadata)
            : const DynamicComparator();
        final valueComparator = typeArgs.length > 1
            ? createFor(typeArgs[1], metadata)
            : const DynamicComparator();
        return MapComparator(
          keyComparator: keyComparator,
          valueComparator: valueComparator,
        );

      default:
        // Unknown container - return fallback
        return const FallbackComparator();
    }
  }

  /// Splits generic type arguments, respecting nested generics.
  ///
  /// For example:
  /// - "String, int" → ["String", "int"]
  /// - "String, List<int>" → ["String", "List<int>"]
  /// - "Map<String, int>, List<double>" → ["Map<String, int>", "List<double>"]
  List<String> _splitTypeArguments(String content) {
    final result = <String>[];
    var depth = 0;
    var start = 0;

    for (var i = 0; i < content.length; i++) {
      final char = content[i];
      if (char == '<') {
        depth++;
      } else if (char == '>') {
        depth--;
      } else if (char == ',' && depth == 0) {
        result.add(content.substring(start, i).trim());
        start = i + 1;
      }
    }

    // Add the last segment
    if (start < content.length) {
      result.add(content.substring(start).trim());
    }

    return result;
  }

  /// Creates a comparator for entity references based on metadata.
  ///
  /// [conceptCode] - The concept name for entity type.
  /// [metadata] - Optional comparison metadata specifying mode and attribute.
  ValueComparator createEntityComparator(
    String conceptCode,
    ComparisonMetadata? metadata,
  ) {
    final mode = metadata?.mode ?? ComparisonMode.byOid;
    final attributeKey = metadata?.attributeKey;

    return EntityComparator(mode: mode, attributeKey: attributeKey);
  }

  /// Compares two values using the appropriate comparator.
  ///
  /// This is a convenience method that:
  /// 1. Gets or creates the appropriate comparator
  /// 2. Performs the comparison
  /// 3. Handles null values and unknown types gracefully
  ///
  /// [value1] - First value to compare.
  /// [value2] - Second value to compare.
  /// [typeCode] - The type code for comparator lookup.
  /// [metadata] - Optional comparison metadata.
  ///
  /// Returns: negative (a < b), zero (a == b), positive (a > b)
  int compare(
    dynamic value1,
    dynamic value2,
    String typeCode, [
    ComparisonMetadata? metadata,
  ]) {
    // Check if comparison is disabled
    if (metadata?.enabled == false) return 0;

    // Get or create comparator
    final comparator = createFor(typeCode, metadata);
    return comparator.compare(value1, value2);
  }
}
