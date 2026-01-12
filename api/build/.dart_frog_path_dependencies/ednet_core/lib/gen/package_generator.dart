part of ednet_core;

/// Package generation orchestrator for complete Dart package creation from YAML DSL
///
/// This is the main entry point for end-to-end code generation that takes EDNet DSL
/// YAML files and generates complete, working Dart packages with:
/// - Domain models (Entities, Aggregates, Value Objects)
/// - CEP cycle (Commands, Events, Policies)
/// - Repository patterns
/// - Complete test suites
/// - Package manifest (pubspec.yaml)
/// - Analyzer configuration (analysis_options.yaml)
///
/// **Quality Gates**: All generated code must pass 0/0/0 analyzer and tests.
class PackageGenerator {
  final TemplateRenderer _renderer;
  final String? templatesPath;

  /// Create a package generator
  ///
  /// [templatesPath] - Optional path to .mustache template files.
  ///                   If not provided, uses embedded templates.
  PackageGenerator({this.templatesPath})
    : _renderer = TemplateRenderer(
        templatesPath: templatesPath ?? 'lib/gen/templates',
        useFileTemplates: templatesPath != null,
      );

  /// Generate a complete Dart package from YAML DSL
  ///
  /// Takes a YAML file defining a domain model and generates a complete
  /// Dart package with all necessary files, following EDNet Core idiomatic patterns.
  ///
  /// **Process**:
  /// 1. Parse YAML to domain model (using existing YAML parser)
  /// 2. Generate package manifest (pubspec.yaml)
  /// 3. Generate analyzer config (analysis_options.yaml)
  /// 4. Generate domain entities
  /// 5. Generate aggregates (if specified)
  /// 6. Generate CEP cycle (commands, events, policies)
  /// 7. Generate repositories
  /// 8. Generate test suite
  /// 9. Create barrel exports
  ///
  /// **Returns**: [PackageGenerationResult] with success status, file list, and errors
  Future<PackageGenerationResult> generatePackage({
    required String yamlFilePath,
    required String outputPath,
    String? packageName,
    String? description,
    String? ednetCorePath,
  }) async {
    final result = PackageGenerationResult();

    try {
      // Step 1: Parse YAML to domain model
      final file = File(yamlFilePath);
      if (!file.existsSync()) {
        result.addError('YAML file not found: $yamlFilePath');
        return result;
      }

      final yamlContent = await file.readAsString();
      final domainModel = _parseYamlToDomainModel(yamlContent);

      if (domainModel == null) {
        result.addError('Failed to parse YAML file');
        return result;
      }

      // Determine package name from YAML or parameter
      final pkgName =
          packageName ??
          domainModel.domainName?.toLowerCase().replaceAll(' ', '_') ??
          'generated_domain';

      // Step 2: Create output directory structure
      await _createDirectoryStructure(outputPath);

      // Step 3: Generate package manifest (pubspec.yaml)
      await _generatePubspec(
        outputPath: outputPath,
        packageName: pkgName,
        description:
            description ??
            domainModel.description ??
            'Generated EDNet domain package',
        ednetCorePath: ednetCorePath,
        result: result,
      );

      // Step 4: Generate analyzer configuration
      await _generateAnalyzerConfig(outputPath, result);

      // Step 5: Generate domain models
      await _generateDomainModels(
        domainModel: domainModel,
        outputPath: outputPath,
        result: result,
      );

      // Step 6: Generate CEP cycle components
      await _generateCEPCycle(
        domainModel: domainModel,
        outputPath: outputPath,
        result: result,
      );

      // Step 7: Generate repositories
      await _generateRepositories(
        domainModel: domainModel,
        outputPath: outputPath,
        result: result,
      );

      // Step 8: Generate test suite
      await _generateTestSuite(
        domainModel: domainModel,
        outputPath: outputPath,
        packageName: pkgName,
        result: result,
      );

      // Step 9: Generate barrel exports
      await _generateBarrelExports(
        outputPath: outputPath,
        packageName: pkgName,
        result: result,
      );

      result.success = true;
    } catch (e, stackTrace) {
      result.addError('Package generation failed: $e');
      result.stackTrace = stackTrace.toString();
    }

    return result;
  }

