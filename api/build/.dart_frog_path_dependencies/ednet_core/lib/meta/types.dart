part of ednet_core;

class AttributeTypes extends Entities<AttributeType> {}

/// Represents a data type in the domain model with support for constraints.
///
/// AttributeType defines the validation rules for attribute values, including:
/// - Basic type validation (int, String, DateTime, etc.)
/// - Min/max value constraints for numeric types
/// - Min/max length and pattern constraints for string types
/// - Format validation for specialized types (Email, Uri)
///
/// These types can be used to:
/// - Validate entity attribute values
/// - Generate UI validation
/// - Document domain constraints
class AttributeType extends Entity<AttributeType> {
  /// The base type name (String, int, double, etc.)
  late String base;

  /// Maximum length for string values, or storage size for other types
  late int length;

  /// Minimum value constraint for numeric types
  num? _minValue;

  /// Maximum value constraint for numeric types
  num? _maxValue;

  /// Minimum length constraint for string types
  int? _minLength;

  /// Pattern constraint for string validation
  String? _pattern;

  /// The constraint validator instance (created on demand)
  TypeConstraintValidator? _constraintValidator;

  /// The domain that owns this type
  Domain domain;

  /// Element type for List<T>, Set<T> - the T type
  AttributeType? _elementType;

  /// Key type for Map<K,V> - the K type
  AttributeType? _keyType;

  /// Value type for Map<K,V> - the V type (same as elementType for consistency)
  AttributeType? get valueType => _elementType;

  /// Last validation error message for collection element validation
  String? _lastCollectionError;

  /// Comparison metadata from YAML configuration
  ComparisonMetadata? _comparisonMetadata;

  /// Gets comparison metadata for this type.
  ComparisonMetadata? get comparisonMetadata => _comparisonMetadata;

  /// Sets comparison metadata (typically from YAML parsing).
  set comparisonMetadata(ComparisonMetadata? metadata) {
    _comparisonMetadata = metadata;
  }

  /// Creates a new attribute type in the specified domain with the given code.
  ///
  /// The type details are set based on the typeCode:
  /// - String types have various default lengths depending on their semantic meaning
  /// - Numeric types have default sizes
  /// - Specialized types like Email, URL, etc. have appropriate base types and lengths
  ///
  /// Parameters:
  /// - domain: The domain that owns this type
  /// - typeCode: The code identifying this type (e.g., 'String', 'int', 'Email')
  AttributeType(this.domain, String typeCode) {
    if (typeCode == 'String') {
      base = typeCode;
      length = 64;
    } else if (typeCode == 'num') {
      base = typeCode;
      length = 8;
    } else if (typeCode == 'int') {
      base = typeCode;
      length = 8;
    } else if (typeCode == 'double') {
      base = typeCode;
      length = 8;
    } else if (typeCode == 'bool') {
      base = typeCode;
      length = 8;
    } else if (typeCode == 'DateTime') {
      base = typeCode;
      length = 16;
    } else if (typeCode == 'Duration') {
      base = typeCode;
      length = 16;
    } else if (typeCode == 'Uri') {
      base = typeCode;
      length = 80;
    } else if (typeCode == 'Email') {
      base = 'String';
      length = 48;
    } else if (typeCode == 'Telephone') {
      base = 'String';
      length = 16;
    } else if (typeCode == 'PostalCode') {
      base = 'String';
      length = 16;
    } else if (typeCode == 'ZipCode') {
      base = 'String';
      length = 16;
    } else if (typeCode == 'Name') {
      base = 'String';
      length = 32;
    } else if (typeCode == 'Description') {
      base = 'String';
      length = 256;
    } else if (typeCode == 'Money') {
      base = 'double';
      length = 8;
    } else if (typeCode == 'dynamic') {
      base = typeCode;
      length = 64;
    } else if (typeCode == 'Other') {
      base = 'dynamic';
      length = 128;
    } else if (typeCode.startsWith('List<')) {
      base = 'List';
      length = 64;
      _parseGenericElementType(typeCode, domain);
    } else if (typeCode.startsWith('Set<')) {
      base = 'Set';
      length = 64;
      _parseGenericElementType(typeCode, domain);
    } else if (typeCode.startsWith('Map<')) {
      base = 'Map';
      length = 64;
      _parseMapTypes(typeCode, domain);
    } else {
      base = typeCode;
      length = 96;
    }
    code = typeCode;
    domain.types.add(this);
  }

