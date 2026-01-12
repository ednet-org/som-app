part of ednet_core;

String genConceptGen(Concept concept, String library) {
  Model model = concept.model;
  Domain domain = model.domain;

  return '''
part of $library;

// lib/gen/${domain.codeLowerUnderscore}/${model.codeLowerUnderscore}/${concept.codesLowerUnderscore}.dart

abstract class ${concept.code}Gen extends Entity<${concept.code}> {
  ${concept.code}Gen(Concept concept) {
    this.concept = concept;
    ${concept.children.isEmpty ? '// concept.children.isEmpty' : _generateChildrenSetup(concept)}
  }
  ${_generateWithIdConstructor(concept)}

  ${_generateParentAccessors(concept)}

  ${_generateAttributeAccessors(concept)}

  ${_generateChildAccessors(concept)}
  @override
  ${concept.code} newEntity() => ${concept.code}(concept);

  @override
  ${concept.codes} newEntities() => ${concept.codes}(concept);

  ${_generateCompareToMethod(concept)}
}

abstract class ${concept.codes}Gen extends Entities<${concept.code}> {
  ${concept.codes}Gen(Concept concept) {
    this.concept = concept;
  }

  @override
  ${concept.codes} newEntities() => ${concept.codes}(concept);

  @override
  ${concept.code} newEntity() => ${concept.code}(concept);
}

${generateCommands(concept)}
${generateEvents(concept)}
${generatePolicies(concept)}
''';
}

String _generateChildrenSetup(Concept concept) {
  var generatedConcepts = <Concept>{};
  return concept.children
      .whereType<Child>()
      .map((child) {
        Concept destinationConcept = child.destinationConcept;
        var setup = '';
        if (!generatedConcepts.contains(destinationConcept)) {
          generatedConcepts.add(destinationConcept);
          setup =
              '''
    final ${destinationConcept.codeFirstLetterLower}Concept = 
        concept.model.concepts.singleWhereCode('${destinationConcept.code}');
    assert(${destinationConcept.codeFirstLetterLower}Concept != null, \'${destinationConcept.code} concept is not defined\');
''';
        }
        return '''
$setup    setChild('${child.code}', ${destinationConcept.codes}(${destinationConcept.codeFirstLetterLower}Concept!));
''';
      })
      .where((item) => item.trim().length > 0)
      .join();
}

String _generateWithIdConstructor(Concept concept) {
  Id id = concept.id;
  if (id.length == 0) return '';

  var params = [
    'Concept concept',
    ...concept.parents
        .whereType<Parent>()
        .where((p) => p.identifier)
        .map((p) => '${p.destinationConcept.code} ${p.code}'),
    ...concept.attributes
        .whereType<Attribute>()
        .where((a) => a.identifier)
        .map((a) => '${a.type?.base} ${a.code}'),
  ].where((item) => item.trim().length > 0).join(', ');

  var body =
      '''
    this.concept = concept;
${concept.parents.whereType<Parent>().where((p) => p.identifier).map((p) => '    setParent(\'${p.code}\', ${p.code});').where((item) => item.trim().length > 0).join('\n')}
${concept.attributes.whereType<Attribute>().where((a) => a.identifier).map((a) => '    setAttribute(\'${a.code}\', ${a.code});').where((item) => item.trim().length > 0).join('\n')}
${_generateChildrenSetup(concept)}
''';

  return '''
  ${concept.code}Gen.withId($params) {
$body  }
''';
}

String _generateParentAccessors(Concept concept) {
  var generatedAccessors = <String, String>{};
  return concept.parents
      .whereType<Parent>()
      .map((parent) {
        Concept destinationConcept = parent.destinationConcept;
        String accessorName = parent.code;
        String accessorType = destinationConcept.code;

        // If we've already generated an accessor for this name, make it unique
        if (generatedAccessors.containsKey(accessorName)) {
          accessorName = '${accessorName}${accessorType}';
        }

        generatedAccessors[accessorName] = accessorType;

        var referenceAccessor =
            '''
  Reference get ${accessorName}Reference => getReference(\'${parent.code}\')!;
  
  set ${accessorName}Reference(Reference reference) => 
      setReference(\'${parent.code}\', reference);
''';

        var parentAccessor =
            '''
  $accessorType get $accessorName =>
      getParent(\'${parent.code}\')! as $accessorType;
  
  set $accessorName($accessorType p) => setParent(\'${parent.code}\', p);
''';

        var result = referenceAccessor + parentAccessor;

        if (result.trim().length == 0) {
          return '';
        }

        return referenceAccessor + parentAccessor;
      })
      .where((item) => item.trim().length > 0)
      .join('\n');
}