  /// Parse YAML content to PackageDomainModel
  PackageDomainModel? _parseYamlToDomainModel(String yamlContent) {
    try {
      // Parse YAML manually since we're working with raw YAML strings
      final yaml = loadYaml(yamlContent) as Map;

      // Extract domain info (can be just a string or a map with name/description)
      String? domainName;
      String? domainDescription;

      final domainValue = yaml['domain'];
      if (domainValue is String) {
        domainName = domainValue;
      } else if (domainValue is Map) {
        domainName = domainValue['name'] as String?;
        domainDescription = domainValue['description'] as String?;
      }

      if (domainName == null) {
        return null;
      }

      // Create Domain object
      final domain = Domain(domainName);

      // Extract model info
      String? modelName;
      String? modelDescription;

      final modelValue = yaml['model'];
      if (modelValue is Map) {
        modelName = modelValue['name'] as String? ?? 'Model';
        modelDescription = modelValue['description'] as String?;
      } else {
        modelName = 'Model';
      }

      // Parse concepts using fromJsonToModel
      final model = fromJsonToModel('', domain, modelName, yaml);

      // Extract concepts
      final concepts = <ConceptData>[];
      for (final concept in model.concepts) {
        concepts.add(ConceptData.fromConcept(concept));
      }

      return PackageDomainModel(
        domainName: domainName,
        modelName: modelName,
        description: modelDescription ?? domainDescription,
        concepts: concepts,
      );
    } catch (e) {
      // YAML parsing error - return null to indicate failure
      return null;
    }
  }

  /// Create directory structure for generated package
  Future<void> _createDirectoryStructure(String outputPath) async {
    final directories = [
      outputPath,
      '$outputPath/lib',
      '$outputPath/lib/src',
      '$outputPath/lib/src/domain',
      '$outputPath/lib/src/commands',
      '$outputPath/lib/src/commands/handlers',
      '$outputPath/lib/src/events',
      '$outputPath/lib/src/events/handlers',
      '$outputPath/lib/src/policies',
      '$outputPath/lib/src/repositories',
      '$outputPath/test',
      '$outputPath/test/domain',
      '$outputPath/test/integration',
    ];

    for (final dir in directories) {
      await Directory(dir).create(recursive: true);
    }
  }

  /// Generate pubspec.yaml
  Future<void> _generatePubspec({
    required String outputPath,
    required String packageName,
    required String description,
    String? ednetCorePath,
    required PackageGenerationResult result,
  }) async {
    final pubspecData = {
      'packageName': packageName,
      'description': description,
      'hasEdnetCorePath': ednetCorePath != null,
      'ednetCorePath': ednetCorePath ?? '../core',
      'usePathDependency': ednetCorePath != null,
    };

    final content = _renderer.render('pubspec', pubspecData);
    final file = File('$outputPath/pubspec.yaml');
    await file.writeAsString(content);

    result.addFile('pubspec.yaml');
  }

  /// Generate analysis_options.yaml with 0/0/0 enforcement
  Future<void> _generateAnalyzerConfig(
    String outputPath,
    PackageGenerationResult result,
  ) async {
    final configData = {
      'enforceStrictMode': true,
      'fatalWarnings': true,
      'fatalInfos': true,
    };

    final content = _renderer.render('analysis_options', configData);
    final file = File('$outputPath/analysis_options.yaml');
    await file.writeAsString(content);

    result.addFile('analysis_options.yaml');
  }

  /// Generate domain models (entities and aggregates)
  Future<void> _generateDomainModels({
    required PackageDomainModel domainModel,
    required String outputPath,
    required PackageGenerationResult result,
  }) async {
    // Generate entities
    for (final concept in domainModel.concepts) {
      final entityData = _conceptToEntityData(concept, domainModel);

      if (concept.isAggregateRoot) {
        // Generate as AggregateRoot
        final content = _renderer.renderAggregateRoot(entityData);
        final fileName = _toSnakeCase(concept.name);
        final file = File('$outputPath/lib/src/domain/$fileName.dart');
        await file.writeAsString(content);
        result.addFile('lib/src/domain/$fileName.dart');
      } else {
        // Generate as Entity
        final content = _renderer.renderEntity(entityData);
        final fileName = _toSnakeCase(concept.name);
        final file = File('$outputPath/lib/src/domain/$fileName.dart');
        await file.writeAsString(content);
        result.addFile('lib/src/domain/$fileName.dart');
      }
    }
  }

