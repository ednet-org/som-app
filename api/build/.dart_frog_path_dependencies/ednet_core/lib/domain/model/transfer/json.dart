part of ednet_core;

final Logger _transferJsonLogger = Logger('ednet_core.transfer.json');

/// Convert YamlMap to Map<String, dynamic> safely
Map<String, dynamic>? convertYamlToMap(dynamic yamlData) {
  if (yamlData == null) return null;
  if (yamlData is Map<String, dynamic>) return yamlData;
  if (yamlData is YamlMap) {
    final result = <String, dynamic>{};
    for (final entry in yamlData.entries) {
      final key = entry.key.toString();
      final value = _convertYamlValue(entry.value);
      result[key] = value;
    }
    return result;
  }
  return null;
}

/// Convert YamlList to List<dynamic> safely
List<dynamic>? convertYamlToList(dynamic yamlData) {
  if (yamlData == null) return null;
  if (yamlData is List<dynamic>) return yamlData;
  if (yamlData is YamlList) {
    return yamlData.map(_convertYamlValue).toList();
  }
  return null;
}

/// Recursively convert YAML values to standard Dart types
dynamic _convertYamlValue(dynamic value) {
  if (value is YamlMap) {
    return convertYamlToMap(value);
  } else if (value is YamlList) {
    return convertYamlToList(value);
  } else {
    return value;
  }
}

