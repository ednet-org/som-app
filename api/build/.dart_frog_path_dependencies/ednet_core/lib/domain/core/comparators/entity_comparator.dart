part of ednet_core;

/// Comparator for Entity values (concept-as-type references).
///
/// Supports multiple comparison modes:
/// - byOid: Compare by OID timestamp (default, fastest)
/// - byCode: Compare by entity code (human-readable)
/// - byAttribute: Compare by a specific attribute value
///
/// Example:
/// ```dart
/// final comparator = EntityComparator(mode: ComparisonMode.byOid);
/// comparator.compare(entity1, entity2);
/// ```
class EntityComparator with NullHandlingComparator<Entity> {
  /// The comparison mode to use.
  final ComparisonMode mode;

  /// The attribute key to use when mode is byAttribute.
  final String? attributeKey;

  @override
  final NullOrdering nullOrdering;

  /// Creates an entity comparator.
  ///
  /// [mode] - The comparison strategy to use.
  /// [attributeKey] - Required when mode is [ComparisonMode.byAttribute].
  /// [nullOrdering] - How null values should be ordered.
  const EntityComparator({
    this.mode = ComparisonMode.byOid,
    this.attributeKey,
    this.nullOrdering = NullOrdering.nullsFirst,
  });

  @override
  int compare(Entity? value1, Entity? value2) {
    final nullResult = handleNulls(value1, value2);
    if (nullResult != null) return nullResult;

    final entity1 = value1!;
    final entity2 = value2!;

    switch (mode) {
      case ComparisonMode.byOid:
        return _compareByOid(entity1, entity2);

      case ComparisonMode.byCode:
        return _compareByCode(entity1, entity2);

      case ComparisonMode.byAttribute:
        return _compareByAttribute(entity1, entity2);
    }
  }

  /// Compares entities by their OID timestamp.
  /// This is the default and fastest comparison mode.
  int _compareByOid(Entity entity1, Entity entity2) {
    final oid1 = entity1.oid;
    final oid2 = entity2.oid;

    // Compare by timestamp
    return oid1.timeStamp.compareTo(oid2.timeStamp);
  }

  /// Compares entities by their code (human-readable identifier).
  int _compareByCode(Entity entity1, Entity entity2) {
    final code1 = entity1.code;
    final code2 = entity2.code;

    return code1.compareTo(code2);
  }

  /// Compares entities by a specific attribute value.
  int _compareByAttribute(Entity entity1, Entity entity2) {
    if (attributeKey == null || attributeKey!.isEmpty) {
      // Fall back to byOid if no attribute specified
      return _compareByOid(entity1, entity2);
    }

    final value1 = entity1.getAttribute(attributeKey!);
    final value2 = entity2.getAttribute(attributeKey!);

    // Use dynamic comparison for attribute values
    return const DynamicComparator().compare(value1, value2);
  }

  @override
  bool canCompare(dynamic value) => value == null || value is Entity;
}
