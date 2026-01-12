part of ednet_core;

/// Generate Event Storming test files for commands, events, and policies
String genEventStormingTest(Model model) {
  final domain = model.domain;
  final buffer = StringBuffer()
    ..writeln()
    ..writeln(
      '// test/${domain.codeLowerUnderscore}/${model.codeLowerUnderscore}/${domain.codeLowerUnderscore}_${model.codeLowerUnderscore}_event_storming_test.dart',
    )
    ..writeln()
    ..writeln('import \'package:test/test.dart\';')
    ..writeln('import \'package:ednet_core/ednet_core.dart\';')
    ..writeln(
      'import \'../../../lib/${domain.codeLowerUnderscore}_${model.codeLowerUnderscore}.dart\';',
    )
    ..writeln()
    ..writeln('void testEventStorming${domain.code}${model.code}(')
    ..writeln('    ${domain.code}Domain ${domain.codeFirstLetterLower}Domain,')
    ..writeln('    ${model.code}Model ${model.codeFirstLetterLower}Model) {')
    ..writeln(
      '  group(\'Testing Event Storming for ${domain.code}.${model.code}\', () {',
    )
    ..writeln('    late DomainSession session;')
    ..writeln()
    ..writeln('    setUp(() {')
    ..writeln(
      '      session = ${domain.codeFirstLetterLower}Domain.newSession();',
    )
    ..writeln('      ${model.codeFirstLetterLower}Model.init();')
    ..writeln('    });')
    ..writeln()
    ..writeln('    tearDown(() {')
    ..writeln('      ${model.codeFirstLetterLower}Model.clear();')
    ..writeln('    });')
    ..writeln();

  // Generate tests for each concept with Event Storming features
  for (var concept in model.concepts) {
    if (concept.hasEventStormingFeatures) {
      buffer.write(_genConceptEventStormingTests(concept, model));
    }
  }

  buffer
    ..writeln('  });')
    ..writeln('}')
    ..writeln()
    ..writeln('void main() {')
    ..writeln('  final repository = CoreRepository();')
    ..writeln(
      '  final ${domain.codeFirstLetterLower}Domain = repository.getDomainModels(\'${domain.code}\');',
    )
    ..writeln(
      '  final ${model.codeFirstLetterLower}Model = ${domain.codeFirstLetterLower}Domain?.getModelEntries(\'${model.code}\') as ${model.code}Model?;',
    )
    ..writeln('  if (${model.codeFirstLetterLower}Model != null) {')
    ..writeln(
      '    testEventStorming${domain.code}${model.code}(${domain.codeFirstLetterLower}Domain!, ${model.codeFirstLetterLower}Model);',
    )
    ..writeln('  }')
    ..writeln('}');

  return buffer.toString();
}

/// Generate Event Storming command handlers
String genEventStormingCommandHandlers(Model model) {
  final domain = model.domain;
  final buffer = StringBuffer()
    ..writeln()
    ..writeln(
      '// lib/${domain.codeLowerUnderscore}/${model.codeLowerUnderscore}/command_handlers.dart',
    )
    ..writeln()
    ..writeln('import \'dart:async\';')
    ..writeln('import \'package:ednet_core/ednet_core.dart\';')
    ..writeln(
      'import \'../${domain.codeLowerUnderscore}_${model.codeLowerUnderscore}.dart\';',
    )
    ..writeln();

  for (var concept in model.concepts) {
    if (concept.hasCommands) {
      buffer.write(_genConceptCommandHandlers(concept, model));
    }
  }

  return buffer.toString();
}

/// Generate Event Storming policy engines
String genEventStormingPolicyEngines(Model model) {
  final domain = model.domain;
  final buffer = StringBuffer()
    ..writeln()
    ..writeln(
      '// lib/${domain.codeLowerUnderscore}/${model.codeLowerUnderscore}/policy_engines.dart',
    )
    ..writeln()
    ..writeln('import \'dart:async\';')
    ..writeln('import \'package:ednet_core/ednet_core.dart\';')
    ..writeln(
      'import \'../${domain.codeLowerUnderscore}_${model.codeLowerUnderscore}.dart\';',
    )
    ..writeln();

  for (var concept in model.concepts) {
    if (concept.hasPolicies) {
      buffer.write(_genConceptPolicyEngines(concept, model));
    }
  }

  return buffer.toString();
}