Model fromJsonToModel(String json, Domain domain, String modelCode, Map? yaml) {
  Iterable jsonConcepts = [];
  Iterable relations = [];

  if (yaml == null || yaml.isEmpty) {
    if (json.trim() == '') {
      throw EDNetException('Empty JSON string for Model parse');
    }
    var boardMap = jsonDecode(json);
    jsonConcepts = boardMap['concepts'];
    relations = boardMap['relations'];
  } else {
    final conceptsValue = yaml['concepts'];
    if (conceptsValue is Iterable) {
      jsonConcepts = conceptsValue;
    } else {
      throw EDNetException(
        'Invalid concepts format in YAML. Expected Iterable but got ${conceptsValue.runtimeType}',
      );
    }

    if (yaml.containsKey('relations')) {
      final relationsValue = yaml['relations'];
      if (relationsValue is Iterable) {
        relations = relationsValue;
      } else {
        throw EDNetException(
          'Invalid relations format in YAML. Expected Iterable but got ${relationsValue.runtimeType}',
        );
      }
    }
  }

  Model model = Model(domain, modelCode);

  // Parse concepts
  for (var jsonConcept in jsonConcepts) {
    final conceptNameValue = jsonConcept['name'];
    if (conceptNameValue is! String?) {
      throw EDNetException(
        'Invalid concept name. Expected String but got ${conceptNameValue.runtimeType}',
      );
    }
    String? conceptCode = conceptNameValue;
    assert(
      conceptCode != null,
      'Concept code is missing for the jsonConcept. For ${domain.code}.$modelCode',
    );
    bool conceptEntry = jsonConcept['entry'] ?? false;
    bool aggregateRoot = jsonConcept['aggregateRoot'] ?? false;

    Concept concept = Concept(model, conceptCode!);
    concept.entry = conceptEntry;

    // Add aggregateRoot marker if present
    if (aggregateRoot) {
      concept.category = 'AggregateRoot';
    }

    // Process attributes
    var items = jsonConcept['attributes'] ?? [];
    for (var item in items) {
      String attributeCode = item['name'];
      if (attributeCode != 'oid' && attributeCode != 'code') {
        Attribute attribute = Attribute(concept, attributeCode);
        String itemCategory = item['category'] ?? '';
        if (itemCategory == 'guid') {
          attribute.guid = true;
        } else if (itemCategory == 'identifier') {
          attribute.identifier = true;
        } else if (itemCategory == 'required') {
          attribute.minc = '1';
        }

        // Enhanced YAML DSL support: required field
        if (item.containsKey('required')) {
          bool itemRequired = item['required'] ?? false;
          attribute.required = itemRequired;
        }

        // Enhanced YAML DSL support: unique field
        if (item.containsKey('unique')) {
          bool itemUnique = item['unique'] ?? false;
          if (itemUnique) {
            attribute.identifier = true;
            // Store unique flag in metadata for code generation
            if (attribute.metadata == null) {
              attribute.metadata = {};
            }
            attribute.metadata!['unique'] = true;
          }
        }

        // Enhanced YAML DSL support: enumValues field
        if (item.containsKey('enumValues')) {
          final enumValues = item['enumValues'];
          if (enumValues is List) {
            // Store enum values in metadata
            if (attribute.metadata == null) {
              attribute.metadata = {};
            }
            attribute.metadata!['enumValues'] = List<String>.from(
              enumValues.map((v) => v.toString()),
            );
          }
        }

        int itemSequence = item['sequence'] as int? ?? 0;
        attribute.sequence = itemSequence;

        // Enhanced YAML DSL support: default field (in addition to init)
        String itemInit = item['init'] ?? '';
        if (item.containsKey('default')) {
          // 'default' takes precedence over 'init' for modern YAML DSL
          final defaultValue = item['default'];
          attribute.init = defaultValue;
        } else if (itemInit.trim() == '') {
          attribute.init = null;
        } else if (itemInit == 'increment') {
          attribute.increment = 1;
          attribute.init = null;
        } else if (itemInit == 'empty') {
          attribute.init = '';
        } else {
          attribute.init = itemInit;
        }

        bool itemEssential = item['essential'] ?? true;
        attribute.essential = itemEssential;
        bool itemSensitive = item['sensitive'] ?? false;
        attribute.sensitive = itemSensitive;
        String itemType = item['type'] ?? 'String';
        AttributeType? type = domain.types.singleWhereCode(itemType);
        if (type != null) {
          attribute.type = type;

          // Process constraints if they exist
          if (item.containsKey('constraints')) {
            Map constraints = item['constraints'];
            applyConstraintsToType(type, constraints);
          }
        } else {
          attribute.type = domain.getType('String');
        }
      }
    }

    // Process commands
    processCommands(jsonConcept, concept);

    // Process events
    processEvents(jsonConcept, concept);

    // Process policies
    processPolicies(jsonConcept, concept);

    // Process Event Storming sentences
    _processEventStormingSentences(jsonConcept, concept);

    // Process criteria and conditional logic
    _processCriteriaDefinitions(jsonConcept, concept);
  }

  // Process relations
  for (var relation in relations) {
    final fromValue = relation['from'];
    final toString = relation['to'];

    if (fromValue is! String) {
      throw EDNetException(
        'Invalid "from" value in relation. Expected String but got ${fromValue.runtimeType}',
      );
    }
    if (toString is! String) {
      throw EDNetException(
        'Invalid "to" value in relation. Expected String but got ${toString.runtimeType}',
      );
    }

    String from = fromValue;
    String to = toString;

    Concept? concept1 = model.concepts.singleWhereCode(from);
    Concept? concept2 = model.concepts.singleWhereCode(to);
    if (concept1 == null) {
      throw ConceptException(
        'Line concept is missing for the $from jsonConcept. For ${domain.code}.$modelCode',
      );
    }
    if (concept2 == null) {
      throw ConceptException(
        'Line concept is missing for the $to jsonConcept. For ${domain.code}.$modelCode',
      );
    }

    final fromToNameValue = relation['fromToName'];
    final toFromNameValue = relation['toFromName'];

    if (fromToNameValue is! String) {
      throw EDNetException(
        'Invalid "fromToName" value in relation. Expected String but got ${fromToNameValue.runtimeType}',
      );
    }
    if (toFromNameValue is! String) {
      throw EDNetException(
        'Invalid "toFromName" value in relation. Expected String but got ${toFromNameValue.runtimeType}',
      );
    }

    String fromToName = fromToNameValue;
    String fromToMin = '${relation["fromToMin"]}';
    String fromToMax = '${relation["fromToMax"]}';
    bool fromToId = relation['fromToId'] ?? false;
    String toFromName = toFromNameValue;
    String toFromMin = '${relation["toFromMin"]}';
    String toFromMax = '${relation["toFromMax"]}';
    bool toFromId = relation['toFromId'] ?? false;
    bool lineInternal = relation['internal'] ?? false;
    String lineCategory = relation['category'] ?? 'rel';

    bool d12Child;
    bool d21Child;
    bool d12Parent;
    bool d21Parent;

    if (fromToMax != '1') {
      d12Child = true;
      if (toFromMax != '1') {
        d21Child = true;
      } else {
        d21Child = false;
      }
    } else if (toFromMax != '1') {
      d12Child = false;
      d21Child = true;
    } else if (fromToMin == '0') {
      d12Child = true;
      d21Child = false;
    } else if (toFromMin == '0') {
      d12Child = false;
      d21Child = true;
    } else {
      d12Child = true;
      d21Child = false;
    }

    d12Parent = !d12Child;
    d21Parent = !d21Child;

    if (d12Child && d21Child) {
      throw Exception('$from -- $to relation has two children.');
    }
    if (d12Parent && d21Parent) {
      throw Exception('$from -- $to relation has two parents.');
    }

    Neighbor neighbor12;
    Neighbor neighbor21;

    if (d12Child && d21Parent) {
      neighbor12 = Child(concept1, concept2, fromToName);
      neighbor21 = Parent(concept2, concept1, toFromName);

      neighbor12.opposite = neighbor21;
      neighbor21.opposite = neighbor12;

      neighbor12.minc = fromToMin;
      neighbor12.maxc = fromToMax;
      neighbor12.identifier = fromToId;

      neighbor21.minc = toFromMin;
      neighbor21.maxc = toFromMax;
      neighbor21.identifier = toFromId;

      neighbor12.internal = lineInternal;
      if (lineCategory == 'inheritance') {
        neighbor12.inheritance = true;
      } else if (lineCategory == 'reflexive') {
        neighbor12.reflexive = true;
      } else if (lineCategory == 'twin') {
        neighbor12.twin = true;
      } else if (lineCategory == 'association') {
        neighbor12.category = 'association';
      }

      neighbor21.internal = lineInternal;
      if (lineCategory == 'inheritance') {
        neighbor21.inheritance = true;
      } else if (lineCategory == 'reflexive') {
        neighbor21.reflexive = true;
      } else if (lineCategory == 'twin') {
        neighbor21.twin = true;
      } else if (lineCategory == 'association') {
        neighbor21.category = 'association';
      }
    } else if (d12Parent && d21Child) {
      neighbor12 = Parent(concept1, concept2, fromToName);
      neighbor21 = Child(concept2, concept1, toFromName);

      neighbor12.opposite = neighbor21;
      neighbor21.opposite = neighbor12;

      neighbor12.minc = fromToMin;
      neighbor12.maxc = fromToMax;
      neighbor12.identifier = fromToId;

      neighbor21.minc = toFromMin;
      neighbor21.maxc = toFromMax;
      neighbor21.identifier = toFromId;

      neighbor12.internal = lineInternal;
      if (lineCategory == 'inheritance') {
        neighbor12.inheritance = true;
      } else if (lineCategory == 'reflexive') {
        neighbor12.reflexive = true;
      } else if (lineCategory == 'twin') {
        neighbor12.twin = true;
      } else if (lineCategory == 'association') {
        neighbor12.category = 'association';
      }

      neighbor21.internal = lineInternal;
      if (lineCategory == 'inheritance') {
        neighbor21.inheritance = true;
      } else if (lineCategory == 'reflexive') {
        neighbor21.reflexive = true;
      } else if (lineCategory == 'twin') {
        neighbor21.twin = true;
      } else if (lineCategory == 'association') {
        neighbor21.category = 'association';
      }
    }
  }

  return model;
}