  /// Parses element type from generic type like List<String> or Set<int>
  void _parseGenericElementType(String typeCode, Domain domain) {
    final start = typeCode.indexOf('<');
    final end = typeCode.lastIndexOf('>');
    if (start > 0 && end > start) {
      final elementTypeName = typeCode.substring(start + 1, end).trim();
      _elementType = domain.getType(elementTypeName);
      if (_elementType == null && elementTypeName.isNotEmpty) {
        // Register the element type if not present
        _elementType = AttributeType(domain, elementTypeName);
      }
    }
  }

  /// Parses key and value types from Map<K, V>
  void _parseMapTypes(String typeCode, Domain domain) {
    final start = typeCode.indexOf('<');
    final end = typeCode.lastIndexOf('>');
    if (start > 0 && end > start) {
      final content = typeCode.substring(start + 1, end).trim();
      final parts = _splitMapTypeArgs(content);
      if (parts.length >= 2) {
        final keyTypeName = parts[0].trim();
        final valueTypeName = parts[1].trim();

        _keyType = domain.getType(keyTypeName);
        if (_keyType == null && keyTypeName.isNotEmpty) {
          _keyType = AttributeType(domain, keyTypeName);
        }

        _elementType = domain.getType(valueTypeName);
        if (_elementType == null && valueTypeName.isNotEmpty) {
          _elementType = AttributeType(domain, valueTypeName);
        }
      }
    }
  }

  /// Splits Map type arguments respecting nested generics
  List<String> _splitMapTypeArgs(String content) {
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

    if (start < content.length) {
      result.add(content.substring(start).trim());
    }

    return result;
  }

  /// Gets the element type for List<T> or Set<T>
  AttributeType? get elementType => _elementType;

  /// Gets the key type for Map<K, V>
  AttributeType? get keyType => _keyType;

  /// Whether this is a List type
  bool get isList => base == 'List';

  /// Whether this is a Set type
  bool get isSet => base == 'Set';

  /// Whether this is a Map type
  bool get isMap => base == 'Map';

  /// Whether this is a collection type (List, Set, or Map)
  bool get isCollection => isList || isSet || isMap;

  /// Sets a minimum value constraint for numeric types.
  ///
  /// This constraint ensures that numeric values are greater than or equal to
  /// the specified minimum value during validation.
  ///
  /// Parameters:
  /// - minValue: The minimum allowed value
  ///
  /// Throws:
  /// - TypeException if applied to a non-numeric type
  void setMinValue(num minValue) {
    if (base != 'int' && base != 'double' && base != 'num') {
      throw TypeException(
        'Minimum value constraint can only be set for numeric types',
      );
    }
    _minValue = minValue;
    _constraintValidator =
        null; // Reset validator to regenerate with new constraints
  }

  /// Sets a maximum value constraint for numeric types.
  ///
  /// This constraint ensures that numeric values are less than or equal to
  /// the specified maximum value during validation.
  ///
  /// Parameters:
  /// - maxValue: The maximum allowed value
  ///
  /// Throws:
  /// - TypeException if applied to a non-numeric type
  void setMaxValue(num maxValue) {
    if (base != 'int' && base != 'double' && base != 'num') {
      throw TypeException(
        'Maximum value constraint can only be set for numeric types',
      );
    }
    _maxValue = maxValue;
    _constraintValidator =
        null; // Reset validator to regenerate with new constraints
  }

  /// Sets a minimum length constraint for string types.
  ///
  /// This constraint ensures that string values have at least the specified
  /// number of characters during validation.
  ///
  /// Parameters:
  /// - minLength: The minimum required length
  ///
  /// Throws:
  /// - TypeException if applied to a non-string type
  void setMinLength(int minLength) {
    if (base != 'String') {
      throw TypeException(
        'Minimum length constraint can only be set for string types',
      );
    }
    _minLength = minLength;
    _constraintValidator =
        null; // Reset validator to regenerate with new constraints
  }

  /// Sets a pattern constraint for string types.
  ///
  /// This constraint ensures that string values match the specified regular expression
  /// pattern during validation.
  ///
  /// Parameters:
  /// - pattern: The regular expression pattern to match against
  ///
  /// Throws:
  /// - TypeException if applied to a non-string type
  void setPattern(String pattern) {
    if (base != 'String') {
      throw TypeException(
        'Pattern constraint can only be set for string types',
      );
    }
    _pattern = pattern;
    _constraintValidator =
        null; // Reset validator to regenerate with new constraints
  }