/// Generate Event Storming criteria evaluators
String genEventStormingCriteriaEvaluators(Model model) {
  final domain = model.domain;
  final buffer = StringBuffer()
    ..writeln()
    ..writeln(
      '// lib/${domain.codeLowerUnderscore}/${model.codeLowerUnderscore}/criteria_evaluators.dart',
    )
    ..writeln()
    ..writeln('import \'package:ednet_core/ednet_core.dart\';')
    ..writeln(
      'import \'../${domain.codeLowerUnderscore}_${model.codeLowerUnderscore}.dart\';',
    )
    ..writeln();

  for (var concept in model.concepts) {
    if (concept.hasCriteria) {
      buffer.write(_genConceptCriteriaEvaluators(concept, model));
    }
  }

  return buffer.toString();
}

/// Generate Event Storming sentences documentation
String genEventStormingSentences(Model model) {
  final domain = model.domain;
  final buffer = StringBuffer()
    ..writeln('# Event Storming Sentences for ${domain.code}.${model.code}')
    ..writeln()
    ..writeln('Generated from domain model: ${domain.code}.${model.code}')
    ..writeln('Timestamp: ${DateTime.now().toIso8601String()}')
    ..writeln();

  for (var concept in model.concepts) {
    if (concept.hasEventStormingFeatures) {
      buffer
        ..writeln('## ${concept.code} Aggregate')
        ..writeln();

      // Generate command-event sentences
      for (var command in concept.commands) {
        if (command.successEvent.isNotEmpty) {
          final roles = command.roles.isNotEmpty
              ? command.roles.first
              : 'Actor';
          buffer.writeln(
            '$roles → ${command.name} → ${concept.code} → ${command.successEvent}',
          );
        }
      }

      // Generate policy-driven sentences
      for (var policy in concept.policies) {
        for (var eventTrigger in policy.events) {
          for (var action in policy.actions) {
            if (action.command.isNotEmpty) {
              buffer.writeln(
                '$eventTrigger → ${policy.name} → ${action.command}',
              );
            }
          }
        }
      }

      // Generate explicit Event Storming sentences
      for (var sentence in concept.eventStormingSentences) {
        buffer.writeln(sentence.sentence);
      }

      buffer.writeln();
    }
  }

  return buffer.toString();
}

/// Generate Event Storming command classes
String genEventStormingCommands(Model model) {
  final domain = model.domain;
  final buffer = StringBuffer()
    ..writeln()
    ..writeln(
      '// lib/${domain.codeLowerUnderscore}/${model.codeLowerUnderscore}/commands.dart',
    )
    ..writeln()
    ..writeln('import \'package:ednet_core/ednet_core.dart\';')
    ..writeln(
      'import \'../${domain.codeLowerUnderscore}_${model.codeLowerUnderscore}.dart\';',
    )
    ..writeln();

  // Generate base command class
  buffer
    ..writeln('/// Base command class for ${domain.code}.${model.code}')
    ..writeln(
      'abstract class ${domain.code}${model.code}Command extends Command {',
    )
    ..writeln('  ${domain.code}${model.code}Command({')
    ..writeln('    required String aggregateId,')
    ..writeln('    DateTime? timestamp,')
    ..writeln(
      '  }) : super(aggregateId: aggregateId, timestamp: timestamp ?? DateTime.now());',
    )
    ..writeln('}')
    ..writeln();

  // Generate command result class
  buffer
    ..writeln('/// Command execution result')
    ..writeln('class CommandResult {')
    ..writeln('  final bool isSuccess;')
    ..writeln('  final String? errorMessage;')
    ..writeln('  final List<DomainEvent> events;')
    ..writeln('  ')
    ..writeln('  const CommandResult({')
    ..writeln('    required this.isSuccess,')
    ..writeln('    this.errorMessage,')
    ..writeln('    this.events = const [],')
    ..writeln('  });')
    ..writeln('  ')
    ..writeln(
      '  factory CommandResult.success({List<DomainEvent> events = const []}) {',
    )
    ..writeln('    return CommandResult(isSuccess: true, events: events);')
    ..writeln('  }')
    ..writeln('  ')
    ..writeln('  factory CommandResult.failure(String errorMessage) {')
    ..writeln(
      '    return CommandResult(isSuccess: false, errorMessage: errorMessage);',
    )
    ..writeln('  }')
    ..writeln('}')
    ..writeln();

  for (var concept in model.concepts) {
    if (concept.hasCommands) {
      buffer.write(_genConceptCommands(concept, model));
    }
  }

  return buffer.toString();
}

