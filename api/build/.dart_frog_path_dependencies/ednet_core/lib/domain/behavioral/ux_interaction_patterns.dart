part of ednet_core;

/// UX Interaction Patterns Domain - Behavioral abstractions for user interface interactions
///
/// This domain models the fundamental interaction patterns that emerge from semantic UI analysis.
/// It provides behavioral abstractions that can be used across different UI implementations
/// while maintaining semantic consistency and domain-driven design principles.
class UXInteractionPatternsDomain extends Domain {
  /// Creates the UX interaction patterns domain
  UXInteractionPatternsDomain() : super('UXInteractionPatterns') {
    description = 'Domain for modeling UX interaction patterns and behaviors';
  }

  /// Initialize the domain with its model
  Model init() {
    final model = Model(this, 'InteractionPatternsModel');
    model.description = 'Model for UX interaction patterns';

    _buildInteractionPatternConcept(model);
    _buildContextualBehaviorConcept(model);
    _buildSemanticAffordanceConcept(model);
    _buildInteractionFlowConcept(model);

    return model;
  }

  void _buildInteractionPatternConcept(Model model) {
    final concept = Concept(model, 'InteractionPattern');
    concept.entry = true;
    concept.description = 'Core interaction pattern concept';
    model.concepts.add(concept);

    final semanticIntentAttr = Attribute(concept, 'semanticIntent');
    semanticIntentAttr.type = model.domain.getType('String');
    semanticIntentAttr.required = true;
    semanticIntentAttr.identifier = true;
    concept.attributes.add(semanticIntentAttr);

    final contextualMeaningAttr = Attribute(concept, 'contextualMeaning');
    contextualMeaningAttr.type = model.domain.getType('String');
    contextualMeaningAttr.required = true;
    concept.attributes.add(contextualMeaningAttr);

    final affordanceTypeAttr = Attribute(concept, 'affordanceType');
    affordanceTypeAttr.type = model.domain.getType('String');
    affordanceTypeAttr.required = true;
    concept.attributes.add(affordanceTypeAttr);

    final interactionWeightAttr = Attribute(concept, 'interactionWeight');
    interactionWeightAttr.type = model.domain.getType('num');
    interactionWeightAttr.required = false;
    concept.attributes.add(interactionWeightAttr);

    final cognitiveLoadAttr = Attribute(concept, 'cognitiveLoad');
    cognitiveLoadAttr.type = model.domain.getType('String');
    cognitiveLoadAttr.required = false;
    concept.attributes.add(cognitiveLoadAttr);
  }

  void _buildContextualBehaviorConcept(Model model) {
    final concept = Concept(model, 'ContextualBehavior');
    concept.description = 'Contextual behavior for interaction patterns';
    model.concepts.add(concept);

    final behaviorTypeAttr = Attribute(concept, 'behaviorType');
    behaviorTypeAttr.type = model.domain.getType('String');
    behaviorTypeAttr.required = true;
    concept.attributes.add(behaviorTypeAttr);

    final triggerConditionsAttr = Attribute(concept, 'triggerConditions');
    triggerConditionsAttr.type = model.domain.getType('Other'); // List type
    triggerConditionsAttr.required = true;
    concept.attributes.add(triggerConditionsAttr);

    final expectedOutcomeAttr = Attribute(concept, 'expectedOutcome');
    expectedOutcomeAttr.type = model.domain.getType('String');
    expectedOutcomeAttr.required = true;
    concept.attributes.add(expectedOutcomeAttr);

    final feedbackMechanismAttr = Attribute(concept, 'feedbackMechanism');
    feedbackMechanismAttr.type = model.domain.getType('String');
    feedbackMechanismAttr.required = false;
    concept.attributes.add(feedbackMechanismAttr);

    // Relationship: Behavior implements Pattern
    final patternConcept = model.getConcept('InteractionPattern')!;
    final parent = Parent(concept, patternConcept, 'pattern');
    parent.identifier = true;

    Child(patternConcept, concept, 'behaviors'); // Create relationship
  }

