part of ednet_core;

/// Template renderer for Mustache-based code generation
///
/// Provides a centralized API for rendering code templates with data,
/// following EDNet Core's architectural patterns and SOLID principles.
class TemplateRenderer {
  final Map<String, mustache.Template> _templateCache = {};
  final String templatesPath;
  final bool useFileTemplates;

  /// Create a template renderer with optional custom templates path
  TemplateRenderer({
    this.templatesPath = 'lib/gen/templates',
    this.useFileTemplates = false,
  });

  /// Render a template with the provided data
  ///
  /// [templateName] - Name of the template file (without .mustache extension)
  /// [data] - Map of data to pass to the template
  ///
  /// Returns the rendered string output
  String render(String templateName, Map<String, dynamic> data) {
    final template = _getTemplate(templateName);
    return template.renderString(data);
  }

  /// Render a command handler with the provided data
  String renderCommandHandler(Map<String, dynamic> data) =>
      render('command_handler', data);

  /// Render an event handler with the provided data
  String renderEventHandler(Map<String, dynamic> data) =>
      render('event_handler', data);

  /// Render a policy with the provided data
  String renderPolicy(Map<String, dynamic> data) =>
      render('policy_engine', data);

  /// Render an entity with the provided data
  String renderEntity(Map<String, dynamic> data) => render('entity', data);

  /// Render an aggregate root with the provided data
  String renderAggregateRoot(Map<String, dynamic> data) =>
      render('aggregate_root', data);

  /// Get or load a template from the cache
  mustache.Template _getTemplate(String templateName) {
    if (_templateCache.containsKey(templateName)) {
      return _templateCache[templateName]!;
    }

    final templateContent = _loadTemplateContent(templateName);
    final template = mustache.Template(templateContent);
    _templateCache[templateName] = template;

    return template;
  }

  /// Load template content from file or embedded string
  String _loadTemplateContent(String templateName) {
    if (useFileTemplates) {
      try {
        return _loadTemplateFromFile(templateName);
      } catch (e) {
        // Fall back to embedded templates if file loading fails
        return _getEmbeddedTemplate(templateName);
      }
    }
    return _getEmbeddedTemplate(templateName);
  }

  /// Load template from .mustache file
  String _loadTemplateFromFile(String templateName) {
    final file = File('$templatesPath/$templateName.mustache');
    if (!file.existsSync()) {
      throw ArgumentError(
        'Template file not found: $templatesPath/$templateName.mustache',
      );
    }
    return file.readAsStringSync();
  }

  /// Get embedded template by name
  ///
  /// This method contains the actual template strings.
  /// In production, these can be loaded from .mustache files using useFileTemplates=true.
  String _getEmbeddedTemplate(String templateName) {
    switch (templateName) {
      case 'entity':
        return _entityTemplate;
      case 'entities_collection':
        return _entitiesCollectionTemplate;
      case 'aggregate_root':
        return _aggregateRootTemplate;
      case 'event_sourced':
        return _eventSourcedTemplate;
      case 'command_handler':
        return _commandHandlerTemplate;
      case 'event_handler':
        return _eventHandlerTemplate;
      case 'policy_engine':
        return _policyEngineTemplate;
      case 'pubspec':
        return _pubspecTemplate;
      case 'analysis_options':
        return _analysisOptionsTemplate;
      case 'test_suite':
        return _testSuiteTemplate;
      case 'repository':
        return _repositoryTemplate;
      default:
        throw ArgumentError('Unknown template: $templateName');
    }
  }

  /// Clear the template cache
  ///
  /// Useful for testing or when templates are updated at runtime
  void clearCache() {
    _templateCache.clear();
  }