/// Apply constraints defined in the YAML schema to an AttributeType
void applyConstraintsToType(AttributeType type, Map constraints) {
  if (type.base == 'int' || type.base == 'double' || type.base == 'num') {
    // Numeric constraints
    if (constraints.containsKey('min')) {
      var minValue = constraints['min'];
      if (minValue is num) {
        type.setMinValue(minValue);
      } else if (minValue is String) {
        try {
          type.setMinValue(num.parse(minValue));
        } catch (e) {
          _transferJsonLogger.warning(
            'Invalid numeric min constraint: $minValue',
          );
        }
      }
    }

    if (constraints.containsKey('max')) {
      var maxValue = constraints['max'];
      if (maxValue is num) {
        type.setMaxValue(maxValue);
      } else if (maxValue is String) {
        try {
          type.setMaxValue(num.parse(maxValue));
        } catch (e) {
          _transferJsonLogger.warning(
            'Invalid numeric max constraint: $maxValue',
          );
        }
      }
    }
  } else if (type.base == 'String') {
    // String constraints
    if (constraints.containsKey('minLength')) {
      var minLength = constraints['minLength'];
      if (minLength is int) {
        type.setMinLength(minLength);
      } else if (minLength is String) {
        try {
          type.setMinLength(int.parse(minLength));
        } catch (e) {
          _transferJsonLogger.warning(
            'Invalid string minLength constraint: $minLength',
          );
        }
      }
    }

    if (constraints.containsKey('maxLength')) {
      var maxLength = constraints['maxLength'];
      if (maxLength is int) {
        // For string types, maxLength is set via the length property
        type.length = maxLength;
      } else if (maxLength is String) {
        try {
          type.length = int.parse(maxLength);
        } catch (e) {
          _transferJsonLogger.warning(
            'Invalid string maxLength constraint: $maxLength',
          );
        }
      }
    }

    if (constraints.containsKey('pattern')) {
      var pattern = constraints['pattern'];
      if (pattern is String) {
        type.setPattern(pattern);
      }
    }

    // For specific string subtypes, apply additional validation
    if (type.code == 'Email' && constraints.containsKey('email')) {
      // Email validation is handled implicitly by the Email type
      // But here we can add additional validation rules if needed
    }

    if (type.code == 'Uri' && constraints.containsKey('url')) {
      // URI validation is handled implicitly by the Uri type
      // But here we can add additional validation rules if needed
    }
  }
}

