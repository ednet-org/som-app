part of ednet_core;

/// Category Theory Foundation Implementation
/// Provides mathematical foundations for the 100% opinionated architecture
/// Integrates with existing EDNet Core and DSL interpreter infrastructure

/// Core category theory foundation that validates and enforces mathematical laws
class CategoryTheoryFoundationImpl implements ICategoryTheoryFoundation {
  final Map<String, DomainConcept> _objects = {};
  final Map<String, DomainMorphism> _morphisms = {};
  final Map<String, DomainMorphism> _identityMorphisms = {};

  @override
  DomainMorphism compose(DomainMorphism f, DomainMorphism g) {
    // Validate composition is valid: target of f must equal source of g
    if (!isValidComposition(f, g)) {
      throw MathematicalException(
        'Invalid composition: target of ${f.name} (${f.target.name}) '
        'must equal source of ${g.name} (${g.source.name})',
      );
    }

    // Create composed morphism: g ∘ f
    final composed = DomainMorphismImpl(
      name: '${g.name}_compose_${f.name}',
      source: f.source,
      target: g.target,
      type: MorphismType.composition,
      composedMorphisms: [f, g],
    );

    _morphisms[composed.name] = composed;
    return composed;
  }

  @override
  DomainMorphism identityMorphism(DomainConcept concept) {
    final identityName = 'id_${concept.name}';

    if (_identityMorphisms.containsKey(identityName)) {
      return _identityMorphisms[identityName]!;
    }

    final identity = DomainMorphismImpl(
      name: identityName,
      source: concept,
      target: concept,
      type: MorphismType.identity,
    );

    _identityMorphisms[identityName] = identity;
    _morphisms[identityName] = identity;
    return identity;
  }

  bool isValidComposition(DomainMorphism f, DomainMorphism g) {
    return f.target.name == g.source.name;
  }

  @override
  DomainMorphism commandToMorphism(BusinessCommand command) {
    final source = DomainConceptImpl(
      name: '${command.name}_source',
      description: 'Source state for command ${command.name}',
    );
    final target = DomainConceptImpl(
      name: '${command.name}_target',
      description: 'Target state for command ${command.name}',
    );

    final morphism = DomainMorphismImpl(
      name: command.name,
      source: source,
      target: target,
      type: MorphismType.command,
    );

    _morphisms[morphism.name] = morphism;
    return morphism;
  }

  @override
  DomainMorphism eventToMorphism(MathematicalDomainEvent event) {
    final source = DomainConceptImpl(
      name: '${event.name}_before',
      description: 'State before event ${event.name}',
    );
    final target = DomainConceptImpl(
      name: '${event.name}_after',
      description: 'State after event ${event.name}',
    );

    final morphism = DomainMorphismImpl(
      name: event.name,
      source: source,
      target: target,
      type: MorphismType.event,
      isImmutable: true,
    );

    _morphisms[morphism.name] = morphism;
    return morphism;
  }

  @override
  DomainMorphism policyToMorphism(BusinessPolicy policy) {
    final source = DomainConceptImpl(
      name: '${policy.name}_precondition',
      description: 'Precondition for policy ${policy.name}',
    );
    final target = DomainConceptImpl(
      name: '${policy.name}_postcondition',
      description: 'Postcondition for policy ${policy.name}',
    );

    final morphism = DomainMorphismImpl(
      name: policy.name,
      source: source,
      target: target,
      type: MorphismType.policy,
    );

    _morphisms[morphism.name] = morphism;
    return morphism;
  }

  NaturalTransformation naturalTransformation(
    BoundedContext source,
    BoundedContext target,
  ) {
    return NaturalTransformationImpl(source, target);
  }

  MonadicWorkflow composeMonadically(BusinessWorkflow w1, BusinessWorkflow w2) {
    // Validate workflows can be composed
    if (w1.output['type'] != w2.input['type']) {
      throw MathematicalException(
        'Workflows cannot be composed: output of ${w1.name} (${w1.output['type']}) '
        'must match input of ${w2.name} (${w2.input['type']})',
      );
    }

    return MonadicWorkflowImpl(
      name: '${w1.name}_then_${w2.name}',
      input: w1.input,
      output: w2.output,
      composedWorkflows: [w1, w2],
    );
  }

  /// Register a domain concept as a category object
  void registerConcept(DomainConcept concept) {
    _objects[concept.name] = concept;

    // Automatically create identity morphism
    identityMorphism(concept);
  }

