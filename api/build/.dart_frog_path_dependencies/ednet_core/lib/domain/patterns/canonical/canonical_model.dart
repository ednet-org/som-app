part of ednet_core;

/// Base class for canonical data models that can transform between
/// external formats and internal canonical representations.
///
/// The Canonical Data Model pattern minimizes dependencies when integrating
/// applications that use different data formats by establishing a common
/// internal format for data interchange.
///
/// In EDNet, this pattern is crucial for:
/// * Standardizing citizen identity data across voting platforms
/// * Representing proposals and amendments in system-agnostic ways
/// * Integrating with various external identity providers
/// * Defining common formats for voting results and analytics
abstract class CanonicalModelBase<T> {
  /// The concept this model represents in the domain
  late Concept concept;

  /// The model name/identifier
  String get modelName;

  /// The model version
  String get version => '1.0.0';

  /// Converts an entity to its canonical representation
  Map<String, dynamic> toCanonical(T entity);

  /// Creates an entity from canonical representation
  T fromCanonical(Map<String, dynamic> canonicalData);

  /// Validates canonical data against business rules
  bool validate(Map<String, dynamic> canonicalData);

  /// Returns the schema definition for this canonical model
  Map<String, dynamic> getSchema();
}

/// Generic canonical model implementation for any data type
class CanonicalModel<T> extends ValueObject {
  /// The type this model represents
  final String type;

  /// The actual data in canonical form
  final T data;

  /// Additional metadata about the canonical data
  final Map<String, dynamic>? metadata;

  /// Schema version
  final String version;

  /// Timestamp when this model was created
  final DateTime createdAt;

  /// Creates a new CanonicalModel
  CanonicalModel({
    required this.type,
    required this.data,
    this.metadata,
    this.version = '1.0.0',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now() {
    validate();
  }

  /// Creates a CanonicalModel from JSON string or Map
  factory CanonicalModel.fromJson(dynamic json) {
    final Map<String, dynamic> map;
    if (json is String) {
      map = jsonDecode(json) as Map<String, dynamic>;
    } else if (json is Map<String, dynamic>) {
      map = json;
    } else {
      throw ArgumentError('json must be a String or Map<String, dynamic>');
    }

    return CanonicalModel(
      type: map['type'] as String,
      data: map['data'] as T,
      metadata: map['metadata'] as Map<String, dynamic>?,
      version: map['version'] as String? ?? '1.0.0',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
    );
  }

  /// Converts this model to JSON
  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'data': data,
      'metadata': metadata,
      'version': version,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Creates a copy of this model with optionally modified properties
  CanonicalModel<T> copyWith({
    String? type,
    T? data,
    Map<String, dynamic>? metadata,
    String? version,
    DateTime? createdAt,
  }) {
    return CanonicalModel<T>(
      type: type ?? this.type,
      data: data ?? this.data,
      metadata: metadata ?? Map.from(this.metadata ?? {}),
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object> get props => [
    type,
    data ?? Object(),
    metadata ?? {},
    version,
    createdAt,
  ];
}

/// Model formatter for converting between canonical and external formats
class ModelFormatter {
  final Map<String, Function> _formatters = {};

  /// Registers a formatter for a specific external format
  void registerFormatter(String formatName, Function formatter) {
    _formatters[formatName] = formatter;
  }

  /// Converts external data to canonical format
  Map<String, dynamic> toCanonical(String formatName, dynamic externalData) {
    final formatter = _formatters[formatName];
    if (formatter == null) {
      throw ArgumentError('No formatter registered for format: $formatName');
    }
    return formatter(externalData);
  }

  /// Converts canonical data to external format
  dynamic fromCanonical(String formatName, Map<String, dynamic> canonicalData) {
    final formatter = _formatters['${formatName}_reverse'];
    if (formatter == null) {
      throw ArgumentError(
        'No reverse formatter registered for format: $formatName',
      );
    }
    return formatter(canonicalData);
  }
}

/// Schema validator for canonical models
class ModelValidator {
  final Map<String, Map<String, dynamic>> _schemas = {};

  /// Registers a schema for a model type
  void registerSchema(String modelType, Map<String, dynamic> schema) {
    _schemas[modelType] = schema;
  }

  /// Validates data against a registered schema
  bool validate(String modelType, Map<String, dynamic> data) {
    final schema = _schemas[modelType];
    if (schema == null) {
      throw ArgumentError('No schema registered for model type: $modelType');
    }

    // Simple validation - check required fields
    final requiredFields = schema['required'] as List<String>? ?? [];
    for (final field in requiredFields) {
      if (!data.containsKey(field) || data[field] == null) {
        return false;
      }
    }

    // Check field types if specified
    final properties = schema['properties'] as Map<String, dynamic>? ?? {};
    for (final entry in properties.entries) {
      final fieldName = entry.key;
      final fieldSchema = entry.value as Map<String, dynamic>;

      if (data.containsKey(fieldName)) {
        final expectedType = fieldSchema['type'] as String?;
        final actualValue = data[fieldName];

        if (expectedType != null) {
          switch (expectedType) {
            case 'string':
              if (actualValue is! String) return false;
              break;
            case 'number':
              if (actualValue is! num) return false;
              break;
            case 'boolean':
              if (actualValue is! bool) return false;
              break;
            case 'date':
              if (actualValue is! DateTime && actualValue is! String)
                return false;
              break;
          }
        }
      }
    }

    return true;
  }

  /// Gets the schema for a model type
  Map<String, dynamic>? getSchema(String modelType) {
    return _schemas[modelType];
  }
}

/// Registry for managing canonical models
class CanonicalModelRegistry {
  final Map<String, CanonicalModelBase> _models = {};
  final ModelFormatter _formatter = ModelFormatter();
  final ModelValidator _validator = ModelValidator();

  /// Registers a canonical model
  void registerModel(CanonicalModelBase model) {
    _models[model.modelName] = model;
  }

  /// Gets a registered model by name
  CanonicalModelBase? getModel(String modelName) {
    return _models[modelName];
  }

  /// Converts external data to canonical format using registered model
  Map<String, dynamic> toCanonical(String modelName, dynamic externalData) {
    final model = _models[modelName];
    if (model == null) {
      throw ArgumentError('No model registered for: $modelName');
    }

    // Use formatter if available, otherwise assume data is already canonical
    if (externalData is Map<String, dynamic>) {
      return externalData;
    }

    throw UnsupportedError('Cannot convert external data to canonical format');
  }

  /// Converts canonical data to entity using registered model
  dynamic fromCanonical(String modelName, Map<String, dynamic> canonicalData) {
    final model = _models[modelName];
    if (model == null) {
      throw ArgumentError('No model registered for: $modelName');
    }

    // This would need to be implemented based on the specific model type
    throw UnsupportedError(
      'Entity creation from canonical data not implemented',
    );
  }

  /// Validates canonical data using registered model
  bool validate(String modelName, Map<String, dynamic> canonicalData) {
    final model = _models[modelName];
    if (model == null) {
      return false;
    }

    return model.validate(canonicalData) &&
        _validator.validate(modelName, canonicalData);
  }

  /// Gets all registered model names
  List<String> getRegisteredModels() {
    return _models.keys.toList();
  }

  /// Gets the formatter for external format conversions
  ModelFormatter get formatter => _formatter;

  /// Gets the validator for schema validation
  ModelValidator get validator => _validator;
}