/// Generate Event Storming event classes
String genEventStormingEvents(Model model) {
  final domain = model.domain;
  final buffer = StringBuffer()
    ..writeln()
    ..writeln(
      '// lib/${domain.codeLowerUnderscore}/${model.codeLowerUnderscore}/events.dart',
    )
    ..writeln()
    ..writeln('import \'package:ednet_core/ednet_core.dart\';')
    ..writeln(
      'import \'../${domain.codeLowerUnderscore}_${model.codeLowerUnderscore}.dart\';',
    )
    ..writeln();

  // Generate base event class
  buffer
    ..writeln('/// Base event class for ${domain.code}.${model.code}')
    ..writeln(
      'abstract class ${domain.code}${model.code}Event extends DomainEvent {',
    )
    ..writeln('  ${domain.code}${model.code}Event({')
    ..writeln('    required String aggregateId,')
    ..writeln('    DateTime? timestamp,')
    ..writeln(
      '  }) : super(aggregateId: aggregateId, timestamp: timestamp ?? DateTime.now());',
    )
    ..writeln('}')
    ..writeln();

  for (var concept in model.concepts) {
    if (concept.hasEvents) {
      buffer.write(_genConceptEvents(concept, model));
    }
  }

  return buffer.toString();
}

/// Generate Event Storming policy classes
String genEventStormingPolicies(Model model) {
  final domain = model.domain;
  final buffer = StringBuffer()
    ..writeln()
    ..writeln(
      '// lib/${domain.codeLowerUnderscore}/${model.codeLowerUnderscore}/policies.dart',
    )
    ..writeln()
    ..writeln('import \'package:ednet_core/ednet_core.dart\';')
    ..writeln(
      'import \'../${domain.codeLowerUnderscore}_${model.codeLowerUnderscore}.dart\';',
    )
    ..writeln();

  // Generate base policy interface
  buffer
    ..writeln('/// Base policy interface for ${domain.code}.${model.code}')
    ..writeln('abstract class IPolicy {')
    ..writeln('  String get name;')
    ..writeln('  String get description;')
    ..writeln('  bool get isActive;')
    ..writeln('  PolicyPriority get priority;')
    ..writeln('  ')
    ..writeln('  Future<bool> evaluate(DomainEvent event);')
    ..writeln('  Future<List<PolicyAction>> getActions(DomainEvent event);')
    ..writeln('}')
    ..writeln();

  // Generate policy priority enum
  buffer
    ..writeln('/// Policy execution priority')
    ..writeln('enum PolicyPriority {')
    ..writeln('  low(1),')
    ..writeln('  normal(2),')
    ..writeln('  high(3),')
    ..writeln('  critical(4);')
    ..writeln('  ')
    ..writeln('  const PolicyPriority(this.value);')
    ..writeln('  final int value;')
    ..writeln('}')
    ..writeln();

  // Generate policy action class
  buffer
    ..writeln('/// Policy action to be executed')
    ..writeln('class PolicyAction {')
    ..writeln('  final String command;')
    ..writeln('  final String target;')
    ..writeln('  final Map<String, dynamic> parameters;')
    ..writeln('  final String conditions;')
    ..writeln('  ')
    ..writeln('  const PolicyAction({')
    ..writeln('    required this.command,')
    ..writeln('    required this.target,')
    ..writeln('    this.parameters = const {},')
    ..writeln('    this.conditions = \'\',')
    ..writeln('  });')
    ..writeln('}')
    ..writeln();

  // Generate policy violation exception
  buffer
    ..writeln('/// Exception thrown when policy evaluation fails')
    ..writeln('class PolicyViolationException implements Exception {')
    ..writeln('  final String policyName;')
    ..writeln('  final String message;')
    ..writeln('  ')
    ..writeln(
      '  const PolicyViolationException(this.policyName, this.message);',
    )
    ..writeln('  ')
    ..writeln('  @override')
    ..writeln(
      '  String toString() => \'PolicyViolationException: \$policyName - \$message\';',
    )
    ..writeln('}')
    ..writeln();

  for (var concept in model.concepts) {
    if (concept.hasPolicies) {
      buffer.write(_genConceptPolicies(concept, model));
    }
  }

  return buffer.toString();
}

// Helper methods