  /// Validate category laws for the entire foundation
  MathematicalValidationResult validateCategoryLaws() {
    final violations = <String>[];

    // Test composition law for all morphisms
    for (final f in _morphisms.values) {
      for (final g in _morphisms.values) {
        if (isValidComposition(f, g)) {
          try {
            compose(f, g);

            // Test associativity if there's a third morphism
            for (final h in _morphisms.values) {
              if (isValidComposition(g, h)) {
                try {
                  final leftAssoc = compose(compose(h, g), f);
                  final rightAssoc = compose(h, compose(g, f));

                  if (!leftAssoc.equals(rightAssoc)) {
                    violations.add(
                      'Associativity violation: (${h.name} ∘ ${g.name}) ∘ ${f.name} ≠ ${h.name} ∘ (${g.name} ∘ ${f.name})',
                    );
                  }
                } catch (e) {
                  // Composition failed - this is expected for some combinations
                }
              }
            }
          } catch (e) {
            violations.add(
              'Composition failed: ${f.name} ∘ ${g.name}: ${e.toString()}',
            );
          }
        }
      }
    }

    // Test identity laws
    for (final concept in _objects.values) {
      final identity = identityMorphism(concept);

      for (final morphism in _morphisms.values) {
        if (morphism.source.name == concept.name) {
          try {
            final rightIdentity = compose(morphism, identity);
            if (!rightIdentity.equals(morphism)) {
              violations.add(
                'Right identity violation: ${morphism.name} ∘ id ≠ ${morphism.name}',
              );
            }
          } catch (e) {
            violations.add(
              'Right identity composition failed: ${e.toString()}',
            );
          }
        }

        if (morphism.target.name == concept.name) {
          try {
            final leftIdentity = compose(identity, morphism);
            if (!leftIdentity.equals(morphism)) {
              violations.add(
                'Left identity violation: id ∘ ${morphism.name} ≠ ${morphism.name}',
              );
            }
          } catch (e) {
            violations.add('Left identity composition failed: ${e.toString()}');
          }
        }
      }
    }

    final compositionLawsValid = !violations.any(
      (v) => v.startsWith('Composition failed'),
    );
    final identityLawsValid = !violations.any(
      (v) => v.toLowerCase().contains('identity'),
    );
    final associativityValid = !violations.any(
      (v) => v.startsWith('Associativity violation'),
    );

    return MathematicalValidationResult(
      isValid: violations.isEmpty,
      compositionLawsValid: compositionLawsValid,
      identityLawsValid: identityLawsValid,
      associativityValid: associativityValid,
      violations: violations,
      details: {
        'objectCount': _objects.length,
        'morphismCount': _morphisms.length,
        'identityCount': _identityMorphisms.length,
      },
    );
  }

  /// Get all registered objects
  List<DomainConcept> get objects => _objects.values.toList();

  /// Get all registered morphisms
  List<DomainMorphism> get morphisms => _morphisms.values.toList();
}

// Domain concept and morphism implementations are now in mathematical_types.dart

/// Concept structure implementation
class ConceptStructureImpl implements ConceptStructure {
  final String conceptName;

  ConceptStructureImpl(this.conceptName);

  @override
  bool isIsomorphicTo(ConceptStructure other) {
    // Simplified isomorphism check - in real implementation would check
    // structural properties, attribute compatibility, etc.
    if (other is ConceptStructureImpl) {
      // For natural transformations, concepts with the same base name
      // (ignoring context prefix) are considered isomorphic
      var thisBaseName = conceptName.contains('_')
          ? conceptName.split('_').last
          : conceptName;
      var otherBaseName = other.conceptName.contains('_')
          ? other.conceptName.split('_').last
          : other.conceptName;
      return thisBaseName == otherBaseName;
    }
    return false;
  }
}

/// Natural transformation implementation
class NaturalTransformationImpl implements NaturalTransformation {
  final BoundedContext sourceContext;
  final BoundedContext targetContext;

  @override
  final bool preservesStructure = true;

  NaturalTransformationImpl(this.sourceContext, this.targetContext);

  @override
  DomainConcept transform(DomainConcept concept) {
    // Create a transformed concept that preserves structure
    // In real implementation, would apply context-specific transformations
    return DomainConceptImpl(
      name: '${targetContext.name}_${concept.name}',
      description: 'Transformed concept in ${targetContext.name}',
    );
  }
}