  void _buildSemanticAffordanceConcept(Model model) {
    final concept = Concept(model, 'SemanticAffordance');
    concept.description = 'Semantic affordances for user interactions';
    model.concepts.add(concept);

    final affordanceNameAttr = Attribute(concept, 'affordanceName');
    affordanceNameAttr.type = model.domain.getType('String');
    affordanceNameAttr.required = true;
    concept.attributes.add(affordanceNameAttr);

    final discoveryHintsAttr = Attribute(concept, 'discoveryHints');
    discoveryHintsAttr.type = model.domain.getType('Other'); // List type
    discoveryHintsAttr.required = true;
    concept.attributes.add(discoveryHintsAttr);

    final accessibilityRoleAttr = Attribute(concept, 'accessibilityRole');
    accessibilityRoleAttr.type = model.domain.getType('String');
    accessibilityRoleAttr.required = true;
    concept.attributes.add(accessibilityRoleAttr);

    final semanticWeightAttr = Attribute(concept, 'semanticWeight');
    semanticWeightAttr.type = model.domain.getType('num');
    semanticWeightAttr.required = false;
    concept.attributes.add(semanticWeightAttr);
  }

  void _buildInteractionFlowConcept(Model model) {
    final concept = Concept(model, 'InteractionFlow');
    concept.description = 'Interaction flow sequences and logic';
    model.concepts.add(concept);

    final flowNameAttr = Attribute(concept, 'flowName');
    flowNameAttr.type = model.domain.getType('String');
    flowNameAttr.required = true;
    concept.attributes.add(flowNameAttr);

    final stepSequenceAttr = Attribute(concept, 'stepSequence');
    stepSequenceAttr.type = model.domain.getType('Other'); // List type
    stepSequenceAttr.required = true;
    concept.attributes.add(stepSequenceAttr);

    final branchingLogicAttr = Attribute(concept, 'branchingLogic');
    branchingLogicAttr.type = model.domain.getType('Other'); // Map type
    branchingLogicAttr.required = false;
    concept.attributes.add(branchingLogicAttr);

    final completionCriteriaAttr = Attribute(concept, 'completionCriteria');
    completionCriteriaAttr.type = model.domain.getType('Other'); // List type
    completionCriteriaAttr.required = true;
    concept.attributes.add(completionCriteriaAttr);
  }
}

/// Core UX Interaction Patterns that emerged from semantic icon analysis
enum CoreInteractionPattern {
  /// Design & Creative Operations
  designSystemManagement(
    'design-system',
    'Manage design system components and tokens',
  ),
  colorThemeOperation('color-theme', 'Manipulate color schemes and themes'),
  typographyControl(
    'typography',
    'Control text styling and typography hierarchy',
  ),
  layoutOrganization(
    'layout',
    'Organize spatial relationships and positioning',
  ),

  /// Connection & Integration Operations
  connectionEstablishment(
    'connection',
    'Establish connections between systems',
  ),
  apiIntegration('api-connection', 'Integrate with external APIs and services'),
  dataSynchronization('figma-sync', 'Synchronize data between systems'),
  resourceImporting('import', 'Import external resources into system'),

  /// Navigation & Discovery Operations
  informationBrowsing('view', 'Browse and discover information'),
  contextualSettings('settings', 'Access context-appropriate configuration'),
  contentEditing('edit', 'Modify existing content or data'),
  resourceSharing('copy', 'Share or duplicate resources'),

  /// Feedback & Status Operations
  successConfirmation('success', 'Confirm successful operation completion'),
  errorHandling('error', 'Handle and communicate errors'),
  progressIndication('loading', 'Indicate ongoing processes'),
  warningAlert('warning', 'Alert users to potential issues'),

  /// System & Management Operations
  performanceOptimization('performance', 'Optimize system performance'),
  securityManagement('security', 'Manage security and access control'),
  fileOperations('file', 'Perform file system operations'),
  userManagement('user', 'Manage user accounts and permissions');

  const CoreInteractionPattern(this.semanticIntent, this.description);

  /// The semantic intent of this interaction pattern
  final String semanticIntent;

  /// Human-readable description of the pattern
  final String description;
}

/// UX Context Types that influence interaction behavior
enum UXContextType {
  /// Primary action contexts - bold, prominent styling
  primaryAction('primary-action', high: true, prominent: true),

  /// Secondary action contexts - subtle, supportive styling
  secondaryAction('secondary-action', high: false, prominent: false),

  /// Navigation contexts - minimal, directional styling
  navigation('navigation', high: false, prominent: false),