String _genConceptEventStormingTests(Concept concept, Model model) {
  final buffer = StringBuffer();
  final conceptName = concept.code;
  final conceptVar = concept.codeFirstLetterLower;

  buffer
    ..writeln()
    ..writeln('    group(\'Testing $conceptName Event Storming\', () {');

  // Test commands
  if (concept.hasCommands) {
    for (var command in concept.commands) {
      buffer
        ..writeln('      test(\'${command.name} command execution\', () {')
        ..writeln('        // Test ${command.name} command')
        ..writeln(
          '        final ${conceptVar}Concept = ${model.codeFirstLetterLower}Model.${concept.codePluralFirstLetterLower}.concept;',
        )
        ..writeln(
          '        final $conceptVar = $conceptName(${conceptVar}Concept);',
        )
        ..writeln('        ')
        ..writeln('        // Set up preconditions');

      for (var precondition in command.preconditions) {
        buffer.writeln('        // Precondition: ${precondition.expression}');
      }

      buffer
        ..writeln('        ')
        ..writeln('        // Execute command')
        ..writeln(
          '        // NOTE: Implement ${command.name} command execution',
        )
        ..writeln('        ')
        ..writeln('        // Verify postconditions');

      for (var postcondition in command.postconditions) {
        buffer.writeln('        // Postcondition: ${postcondition.expression}');
      }

      buffer
        ..writeln('        ')
        ..writeln('        // Verify success event: ${command.successEvent}')
        ..writeln(
          '        // NOTE: Verify ${command.successEvent} event was emitted',
        )
        ..writeln('      });')
        ..writeln();
    }
  }

  // Test policies
  if (concept.hasPolicies) {
    for (var policy in concept.policies) {
      buffer
        ..writeln('      test(\'${policy.name} policy evaluation\', () {')
        ..writeln('        // Test ${policy.name} policy')
        ..writeln('        // Expression: ${policy.expression}')
        ..writeln('        ')
        ..writeln('        // NOTE: Set up event triggers');

      for (var eventTrigger in policy.events) {
        buffer.writeln('        // Event trigger: $eventTrigger');
      }

      buffer
        ..writeln('        ')
        ..writeln('        // NOTE: Verify policy actions');

      for (var action in policy.actions) {
        buffer.writeln(
          '        // Action: ${action.command} on ${action.target}',
        );
      }

      buffer
        ..writeln('      });')
        ..writeln();
    }
  }

  // Test criteria
  if (concept.hasCriteria) {
    for (var criterion in concept.criteria) {
      buffer
        ..writeln('      test(\'${criterion.name} criteria evaluation\', () {')
        ..writeln('        // Test ${criterion.name} criteria')
        ..writeln('        // Expression: ${criterion.expression}')
        ..writeln('        // Return type: ${criterion.returnType}')
        ..writeln('        ')
        ..writeln('        final evaluator = CriteriaLanguageEvaluator();')
        ..writeln('        final context = <String, dynamic>{');

      for (var parameter in criterion.parameters) {
        buffer.writeln(
          '          \'${parameter.name}\': null, // NOTE: Set ${parameter.type} value',
        );
      }

      buffer
        ..writeln('        };')
        ..writeln('        ')
        ..writeln('        final result = evaluator.evaluateExpression(')
        ..writeln('          \'${criterion.expression}\',')
        ..writeln('          context,')
        ..writeln('        );')
        ..writeln('        ')
        ..writeln('        expect(result, isA<${criterion.returnType}>());')
        ..writeln('      });')
        ..writeln();
    }
  }

  buffer.writeln('    });');

  return buffer.toString();
}

String _genConceptCommandHandlers(Concept concept, Model model) {
  final buffer = StringBuffer();
  final conceptName = concept.code;

  buffer
    ..writeln('/// Command handlers for $conceptName aggregate')
    ..writeln('class ${conceptName}CommandHandler {')
    ..writeln('  final ${conceptName}Repository repository;')
    ..writeln('  final EventBus eventBus;')
    ..writeln('  ')
    ..writeln('  ${conceptName}CommandHandler(this.repository, this.eventBus);')
    ..writeln();

  for (var command in concept.commands) {
    buffer
      ..writeln('  /// Handle ${command.name} command')
      ..writeln('  /// ${command.description}')
      ..writeln(
        '  Future<void> handle${command.name}(${command.name}Command command) async {',
      )
      ..writeln('    // Validate preconditions');

    for (var precondition in command.preconditions) {
      buffer
        ..writeln('    if (!(${precondition.expression})) {')
        ..writeln(
          '      throw PreconditionException(\'${precondition.errorMessage}\');',
        )
        ..writeln('    }');
    }

    buffer
      ..writeln('    ')
      ..writeln('    // Execute command logic')
      ..writeln(
        '    final aggregate = await repository.findById(command.aggregateId);',
      )
      ..writeln('    if (aggregate == null) {')
      ..writeln('      throw AggregateNotFoundException(command.aggregateId);')
      ..writeln('    }')
      ..writeln('    ')
      ..writeln('    // NOTE: Implement ${command.name} business logic')
      ..writeln('    ')
      ..writeln('    // Emit success event');

    if (command.successEvent.isNotEmpty) {
      buffer
        ..writeln('    final event = ${command.successEvent}Event(')
        ..writeln('      aggregateId: aggregate.id,')
        ..writeln('      timestamp: DateTime.now(),')
        ..writeln('    );')
        ..writeln('    await eventBus.publish(event);');
    }

    buffer
      ..writeln('    ')
      ..writeln('    // Verify postconditions');

    for (var postcondition in command.postconditions) {
      buffer.writeln(
        '    assert(${postcondition.expression}, \'${postcondition.description}\');',
      );
    }

    buffer
      ..writeln('  }')
      ..writeln();
  }

  buffer.writeln('}');

  return buffer.toString();
}