String _generateAttributeAccessors(Concept concept) {
  return concept.attributes
      .whereType<Attribute>()
      .map((attribute) {
        // Special handling for 'id' attribute to match Entity<T> base class
        if (attribute.code.toLowerCase() == 'id') {
          return '''
  Id? get ${attribute.code} => getAttribute('${attribute.code}') as Id?;
  
  set ${attribute.code}(Id? a) => setAttribute('${attribute.code}', a);
''';
        }

        // Regular attribute handling
        return '''
  ${attribute.type?.base} get ${attribute.code} => getAttribute('${attribute.code}') as ${attribute.type?.base};
  
  set ${attribute.code}(${attribute.type?.base} a) => setAttribute('${attribute.code}', a);
''';
      })
      .where((item) => item.trim().length > 0)
      .join('\n');
}

String _generateChildAccessors(Concept concept) {
  return concept.children
      .whereType<Child>()
      .map((child) {
        Concept destinationConcept = child.destinationConcept;
        return '''
  ${destinationConcept.codes} get ${child.code} => getChild(\'${child.code}\')! as ${destinationConcept.codes};
''';
      })
      .where((item) => item.trim().length > 0)
      .join('\n');
}

String _generateCompareToMethod(Concept concept) {
  Id id = concept.id;
  if (id.attributeLength != 1) return '';

  var attribute = concept.attributes.whereType<Attribute>().firstWhere(
    (a) => a.identifier,
  );
  var compareBody = attribute.type?.code == 'Uri'
      ? '${attribute.code}.toString().compareTo(other.${attribute.code}.toString())'
      : '${attribute.code}.compareTo(other.${attribute.code})';
  var result =
      '''
  int ${attribute.code}CompareTo(${concept.code} other) => $compareBody;
''';
  return result.isEmpty ? '' : result;
}

String generateCommands(Concept concept) {
  final commandsData = concept.metadata['commands'];
  if (commandsData == null) return '';

  final commandsMap = Map<String, dynamic>.from(commandsData as Map);
  if (commandsMap.isEmpty) return '';

  final buffer = StringBuffer();
  buffer.writeln('// Commands for ${concept.code}');

  for (final commandEntry in commandsMap.entries) {
    final commandName = commandEntry.key;
    final commandData = commandEntry.value as Map<String, dynamic>;
    final description = commandData['description'] as String? ?? '';
    final successEvent = commandData['successEvent'] as String? ?? '';
    final failureEvent = commandData['failureEvent'] as String? ?? '';
    final _ =
        commandData['roles'] as List<dynamic>? ??
        []; // roles - reserved for role validation
    final preconditions = commandData['preconditions'] as List<dynamic>? ?? [];
    final postconditions =
        commandData['postconditions'] as List<dynamic>? ?? [];

    buffer.writeln('''
/// Command: $commandName
/// $description
class ${commandName}Command {
  final String entityId;
  final DateTime timestamp;
  final Map<String, dynamic> payload;

  ${commandName}Command({
    required this.entityId,
    DateTime? timestamp,
    this.payload = const {},
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'entityId': entityId,
    'timestamp': timestamp.toIso8601String(),
    'payload': payload,
  };
}

/// Execute $commandName command
Future<CommandResult> execute$commandName(${commandName}Command command) async {
  try {''');

    // Generate preconditions
    for (final precondition in preconditions) {
      final condition = precondition as Map<String, dynamic>;
      final expression = condition['expression'] as String;
      final errorMessage = condition['errorMessage'] as String;
      buffer.writeln('''
    // Precondition: $errorMessage
    if (!($expression)) {
      throw PolicyViolationException('$errorMessage');
    }''');
    }

    buffer.writeln('''
    
    // Execute command logic here
    // NOTE: Implement business logic for $commandName
    ''');

    // Generate postconditions
    for (final postcondition in postconditions) {
      final condition = postcondition as Map<String, dynamic>;
      final expression = condition['expression'] as String;
      final description = condition['description'] as String;
      buffer.writeln('''
    // Postcondition: $description
    assert($expression, '$description');''');
    }

    if (successEvent.isNotEmpty) {
      buffer.writeln('''
    
    // Emit success event
    final event = ${successEvent}Event(
      entityId: command.entityId,
      timestamp: DateTime.now(),
      payload: command.payload,
    );
    
    return CommandResult.success(event);''');
    } else {
      buffer.writeln('''
    
    return CommandResult.success(null);''');
    }

    buffer.writeln('''
  } catch (e) {''');

    if (failureEvent.isNotEmpty) {
      buffer.writeln('''
    // Emit failure event
    final failureEvent = ${failureEvent}Event(
      entityId: command.entityId,
      timestamp: DateTime.now(),
      error: e.toString(),
    );
    return CommandResult.failure(failureEvent);''');
    } else {
      buffer.writeln('''
    rethrow;''');
    }

    buffer.writeln('''
  }
}
''');
  }

  return buffer.toString();
}

