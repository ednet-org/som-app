part of ednet_core;

/// Represents a concept-driven value object in Domain-Driven Design.
///
/// [ConceptValueObject] extends the traditional ValueObject pattern by making it
/// concept-driven, similar to how [Entity] is concept-driven. This enables:
/// - Automatic property discovery via [Concept] metadata
/// - Automatic `copyWith()` implementation using reflection-free property maps
/// - Runtime introspection of value object structure
/// - Domain-driven validation based on concept constraints
///
/// Unlike the legacy [ValueObject] class (which requires manual `props` and `copyWith`),
/// [ConceptValueObject] leverages the meta-model to provide these automatically.
///
/// ## Architecture Principles
///
/// 1. **Concept-Driven**: The [concept] defines attributes, not hardcoded fields
/// 2. **Meta-Model**: Uses [Concept]/[Attribute] from ednet_core meta layer
/// 3. **Automatic Equality**: Compares all concept-defined attributes
/// 4. **Automatic copyWith**: Creates copies by attribute code, not field names
/// 5. **Domain Validation**: Validates against concept constraints (required, type, etc.)
///
/// ## Example Usage
///
/// ```dart
/// // Define concept metadata
/// final domain = Domain('Commerce');
/// final model = Model('Catalog');
/// final moneyConcept = Concept(model, 'Money');
///
/// // Define attributes
/// Attribute(moneyConcept, 'amount')
///   ..type = model.domain.getType('double')
///   ..required = true;
/// Attribute(moneyConcept, 'currency')
///   ..type = model.domain.getType('String')
///   ..required = true;
///
/// // Create value object
/// final money = ConceptValueObject(moneyConcept)
///   ..setAttribute('amount', 100.0)
///   ..setAttribute('currency', 'USD');
///
/// // Automatic equality
/// final money2 = ConceptValueObject(moneyConcept)
///   ..setAttribute('amount', 100.0)
///   ..setAttribute('currency', 'USD');
/// assert(money == money2); // true
///
/// // Automatic copyWith
/// final euros = money.copyWith({'currency': 'EUR'});
/// assert(euros.getAttribute('currency') == 'EUR');
/// assert(euros.getAttribute('amount') == 100.0);
///
/// // Domain validation
/// money.setAttribute('amount', -50.0); // Throws if concept has validation
/// ```
///
/// ## Migration from ValueObject
///
/// Old pattern (manual):
/// ```dart
/// class Money extends ValueObject {
///   final double amount;
///   final String currency;
///
///   Money({required this.amount, required this.currency});
///
///   @override
///   List<Object> get props => [amount, currency];
///
///   @override
///   Money copyWith({double? amount, String? currency}) {
///     return Money(
///       amount: amount ?? this.amount,
///       currency: currency ?? this.currency,
///     );
///   }
/// }
/// ```
///
/// New pattern (concept-driven):
/// ```dart
/// final money = ConceptValueObject(moneyConcept)
///   ..setAttribute('amount', 100.0)
///   ..setAttribute('currency', 'USD');
/// ```
///
/// ## See Also
///
/// - [ValueObject] - Legacy manual value object (deprecated)
/// - [Entity] - Concept-driven entity (same pattern for mutable domain objects)
/// - [Concept] - Meta-model that drives this value object's behavior
/// - Chapter 7 (Meta-modeling) in EDNet book
class ConceptValueObject {
  /// The [Concept] that defines the metadata for this value object.
  /// It includes the attributes and validation rules.
  Concept? _concept;

  /// Internal map storing attribute values by attribute code.
  /// Key: attribute code (e.g., 'amount', 'currency')
  /// Value: attribute's current value
  Map<String, Object?> _attributeMap = <String, Object?>{};

  /// Accumulates validation or constraint violation exceptions.
  ValidationExceptions exceptions = ValidationExceptions();

  /// Creates a new [ConceptValueObject] with the given [concept].
  ///
  /// The constructor initializes all attributes with default values
  /// defined in the concept metadata (if any).
  ///
  /// Example:
  /// ```dart
  /// final money = ConceptValueObject(moneyConcept);
  /// ```
  ConceptValueObject(Concept concept) {
    _concept = concept;
    _initializeAttributes();
  }

  /// The [Concept] describing the domain structure for this value object.
  /// Throws [EDNetException] if concept is not set.
  Concept get concept {
    if (_concept == null) {
      throw EDNetException('concept is not set');
    }
    return _concept!;
  }