String _genConceptPolicyEngines(Concept concept, Model model) {
  final buffer = StringBuffer();
  final conceptName = concept.code;

  buffer
    ..writeln('/// Policy engines for $conceptName aggregate')
    ..writeln('class ${conceptName}PolicyEngine {')
    ..writeln('  final CommandBus commandBus;')
    ..writeln('  ')
    ..writeln('  ${conceptName}PolicyEngine(this.commandBus);')
    ..writeln();

  for (var policy in concept.policies) {
    buffer
      ..writeln('  /// Evaluate ${policy.name} policy')
      ..writeln('  /// ${policy.description}')
      ..writeln(
        '  Future<void> evaluate${policy.name}(DomainEvent event) async {',
      )
      ..writeln('    if (!${policy.isActive}) return;')
      ..writeln('    ')
      ..writeln('    // Check if policy applies to this event');

    for (var eventTrigger in policy.events) {
      buffer.writeln('    if (event is! ${eventTrigger}Event) return;');
    }

    buffer
      ..writeln('    ')
      ..writeln('    // Evaluate policy expression')
      ..writeln('    if (${policy.expression}) {');

    for (var action in policy.actions) {
      if (action.conditions.isNotEmpty) {
        buffer
          ..writeln('      if (${action.conditions}) {')
          ..writeln('        await commandBus.send(${action.command}Command(')
          ..writeln('          target: ${action.target},')
          ..writeln('        ));')
          ..writeln('      }');
      } else {
        buffer
          ..writeln('      await commandBus.send(${action.command}Command(')
          ..writeln('        target: ${action.target},')
          ..writeln('      ));');
      }
    }

    buffer
      ..writeln('    }')
      ..writeln('  }')
      ..writeln();
  }

  buffer.writeln('}');

  return buffer.toString();
}

String _genConceptCommands(Concept concept, Model model) {
  final buffer = StringBuffer();
  final conceptName = concept.code;

  buffer
    ..writeln('/// Commands for $conceptName aggregate')
    ..writeln();

  for (var command in concept.commands) {
    buffer
      ..writeln('/// ${command.description}')
      ..writeln(
        'class ${command.name}Command extends ${model.domain.code}${model.code}Command {',
      );

    // Generate command properties based on concept attributes
    for (var attribute in concept.attributes) {
      if (!attribute.identifier) {
        buffer.writeln(
          '  final ${attribute.type?.code ?? 'String'}? ${attribute.code};',
        );
      }
    }

    buffer
      ..writeln('  ')
      ..writeln('  ${command.name}Command({')
      ..writeln('    required String aggregateId,');

    for (var attribute in concept.attributes) {
      if (!attribute.identifier) {
        buffer.writeln('    this.${attribute.code},');
      }
    }

    buffer
      ..writeln('    DateTime? timestamp,')
      ..writeln('  }) : super(aggregateId: aggregateId, timestamp: timestamp);')
      ..writeln('  ')
      ..writeln('  /// Validate command preconditions')
      ..writeln('  bool validatePreconditions() {');

    for (var precondition in command.preconditions) {
      buffer.writeln('    // ${precondition.expression}');
    }

    buffer
      ..writeln('    return true; // NOTE: Implement precondition validation')
      ..writeln('  }')
      ..writeln('  ')
      ..writeln('  /// Get expected success event')
      ..writeln('  String get successEvent => \'${command.successEvent}\';')
      ..writeln('  ')
      ..writeln('  /// Get expected failure event')
      ..writeln('  String get failureEvent => \'${command.failureEvent}\';')
      ..writeln('  ')
      ..writeln('  /// Get required roles')
      ..writeln('  List<String> get requiredRoles => ${command.roles};')
      ..writeln('}')
      ..writeln();
  }

  return buffer.toString();
}