  /// Header contexts - clean, hierarchical styling
  header('header', high: false, prominent: true),

  /// Status contexts - communicative, clear styling
  status('status', high: false, prominent: true),

  /// System contexts - technical, precise styling
  system('system', high: true, prominent: false);

  const UXContextType(
    this.contextName, {
    required this.high,
    required this.prominent,
  });

  /// The name of this context type
  final String contextName;

  /// Whether this context requires high-attention styling
  final bool high;

  /// Whether this context should be visually prominent
  final bool prominent;
}

/// Cognitive Load Categories for UX interactions
enum CognitiveLoadCategory {
  /// Minimal cognitive load - immediate, instinctive actions
  instinctive('instinctive', loadLevel: 1),

  /// Low cognitive load - simple, familiar actions
  simple('simple', loadLevel: 2),

  /// Medium cognitive load - requires some thought
  moderate('moderate', loadLevel: 3),

  /// High cognitive load - complex, requires planning
  complex('complex', loadLevel: 4),

  /// Maximum cognitive load - expert-level, requires deep knowledge
  expert('expert', loadLevel: 5);

  const CognitiveLoadCategory(this.category, {required this.loadLevel});

  /// The category name
  final String category;

  /// Numerical load level (1-5)
  final int loadLevel;
}

/// Behavioral UX Pattern Aggregate Root
class UXInteractionPatternAggregate
    extends AggregateRoot<UXInteractionPatternAggregate> {
  /// Creates UX interaction pattern aggregate
  UXInteractionPatternAggregate() : super();

  /// Resolve interaction pattern based on semantic intent and context
  InteractionResolution resolveInteraction(
    String semanticIntent,
    UXContextType context,
  ) {
    // Apply behavioral logic to determine appropriate interaction pattern
    final pattern = _findMatchingPattern(semanticIntent);
    final contextualBehavior = _determineContextualBehavior(pattern, context);
    final cognitiveLoad = _calculateCognitiveLoad(pattern, context);

    return InteractionResolution(
      pattern: pattern,
      behavior: contextualBehavior,
      cognitiveLoad: cognitiveLoad,
      affordances: _generateAffordances(pattern, context),
    );
  }

  CoreInteractionPattern? _findMatchingPattern(String semanticIntent) {
    return CoreInteractionPattern.values
        .where((pattern) => pattern.semanticIntent == semanticIntent)
        .firstOrNull;
  }

  ContextualBehavior _determineContextualBehavior(
    CoreInteractionPattern? pattern,
    UXContextType context,
  ) {
    // Behavioral rules based on pattern and context combination
    if (pattern == null) {
      return ContextualBehavior.fallback();
    }

    switch (context) {
      case UXContextType.primaryAction:
        return ContextualBehavior.prominent(pattern);
      case UXContextType.navigation:
        return ContextualBehavior.subtle(pattern);
      case UXContextType.header:
        return ContextualBehavior.hierarchical(pattern);
      case UXContextType.status:
        return ContextualBehavior.communicative(pattern);
      default:
        return ContextualBehavior.standard(pattern);
    }
  }

  CognitiveLoadCategory _calculateCognitiveLoad(
    CoreInteractionPattern? pattern,
    UXContextType context,
  ) {
    if (pattern == null) return CognitiveLoadCategory.simple;

    // Complex patterns in high-attention contexts increase cognitive load
    if (context.high && _isComplexPattern(pattern)) {
      return CognitiveLoadCategory.complex;
    }

    // Simple patterns in prominent contexts remain simple
    if (context.prominent && _isSimplePattern(pattern)) {
      return CognitiveLoadCategory.simple;
    }

    return CognitiveLoadCategory.moderate;
  }

  bool _isComplexPattern(CoreInteractionPattern pattern) {
    return [
      CoreInteractionPattern.apiIntegration,
      CoreInteractionPattern.dataSynchronization,
      CoreInteractionPattern.performanceOptimization,
      CoreInteractionPattern.securityManagement,
    ].contains(pattern);
  }

  bool _isSimplePattern(CoreInteractionPattern pattern) {
    return [
      CoreInteractionPattern.informationBrowsing,
      CoreInteractionPattern.resourceSharing,
      CoreInteractionPattern.successConfirmation,
    ].contains(pattern);
  }

  List<SemanticAffordance> _generateAffordances(
    CoreInteractionPattern? pattern,
    UXContextType context,
  ) {
    // Generate appropriate affordances based on pattern and context
    final affordances = <SemanticAffordance>[];

    if (pattern != null) {
      affordances.add(SemanticAffordance.primary(pattern, context));

      // Add secondary affordances based on pattern relationships
      affordances.addAll(_getRelatedAffordances(pattern, context));
    }

    return affordances;
  }

  List<SemanticAffordance> _getRelatedAffordances(
    CoreInteractionPattern pattern,
    UXContextType context,
  ) {
    // Pattern relationship logic for generating related affordances
    return [];
  }
}