  /// Initializes all attributes with default or init values from concept metadata.
  void _initializeAttributes() {
    if (_concept == null) return;

    for (Attribute a in _concept!.attributes.whereType<Attribute>()) {
      if (a.init == null) {
        // No default assigned
        if (a.required) {
          // Required attributes without init remain null (must be set explicitly)
          _attributeMap[a.code] = null;
        }
      } else if (a.type?.code == 'DateTime' && a.init == 'now') {
        _attributeMap[a.code] = DateTime.now();
      } else if (a.type?.code == 'bool' && a.init == 'true') {
        _attributeMap[a.code] = true;
      } else if (a.type?.code == 'bool' && a.init == 'false') {
        _attributeMap[a.code] = false;
      } else if (a.type?.code == 'int') {
        try {
          _attributeMap[a.code] = int.parse(a.init.toString());
        } on FormatException catch (e) {
          throw TypeException(
            '${a.code} attribute init (default) value is not int: $e',
          );
        }
      } else if (a.type?.code == 'double') {
        try {
          _attributeMap[a.code] = double.parse(a.init.toString());
        } on FormatException catch (e) {
          throw TypeException(
            '${a.code} attribute init (default) value is not double: $e',
          );
        }
      } else if (a.type?.code == 'String') {
        _attributeMap[a.code] = a.init.toString();
      } else {
        _attributeMap[a.code] = a.init;
      }
    }
  }

  /// Gets the value of an attribute by its code.
  ///
  /// Parameters:
  /// - [attributeCode]: The code of the attribute (e.g., 'amount', 'currency')
  ///
  /// Returns:
  /// The attribute's value, or null if not set.
  ///
  /// Example:
  /// ```dart
  /// final amount = money.getAttribute('amount');
  /// ```
  Object? getAttribute(String attributeCode) {
    return _attributeMap[attributeCode];
  }

  /// Sets the value of an attribute by its code.
  ///
  /// This method performs domain validation:
  /// - Checks if attribute exists in concept
  /// - Validates required constraints
  /// - Validates type constraints (if strict type checking enabled)
  /// - Records validation exceptions in [exceptions]
  ///
  /// Parameters:
  /// - [attributeCode]: The code of the attribute
  /// - [value]: The new value for the attribute
  ///
  /// Throws:
  /// - [ArgumentError] if attribute doesn't exist in concept
  ///
  /// Example:
  /// ```dart
  /// money.setAttribute('amount', 100.0);
  /// money.setAttribute('currency', 'USD');
  /// ```
  void setAttribute(String attributeCode, Object? value) {
    final attribute = _concept?.attributes.singleWhereCode(attributeCode);
    if (attribute == null) {
      throw ArgumentError(
        'Attribute "$attributeCode" does not exist in concept "${_concept?.code}"',
      );
    }

    // Validate required constraint
    if (attribute.required && value == null) {
      final exception = ValidationException(
        'required',
        'Attribute "$attributeCode" is required and cannot be null',
      );
      exceptions.add(exception);
      throw exception;
    }

    _attributeMap[attributeCode] = value;
  }

  /// Validates this value object against concept constraints.
  ///
  /// Checks:
  /// - All required attributes are set (non-null)
  /// - Type constraints (if applicable)
  /// - Custom validation rules from concept metadata
  ///
  /// Throws:
  /// - [ValidationExceptions] if any constraints are violated
  ///
  /// Example:
  /// ```dart
  /// money.validate(); // Throws if amount or currency missing
  /// ```
  void validate() {
    exceptions = ValidationExceptions();

    if (_concept == null) {
      exceptions.add(ValidationException('validation', 'Concept is not set'));
      if (exceptions.length > 0) throw exceptions;
      return;
    }

    // Check required attributes
    for (Attribute a in _concept!.attributes.whereType<Attribute>()) {
      if (a.required) {
        final value = _attributeMap[a.code];
        if (value == null) {
          exceptions.add(
            ValidationException(
              'required',
              'Required attribute "${a.code}" is not set',
            ),
          );
        }
      }
    }

    if (exceptions.length > 0) {
      throw exceptions;
    }
  }

  /// Creates a copy of this value object with updated attribute values.
  ///
  /// This is the automatic `copyWith` implementation - no manual coding required!
  /// It works with any concept, any attributes, discovered at runtime.
  ///
  /// Parameters:
  /// - [updates]: Map of attribute codes to new values
  ///
  /// Returns:
  /// A new [ConceptValueObject] with updated values
  ///
  /// Example:
  /// ```dart
  /// final dollars = ConceptValueObject(moneyConcept)
  ///   ..setAttribute('amount', 100.0)
  ///   ..setAttribute('currency', 'USD');
  ///
  /// final euros = dollars.copyWith({'currency': 'EUR'});
  /// assert(euros.getAttribute('currency') == 'EUR');
  /// assert(euros.getAttribute('amount') == 100.0); // Unchanged
  /// ```
  ConceptValueObject copyWith(Map<String, Object?> updates) {
    final copy = ConceptValueObject(_concept!);

    // Copy all existing attributes
    _attributeMap.forEach((key, value) {
      copy._attributeMap[key] = value;
    });

    // Apply updates
    updates.forEach((key, value) {
      copy.setAttribute(key, value);
    });

    return copy;
  }