String _genConceptEvents(Concept concept, Model model) {
  final buffer = StringBuffer();
  final conceptName = concept.code;

  buffer
    ..writeln('/// Events for $conceptName aggregate')
    ..writeln();

  for (var event in concept.events) {
    buffer
      ..writeln('/// ${event.description}')
      ..writeln(
        'class ${event.name}Event extends ${model.domain.code}${model.code}Event {',
      );

    // Generate event payload properties
    for (var payloadEntry in event.payload.entries) {
      buffer.writeln('  final ${payloadEntry.value} ${payloadEntry.key};');
    }

    buffer
      ..writeln('  ')
      ..writeln('  ${event.name}Event({')
      ..writeln('    required String aggregateId,');

    for (var payloadEntry in event.payload.entries) {
      buffer.writeln('    required this.${payloadEntry.key},');
    }

    buffer
      ..writeln('    DateTime? timestamp,')
      ..writeln('  }) : super(aggregateId: aggregateId, timestamp: timestamp);')
      ..writeln('  ')
      ..writeln('  /// Get event subscribers')
      ..writeln('  List<String> get subscribers => ${event.subscribers};')
      ..writeln('  ')
      ..writeln('  /// Notify subscribers')
      ..writeln('  Future<void> notifySubscribers() async {');

    for (var subscriber in event.subscribers) {
      buffer.writeln('    // Notify $subscriber');
    }

    buffer
      ..writeln('    // NOTE: Implement subscriber notification')
      ..writeln('  }')
      ..writeln('  ')
      ..writeln('  /// Convert to JSON for serialization')
      ..writeln('  Map<String, dynamic> toJson() {')
      ..writeln('    return {')
      ..writeln('      \'aggregateId\': aggregateId,')
      ..writeln('      \'timestamp\': timestamp.toIso8601String(),');

    for (var payloadEntry in event.payload.entries) {
      buffer.writeln('      \'${payloadEntry.key}\': ${payloadEntry.key},');
    }

    buffer
      ..writeln('    };')
      ..writeln('  }')
      ..writeln('}')
      ..writeln();
  }

  return buffer.toString();
}

String _genConceptPolicies(Concept concept, Model model) {
  final buffer = StringBuffer();
  final conceptName = concept.code;

  buffer
    ..writeln('/// Policies for $conceptName aggregate')
    ..writeln();

  for (var policy in concept.policies) {
    final priorityValue = policy.priority.toLowerCase();
    final priority = priorityValue == 'high'
        ? 'PolicyPriority.high'
        : priorityValue == 'low'
        ? 'PolicyPriority.low'
        : priorityValue == 'critical'
        ? 'PolicyPriority.critical'
        : 'PolicyPriority.normal';

    buffer
      ..writeln('/// ${policy.description}')
      ..writeln('class ${policy.name}Policy implements IPolicy {')
      ..writeln('  @override')
      ..writeln('  String get name => \'${policy.name}\';')
      ..writeln('  ')
      ..writeln('  @override')
      ..writeln('  String get description => \'${policy.description}\';')
      ..writeln('  ')
      ..writeln('  @override')
      ..writeln('  bool get isActive => ${policy.isActive};')
      ..writeln('  ')
      ..writeln('  @override')
      ..writeln('  PolicyPriority get priority => $priority;')
      ..writeln('  ')
      ..writeln('  @override')
      ..writeln('  Future<bool> evaluate(DomainEvent event) async {')
      ..writeln('    if (!isActive) return false;')
      ..writeln('    ')
      ..writeln('    // Check if policy applies to this event type');

    for (var eventTrigger in policy.events) {
      buffer.writeln('    if (event is! ${eventTrigger}Event) return false;');
    }

    buffer
      ..writeln('    ')
      ..writeln('    // Evaluate policy expression: ${policy.expression}')
      ..writeln('    // NOTE: Implement policy evaluation logic')
      ..writeln('    return true; // Placeholder')
      ..writeln('  }')
      ..writeln('  ')
      ..writeln('  @override')
      ..writeln(
        '  Future<List<PolicyAction>> getActions(DomainEvent event) async {',
      )
      ..writeln('    if (!await evaluate(event)) return [];')
      ..writeln('    ')
      ..writeln('    final actions = <PolicyAction>[];');

    for (var action in policy.actions) {
      buffer
        ..writeln('    ')
        ..writeln('    // Action: ${action.command}')
        ..writeln(
          '    if (${action.conditions.isEmpty ? 'true' : action.conditions}) {',
        )
        ..writeln('      actions.add(PolicyAction(')
        ..writeln('        command: \'${action.command}\',')
        ..writeln('        target: \'${action.target}\',')
        ..writeln(
          '        parameters: ${action.parameters.isEmpty ? '{}' : action.parameters},',
        )
        ..writeln('        conditions: \'${action.conditions}\',')
        ..writeln('      ));')
        ..writeln('    }');
    }

    buffer
      ..writeln('    ')
      ..writeln('    return actions;')
      ..writeln('  }')
      ..writeln('}')
      ..writeln();
  }

  return buffer.toString();
}