void processCommands(Map jsonConcept, Concept concept) {
  var commands = jsonConcept['commands'] ?? [];
  for (var command in commands) {
    String commandName = command['name'];
    String description = command['description'] ?? '';
    String successEvent = command['successEvent'] ?? '';
    String failureEvent = command['failureEvent'] ?? '';
    List<String> roles = [];
    List<Map<String, dynamic>> preconditions = [];
    List<Map<String, dynamic>> postconditions = [];
    Map<String, dynamic> validation = {};

    if (command.containsKey('roles')) {
      var rolesList = convertYamlToList(command['roles']) ?? [];
      roles = rolesList.map((role) => role.toString()).toList();
    }

    // Process preconditions with criteria language
    if (command.containsKey('preconditions')) {
      var preconditionsList = convertYamlToList(command['preconditions']) ?? [];
      for (var precondition in preconditionsList) {
        preconditions.add({
          'expression': precondition['expression'] ?? '',
          'errorMessage': precondition['errorMessage'] ?? '',
          'severity': precondition['severity'] ?? 'error',
        });
      }
    }

    // Process postconditions
    if (command.containsKey('postconditions')) {
      var postconditionsList =
          convertYamlToList(command['postconditions']) ?? [];
      for (var postcondition in postconditionsList) {
        postconditions.add({
          'expression': postcondition['expression'] ?? '',
          'description': postcondition['description'] ?? '',
        });
      }
    }

    // Process validation rules
    if (command.containsKey('validation')) {
      validation = convertYamlToMap(command['validation']) ?? {};
    }

    // Add command metadata to the concept
    if (!concept.metadata.containsKey('commands')) {
      concept.metadata['commands'] = {};
    }

    concept.metadata['commands'][commandName] = {
      'description': description,
      'successEvent': successEvent,
      'failureEvent': failureEvent,
      'roles': roles,
      'preconditions': preconditions,
      'postconditions': postconditions,
      'validation': validation,
    };
  }
}

void processEvents(Map jsonConcept, Concept concept) {
  var events = jsonConcept['events'] ?? [];
  for (var event in events) {
    String eventName = event['name'];
    String description = event['description'] ?? '';
    List<String> triggers = [];
    Map<String, dynamic> payload = {};
    List<Map<String, dynamic>> projections = [];
    List<String> subscribers = [];

    if (event.containsKey('triggers')) {
      var triggersList = convertYamlToList(event['triggers']) ?? [];
      triggers = triggersList.map((trigger) => trigger.toString()).toList();
    }

    // Process event payload schema
    if (event.containsKey('payload')) {
      payload = convertYamlToMap(event['payload']) ?? {};
    }

    // Process event projections for read models
    if (event.containsKey('projections')) {
      var projectionsList = convertYamlToList(event['projections']) ?? [];
      for (var projection in projectionsList) {
        projections.add({
          'readModel': projection['readModel'] ?? '',
          'transformation': projection['transformation'] ?? '',
          'conditions': projection['conditions'] ?? [],
        });
      }
    }

    // Process event subscribers
    if (event.containsKey('subscribers')) {
      var subscribersList = convertYamlToList(event['subscribers']) ?? [];
      subscribers = subscribersList.map((sub) => sub.toString()).toList();
    }

    // Add event metadata to the concept
    if (!concept.metadata.containsKey('events')) {
      concept.metadata['events'] = {};
    }

    concept.metadata['events'][eventName] = {
      'description': description,
      'triggers': triggers,
      'payload': payload,
      'projections': projections,
      'subscribers': subscribers,
    };
  }
}