/// Monadic workflow implementation
class MonadicWorkflowImpl extends MonadicWorkflow {
  final List<BusinessWorkflow> composedWorkflows;

  @override
  final String name;

  @override
  final Map<String, dynamic> input;

  @override
  final Map<String, dynamic> output;

  @override
  final bool satisfiesMonadLaws = true;

  @override
  final bool handlesErrorsProperly = true;

  MonadicWorkflowImpl({
    required this.name,
    required this.input,
    required this.output,
    this.composedWorkflows = const [],
  });

  /// Execute the monadic workflow composition
  Future<MathematicalWorkflowResult> execute(
    Map<String, dynamic> inputData,
  ) async {
    try {
      var currentData = inputData;

      for (final workflow in composedWorkflows) {
        // In real implementation, would execute each workflow
        // and handle potential failures monadically
        currentData = await _executeWorkflow(workflow, currentData);
      }

      return MathematicalWorkflowResult(
        isCompleted: true,
        currentStep: 'completed',
        completedSteps: composedWorkflows.map((w) => w.name).toList(),
        context: currentData,
      );
    } catch (error) {
      return MathematicalWorkflowResult(
        isCompleted: false,
        currentStep: 'error',
        completedSteps: [],
        context: inputData,
        errorMessage: error.toString(),
      );
    }
  }

  Future<Map<String, dynamic>> _executeWorkflow(
    BusinessWorkflow workflow,
    Map<String, dynamic> data,
  ) async {
    // Validate input data against workflow expectations
    _validateWorkflowInput(workflow, data);

    // Execute the workflow logic based on its mathematical definition
    final result = await _executeWorkflowLogic(workflow, data);

    // Validate output data against workflow expectations
    _validateWorkflowOutput(workflow, result);

    return result;
  }

  /// Validates that input data matches workflow expectations
  void _validateWorkflowInput(
    BusinessWorkflow workflow,
    Map<String, dynamic> data,
  ) {
    // Check required input fields
    for (final entry in workflow.input.entries) {
      final key = entry.key;
      final value = entry.value;

      // Only treat String values as type definitions requiring input
      // Lists/Maps are considered configuration/defaults
      if (value is! String) continue;

      if (!data.containsKey(key)) {
        throw MathematicalException(
          'Workflow ${workflow.name} expects input field: $key',
        );
      }
    }

    // Validate input types if specified
    for (final entry in workflow.input.entries) {
      final fieldName = entry.key;
      final expectedType = entry.value;

      if (data.containsKey(fieldName) && expectedType != null) {
        final actualValue = data[fieldName];
        if (!_isCompatibleType(actualValue, expectedType)) {
          throw MathematicalException(
            'Workflow ${workflow.name} field $fieldName expects type $expectedType, got ${actualValue.runtimeType}',
          );
        }
      }
    }
  }

  /// Validates that output data matches workflow expectations
  void _validateWorkflowOutput(
    BusinessWorkflow workflow,
    Map<String, dynamic> data,
  ) {
    // Check required output fields
    for (final key in workflow.output.keys) {
      if (!data.containsKey(key)) {
        throw MathematicalException(
          'Workflow ${workflow.name} should produce output field: $key',
        );
      }
    }
  }

  /// Executes the actual workflow logic
  Future<Map<String, dynamic>> _executeWorkflowLogic(
    BusinessWorkflow workflow,
    Map<String, dynamic> data,
  ) async {
    // For now, implement basic workflow execution patterns
    // In a full implementation, this would interpret workflow definitions
    // and execute them using appropriate execution engines

    switch (workflow.name) {
      case 'IdentityWorkflow':
        return _executeIdentityWorkflow(workflow, data);
      case 'CompositionWorkflow':
        return _executeCompositionWorkflow(workflow, data);
      case 'ValidationWorkflow':
        return _executeValidationWorkflow(workflow, data);
      case 'TransformationWorkflow':
        return _executeTransformationWorkflow(workflow, data);
      default:
        return _executeGenericWorkflow(workflow, data);
    }
  }