String _genConceptCriteriaEvaluators(Concept concept, Model model) {
  final buffer = StringBuffer();
  final conceptName = concept.code;

  buffer
    ..writeln('/// Criteria evaluators for $conceptName aggregate')
    ..writeln('class ${conceptName}CriteriaEvaluator {')
    ..writeln();

  for (var criterion in concept.criteria) {
    buffer
      ..writeln('  /// ${criterion.description}')
      ..writeln('  static ${criterion.returnType} ${criterion.name}(');

    for (var i = 0; i < criterion.parameters.length; i++) {
      final param = criterion.parameters[i];
      final isLast = i == criterion.parameters.length - 1;
      buffer.write(
        '    ${param.type} ${param.name}${param.required ? '' : '?'}${isLast ? '' : ','}',
      );
      if (!isLast) buffer.writeln();
    }

    buffer
      ..writeln('  ) {')
      ..writeln('    // Expression: ${criterion.expression}')
      ..writeln('    // NOTE: Implement criteria evaluation logic')
      ..writeln(
        '    throw UnsupportedError(\'${criterion.name} criteria not implemented\');',
      )
      ..writeln('  }')
      ..writeln();
  }

  buffer.writeln('}');

  return buffer.toString();
}

// Extension methods to check for Event Storming features

extension ConceptEventStormingExtensions on Concept {
  bool get hasEventStormingFeatures =>
      hasCommands ||
      hasEvents ||
      hasPolicies ||
      hasCriteria ||
      hasEventStormingSentences;

  bool get hasCommands =>
      metadata.containsKey('commands') &&
      (metadata['commands'] as Map).isNotEmpty;

  bool get hasEvents =>
      metadata.containsKey('events') && (metadata['events'] as Map).isNotEmpty;

  bool get hasPolicies =>
      metadata.containsKey('policies') &&
      (metadata['policies'] as Map).isNotEmpty;

  bool get hasCriteria =>
      metadata.containsKey('criteria') &&
      (metadata['criteria'] as Map).isNotEmpty;

  bool get hasEventStormingSentences =>
      metadata.containsKey('eventStormingSentences') &&
      (metadata['eventStormingSentences'] as List).isNotEmpty;

  List<CommandMetadata> get commands {
    if (!hasCommands) return [];
    final commandsMap = metadata['commands'] as Map;
    return commandsMap.entries
        .map((entry) => CommandMetadata.fromMap(entry.key, entry.value))
        .toList();
  }

  List<EventMetadata> get events {
    if (!hasEvents) return [];
    final eventsMap = metadata['events'] as Map;
    return eventsMap.entries
        .map((entry) => EventMetadata.fromMap(entry.key, entry.value))
        .toList();
  }

  List<PolicyMetadata> get policies {
    if (!hasPolicies) return [];
    final policiesMap = metadata['policies'] as Map;
    return policiesMap.entries
        .map((entry) => PolicyMetadata.fromMap(entry.key, entry.value))
        .toList();
  }

  List<CriterionMetadata> get criteria {
    if (!hasCriteria) return [];
    final criteriaMap = metadata['criteria'] as Map;
    return criteriaMap.entries
        .map((entry) => CriterionMetadata.fromMap(entry.key, entry.value))
        .toList();
  }

  List<EventStormingSentenceMetadata> get eventStormingSentences {
    if (!hasEventStormingSentences) return [];
    final sentencesList = metadata['eventStormingSentences'] as List;
    return sentencesList
        .map((sentence) => EventStormingSentenceMetadata.fromMap(sentence))
        .toList();
  }
}

// Metadata classes for Event Storming features

class CommandMetadata {
  final String name;
  final String description;
  final String successEvent;
  final String failureEvent;
  final List<String> roles;
  final List<PreconditionMetadata> preconditions;
  final List<PostconditionMetadata> postconditions;
  final Map<String, dynamic> validation;

  CommandMetadata({
    required this.name,
    required this.description,
    required this.successEvent,
    required this.failureEvent,
    required this.roles,
    required this.preconditions,
    required this.postconditions,
    required this.validation,
  });

  factory CommandMetadata.fromMap(String name, Map<String, dynamic> data) {
    return CommandMetadata(
      name: name,
      description: data['description'] ?? '',
      successEvent: data['successEvent'] ?? '',
      failureEvent: data['failureEvent'] ?? '',
      roles: List<String>.from(data['roles'] ?? []),
      preconditions: (data['preconditions'] as List? ?? [])
          .map((p) => PreconditionMetadata.fromMap(p))
          .toList(),
      postconditions: (data['postconditions'] as List? ?? [])
          .map((p) => PostconditionMetadata.fromMap(p))
          .toList(),
      validation: data['validation'] ?? {},
    );
  }
}

class EventMetadata {
  final String name;
  final String description;
  final List<String> triggers;
  final Map<String, dynamic> payload;
  final List<String> subscribers;