String generateEvents(Concept concept) {
  final eventsData = concept.metadata['events'];
  if (eventsData == null) return '';

  final eventsMap = Map<String, dynamic>.from(eventsData as Map);
  if (eventsMap.isEmpty) return '';

  final buffer = StringBuffer();
  buffer.writeln('// Events for ${concept.code}');

  for (final eventEntry in eventsMap.entries) {
    final eventName = eventEntry.key;
    final eventData = eventEntry.value as Map<String, dynamic>;
    final description = eventData['description'] as String? ?? '';
    final _ =
        eventData['triggers'] as List<dynamic>? ??
        []; // triggers - reserved for trigger processing
    final payload = eventData['payload'] as Map<String, dynamic>? ?? {};
    final subscribers = eventData['subscribers'] as List<dynamic>? ?? [];
    eventData['projections']; // projections - reserved for projection handling (access without variable assignment)

    buffer.writeln('''
/// Event: $eventName
/// $description
class ${eventName}Event {
  final String entityId;
  final DateTime timestamp;''');

    // Generate payload fields
    for (final entry in payload.entries) {
      final fieldName = entry.key;
      final fieldType = entry.value;
      buffer.writeln('  final $fieldType $fieldName;');
    }

    buffer.writeln('''

  ${eventName}Event({
    required this.entityId,
    required this.timestamp,''');

    // Generate payload parameters
    for (final entry in payload.entries) {
      final fieldName = entry.key;
      buffer.writeln('    required this.$fieldName,');
    }

    buffer.writeln('''  });

  Map<String, dynamic> toJson() => {
    'entityId': entityId,
    'timestamp': timestamp.toIso8601String(),''');

    // Generate payload JSON
    for (final entry in payload.entries) {
      final fieldName = entry.key;
      buffer.writeln("    '$fieldName': $fieldName,");
    }

    buffer.writeln('  };');

    // Generate subscriber notifications
    for (final subscriber in subscribers) {
      buffer.writeln('''
  
  /// Notify $subscriber service
  void notify${subscriber}() {
    // NOTE: Implement $subscriber notification
  }''');
    }

    buffer.writeln('}');
    buffer.writeln();
  }

  return buffer.toString();
}

String generatePolicies(Concept concept) {
  final policiesData = concept.metadata['policies'];
  if (policiesData == null) return '';

  final policiesMap = Map<String, dynamic>.from(policiesData as Map);
  if (policiesMap.isEmpty) return '';

  final buffer = StringBuffer();
  buffer.writeln('// Policies for ${concept.code}');

  for (final policyEntry in policiesMap.entries) {
    final policyName = policyEntry.key;
    final policyData = policyEntry.value as Map<String, dynamic>;
    final description = policyData['description'] as String? ?? '';
    final expression = policyData['expression'] as String? ?? '';
    final priority = policyData['priority'] as String? ?? 'normal';
    final isActive = policyData['isActive'] as bool? ?? true;
    final _ =
        policyData['events'] as List<dynamic>? ??
        []; // events - reserved for event handling
    final actions = policyData['actions'] as List<dynamic>? ?? [];
    final conditions = policyData['conditions'] as Map<String, dynamic>?;

    buffer.writeln('''
/// Policy: $policyName
/// $description
class ${policyName}Policy extends IPolicy {
  @override
  String get name => '$policyName';

  @override
  String get description => '$description';

  @override
  PolicyPriority get priority => PolicyPriority.$priority;

  @override
  bool get isActive => $isActive;

  @override
  bool evaluate(Map<String, dynamic> context) {''');

    if (conditions != null) {
      final conditionExpression =
          conditions['expression'] as String? ?? expression;
      buffer.writeln('    return $conditionExpression;');
    } else {
      buffer.writeln('    return $expression;');
    }

    buffer.writeln('''  }

  @override
  List<PolicyAction> getActions(Map<String, dynamic> context) {
    final actions = <PolicyAction>[];''');

    // Generate policy actions
    for (final actionData in actions) {
      final action = actionData as Map<String, dynamic>;
      final command = action['command'] as String;
      final target = action['target'] as String;
      final parameters = action['parameters'] as String? ?? '';
      final actionConditions = action['conditions'] as String? ?? 'true';

      buffer.writeln('''
    if ($actionConditions) {
      actions.add(PolicyAction(
        command: '$command',
        target: $target,''');

      if (parameters.isNotEmpty) {
        buffer.writeln("        parameters: '$parameters',");
      }

      buffer.writeln('''      ));
    }''');
    }

    buffer.writeln('''    return actions;
  }
}
''');
  }

  // Generate supporting classes if not already present
  buffer.writeln('''
/// Command execution result
class CommandResult {
  final bool isSuccess;
  final dynamic event;
  final String? error;

  CommandResult.success(this.event) : isSuccess = true, error = null;
  CommandResult.failure(this.event, [this.error]) : isSuccess = false;
}

/// Policy action definition
class PolicyAction {
  final String command;
  final String target;
  final String? parameters;

  PolicyAction({
    required this.command,
    required this.target,
    this.parameters,
  });
}

/// Policy priority enumeration
enum PolicyPriority { low, normal, high, critical }
''');

  return buffer.toString();
}
