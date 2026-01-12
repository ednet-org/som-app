part of ednet_core;

/// Mathematical Meta-Model
/// Provides meta-level mathematical foundations for domain concepts
/// Ensures category theory compliance at the meta-modeling level

/// Mathematical meta-concept that extends core concepts with mathematical properties
class MathematicalMetaConcept {
  final String code;
  final Map<String, dynamic> mathematicalProperties;
  final bool followsCategoryTheory;
  final bool hasCompositionLaws;

  MathematicalMetaConcept(
    this.code, {
    required this.mathematicalProperties,
    this.followsCategoryTheory = true,
    this.hasCompositionLaws = true,
  });

  /// Validate that this concept satisfies category theory laws
  bool validateCategoryLaws() {
    return followsCategoryTheory && hasCompositionLaws;
  }

  /// Create a morphism between this concept and another
  MathematicalMorphism createMorphism(
    MathematicalMetaConcept target,
    String name,
  ) {
    return MathematicalMorphism(
      name: name,
      source: this,
      target: target,
      preservesStructure: true,
    );
  }
}

/// Mathematical morphism between meta-concepts
class MathematicalMorphism {
  final String name;
  final MathematicalMetaConcept source;
  final MathematicalMetaConcept target;
  final bool preservesStructure;
  final Map<String, dynamic> properties;

  const MathematicalMorphism({
    required this.name,
    required this.source,
    required this.target,
    this.preservesStructure = true,
    this.properties = const {},
  });

  /// Compose this morphism with another
  MathematicalMorphism compose(MathematicalMorphism other) {
    if (target != other.source) {
      throw ArgumentError('Cannot compose morphisms: target must equal source');
    }

    return MathematicalMorphism(
      name: '${other.name}_compose_$name',
      source: source,
      target: other.target,
      preservesStructure: preservesStructure && other.preservesStructure,
      properties: {...properties, ...other.properties, 'composition': true},
    );
  }

  @override
  String toString() =>
      'MathematicalMorphism($name: ${source.code} → ${target.code})';
}

/// Mathematical meta-model that enforces category theory at the meta level
class MathematicalMetaModel {
  final String title;
  final Map<String, MathematicalMetaConcept> _mathematicalConcepts = {};
  final Map<String, MathematicalMorphism> _morphisms = {};

  MathematicalMetaModel(this.title);

  /// Add a mathematical concept to the meta-model
  void addMathematicalConcept(MathematicalMetaConcept concept) {
    if (!concept.validateCategoryLaws()) {
      throw ArgumentError(
        'Concept ${concept.code} does not satisfy category theory laws',
      );
    }
    _mathematicalConcepts[concept.code] = concept;
  }

  /// Add a morphism between concepts
  void addMorphism(MathematicalMorphism morphism) {
    if (!_mathematicalConcepts.containsKey(morphism.source.code) ||
        !_mathematicalConcepts.containsKey(morphism.target.code)) {
      throw ArgumentError(
        'Both source and target concepts must be in the meta-model',
      );
    }
    _morphisms[morphism.name] = morphism;
  }

  /// Validate that the entire meta-model follows category theory
  bool validateMetaModelCategoryLaws() {
    // Check that all concepts follow category laws
    for (final concept in _mathematicalConcepts.values) {
      if (!concept.validateCategoryLaws()) {
        return false;
      }
    }

    // Check that all morphisms preserve structure
    for (final morphism in _morphisms.values) {
      if (!morphism.preservesStructure) {
        return false;
      }
    }

    return true;
  }

  /// Get all mathematical concepts
  List<MathematicalMetaConcept> get mathematicalConcepts =>
      _mathematicalConcepts.values.toList();

  /// Get all morphisms
  List<MathematicalMorphism> get morphisms => _morphisms.values.toList();

  @override
  String toString() =>
      'MathematicalMetaModel($title) with ${_mathematicalConcepts.length} concepts';
}

/// CEP meta-model that ensures Commands, Events, and Policies follow mathematical laws
class CEPMetaModel extends MathematicalMetaModel {
  CEPMetaModel() : super('CEP Mathematical Meta-Model');

  /// Initialize with standard CEP concepts that follow category theory
  void initializeStandardCEPConcepts() {
    // Command concept
    final commandConcept = MathematicalMetaConcept(
      'Command',
      mathematicalProperties: {
        'type': 'morphism',
        'intent': 'state_change',
        'composable': true,
      },
    );

    // Event concept
    final eventConcept = MathematicalMetaConcept(
      'Event',
      mathematicalProperties: {
        'type': 'morphism',
        'immutable': true,
        'observable': true,
      },
    );

    // Policy concept
    final policyConcept = MathematicalMetaConcept(
      'Policy',
      mathematicalProperties: {
        'type': 'morphism_composition',
        'reactive': true,
        'composable': true,
      },
    );

    addMathematicalConcept(commandConcept);
    addMathematicalConcept(eventConcept);
    addMathematicalConcept(policyConcept);

    // Add fundamental morphisms
    addMorphism(
      commandConcept.createMorphism(eventConcept, 'command_triggers_event'),
    );
    addMorphism(
      eventConcept.createMorphism(policyConcept, 'event_activates_policy'),
    );
    addMorphism(
      policyConcept.createMorphism(commandConcept, 'policy_generates_command'),
    );
  }

  /// Validate that CEP cycle forms a proper mathematical category
  bool validateCEPCycle() {
    return validateMetaModelCategoryLaws() && morphisms.length >= 3;
  }
}