void processPolicies(Map jsonConcept, Concept concept) {
  var policies = jsonConcept['policies'] ?? [];
  for (var policy in policies) {
    String policyName = policy['name'];
    String description = policy['description'] ?? '';
    String expression = policy['expression'] ?? '';
    List<String> eventTriggers = [];
    List<Map<String, String>> actions = [];
    Map<String, dynamic> conditions = {};
    String priority = policy['priority'] ?? 'normal';
    bool isActive = policy['isActive'] ?? true;

    if (policy.containsKey('events')) {
      var eventsList = convertYamlToList(policy['events']) ?? [];
      eventTriggers = eventsList.map((event) => event.toString()).toList();
    }

    if (policy.containsKey('actions')) {
      var actionsList = convertYamlToList(policy['actions']) ?? [];
      for (var action in actionsList) {
        actions.add({
          'command': action['command'] ?? '',
          'target': action['target'] ?? '',
          'parameters': action['parameters'] ?? '',
          'conditions': action['conditions'] ?? '',
        });
      }
    }

    // Process complex conditional logic
    if (policy.containsKey('conditions')) {
      conditions = convertYamlToMap(policy['conditions']) ?? {};
    }

    // Add policy metadata to the concept
    if (!concept.metadata.containsKey('policies')) {
      concept.metadata['policies'] = {};
    }

    concept.metadata['policies'][policyName] = {
      'description': description,
      'expression': expression,
      'events': eventTriggers,
      'actions': actions,
      'conditions': conditions,
      'priority': priority,
      'isActive': isActive,
    };
  }
}

/// Process Event Storming sentences for semantic validation and generation
void _processEventStormingSentences(Map jsonConcept, Concept concept) {
  var sentences = jsonConcept['eventStormingSentences'] ?? [];

  for (var sentence in sentences) {
    String sentenceText = sentence['sentence'] ?? '';
    String actor = sentence['actor'] ?? '';
    String command = sentence['command'] ?? '';
    String aggregate = sentence['aggregate'] ?? concept.code;
    String event = sentence['event'] ?? '';
    String policy = sentence['policy'] ?? '';
    String nextCommand = sentence['nextCommand'] ?? '';
    List<String> timeline = [];
    Map<String, dynamic> semantics = {};

    if (sentence.containsKey('timeline')) {
      var timelineList = convertYamlToList(sentence['timeline']) ?? [];
      timeline = timelineList.map((item) => item.toString()).toList();
    }

    if (sentence.containsKey('semantics')) {
      semantics = convertYamlToMap(sentence['semantics']) ?? {};
    }

    // Add Event Storming sentence metadata
    if (!concept.metadata.containsKey('eventStormingSentences')) {
      concept.metadata['eventStormingSentences'] = [];
    }

    concept.metadata['eventStormingSentences'].add({
      'sentence': sentenceText,
      'actor': actor,
      'command': command,
      'aggregate': aggregate,
      'event': event,
      'policy': policy,
      'nextCommand': nextCommand,
      'timeline': timeline,
      'semantics': semantics,
    });
  }
}