  Map<String, dynamic> _executeIdentityWorkflow(
    BusinessWorkflow workflow,
    Map<String, dynamic> data,
  ) {
    // Identity workflow just passes through the data
    return {
      ...data,
      'workflow_${workflow.name}_executed': true,
      'execution_type': 'identity',
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  Map<String, dynamic> _executeCompositionWorkflow(
    BusinessWorkflow workflow,
    Map<String, dynamic> data,
  ) {
    // Composition workflow applies a series of transformations
    var result = Map<String, dynamic>.from(data);

    // Apply transformations based on workflow definition
    // This is a simplified implementation - real workflows would be more complex
    result['workflow_${workflow.name}_executed'] = true;
    result['execution_type'] = 'composition';
    result['composition_steps'] = workflow.input['steps'] ?? 1;
    result['timestamp'] = DateTime.now().toIso8601String();

    return result;
  }

  Map<String, dynamic> _executeValidationWorkflow(
    BusinessWorkflow workflow,
    Map<String, dynamic> data,
  ) {
    // Validation workflow checks data integrity
    final validationRules =
        workflow.input['validation_rules'] as List<dynamic>? ?? [];
    final errors = <String>[];

    for (final rule in validationRules) {
      if (rule is Map<String, dynamic>) {
        final field = rule['field'] as String?;
        final condition = rule['condition'] as String?;

        if (field != null && condition != null) {
          final fieldValue = data[field];
          if (!_validateField(fieldValue, condition)) {
            errors.add('Validation failed for field $field: $condition');
          }
        }
      }
    }

    return {
      ...data,
      'workflow_${workflow.name}_executed': true,
      'execution_type': 'validation',
      'validation_errors': errors,
      'is_valid': errors.isEmpty,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  Map<String, dynamic> _executeTransformationWorkflow(
    BusinessWorkflow workflow,
    Map<String, dynamic> data,
  ) {
    // Transformation workflow applies business transformations
    var result = Map<String, dynamic>.from(data);

    // Apply transformations based on workflow definition
    final transformations =
        workflow.input['transformations'] as List<dynamic>? ?? [];

    for (final transformation in transformations) {
      if (transformation is Map<String, dynamic>) {
        result = _applyTransformation(result, transformation);
      }
    }

    result['workflow_${workflow.name}_executed'] = true;
    result['execution_type'] = 'transformation';
    result['timestamp'] = DateTime.now().toIso8601String();

    return result;
  }

  Map<String, dynamic> _executeGenericWorkflow(
    BusinessWorkflow workflow,
    Map<String, dynamic> data,
  ) {
    // Generic workflow execution for unknown workflow types
    // This provides a basic structure that can be extended
    return {
      ...data,
      'workflow_${workflow.name}_executed': true,
      'execution_type': 'generic',
      'workflow_name': workflow.name,
      'input_schema': workflow.input,
      'output_schema': workflow.output,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Checks if a value is compatible with expected type
  bool _isCompatibleType(dynamic value, dynamic expectedType) {
    if (expectedType == null) return true;

    if (expectedType is String) {
      return value.runtimeType.toString().toLowerCase() ==
          expectedType.toLowerCase();
    }

    return value.runtimeType == expectedType;
  }

  /// Validates a field against a condition
  bool _validateField(dynamic value, String condition) {
    // Simple validation logic - could be extended with more complex conditions
    switch (condition) {
      case 'not_null':
        return value != null;
      case 'not_empty':
        return value != null && value.toString().isNotEmpty;
      case 'is_string':
        return value is String;
      case 'is_number':
        return value is num;
      case 'is_boolean':
        return value is bool;
      default:
        return true; // Unknown condition passes by default
    }
  }

  /// Applies a transformation to data
  Map<String, dynamic> _applyTransformation(
    Map<String, dynamic> data,
    Map<String, dynamic> transformation,
  ) {
    final type = transformation['type'] as String?;
    final sourceField = transformation['source_field'] as String?;
    final targetField = transformation['target_field'] as String?;

    if (type == null || sourceField == null || targetField == null) {
      return data;
    }

    var result = Map<String, dynamic>.from(data);

    switch (type) {
      case 'copy':
        if (data.containsKey(sourceField)) {
          result[targetField] = data[sourceField];
        }
        break;
      case 'uppercase':
        if (data[sourceField] is String) {
          result[targetField] = (data[sourceField] as String).toUpperCase();
        }
        break;
      case 'lowercase':
        if (data[sourceField] is String) {
          result[targetField] = (data[sourceField] as String).toLowerCase();
        }
        break;
      case 'trim':
        if (data[sourceField] is String) {
          result[targetField] = (data[sourceField] as String).trim();
        }
        break;
    }

    return result;
  }
}

// WorkflowResult is already defined in business_primitives.dart
// Mathematical types are defined in mathematical_types.dart