  /// Generate CEP cycle components
  Future<void> _generateCEPCycle({
    required PackageDomainModel domainModel,
    required String outputPath,
    required PackageGenerationResult result,
  }) async {
    // For each aggregate root, generate CEP components
    for (final concept in domainModel.concepts.where(
      (c) => c.isAggregateRoot,
    )) {
      await _generateCommandsForAggregate(concept, outputPath, result);
      await _generateEventsForAggregate(concept, outputPath, result);
      await _generatePoliciesForAggregate(concept, outputPath, result);
    }
  }

  /// Generate commands and handlers for an aggregate
  Future<void> _generateCommandsForAggregate(
    ConceptData concept,
    String outputPath,
    PackageGenerationResult result,
  ) async {
    // Generate Create command (basic example)
    final commandData = {
      'commandName': 'Create${concept.name}',
      'entityName': concept.name,
      'hasDependencies': true,
      'dependencies': [
        {'type': '${concept.name}Repository', 'name': 'repository'},
      ],
      'hasValidation': true,
      'validations': concept.attributes
          .where((a) => a.isRequired)
          .map(
            (a) => {
              'isRequired': true,
              'hasCondition': false,
              'field': a.name,
              'errorMessage': '${a.name} is required',
            },
          )
          .toList(),
      'usesRepository': true,
      'repositoryName': 'repository',
      'aggregateVar': _toLowerCamelCase(concept.name),
      'aggregateId': '${_toLowerCamelCase(concept.name)}Id',
      'commandMethod': 'create',
      'commandParams': <Map<String, dynamic>>[],
      'checksResult': false,
      'publishesEvents': false,
      'commandFields': concept.attributes
          .map((a) => {'type': _dartType(a.type), 'name': a.name})
          .toList(),
      'businessLogic': <Map<String, dynamic>>[],
      'hasResultData': false,
      'hasToJson': true,
      'hasFromJson': true,
    };

    final content = _renderer.renderCommandHandler(commandData);
    final fileName = 'create_${_toSnakeCase(concept.name)}_command.dart';
    final file = File('$outputPath/lib/src/commands/$fileName');
    await file.writeAsString(content);
    result.addFile('lib/src/commands/$fileName');
  }

  /// Generate events and handlers for an aggregate
  Future<void> _generateEventsForAggregate(
    ConceptData concept,
    String outputPath,
    PackageGenerationResult result,
  ) async {
    // Generate Created event (basic example)
    final eventData = {
      'eventName': '${concept.name}Created',
      'eventType': '${concept.name}Created',
      'hasDependencies': false,
      'hasLogging': false,
      'updatesReadModel': false,
      'triggersSideEffects': false,
      'triggersCommands': false,
      'updatesProjection': false,
      'customLogic': false,
      'hasErrorHandling': false,
      'hasMetadata': false,
      'eventFields': concept.attributes
          .map((a) => {'type': _dartType(a.type), 'name': a.name})
          .toList(),
      'hasToJson': true,
      'hasFromJson': true,
      'hasEquality': true,
      'hasToString': true,
    };

    final content = _renderer.renderEventHandler(eventData);
    final fileName = '${_toSnakeCase(concept.name)}_created_event.dart';
    final file = File('$outputPath/lib/src/events/$fileName');
    await file.writeAsString(content);
    result.addFile('lib/src/events/$fileName');
  }

  /// Generate policies for an aggregate
  Future<void> _generatePoliciesForAggregate(
    ConceptData concept,
    String outputPath,
    PackageGenerationResult result,
  ) async {
    // Generate validation policy (basic example)
    final policyData = {
      'policyName': '${concept.name}Validation',
      'policyDescription': 'Validates ${concept.name} domain rules',
      'hasDependencies': false,
      'hasScope': true,
      'scopeValue': 'entity',
      'hasTypeCheck': true,
      'entityType': concept.name,
      'hasSimpleEvaluation': false,
      'hasRules': true,
      'hasCompositeRules': false,
      'hasCustomEvaluation': false,
      'hasValidMessage': false,
      'includesPassedRules': false,
      'hasValidateMethod': true,
      'hasCanApplyMethod': true,
      'rules': concept.attributes
          .where((a) => a.isRequired)
          .map(
            (a) => {
              'ruleName': '${a.name}Required',
              'ruleVar': '${_toLowerCamelCase(a.name)}Required',
              'isCustomCondition': true,
              'isAndCondition': false,
              'isOrCondition': false,
              'customCondition': 'typedEntity.${a.name} != null',
              'violationMessage': '${a.name} is required',
              'hasSeverity': false,
              'hasContext': false,
              'hasRuleDescription': false,
            },
          )
          .toList(),
    };

    final content = _renderer.renderPolicy(policyData);
    final fileName = '${_toSnakeCase(concept.name)}_validation_policy.dart';
    final file = File('$outputPath/lib/src/policies/$fileName');
    await file.writeAsString(content);
    result.addFile('lib/src/policies/$fileName');
  }