/// Represents the resolution of an interaction pattern
class InteractionResolution {
  /// Creates an interaction resolution
  const InteractionResolution({
    required this.pattern,
    required this.behavior,
    required this.cognitiveLoad,
    required this.affordances,
  });

  /// The resolved interaction pattern
  final CoreInteractionPattern? pattern;

  /// The contextual behavior for this interaction
  final ContextualBehavior behavior;

  /// The cognitive load category
  final CognitiveLoadCategory cognitiveLoad;

  /// Generated semantic affordances
  final List<SemanticAffordance> affordances;
}

/// Represents contextual behavior for an interaction
class ContextualBehavior {
  /// Creates contextual behavior
  const ContextualBehavior({
    required this.type,
    required this.emphasis,
    required this.timing,
    required this.feedback,
  });

  /// Creates fallback behavior
  factory ContextualBehavior.fallback() => const ContextualBehavior(
    type: 'fallback',
    emphasis: 'minimal',
    timing: 'immediate',
    feedback: 'subtle',
  );

  /// Creates prominent behavior
  factory ContextualBehavior.prominent(CoreInteractionPattern pattern) =>
      const ContextualBehavior(
        type: 'prominent',
        emphasis: 'high',
        timing: 'immediate',
        feedback: 'clear',
      );

  /// Creates subtle behavior
  factory ContextualBehavior.subtle(CoreInteractionPattern pattern) =>
      const ContextualBehavior(
        type: 'subtle',
        emphasis: 'low',
        timing: 'smooth',
        feedback: 'minimal',
      );

  /// Creates hierarchical behavior
  factory ContextualBehavior.hierarchical(CoreInteractionPattern pattern) =>
      const ContextualBehavior(
        type: 'hierarchical',
        emphasis: 'contextual',
        timing: 'smooth',
        feedback: 'structured',
      );

  /// Creates communicative behavior
  factory ContextualBehavior.communicative(CoreInteractionPattern pattern) =>
      const ContextualBehavior(
        type: 'communicative',
        emphasis: 'clear',
        timing: 'immediate',
        feedback: 'informative',
      );

  /// Creates standard behavior
  factory ContextualBehavior.standard(CoreInteractionPattern pattern) =>
      const ContextualBehavior(
        type: 'standard',
        emphasis: 'balanced',
        timing: 'natural',
        feedback: 'appropriate',
      );

  /// The type of behavior
  final String type;

  /// The emphasis level
  final String emphasis;

  /// The timing characteristics
  final String timing;

  /// The feedback mechanism
  final String feedback;
}

/// Represents a semantic affordance for user interaction
class SemanticAffordance {
  /// Creates a semantic affordance
  const SemanticAffordance({
    required this.name,
    required this.role,
    required this.discoveryHints,
    required this.weight,
  });

  /// Creates primary affordance
  factory SemanticAffordance.primary(
    CoreInteractionPattern pattern,
    UXContextType context,
  ) => SemanticAffordance(
    name: pattern.semanticIntent,
    role: 'primary',
    discoveryHints: _getPrimaryDiscoveryHints(pattern, context),
    weight: 1.0,
  );

  static List<String> _getPrimaryDiscoveryHints(
    CoreInteractionPattern pattern,
    UXContextType context,
  ) {
    return ['visual-prominence', 'accessible-label', 'keyboard-shortcut'];
  }

  /// The affordance name
  final String name;

  /// The accessibility role
  final String role;

  /// Discovery hints for users
  final List<String> discoveryHints;

  /// Semantic weight (0.0 - 1.0)
  final double weight;
}