  /// Compares this value object with another.
  ///
  /// Equality is based on:
  /// 1. Same concept (same code)
  /// 2. All attributes have equal values
  ///
  /// This is automatic - no manual `props` list needed!
  ///
  /// Example:
  /// ```dart
  /// final money1 = ConceptValueObject(moneyConcept)
  ///   ..setAttribute('amount', 100.0)
  ///   ..setAttribute('currency', 'USD');
  ///
  /// final money2 = ConceptValueObject(moneyConcept)
  ///   ..setAttribute('amount', 100.0)
  ///   ..setAttribute('currency', 'USD');
  ///
  /// assert(money1 == money2); // true
  /// ```
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ConceptValueObject) return false;

    // Must have same concept
    if (_concept?.code != other._concept?.code) return false;

    // Compare all attributes
    if (_attributeMap.length != other._attributeMap.length) return false;

    for (final entry in _attributeMap.entries) {
      if (!other._attributeMap.containsKey(entry.key)) return false;
      if (entry.value != other._attributeMap[entry.key]) return false;
    }

    return true;
  }

  /// Generates hash code based on concept and all attribute values.
  ///
  /// Example:
  /// ```dart
  /// final hash = money.hashCode; // Consistent for same values
  /// ```
  @override
  int get hashCode {
    var hash = _concept?.code.hashCode ?? 0;
    _attributeMap.forEach((key, value) {
      hash ^= key.hashCode ^ (value?.hashCode ?? 0);
    });
    return hash;
  }

  /// Returns a string representation of this value object.
  ///
  /// Format: `ConceptCode(attr1: value1, attr2: value2, ...)`
  ///
  /// Example:
  /// ```dart
  /// print(money); // Money(amount: 100.0, currency: USD)
  /// ```
  @override
  String toString() {
    final conceptName = _concept?.code ?? 'UnknownConcept';
    final attrs = _attributeMap.entries
        .map((e) => '${e.key}: ${e.value}')
        .join(', ');
    return '$conceptName($attrs)';
  }

  /// Converts this value object to a JSON map representation.
  ///
  /// Includes:
  /// - `_type`: The concept code
  /// - All attribute codes → values
  ///
  /// Example:
  /// ```dart
  /// final json = money.toJson();
  /// // {
  /// //   '_type': 'Money',
  /// //   'amount': 100.0,
  /// //   'currency': 'USD'
  /// // }
  /// ```
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['_type'] = _concept?.code ?? 'UnknownConcept';

    _attributeMap.forEach((key, value) {
      json[key] = _serializeValue(value);
    });

    return json;
  }

  /// Serializes a value for JSON representation.
  ///
  /// Handles:
  /// - Primitives (String, num, bool)
  /// - DateTime → ISO 8601 string
  /// - Lists, Sets, Maps
  /// - Nested ConceptValueObject → toJson()
  dynamic _serializeValue(dynamic value) {
    if (value == null) return null;

    // Primitive types
    if (value is String || value is num || value is bool) return value;

    // DateTime
    if (value is DateTime) return value.toIso8601String();

    // Duration
    if (value is Duration) return value.inMicroseconds;

    // Lists
    if (value is List) {
      return value.map(_serializeValue).toList();
    }

    // Sets
    if (value is Set) {
      return value.map(_serializeValue).toList();
    }

    // Maps
    if (value is Map) {
      final result = <String, dynamic>{};
      value.forEach((k, v) => result[k.toString()] = _serializeValue(v));
      return result;
    }

    // Nested ConceptValueObject
    if (value is ConceptValueObject) {
      return value.toJson();
    }

    // Fallback to string representation
    return value.toString();
  }

  /// Creates a [ConceptValueObject] from a JSON map.
  ///
  /// Parameters:
  /// - [json]: The JSON map representation
  /// - [concept]: The concept to use for the value object
  ///
  /// Returns:
  /// A new [ConceptValueObject] with values from JSON
  ///
  /// Example:
  /// ```dart
  /// final json = {
  ///   'amount': 100.0,
  ///   'currency': 'USD'
  /// };
  /// final money = ConceptValueObject.fromJson(json, moneyConcept);
  /// ```
  factory ConceptValueObject.fromJson(
    Map<String, dynamic> json,
    Concept concept,
  ) {
    final valueObject = ConceptValueObject(concept);

    json.forEach((key, value) {
      if (key == '_type') return; // Skip type metadata

      // Only set attributes that exist in concept
      final attribute = concept.attributes.singleWhereCode(key);
      if (attribute != null) {
        valueObject.setAttribute(key, value);
      }
    });

    return valueObject;
  }

  /// Gets all attribute codes defined in the concept.
  ///
  /// Returns:
  /// List of attribute codes
  ///
  /// Example:
  /// ```dart
  /// final codes = money.attributeCodes;
  /// // ['amount', 'currency']
  /// ```
  List<String> get attributeCodes {
    return _concept?.attributes.map((a) => a.code).toList() ?? [];
  }

  /// Gets all attribute values as a map.
  ///
  /// Returns:
  /// Map of attribute code → value
  ///
  /// Example:
  /// ```dart
  /// final values = money.attributeValues;
  /// // {'amount': 100.0, 'currency': 'USD'}
  /// ```
  Map<String, Object?> get attributeValues {
    return Map.unmodifiable(_attributeMap);
  }
}