/// Process criteria definitions for powerful conditional logic
void _processCriteriaDefinitions(Map jsonConcept, Concept concept) {
  var criteria = jsonConcept['criteria'] ?? [];

  for (var criterion in criteria) {
    String criterionName = criterion['name'] ?? '';
    String description = criterion['description'] ?? '';
    String expression = criterion['expression'] ?? '';
    String returnType = criterion['returnType'] ?? 'boolean';
    List<Map<String, dynamic>> parameters = [];
    Map<String, dynamic> operators = {};
    List<String> dependencies = [];

    if (criterion.containsKey('parameters')) {
      var paramsList = convertYamlToList(criterion['parameters']) ?? [];
      for (var param in paramsList) {
        parameters.add({
          'name': param['name'] ?? '',
          'type': param['type'] ?? 'String',
          'required': param['required'] ?? true,
          'defaultValue': param['defaultValue'],
        });
      }
    }

    if (criterion.containsKey('operators')) {
      operators = convertYamlToMap(criterion['operators']) ?? {};
    }

    if (criterion.containsKey('dependencies')) {
      var depsList = convertYamlToList(criterion['dependencies']) ?? [];
      dependencies = depsList.map((dep) => dep.toString()).toList();
    }

    // Add criteria metadata
    if (!concept.metadata.containsKey('criteria')) {
      concept.metadata['criteria'] = {};
    }

    concept.metadata['criteria'][criterionName] = {
      'description': description,
      'expression': expression,
      'returnType': returnType,
      'parameters': parameters,
      'operators': operators,
      'dependencies': dependencies,
    };
  }
}

/// Generate Event Storming sentences from domain model
String generateEventStormingSentences(Model model) {
  StringBuffer sentences = StringBuffer();

  for (var concept in model.concepts) {
    // Generate sentences from commands and events
    if (concept.metadata.containsKey('commands') &&
        concept.metadata.containsKey('events')) {
      var commands = concept.metadata['commands'] as Map;
      var events = concept.metadata['events'] as Map;

      for (var commandEntry in commands.entries) {
        String commandName = commandEntry.key;
        Map commandData = commandEntry.value;
        String successEvent = commandData['successEvent'] ?? '';

        if (successEvent.isNotEmpty && events.containsKey(successEvent)) {
          // Generate basic Event Storming sentence
          sentences.writeln(
            'Actor → $commandName → ${concept.code} → $successEvent',
          );

          // Add policy-driven sentences if policies exist
          if (concept.metadata.containsKey('policies')) {
            var policies = concept.metadata['policies'] as Map;
            for (var policyEntry in policies.entries) {
              String policyName = policyEntry.key;
              Map policyData = policyEntry.value;
              List eventTriggers = policyData['events'] ?? [];

              if (eventTriggers.contains(successEvent)) {
                List actions = policyData['actions'] ?? [];
                for (var action in actions) {
                  String nextCommand = action['command'] ?? '';
                  if (nextCommand.isNotEmpty) {
                    sentences.writeln(
                      '$successEvent → $policyName → $nextCommand',
                    );
                  }
                }
              }
            }
          }
        }
      }
    }

    // Generate sentences from explicit Event Storming definitions
    if (concept.metadata.containsKey('eventStormingSentences')) {
      var explicitSentences =
          concept.metadata['eventStormingSentences'] as List;
      for (var sentence in explicitSentences) {
        sentences.writeln(sentence['sentence']);
      }
    }
  }

  return sentences.toString();
}

/// Validate Event Storming sentence semantics
bool validateEventStormingSentence(String sentence, Model model) {
  // Parse sentence structure: Actor → Command → Aggregate → Event → Policy → Command
  var parts = sentence.split('→').map((s) => s.trim()).toList();

  if (parts.length < 3) {
    return false; // Minimum: Actor → Command → Event
  }

  // Validate that referenced concepts exist in the model
  for (int i = 2; i < parts.length; i += 2) {
    // Check aggregate/concept references
    String conceptName = parts[i];
    if (model.concepts.singleWhereCode(conceptName) == null) {
      return false;
    }
  }

  return true;
}

/// Generate criteria expressions for conditional logic
String generateCriteriaExpression(Map<String, dynamic> criteria) {
  String expression = criteria['expression'] ?? '';
  List parameters = criteria['parameters'] ?? [];
  Map operators = criteria['operators'] ?? {};

  // Replace parameter placeholders with actual values
  for (var param in parameters) {
    String paramName = param['name'] ?? '';
    String paramType = param['type'] ?? 'String';
    expression = expression.replaceAll(
      '\${$paramName}',
      '($paramType $paramName)',
    );
  }

  // Apply operator transformations
  for (var operatorEntry in operators.entries) {
    String operatorKey = operatorEntry.key;
    String operatorValue = operatorEntry.value;
    expression = expression.replaceAll(operatorKey, operatorValue);
  }

  return expression;
}