  /// Generate repositories for aggregates
  Future<void> _generateRepositories({
    required PackageDomainModel domainModel,
    required String outputPath,
    required PackageGenerationResult result,
  }) async {
    for (final concept in domainModel.concepts.where(
      (c) => c.isAggregateRoot,
    )) {
      final repositoryData = {
        'entityName': concept.name,
        'entityType': concept.name,
        'hasInMemoryImplementation': true,
        'hasPersistenceContract': true,
      };

      final content = _renderer.render('repository', repositoryData);
      final fileName = '${_toSnakeCase(concept.name)}_repository.dart';
      final file = File('$outputPath/lib/src/repositories/$fileName');
      await file.writeAsString(content);
      result.addFile('lib/src/repositories/$fileName');
    }
  }

  /// Generate test suite
  Future<void> _generateTestSuite({
    required PackageDomainModel domainModel,
    required String outputPath,
    required String packageName,
    required PackageGenerationResult result,
  }) async {
    // Generate tests for each entity
    for (final concept in domainModel.concepts) {
      final testData = {
        'packageName': packageName,
        'entityName': concept.name,
        'hasAttributes': concept.attributes.isNotEmpty,
        'attributes': concept.attributes
            .map(
              (a) => {
                'name': a.name,
                'type': _dartType(a.type),
                'isRequired': a.isRequired,
                'isUnique': a.isUnique,
                'hasDefault': a.defaultValue != null,
                'defaultValue': a.defaultValue,
                'hasEnumValues':
                    a.enumValues != null && a.enumValues!.isNotEmpty,
                'enumValues': a.enumValues,
              },
            )
            .toList(),
        'isAggregateRoot': concept.isAggregateRoot,
      };

      final content = _renderer.render('test_suite', testData);
      final fileName = '${_toSnakeCase(concept.name)}_test.dart';
      final file = File('$outputPath/test/domain/$fileName');
      await file.writeAsString(content);
      result.addFile('test/domain/$fileName');
    }
  }

  /// Generate barrel exports (main library file)
  Future<void> _generateBarrelExports({
    required String outputPath,
    required String packageName,
    required PackageGenerationResult result,
  }) async {
    // Read all generated files from lib/src/domain
    final domainFiles = <String>[];
    await for (final entity in Directory('$outputPath/lib/src/domain').list()) {
      if (entity is File && entity.path.endsWith('.dart')) {
        final fileName = entity.path.split('/').last;
        domainFiles.add(fileName.replaceAll('.dart', ''));
      }
    }

    final barrelContent = StringBuffer();
    barrelContent.writeln('/// Generated EDNet domain package');
    barrelContent.writeln('library $packageName;');
    barrelContent.writeln('');
    barrelContent.writeln("import 'package:ednet_core/ednet_core.dart';");
    barrelContent.writeln('');
    barrelContent.writeln('// Domain models');
    for (final file in domainFiles) {
      barrelContent.writeln("export 'src/domain/$file.dart';");
    }

    final file = File('$outputPath/lib/$packageName.dart');
    await file.writeAsString(barrelContent.toString());
    result.addFile('lib/$packageName.dart');
  }