  /// Creates or retrieves the constraint validator for this type
  TypeConstraintValidator _getConstraintValidator() {
    if (_constraintValidator != null) {
      return _constraintValidator!;
    }

    // Create appropriate validator based on type
    if (base == 'int') {
      _constraintValidator = TypeConstraintValidator.forInt(
        min: _minValue as int?,
        max: _maxValue as int?,
      );
    } else if (base == 'double') {
      _constraintValidator = TypeConstraintValidator.forDouble(
        min: _minValue as double?,
        max: _maxValue as double?,
      );
    } else if (code == 'Email') {
      _constraintValidator = TypeConstraintValidator.forEmail();
    } else if (code == 'Uri') {
      _constraintValidator = TypeConstraintValidator.forUrl();
    } else if (base == 'String') {
      _constraintValidator = TypeConstraintValidator.forString(
        minLength: _minLength,
        maxLength: length,
        pattern: _pattern,
      );
    } else {
      // Default validator that always returns true for types without constraints
      _constraintValidator = TypeConstraintValidator._('default', (_) => true);
    }

    return _constraintValidator!;
  }

  /// Checks if a string value matches the email format pattern.
  ///
  /// Parameters:
  /// - email: The string to validate as an email address
  ///
  /// Returns:
  /// - true if the string has a valid email format, false otherwise
  bool isEmail(String email) {
    var regexp = RegExp(r'\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\b');
    return regexp.hasMatch(email);
  }

  /// Validates a string value against the type's rules.
  ///
  /// This method is used for validating string representations of values,
  /// such as when parsing user input or importing data.
  ///
  /// Parameters:
  /// - value: The string value to validate
  ///
  /// Returns:
  /// - true if the string can be parsed as a valid value of this type, false otherwise
  bool validate(String value) {
    if (base == 'num') {
      try {
        num.parse(value);
      } on FormatException {
        return false;
      }
    } else if (base == 'int') {
      try {
        int.parse(value);
      } on FormatException {
        return false;
      }
    } else if (base == 'double') {
      try {
        double.parse(value);
      } on FormatException {
        return false;
      }
    } else if (base == 'bool') {
      if (value != 'true' && value != 'false') {
        return false;
      }
    } else if (base == 'DateTime') {
      try {
        DateTime.parse(value);
      } on FormatException {
        return false;
      }
    } else if (base == 'Duration') {
      // validation?
    } else if (base == 'Uri') {
      var uri = Uri.parse(value);
      if (uri.host == '') {
        return false;
      }
    } else if (code == 'Email') {
      return isEmail(value);
    }
    return true;
  }

  /// Validates a value against this type's constraints.
  ///
  /// This performs both basic type checking and additional constraint validation:
  /// - Checks if the value is of the correct type (int, String, etc.)
  /// - If constraints are defined, applies them (min/max value, length, pattern, etc.)
  /// - For collections, validates each element against the element type
  ///
  /// Parameters:
  /// - value: The value to validate
  ///
  /// Returns:
  /// - true if the value is valid for this type and satisfies all constraints, false otherwise
  bool validateValue(dynamic value) {
    // Skip validation for null values
    if (value == null) {
      return true;
    }

    // Clear previous collection error
    _lastCollectionError = null;

    // First check if the basic type is correct
    bool basicTypeValid = _validateBasicType(value);
    if (!basicTypeValid) {
      return false;
    }

    // For collection types, validate elements
    if (isCollection) {
      return _validateCollectionElements(value);
    }

    // Apply additional constraint validation if any constraints are set
    if (_hasConstraints()) {
      return _getConstraintValidator().validate(value);
    }

    // If no constraints, basic type validation is sufficient
    return true;
  }

  /// Validates elements of a collection.
  ///
  /// For List and Set, validates each element against the element type.
  /// For Map, validates both keys and values against their respective types.
  bool _validateCollectionElements(dynamic value) {
    if (isList && value is List) {
      return _validateListElements(value);
    } else if (isSet && value is Set) {
      return _validateSetElements(value);
    } else if (isMap && value is Map) {
      return _validateMapEntries(value);
    }
    return true;
  }

  /// Validates each element in a List against the element type.
  bool _validateListElements(List value) {
    final elemType = _elementType;
    if (elemType == null) {
      return true; // No element type constraint
    }

    for (var i = 0; i < value.length; i++) {
      final element = value[i];
      if (!elemType.validateValue(element)) {
        _lastCollectionError =
            'List element at index $i is invalid: ${elemType.getValidationError() ?? "type mismatch"}';
        return false;
      }
    }
    return true;
  }