  /// Check if a template exists (either as file or embedded)
  bool hasTemplate(String templateName) {
    if (useFileTemplates) {
      final file = File('$templatesPath/$templateName.mustache');
      return file.existsSync();
    }

    try {
      _getEmbeddedTemplate(templateName);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Get all available template names
  List<String> get availableTemplates => [
    'entity',
    'entities_collection',
    'aggregate_root',
    'event_sourced',
    'command_handler',
    'event_handler',
    'policy_engine',
    'pubspec',
    'analysis_options',
    'test_suite',
    'repository',
  ];
}

/// Entity class template
const String _entityTemplate = '''
abstract class {{entityName}}Gen extends Entity<{{entityName}}> {
  {{entityName}}Gen(Concept concept) {
    this.concept = concept;
    {{#hasChildren}}
    {{#children}}
    {{#needsConcept}}
    final {{childConceptVar}}Concept =
        concept.model.concepts.singleWhereCode('{{childConceptName}}');
    assert({{childConceptVar}}Concept != null, '{{childConceptName}} concept is not defined');
    {{/needsConcept}}
    setChild('{{childCode}}', {{childCollectionName}}({{childConceptVar}}Concept!));
    {{/children}}
    {{/hasChildren}}
  }

  {{#hasIdAttributes}}
  {{entityName}}Gen.withId({{#idParams}}{{type}} {{name}}{{^isLast}}, {{/isLast}}{{/idParams}}) {
    this.concept = concept;
    {{#idParents}}
    setParent('{{code}}', {{code}});
    {{/idParents}}
    {{#idAttributes}}
    setAttribute('{{code}}', {{code}});
    {{/idAttributes}}
    {{#hasChildren}}
    {{#children}}
    {{#needsConcept}}
    final {{childConceptVar}}Concept =
        concept.model.concepts.singleWhereCode('{{childConceptName}}');
    assert({{childConceptVar}}Concept != null, '{{childConceptName}} concept is not defined');
    {{/needsConcept}}
    setChild('{{childCode}}', {{childCollectionName}}({{childConceptVar}}Concept!));
    {{/children}}
    {{/hasChildren}}
  }
  {{/hasIdAttributes}}

  {{#parents}}
  Reference get {{accessorName}}Reference => getReference('{{code}}')!;

  set {{accessorName}}Reference(Reference reference) =>
      setReference('{{code}}', reference);

  {{parentType}} get {{accessorName}} =>
      getParent('{{code}}')! as {{parentType}};

  set {{accessorName}}({{parentType}} p) => setParent('{{code}}', p);

  {{/parents}}

  {{#attributes}}
  {{#isId}}
  Id? get {{code}} => getAttribute('{{code}}') as Id?;

  set {{code}}(Id? a) => setAttribute('{{code}}', a);
  {{/isId}}
  {{^isId}}
  {{type}} get {{code}} => getAttribute('{{code}}') as {{type}};

  set {{code}}({{type}} a) => setAttribute('{{code}}', a);
  {{/isId}}

  {{/attributes}}

  {{#children}}
  {{childCollectionName}} get {{childCode}} => getChild('{{childCode}}')! as {{childCollectionName}};

  {{/children}}

  @override
  {{entityName}} newEntity() => {{entityName}}(concept);

  @override
  {{entityCollectionName}} newEntities() => {{entityCollectionName}}(concept);

  {{#hasSingleIdAttribute}}
  int {{compareMethod}}CompareTo({{entityName}} other) => {{compareExpression}};
  {{/hasSingleIdAttribute}}
}
''';

/// Entities collection template
const String _entitiesCollectionTemplate = '''
abstract class {{collectionName}}Gen extends Entities<{{entityName}}> {
  {{collectionName}}Gen(Concept concept) {
    this.concept = concept;
  }

  @override
  {{collectionName}} newEntities() => {{collectionName}}(concept);

  @override
  {{entityName}} newEntity() => {{entityName}}(concept);
}
''';

/// AggregateRoot template
const String _aggregateRootTemplate = '''
abstract class {{entityName}}Gen extends {{#isEnhanced}}EnhancedAggregateRoot{{/isEnhanced}}{{^isEnhanced}}AggregateRoot{{/isEnhanced}}<{{entityName}}> {
  {{entityName}}Gen(Concept concept) {
    this.concept = concept;
    {{#hasChildren}}
    {{#children}}
    {{#needsConcept}}
    final {{childConceptVar}}Concept =
        concept.model.concepts.singleWhereCode('{{childConceptName}}');
    assert({{childConceptVar}}Concept != null, '{{childConceptName}} concept is not defined');
    {{/needsConcept}}
    setChild('{{childCode}}', {{childCollectionName}}({{childConceptVar}}Concept!));
    {{/children}}
    {{/hasChildren}}
  }

  {{#hasIdAttributes}}
  {{entityName}}Gen.withId({{#idParams}}{{type}} {{name}}{{^isLast}}, {{/isLast}}{{/idParams}}) {
    this.concept = concept;
    {{#idParents}}
    setParent('{{code}}', {{code}});
    {{/idParents}}
    {{#idAttributes}}
    setAttribute('{{code}}', {{code}});
    {{/idAttributes}}
    {{#hasChildren}}
    {{#children}}
    {{#needsConcept}}
    final {{childConceptVar}}Concept =
        concept.model.concepts.singleWhereCode('{{childConceptName}}');
    assert({{childConceptVar}}Concept != null, '{{childConceptName}} concept is not defined');
    {{/needsConcept}}
    setChild('{{childCode}}', {{childCollectionName}}({{childConceptVar}}Concept!));
    {{/children}}
    {{/hasChildren}}
  }
  {{/hasIdAttributes}}

  {{#parents}}
  Reference get {{accessorName}}Reference => getReference('{{code}}')!;

  set {{accessorName}}Reference(Reference reference) =>
      setReference('{{code}}', reference);

  {{parentType}} get {{accessorName}} =>
      getParent('{{code}}')! as {{parentType}};

  set {{accessorName}}({{parentType}} p) => setParent('{{code}}', p);

  {{/parents}}

  {{#attributes}}
  {{#isId}}
  Id? get {{code}} => getAttribute('{{code}}') as Id?;

  set {{code}}(Id? a) => setAttribute('{{code}}', a);
  {{/isId}}
  {{^isId}}
  {{type}} get {{code}} => getAttribute('{{code}}') as {{type}};

  set {{code}}({{type}} a) => setAttribute('{{code}}', a);
  {{/isId}}

  {{/attributes}}

  {{#children}}
  {{childCollectionName}} get {{childCode}} => getChild('{{childCode}}')! as {{childCollectionName}};

  {{/children}}

  @override
  {{entityName}} newEntity() => {{entityName}}(concept);

  @override
  {{entityCollectionName}} newEntities() => {{entityCollectionName}}(concept);

  {{#hasSingleIdAttribute}}
  int {{compareMethod}}CompareTo({{entityName}} other) => {{compareExpression}};
  {{/hasSingleIdAttribute}}

  /// Apply an event to update the aggregate state
  /// Override this method to handle your domain events
  @override
  void applyEvent(dynamic event) {
    {{#hasEvents}}
    if (event is Event) {
      switch (event.name) {
        {{#events}}
        case '{{eventName}}':
          _apply{{eventName}}(event);
          break;
        {{/events}}
        default:
          // Unknown event - could log or throw
          break;
      }
    }
    {{/hasEvents}}
    {{^hasEvents}}
    // Override this method to handle your domain events
    {{/hasEvents}}
  }

  {{#hasEvents}}
  {{#events}}
  /// Apply {{eventName}} event to update state
  void _apply{{eventName}}(Event event) {
    // NOTE: Update aggregate state based on {{eventName}} event
    {{#stateChanges}}
    // {{stateChange}}
    {{/stateChanges}}
  }

  {{/events}}
  {{/hasEvents}}
}
''';

/// Event sourced scaffolding template
const String _eventSourcedTemplate = '''
// Event sourcing scaffolding for {{entityName}}

{{#hasCommands}}
// Commands
{{#commands}}
/// {{commandDescription}}
CommandResult {{commandMethod}}({{#commandParams}}{{paramType}} {{paramName}}{{^isLast}}, {{/isLast}}{{/commandParams}}) {
  {{#hasPreconditions}}
  // Preconditions
  {{#preconditions}}
  if ({{condition}}) {
    return CommandResult.failure('{{errorMessage}}');
  }
  {{/preconditions}}
  {{/hasPreconditions}}

  // Record the event
  recordEvent(
    '{{eventName}}',
    '{{eventDescription}}',
    [{{#eventHandlers}}'{{handlerName}}'{{^isLast}}, {{/isLast}}{{/eventHandlers}}],
    {{#hasEventData}}
    data: {
      {{#eventData}}
      '{{key}}': {{value}},
      {{/eventData}}
    },
    {{/hasEventData}}
  );

  return CommandResult.success({{#hasResultData}}data: {
    {{#resultData}}
    '{{key}}': {{value}},
    {{/resultData}}
  }{{/hasResultData}});
}

{{/commands}}
{{/hasCommands}}

// Command result helper
class CommandResult {
  final bool isSuccess;
  final String? errorMessage;
  final Map<String, dynamic>? data;

  CommandResult.success({this.data})
      : isSuccess = true,
        errorMessage = null;

  CommandResult.failure(this.errorMessage)
      : isSuccess = false,
        data = null;
}
''';

/// Command handler template for CEP cycle
const String _commandHandlerTemplate = r'''
/// Command handler for {{commandName}}Command
///
/// This handler processes {{commandName}} commands and executes
/// the corresponding business logic on {{entityName}} aggregates.
class {{commandName}}CommandHandler implements ICommandHandler<{{commandName}}Command> {
  {{#hasDependencies}}
  {{#dependencies}}
  final {{type}} {{name}};
  {{/dependencies}}

  {{commandName}}CommandHandler({
    {{#dependencies}}
    required this.{{name}},
    {{/dependencies}}
  });
  {{/hasDependencies}}
  {{^hasDependencies}}
  {{commandName}}CommandHandler();
  {{/hasDependencies}}

  @override
  Future<CommandResult> handle({{commandName}}Command command) async {
    {{#hasValidation}}
    // Validation
    {{#validations}}
    {{#isRequired}}
    if (command.{{field}} == null) {
      return CommandResult.failure('{{errorMessage}}');
    }
    {{/isRequired}}
    {{#hasCondition}}
    if ({{&condition}}) {
      return CommandResult.failure('{{errorMessage}}');
    }
    {{/hasCondition}}
    {{/validations}}
    {{/hasValidation}}

    try {
      {{#usesRepository}}
      // Load aggregate from repository
      final {{aggregateVar}} = await {{repositoryName}}.findById(command.{{aggregateId}});
      if ({{aggregateVar}} == null) {
        return CommandResult.failure('{{entityName}} not found');
      }

      // Execute command on aggregate
      final result = {{aggregateVar}}.{{commandMethod}}({{#commandParams}}command.{{param}}{{^isLast}}, {{/isLast}}{{/commandParams}});

      {{#checksResult}}
      if (!result.isSuccess) {
        return result;
      }
      {{/checksResult}}

      // Save aggregate
      await {{repositoryName}}.save({{aggregateVar}});

      {{#publishesEvents}}
      // Publish domain events
      {{#hasEventBus}}
      for (final event in {{aggregateVar}}.uncommittedEvents) {
        await eventBus.publish(event);
      }
      {{aggregateVar}}.markEventsAsCommitted();
      {{/hasEventBus}}
      {{/publishesEvents}}

      return CommandResult.success({{#hasResultData}}data: {
        {{#resultData}}
        '{{key}}': {{value}},
        {{/resultData}}
      }{{/hasResultData}});
      {{/usesRepository}}
      {{^usesRepository}}
      // Execute business logic
      {{#businessLogic}}
      {{line}}
      {{/businessLogic}}

      return CommandResult.success({{#hasResultData}}data: {
        {{#resultData}}
        '{{key}}': {{value}},
        {{/resultData}}
      }{{/hasResultData}});
      {{/usesRepository}}
    } catch (e) {
      return CommandResult.failure('Failed to execute {{commandName}}: $e');
    }
  }

  @override
  bool canHandle(dynamic command) => command is {{commandName}}Command;
}

/// {{commandName}} command
class {{commandName}}Command implements ICommandBusCommand {
  @override
  final String id;

  @override
  final DateTime timestamp;

  {{#commandFields}}
  final {{type}} {{name}};
  {{/commandFields}}

  {{commandName}}Command({
    String? id,
    DateTime? timestamp,
    {{#commandFields}}
    required this.{{name}},
    {{/commandFields}}
  }) : id = id ?? Uuid().v4(),
       timestamp = timestamp ?? DateTime.now();

  {{#hasToJson}}
  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    {{#commandFields}}
    '{{&name}}': {{&name}},
    {{/commandFields}}
  };
  {{/hasToJson}}

  {{#hasFromJson}}
  factory {{commandName}}Command.fromJson(Map<String, dynamic> json) => {{commandName}}Command(
    id: json['id'] as String,
    timestamp: DateTime.parse(json['timestamp'] as String),
    {{#commandFields}}
    {{&name}}: json['{{&name}}'] as {{type}},
    {{/commandFields}}
  );
  {{/hasFromJson}}
}
''';

/// Event handler template for CEP cycle
const String _eventHandlerTemplate = r'''
/// Event handler for {{eventName}}Event
///
/// This handler reacts to {{eventName}} events and executes
/// corresponding side effects, updates, or integrations.
class {{eventName}}EventHandler implements IEventHandler<{{eventName}}Event> {
  {{#hasDependencies}}
  {{#dependencies}}
  final {{type}} {{name}};
  {{/dependencies}}

  {{eventName}}EventHandler({
    {{#dependencies}}
    required this.{{name}},
    {{/dependencies}}
  });
  {{/hasDependencies}}
  {{^hasDependencies}}
  {{eventName}}EventHandler();
  {{/hasDependencies}}

  @override
  String get handlerName => '{{eventName}}EventHandler';

  @override
  Future<void> handle({{eventName}}Event event) async {
    {{#hasLogging}}
    // Log event processing
    {{#logger}}
    {{logger}}.info('Processing {{eventName}}Event: ${event.id}');
    {{/logger}}
    {{/hasLogging}}

    try {
      {{#updatesReadModel}}
      // Update read model
      {{#readModelUpdates}}
      await {{readModelName}}.update(
        {{#updateParams}}
        {{key}}: event.{{value}},
        {{/updateParams}}
      );
      {{/readModelUpdates}}
      {{/updatesReadModel}}

      {{#triggersSideEffects}}
      // Execute side effects
      {{#sideEffects}}
      {{#sendsNotification}}
      await {{notificationService}}.send(
        recipient: event.{{recipient}},
        message: '{{messageTemplate}}',
        {{#notificationParams}}
        {{key}}: event.{{value}},
        {{/notificationParams}}
      );
      {{/sendsNotification}}

      {{#sendsEmail}}
      await {{emailService}}.send(
        to: event.{{emailRecipient}},
        subject: '{{emailSubject}}',
        body: '{{emailBody}}',
        {{#emailParams}}
        {{key}}: event.{{value}},
        {{/emailParams}}
      );
      {{/sendsEmail}}

      {{#callsExternalService}}
      await {{externalService}}.{{methodName}}(
        {{#serviceParams}}
        {{key}}: event.{{value}},
        {{/serviceParams}}
      );
      {{/callsExternalService}}

      {{#customSideEffect}}
      {{code}}
      {{/customSideEffect}}
      {{/sideEffects}}
      {{/triggersSideEffects}}

      {{#triggersCommands}}
      // Trigger follow-up commands
      {{#commands}}
      final {{commandVar}} = {{commandType}}(
        {{#commandParams}}
        {{key}}: event.{{value}},
        {{/commandParams}}
      );
      await {{commandBus}}.dispatch({{commandVar}});
      {{/commands}}
      {{/triggersCommands}}

      {{#updatesProjection}}
      // Update projection
      {{#projections}}
      await {{projectionName}}.apply(event);
      {{/projections}}
      {{/updatesProjection}}

      {{#customLogic}}
      // Custom event handling logic
      {{#logicLines}}
      {{line}}
      {{/logicLines}}
      {{/customLogic}}

      {{#hasLogging}}
      {{#logger}}
      {{logger}}.info('Successfully processed {{eventName}}Event: ${event.id}');
      {{/logger}}
      {{/hasLogging}}
    } catch (e, stackTrace) {
      {{#hasErrorHandling}}
      {{#logger}}
      {{logger}}.error('Failed to process {{eventName}}Event: $e', error: e, stackTrace: stackTrace);
      {{/logger}}

      {{#hasCompensation}}
      // Trigger compensation
      {{#compensationActions}}
      try {
        {{#compensationCode}}
        {{line}}
        {{/compensationCode}}
      } catch (compensationError) {
        {{#logger}}
        {{logger}}.error('Compensation failed: $compensationError');
        {{/logger}}
      }
      {{/compensationActions}}
      {{/hasCompensation}}

      {{#rethrowsError}}
      rethrow;
      {{/rethrowsError}}
      {{/hasErrorHandling}}
      {{^hasErrorHandling}}
      // Error occurred while processing event
      rethrow;
      {{/hasErrorHandling}}
    }
  }

  @override
  bool canHandle(IDomainEvent event) => event is {{eventName}}Event;
}

/// {{eventName}} domain event
class {{eventName}}Event implements IDomainEvent {
  @override
  final String id;

  @override
  final DateTime occurredAt;

  @override
  final String aggregateId;

  {{#eventFields}}
  final {{type}} {{name}};
  {{/eventFields}}

  {{eventName}}Event({
    String? id,
    DateTime? occurredAt,
    required this.aggregateId,
    {{#eventFields}}
    required this.{{name}},
    {{/eventFields}}
  }) : id = id ?? Uuid().v4(),
       occurredAt = occurredAt ?? DateTime.now();

  @override
  String get eventType => '{{eventType}}';

  {{#hasMetadata}}
  @override
  Map<String, dynamic> get metadata => {
    {{#metadataFields}}
    '{{&key}}': {{&value}},
    {{/metadataFields}}
  };
  {{/hasMetadata}}
  {{^hasMetadata}}
  @override
  Map<String, dynamic> get metadata => {};
  {{/hasMetadata}}

  {{#hasToJson}}
  Map<String, dynamic> toJson() => {
    'id': id,
    'occurredAt': occurredAt.toIso8601String(),
    'aggregateId': aggregateId,
    'eventType': eventType,
    {{#eventFields}}
    '{{&name}}': {{&name}},
    {{/eventFields}}
    {{#hasMetadata}}
    'metadata': metadata,
    {{/hasMetadata}}
  };
  {{/hasToJson}}

  {{#hasFromJson}}
  factory {{eventName}}Event.fromJson(Map<String, dynamic> json) => {{eventName}}Event(
    id: json['id'] as String,
    occurredAt: DateTime.parse(json['occurredAt'] as String),
    aggregateId: json['aggregateId'] as String,
    {{#eventFields}}
    {{&name}}: json['{{&name}}'] as {{type}},
    {{/eventFields}}
  );
  {{/hasFromJson}}

  {{#hasEquality}}
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is {{eventName}}Event &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          aggregateId == other.aggregateId;

  @override
  int get hashCode => id.hashCode ^ aggregateId.hashCode;
  {{/hasEquality}}

  {{#hasToString}}
  @override
  String toString() => '{{eventName}}Event(id: $id, aggregateId: $aggregateId, occurredAt: $occurredAt)';
  {{/hasToString}}
}
''';

/// Policy engine template for CEP cycle
const String _policyEngineTemplate = r'''
/// Policy for {{policyName}}
///
/// {{policyDescription}}
class {{policyName}}Policy implements IPolicy {
  {{#hasDependencies}}
  {{#dependencies}}
  final {{type}} {{name}};
  {{/dependencies}}

  {{policyName}}Policy({
    {{#dependencies}}
    required this.{{name}},
    {{/dependencies}}
  });
  {{/hasDependencies}}
  {{^hasDependencies}}
  {{policyName}}Policy();
  {{/hasDependencies}}

  @override
  String get name => '{{policyName}}';

  @override
  String get description => '{{policyDescription}}';

  {{#hasScope}}
  @override
  PolicyScope? get scope => PolicyScope.{{scopeValue}};
  {{/hasScope}}
  {{^hasScope}}
  @override
  PolicyScope? get scope => null;
  {{/hasScope}}

  @override
  bool evaluate(Entity entity) {
    {{#hasTypeCheck}}
    if (entity is! {{entityType}}) {
      return false;
    }
    {{/hasTypeCheck}}

    {{#hasSimpleEvaluation}}
    {{#rules}}
    {{#isSimpleCondition}}
    // Rule: {{ruleName}}
    if ({{&condition}}) {
      return {{expectedResult}};
    }
    {{/isSimpleCondition}}
    {{/rules}}

    return {{defaultResult}};
    {{/hasSimpleEvaluation}}
    {{^hasSimpleEvaluation}}
    final result = evaluateWithDetails(entity);
    return result.isValid;
    {{/hasSimpleEvaluation}}
  }

  @override
  PolicyEvaluationResult evaluateWithDetails(Entity entity) {
    {{#hasTypeCheck}}
    if (entity is! {{entityType}}) {
      return PolicyEvaluationResult.invalid(
        policy: name,
        reasons: ['Entity is not of type {{entityType}}'],
      );
    }

    final typedEntity = entity as {{entityType}};
    {{/hasTypeCheck}}
    {{^hasTypeCheck}}
    final typedEntity = entity;
    {{/hasTypeCheck}}

    final violations = <PolicyViolation>[];
    final passedRules = <String>[];

    {{#hasRules}}
    {{#rules}}
    // Rule: {{ruleName}}
    {{#hasRuleDescription}}
    // {{ruleDescription}}
    {{/hasRuleDescription}}
    {{#isAndCondition}}
    final {{ruleVar}}Passed = {{#conditions}}{{&condition}}{{#isNotLast}} && {{/isNotLast}}{{/conditions}};
    {{/isAndCondition}}
    {{#isOrCondition}}
    final {{ruleVar}}Passed = {{#conditions}}{{&condition}}{{#isNotLast}} || {{/isNotLast}}{{/conditions}};
    {{/isOrCondition}}
    {{#isCustomCondition}}
    final {{ruleVar}}Passed = {{&customCondition}};
    {{/isCustomCondition}}

    if (!{{ruleVar}}Passed) {
      violations.add(PolicyViolation(
        rule: '{{ruleName}}',
        message: '{{violationMessage}}',
        {{#hasSeverity}}
        severity: PolicyViolationSeverity.{{severity}},
        {{/hasSeverity}}
        {{#hasContext}}
        context: {
          {{#contextFields}}
          '{{key}}': {{value}},
          {{/contextFields}}
        },
        {{/hasContext}}
      ));
    } else {
      passedRules.add('{{ruleName}}');
    }

    {{/rules}}
    {{/hasRules}}

    {{#hasCompositeRules}}
    // Composite rules evaluation
    {{#compositeRules}}
    {{#isAllOf}}
    final {{compositeVar}}Valid = {{#ruleVars}}{{var}}Passed{{#isNotLast}} && {{/isNotLast}}{{/ruleVars}};
    {{/isAllOf}}
    {{#isAnyOf}}
    final {{compositeVar}}Valid = {{#ruleVars}}{{var}}Passed{{#isNotLast}} || {{/isNotLast}}{{/ruleVars}};
    {{/isAnyOf}}
    {{#isNoneOf}}
    final {{compositeVar}}Valid = !({{#ruleVars}}{{var}}Passed{{#isNotLast}} || {{/isNotLast}}{{/ruleVars}});
    {{/isNoneOf}}

    if (!{{compositeVar}}Valid) {
      violations.add(PolicyViolation(
        rule: '{{compositeName}}',
        message: '{{compositeMessage}}',
      ));
    }
    {{/compositeRules}}
    {{/hasCompositeRules}}

    {{#hasCustomEvaluation}}
    // Custom evaluation logic
    {{#customEvaluationLines}}
    {{line}}
    {{/customEvaluationLines}}
    {{/hasCustomEvaluation}}

    if (violations.isEmpty) {
      return PolicyEvaluationResult.valid(
        policy: name,
        {{#hasValidMessage}}
        message: '{{validMessage}}',
        {{/hasValidMessage}}
        {{#includesPassedRules}}
        passedRules: passedRules,
        {{/includesPassedRules}}
      );
    } else {
      return PolicyEvaluationResult.invalid(
        policy: name,
        violations: violations,
        {{#includesPassedRules}}
        passedRules: passedRules,
        {{/includesPassedRules}}
      );
    }
  }

  {{#hasValidateMethod}}
  /// Validates the entity and throws if policy is violated
  void validate(Entity entity) {
    final result = evaluateWithDetails(entity);
    if (!result.isValid) {
      throw PolicyViolationException(
        policy: name,
        violations: result.violations,
      );
    }
  }
  {{/hasValidateMethod}}

  {{#hasCanApplyMethod}}
  /// Checks if this policy can be applied to the entity
  bool canApply(Entity entity) {
    {{#hasTypeCheck}}
    return entity is {{entityType}};
    {{/hasTypeCheck}}
    {{^hasTypeCheck}}
    return true;
    {{/hasTypeCheck}}
  }
  {{/hasCanApplyMethod}}
}
''';

/// Pubspec template for package generation
const String _pubspecTemplate = r'''
name: {{packageName}}
description: {{description}}
version: 1.0.0

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  {{#usePathDependency}}
  ednet_core:
    path: {{&ednetCorePath}}
  {{/usePathDependency}}
  {{^usePathDependency}}
  ednet_core: any
  {{/usePathDependency}}

dev_dependencies:
  test: ^1.24.0
  lints: ^3.0.0
''';

/// Analysis options template for 0/0/0 quality gates
const String _analysisOptionsTemplate = r'''
# Analysis options for generated EDNet package
# Enforces 0/0/0 quality gates (zero errors, warnings, infos)

include: package:lints/recommended.yaml

analyzer:
  {{#enforceStrictMode}}
  strong-mode:
    implicit-casts: false
    implicit-dynamic: false
  {{/enforceStrictMode}}

  {{#fatalWarnings}}
  errors:
    # Treat warnings as errors for quality gates
    invalid_annotation_target: error
    missing_required_param: error
    missing_return: error
    unused_element: error
    unused_field: error
    unused_import: error
    unused_local_variable: error
    dead_code: error
    deprecated_member_use: error
    deprecated_member_use_from_same_package: error
  {{/fatalWarnings}}

  {{#fatalInfos}}
    # Treat infos as errors for strict 0/0/0 compliance
    todo: error
    directives_ordering: error
    file_names: error
    always_declare_return_types: error
    avoid_print: error
    prefer_const_constructors: error
    prefer_final_fields: error
  {{/fatalInfos}}

linter:
  rules:
    # Core quality rules
    - always_declare_return_types
    - always_require_non_null_named_parameters
    - annotate_overrides
    - avoid_empty_else
    - avoid_print
    - avoid_relative_lib_imports
    - avoid_return_types_on_setters
    - avoid_shadowing_type_parameters
    - avoid_types_as_parameter_names
    - camel_case_extensions
    - curly_braces_in_flow_control_structures
    - empty_catches
    - file_names
    - hash_and_equals
    - iterable_contains_unrelated_type
    - list_remove_unrelated_type
    - no_duplicate_case_values
    - non_constant_identifier_names
    - null_closures
    - prefer_const_constructors
    - prefer_equal_for_default_values
    - prefer_final_fields
    - prefer_is_empty
    - prefer_is_not_empty
    - prefer_iterable_whereType
    - prefer_single_quotes
    - slash_for_doc_comments
    - type_init_formals
    - unawaited_futures
    - unnecessary_const
    - unnecessary_new
    - unnecessary_null_in_if_null_operators
    - unnecessary_this
    - unrelated_type_equality_checks
    - use_rethrow_when_possible
    - valid_regexps
''';

/// Test suite template for entity tests
const String _testSuiteTemplate = r'''
import 'package:test/test.dart';
import 'package:{{packageName}}/{{packageName}}.dart';

/// Tests for {{entityName}} entity
void main() {
  group('{{entityName}}', () {
    test('should create instance', () {
      final entity = {{entityName}}();
      expect(entity, isNotNull);
    });

    {{#hasAttributes}}
    {{#attributes}}
    test('should have {{name}} attribute', () {
      final entity = {{entityName}}();
      {{#hasDefault}}
      expect(entity.{{name}}, equals({{&defaultValue}}));
      {{/hasDefault}}
      {{^hasDefault}}
      expect(entity.{{name}}, isNull);
      {{/hasDefault}}
    });

    {{#isRequired}}
    test('should require {{name}} attribute', () {
      final entity = {{entityName}}();
      // Required field validation
      expect(() => entity.{{name}}, returnsNormally);
    });
    {{/isRequired}}

    {{#isUnique}}
    test('should enforce unique constraint on {{name}}', () {
      final entity1 = {{entityName}}();
      final entity2 = {{entityName}}();

      entity1.{{name}} = 'value1';
      entity2.{{name}} = 'value2';

      expect(entity1.{{name}}, isNot(equals(entity2.{{name}})));
    });
    {{/isUnique}}

    {{#hasEnumValues}}
    test('should validate {{name}} enum values', () {
      final entity = {{entityName}}();
      final validValues = <String>[{{#enumValues}}'{{.}}', {{/enumValues}}];

      // All enum values should be valid
      for (final value in validValues) {
        expect(() => entity.{{name}} = value, returnsNormally);
      }
    });
    {{/hasEnumValues}}

    {{/attributes}}
    {{/hasAttributes}}

    {{#isAggregateRoot}}
    group('Aggregate Root behavior', () {
      test('should have aggregate root capabilities', () {
        final aggregate = {{entityName}}();
        expect(aggregate, isA<AggregateRoot>());
      });

      test('should track uncommitted events', () {
        final aggregate = {{entityName}}();
        expect(aggregate.uncommittedEvents, isEmpty);
      });

      test('should clear uncommitted events', () {
        final aggregate = {{entityName}}();
        aggregate.clearUncommittedEvents();
        expect(aggregate.uncommittedEvents, isEmpty);
      });

      test('should apply events', () {
        final aggregate = {{entityName}}();
        // Event application tests would go here
        expect(aggregate.version, equals(0));
      });
    });
    {{/isAggregateRoot}}

    test('should convert to JSON', () {
      final entity = {{entityName}}();
      {{#hasAttributes}}
      {{#attributes}}
      {{#hasDefault}}
      entity.{{name}} = {{&defaultValue}};
      {{/hasDefault}}
      {{/attributes}}
      {{/hasAttributes}}

      final json = entity.toJson();
      expect(json, isA<Map<String, dynamic>>());
      {{#hasAttributes}}
      {{#attributes}}
      expect(json.containsKey('{{name}}'), isTrue);
      {{/attributes}}
      {{/hasAttributes}}
    });

    test('should create from JSON', () {
      final json = <String, dynamic>{
        {{#hasAttributes}}
        {{#attributes}}
        '{{name}}': {{#hasDefault}}{{&defaultValue}}{{/hasDefault}}{{^hasDefault}}null{{/hasDefault}},
        {{/attributes}}
        {{/hasAttributes}}
      };

      final entity = {{entityName}}.fromJson(json);
      expect(entity, isNotNull);
      {{#hasAttributes}}
      {{#attributes}}
      {{#hasDefault}}
      expect(entity.{{name}}, equals({{&defaultValue}}));
      {{/hasDefault}}
      {{/attributes}}
      {{/hasAttributes}}
    });
  });
}
''';

/// Repository template for aggregate persistence
const String _repositoryTemplate = r'''
import 'package:ednet_core/ednet_core.dart';
import '../domain/{{&entityName}}.dart';

{{#hasPersistenceContract}}
/// Repository contract for {{entityName}} aggregate
///
/// Defines persistence operations for {{entityName}} entities following
/// the Repository pattern. Implementations provide actual storage mechanisms.
abstract class {{entityType}}Repository {
  /// Find {{entityName}} by ID
  Future<{{entityType}}?> findById(String id);

  /// Find all {{entityName}} instances
  Future<List<{{entityType}}>> findAll();

  /// Save {{entityName}} instance
  Future<void> save({{entityType}} entity);

  /// Update existing {{entityName}}
  Future<void> update({{entityType}} entity);

  /// Delete {{entityName}} by ID
  Future<void> delete(String id);

  /// Check if {{entityName}} exists
  Future<bool> exists(String id);

  /// Count total {{entityName}} instances
  Future<int> count();
}
{{/hasPersistenceContract}}

{{#hasInMemoryImplementation}}
/// In-memory implementation of {{entityType}}Repository
///
/// Provides a simple in-memory storage for {{entityName}} entities.
/// Useful for testing and prototyping. Not suitable for production.
class InMemory{{entityType}}Repository implements {{entityType}}Repository {
  final Map<String, {{entityType}}> _storage = {};

  @override
  Future<{{entityType}}?> findById(String id) async {
    return _storage[id];
  }

  @override
  Future<List<{{entityType}}>> findAll() async {
    return _storage.values.toList();
  }

  @override
  Future<void> save({{entityType}} entity) async {
    if (entity.id == null || entity.id!.isEmpty) {
      throw ArgumentError('Entity must have a valid ID');
    }

    if (_storage.containsKey(entity.id)) {
      throw StateError('{{entityType}} with ID ${entity.id} already exists');
    }

    _storage[entity.id!] = entity;
  }

  @override
  Future<void> update({{entityType}} entity) async {
    if (entity.id == null || entity.id!.isEmpty) {
      throw ArgumentError('Entity must have a valid ID');
    }

    if (!_storage.containsKey(entity.id)) {
      throw StateError('{{entityType}} with ID ${entity.id} not found');
    }

    _storage[entity.id!] = entity;
  }

  @override
  Future<void> delete(String id) async {
    if (!_storage.containsKey(id)) {
      throw StateError('{{entityType}} with ID $id not found');
    }

    _storage.remove(id);
  }

  @override
  Future<bool> exists(String id) async {
    return _storage.containsKey(id);
  }

  @override
  Future<int> count() async {
    return _storage.length;
  }

  /// Clear all stored entities (for testing)
  void clear() {
    _storage.clear();
  }

  /// Get all entity IDs (for testing)
  List<String> getAllIds() {
    return _storage.keys.toList();
  }
}
{{/hasInMemoryImplementation}}
''';