  /// Convert concept to entity data for template rendering
  Map<String, dynamic> _conceptToEntityData(
    ConceptData concept,
    PackageDomainModel model,
  ) {
    final uniqueAttrs = concept.attributes.where((a) => a.isUnique).toList();

    return {
      'entityName': concept.name,
      'entityCollectionName': '${concept.name}s', // Pluralized entity name
      'description': concept.description,
      'hasChildren': false, // NOTE: Implement relationship parsing
      'children': <Map<String, dynamic>>[],
      'hasParents': false, // NOTE: Implement relationship parsing
      'parents': <Map<String, dynamic>>[],
      'hasIdAttributes': uniqueAttrs.isNotEmpty,
      'hasSingleIdAttribute': uniqueAttrs.length == 1,
      'hasMultipleIdAttributes': uniqueAttrs.length > 1,
      'idAttributes': uniqueAttrs
          .map((a) => {'code': a.name, 'type': _dartType(a.type)})
          .toList(),
      'idParams': uniqueAttrs
          .asMap()
          .entries
          .map(
            (e) => {
              'type': _dartType(e.value.type),
              'name': e.value.name,
              'isLast': e.key == uniqueAttrs.length - 1,
            },
          )
          .toList(),
      'idParents': <Map<String, dynamic>>[],
      'attributes': concept.attributes
          .map(
            (a) => {
              'name': a.name,
              'code': a.name,
              'type': _dartType(a.type),
              'isRequired': a.isRequired,
              'hasDefault': a.defaultValue != null,
              'defaultValue': a.defaultValue,
              'isUnique': a.isUnique,
              'isId': a.isUnique, // ID attributes are unique attributes
              'hasEnumValues': a.enumValues != null && a.enumValues!.isNotEmpty,
              'enumValues': a.enumValues,
            },
          )
          .toList(),
      // Aggregate root specific fields
      'isEnhanced': false, // Use regular AggregateRoot for now
      'hasCommands': false,
      'commands': <Map<String, dynamic>>[],
      'hasEvents': false,
      'events': <Map<String, dynamic>>[],
      'hasEventApplication': false,
      'eventApplications': <Map<String, dynamic>>[],
    };
  }

  /// Convert EDNet type to Dart type
  String _dartType(String ednetType) {
    switch (ednetType.toLowerCase()) {
      case 'string':
        return 'String';
      case 'int':
        return 'int';
      case 'double':
        return 'double';
      case 'bool':
        return 'bool';
      case 'datetime':
        return 'DateTime';
      default:
        return ednetType; // Custom types pass through
    }
  }

  /// Convert PascalCase to snake_case
  String _toSnakeCase(String input) {
    return input
        .replaceAllMapped(
          RegExp(r'[A-Z]'),
          (m) => '_${m.group(0)!.toLowerCase()}',
        )
        .replaceFirst(RegExp(r'^_'), '');
  }

  /// Convert PascalCase to lowerCamelCase
  String _toLowerCamelCase(String input) {
    if (input.isEmpty) return input;
    return input[0].toLowerCase() + input.substring(1);
  }
}

/// Result of package generation
class PackageGenerationResult {
  bool success = false;
  final List<String> files = [];
  final List<String> errors = [];
  String? stackTrace;

  void addFile(String filePath) => files.add(filePath);
  void addError(String error) => errors.add(error);

  bool get hasErrors => errors.isNotEmpty;
  int get fileCount => files.length;

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('PackageGenerationResult {');
    buffer.writeln('  success: $success');
    buffer.writeln('  files: ${files.length}');
    if (hasErrors) {
      buffer.writeln('  errors: ${errors.length}');
      for (final error in errors) {
        buffer.writeln('    - $error');
      }
    }
    buffer.writeln('}');
    return buffer.toString();
  }
}

/// Package domain model representation for code generation
class PackageDomainModel {
  final String? domainName;
  final String? modelName;
  final String? description;
  final List<ConceptData> concepts;

  PackageDomainModel({
    this.domainName,
    this.modelName,
    this.description,
    required this.concepts,
  });
}

/// Concept data for code generation
class ConceptData {
  final String name;
  final String? description;
  final bool isAggregateRoot;
  final List<AttributeData> attributes;

  ConceptData({
    required this.name,
    this.description,
    this.isAggregateRoot = false,
    required this.attributes,
  });

  factory ConceptData.fromConcept(Concept concept) {
    return ConceptData(
      name: concept.code,
      description: concept.description,
      isAggregateRoot: concept.entry, // Entry concepts are aggregate roots
      attributes: concept.attributes
          .map((a) => AttributeData.fromAttribute(a))
          .toList(),
    );
  }
}

/// Attribute data for code generation
class AttributeData {
  final String name;
  final String type;
  final bool isRequired;
  final bool isUnique;
  final dynamic defaultValue;
  final List<String>? enumValues;

  AttributeData({
    required this.name,
    required this.type,
    this.isRequired = false,
    this.isUnique = false,
    this.defaultValue,
    this.enumValues,
  });

  factory AttributeData.fromAttribute(Property attr) {
    // Get metadata if it's an Attribute
    final metadata = attr is Attribute ? attr.metadata : null;

    return AttributeData(
      name: attr.code,
      type: attr.type?.code ?? 'String',
      isRequired: attr.required,
      isUnique: metadata?['unique'] == true || attr.id != null,
      defaultValue: attr is Attribute ? attr.init : null,
      enumValues: metadata?['enumValues'] as List<String>?,
    );
  }
}