  /// Validates each element in a Set against the element type.
  bool _validateSetElements(Set value) {
    final elemType = _elementType;
    if (elemType == null) {
      return true; // No element type constraint
    }

    var index = 0;
    for (final element in value) {
      if (!elemType.validateValue(element)) {
        _lastCollectionError =
            'Set element at index $index is invalid: ${elemType.getValidationError() ?? "type mismatch"}';
        return false;
      }
      index++;
    }
    return true;
  }

  /// Validates each entry in a Map against the key and value types.
  bool _validateMapEntries(Map value) {
    var index = 0;
    for (final entry in value.entries) {
      // Validate key
      if (_keyType != null && !_keyType!.validateValue(entry.key)) {
        _lastCollectionError =
            'Map key at entry $index is invalid: ${_keyType!.getValidationError() ?? "type mismatch"}';
        return false;
      }

      // Validate value
      if (_elementType != null && !_elementType!.validateValue(entry.value)) {
        _lastCollectionError =
            'Map value at entry $index is invalid: ${_elementType!.getValidationError() ?? "type mismatch"}';
        return false;
      }
      index++;
    }
    return true;
  }

  /// Checks if the value matches the basic type requirements
  bool _validateBasicType(dynamic value) {
    if (base == 'num') {
      return value is num;
    } else if (base == 'int') {
      return value is int;
    } else if (base == 'double') {
      return value is double;
    } else if (base == 'bool') {
      return value is bool;
    } else if (base == 'DateTime') {
      return value is DateTime;
    } else if (base == 'Duration') {
      return value is Duration;
    } else if (base == 'Uri') {
      return value is Uri;
    } else if (code == 'Email') {
      return value is String;
    } else if (base == 'String') {
      return value is String;
    } else if (base == 'List') {
      return value is List;
    } else if (base == 'Set') {
      return value is Set;
    } else if (base == 'Map') {
      return value is Map;
    } else if (base == 'dynamic') {
      return true; // dynamic accepts any value
    }
    return true;
  }

  /// Checks if any constraints are defined for this type
  bool _hasConstraints() {
    return _minValue != null ||
        _maxValue != null ||
        _minLength != null ||
        _pattern != null ||
        code == 'Email' ||
        code == 'Uri';
  }

  /// Gets the most recent validation error message.
  ///
  /// After a call to [validateValue] that returns false, this method can be
  /// called to retrieve a detailed description of why validation failed.
  ///
  /// Returns:
  /// - A descriptive error message, or null if no validation has been performed
  ///   or the last validation was successful
  String? getValidationError() {
    // First check for collection element errors
    if (_lastCollectionError != null) {
      return _lastCollectionError;
    }
    // Then check constraint validator errors
    return _hasConstraints() ? _getConstraintValidator().getLastError() : null;
  }

  /// Compares two values of this type.
  ///
  /// This method enables sorting and comparison operations on values of the same type.
  /// It delegates to the ComparatorRegistry which provides type-specific comparators
  /// for all types including collections, entity references, and custom types.
  ///
  /// Parameters:
  /// - value1: The first value to compare
  /// - value2: The second value to compare
  ///
  /// Returns:
  /// - A negative number if value1 < value2
  /// - Zero if value1 == value2
  /// - A positive number if value1 > value2
  ///
  /// Note: This method never throws. For unsupported types, it falls back to
  /// toString() comparison to ensure deterministic ordering.
  int compare(var value1, var value2) {
    // Check if comparison is disabled via metadata
    if (_comparisonMetadata?.enabled == false) return 0;

    // Delegate to the ComparatorRegistry for type-specific comparison
    return ComparatorRegistry.instance.compare(
      value1,
      value2,
      code,
      _comparisonMetadata,
    );
  }

  /// Converts this type to a map suitable for serialization.
  ///
  /// This method enhances the base toGraph implementation by adding
  /// type-specific details and constraints.
  ///
  /// Returns:
  /// - A map containing the serialized representation of this type
  @override
  Map<String, dynamic> toGraph() {
    final graph = super.toGraph();
    graph['base'] = base;
    graph['length'] = length;

    // Include constraints in the graph representation
    if (_minValue != null) graph['minValue'] = _minValue;
    if (_maxValue != null) graph['maxValue'] = _maxValue;
    if (_minLength != null) graph['minLength'] = _minLength;
    if (_pattern != null) graph['pattern'] = _pattern;

    return graph;
  }
}
