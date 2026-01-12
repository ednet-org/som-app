/// Context for expression evaluation containing variable bindings
class EvaluationContext {
  final Map<String, dynamic> _variables;

  EvaluationContext(Map<String, dynamic> variables)
    : _variables = Map.from(variables);

  /// Create an empty context
  factory EvaluationContext.empty() => EvaluationContext({});

  /// Get a value by variable path (supports dot notation)
  dynamic getValue(String path) {
    final parts = path.split('.');
    var current = _variables[parts.first];

    if (current == null) return null;

    for (var i = 1; i < parts.length; i++) {
      if (current is Map<String, dynamic>) {
        current = current[parts[i]];
      } else {
        return null;
      }
    }

    return current;
  }

  /// Check if a variable exists
  bool hasVariable(String path) {
    return getValue(path) != null;
  }

  /// Set a variable value
  void setValue(String name, Object? value) {
    _variables[name] = value;
  }

  /// Get all variable names (top level only)
  Set<String> get variableNames => Set.unmodifiable(_variables.keys);

  /// Create a copy with additional variables
  EvaluationContext copyWith(Map<String, dynamic> additionalVariables) {
    final newVariables = <String, dynamic>{
      ..._variables,
      ...additionalVariables,
    };
    return EvaluationContext(newVariables);
  }

  @override
  String toString() {
    return 'EvaluationContext(${_variables.length} variables)';
  }
}