  EventMetadata({
    required this.name,
    required this.description,
    required this.triggers,
    required this.payload,
    required this.subscribers,
  });

  factory EventMetadata.fromMap(String name, Map<String, dynamic> data) {
    return EventMetadata(
      name: name,
      description: data['description'] ?? '',
      triggers: List<String>.from(data['triggers'] ?? []),
      payload: data['payload'] ?? {},
      subscribers: List<String>.from(data['subscribers'] ?? []),
    );
  }
}

class PolicyMetadata {
  final String name;
  final String description;
  final String expression;
  final List<String> events;
  final List<ActionMetadata> actions;
  final String priority;
  final bool isActive;

  PolicyMetadata({
    required this.name,
    required this.description,
    required this.expression,
    required this.events,
    required this.actions,
    required this.priority,
    required this.isActive,
  });

  factory PolicyMetadata.fromMap(String name, Map<String, dynamic> data) {
    return PolicyMetadata(
      name: name,
      description: data['description'] ?? '',
      expression: data['expression'] ?? '',
      events: List<String>.from(data['events'] ?? []),
      actions: (data['actions'] as List? ?? [])
          .map((a) => ActionMetadata.fromMap(a))
          .toList(),
      priority: data['priority'] ?? 'normal',
      isActive: data['isActive'] ?? true,
    );
  }
}

class CriterionMetadata {
  final String name;
  final String description;
  final String expression;
  final String returnType;
  final List<ParameterMetadata> parameters;

  CriterionMetadata({
    required this.name,
    required this.description,
    required this.expression,
    required this.returnType,
    required this.parameters,
  });

  factory CriterionMetadata.fromMap(String name, Map<String, dynamic> data) {
    return CriterionMetadata(
      name: name,
      description: data['description'] ?? '',
      expression: data['expression'] ?? '',
      returnType: data['returnType'] ?? 'boolean',
      parameters: (data['parameters'] as List? ?? [])
          .map((p) => ParameterMetadata.fromMap(p))
          .toList(),
    );
  }
}

class EventStormingSentenceMetadata {
  final String sentence;
  final String actor;
  final String command;
  final String aggregate;
  final String event;
  final String policy;
  final String nextCommand;

  EventStormingSentenceMetadata({
    required this.sentence,
    required this.actor,
    required this.command,
    required this.aggregate,
    required this.event,
    required this.policy,
    required this.nextCommand,
  });

  factory EventStormingSentenceMetadata.fromMap(Map<String, dynamic> data) {
    return EventStormingSentenceMetadata(
      sentence: data['sentence'] ?? '',
      actor: data['actor'] ?? '',
      command: data['command'] ?? '',
      aggregate: data['aggregate'] ?? '',
      event: data['event'] ?? '',
      policy: data['policy'] ?? '',
      nextCommand: data['nextCommand'] ?? '',
    );
  }
}

class PreconditionMetadata {
  final String expression;
  final String errorMessage;
  final String severity;

  PreconditionMetadata({
    required this.expression,
    required this.errorMessage,
    required this.severity,
  });

  factory PreconditionMetadata.fromMap(Map<String, dynamic> data) {
    return PreconditionMetadata(
      expression: data['expression'] ?? '',
      errorMessage: data['errorMessage'] ?? '',
      severity: data['severity'] ?? 'error',
    );
  }
}

class PostconditionMetadata {
  final String expression;
  final String description;

  PostconditionMetadata({required this.expression, required this.description});

  factory PostconditionMetadata.fromMap(Map<String, dynamic> data) {
    return PostconditionMetadata(
      expression: data['expression'] ?? '',
      description: data['description'] ?? '',
    );
  }
}

class ActionMetadata {
  final String command;
  final String target;
  final String parameters;
  final String conditions;

  ActionMetadata({
    required this.command,
    required this.target,
    required this.parameters,
    required this.conditions,
  });

  factory ActionMetadata.fromMap(Map<String, dynamic> data) {
    return ActionMetadata(
      command: data['command'] ?? '',
      target: data['target'] ?? '',
      parameters: data['parameters'] ?? '',
      conditions: data['conditions'] ?? '',
    );
  }
}

class ParameterMetadata {
  final String name;
  final String type;
  final bool required;
  final dynamic defaultValue;

  ParameterMetadata({
    required this.name,
    required this.type,
    required this.required,
    this.defaultValue,
  });

  factory ParameterMetadata.fromMap(Map<String, dynamic> data) {
    return ParameterMetadata(
      name: data['name'] ?? '',
      type: data['type'] ?? 'String',
      required: data['required'] ?? true,
      defaultValue: data['defaultValue'],
    );
  }
}
