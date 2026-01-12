part of ednet_core;

/// Metadata for customizing comparison behavior of an attribute type.
///
/// This class stores comparison configuration parsed from YAML DSL
/// and is used by the comparator registry to create appropriate comparators.
///
/// Example YAML:
/// ```yaml
/// attributes:
///   - name: customer
///     type: Customer
///     comparison:
///       enabled: true
///       strategy: by_attribute
///       attribute: lastName
///       fallback: by_oid
/// ```
class ComparisonMetadata {
  /// Whether comparison is enabled for this attribute.
  /// If false, comparison always returns 0 (equal).
  final bool enabled;

  /// The comparison strategy to use.
  final ComparisonStrategy strategy;

  /// For entity references: the comparison mode (byOid, byCode, byAttribute).
  final ComparisonMode? mode;

  /// The attribute key to use when strategy is byAttribute.
  final String? attributeKey;

  /// Fallback strategy if primary comparison fails.
  final ComparisonStrategy? fallback;

  /// Fallback mode for entity references.
  final ComparisonMode? fallbackMode;

  /// Whether comparison should be case-sensitive (for strings).
  final bool caseSensitive;

  /// Null ordering preference.
  final NullOrdering nullOrdering;

  /// Creates comparison metadata.
  const ComparisonMetadata({
    this.enabled = true,
    this.strategy = ComparisonStrategy.defaultStrategy,
    this.mode,
    this.attributeKey,
    this.fallback,
    this.fallbackMode,
    this.caseSensitive = true,
    this.nullOrdering = NullOrdering.nullsFirst,
  });

  /// Creates comparison metadata from a YAML map.
  ///
  /// Expected YAML structure:
  /// ```yaml
  /// comparison:
  ///   enabled: true
  ///   strategy: lexicographic
  ///   attribute: lastName
  ///   fallback: by_oid
  ///   caseSensitive: false
  ///   nullOrdering: nullsFirst
  /// ```
  factory ComparisonMetadata.fromYaml(Map<String, dynamic> yaml) {
    return ComparisonMetadata(
      enabled: yaml['enabled'] as bool? ?? true,
      strategy: _parseStrategy(yaml['strategy'] as String?),
      mode: _parseMode(yaml['strategy'] as String?),
      attributeKey: yaml['attribute'] as String?,
      fallback: _parseStrategy(yaml['fallback'] as String?),
      fallbackMode: _parseMode(yaml['fallback'] as String?),
      caseSensitive: yaml['caseSensitive'] as bool? ?? true,
      nullOrdering: _parseNullOrdering(yaml['nullOrdering'] as String?),
    );
  }

  /// Parses a strategy string from YAML.
  static ComparisonStrategy _parseStrategy(String? name) {
    if (name == null || name.isEmpty) return ComparisonStrategy.defaultStrategy;

    // Normalize the name
    final normalized = name
        .toLowerCase()
        .replaceAll('_', '')
        .replaceAll('-', '');

    // Map to enum values
    switch (normalized) {
      case 'default':
      case 'defaultstrategy':
        return ComparisonStrategy.defaultStrategy;
      case 'lexicographic':
        return ComparisonStrategy.lexicographic;
      case 'bylength':
      case 'length':
        return ComparisonStrategy.byLength;
      case 'bysize':
      case 'size':
        return ComparisonStrategy.bySize;
      case 'sortedlexicographic':
      case 'sorted':
        return ComparisonStrategy.sortedLexicographic;
      case 'bykeys':
      case 'keys':
        return ComparisonStrategy.byKeys;
      case 'skip':
      case 'disabled':
        return ComparisonStrategy.skip;
      case 'byoid':
      case 'oid':
        return ComparisonStrategy.byOid;
      case 'bycode':
      case 'code':
        return ComparisonStrategy.byCode;
      case 'byattribute':
      case 'attribute':
        return ComparisonStrategy.byAttribute;
      case 'custom':
        return ComparisonStrategy.custom;
      default:
        return ComparisonStrategy.defaultStrategy;
    }
  }

  /// Parses a mode string from YAML for entity references.
  static ComparisonMode? _parseMode(String? name) {
    if (name == null || name.isEmpty) return null;

    final normalized = name
        .toLowerCase()
        .replaceAll('_', '')
        .replaceAll('-', '');

    switch (normalized) {
      case 'byoid':
      case 'oid':
        return ComparisonMode.byOid;
      case 'bycode':
      case 'code':
        return ComparisonMode.byCode;
      case 'byattribute':
      case 'attribute':
        return ComparisonMode.byAttribute;
      default:
        return null;
    }
  }

  /// Parses null ordering from YAML.
  static NullOrdering _parseNullOrdering(String? name) {
    if (name == null || name.isEmpty) return NullOrdering.nullsFirst;

    final normalized = name
        .toLowerCase()
        .replaceAll('_', '')
        .replaceAll('-', '');

    switch (normalized) {
      case 'nullslast':
      case 'last':
        return NullOrdering.nullsLast;
      case 'nullsfirst':
      case 'first':
      default:
        return NullOrdering.nullsFirst;
    }
  }

  /// Converts to a map for serialization.
  Map<String, dynamic> toMap() {
    return {
      'enabled': enabled,
      'strategy': strategy.name,
      if (mode != null) 'mode': mode!.name,
      if (attributeKey != null) 'attribute': attributeKey,
      if (fallback != null) 'fallback': fallback!.name,
      if (fallbackMode != null) 'fallbackMode': fallbackMode!.name,
      'caseSensitive': caseSensitive,
      'nullOrdering': nullOrdering.name,
    };
  }

  @override
  String toString() {
    return 'ComparisonMetadata(enabled: $enabled, strategy: ${strategy.name})';
  }
}
