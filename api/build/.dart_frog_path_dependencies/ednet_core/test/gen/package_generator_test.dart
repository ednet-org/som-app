import 'dart:io';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';
import 'package:ednet_core/ednet_core.dart';

void main() {
  group('PackageGenerator', () {
    late PackageGenerator generator;
    late Directory tempDir;

    setUp(() {
      generator = PackageGenerator();
      tempDir = Directory.systemTemp.createTempSync('package_gen_test_');
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('should create instance', () {
      expect(generator, isNotNull);
      expect(generator, isA<PackageGenerator>());
    });

    test('should use embedded templates by default', () {
      final gen = PackageGenerator();
      expect(gen.templatesPath, isNull);
    });

    test('should accept custom templates path', () {
      final gen = PackageGenerator(templatesPath: '/custom/templates');
      expect(gen.templatesPath, equals('/custom/templates'));
    });

    group('generatePackage', () {
      late File testYamlFile;

      setUp(() {
        // Create a minimal test YAML file with modern EDNet YAML DSL format
        testYamlFile = File('${tempDir.path}/test_domain.yaml');
        testYamlFile.writeAsStringSync('''
domain:
  name: TestDomain
  description: Test domain

model:
  name: TestModel
  description: Test domain model

concepts:
  - name: TestEntity
    description: A test entity
    attributes:
      - name: code
        type: string
      - name: count
        type: int
        required: true
        default: 0
      - name: status
        type: string
        default: 'pending'
''');
      });

      test('should fail when YAML file does not exist', () async {
        final result = await generator.generatePackage(
          yamlFilePath: '${tempDir.path}/nonexistent.yaml',
          outputPath: '${tempDir.path}/output',
        );

        expect(result.success, isFalse);
        expect(result.hasErrors, isTrue);
        expect(result.errors.first, contains('YAML file not found'));
      });

      test('should generate package structure', () async {
        final outputPath = '${tempDir.path}/generated_package';

        final result = await generator.generatePackage(
          yamlFilePath: testYamlFile.path,
          outputPath: outputPath,
        );

        expect(result.success, isTrue);
        expect(result.hasErrors, isFalse);

        // Verify directory structure
        expect(await Directory(outputPath).exists(), isTrue);
        expect(await Directory('$outputPath/lib').exists(), isTrue);
        expect(await Directory('$outputPath/lib/src').exists(), isTrue);
        expect(await Directory('$outputPath/lib/src/domain').exists(), isTrue);
        expect(
          await Directory('$outputPath/lib/src/commands').exists(),
          isTrue,
        );
        expect(await Directory('$outputPath/lib/src/events').exists(), isTrue);
        expect(
          await Directory('$outputPath/lib/src/policies').exists(),
          isTrue,
        );
        expect(
          await Directory('$outputPath/lib/src/repositories').exists(),
          isTrue,
        );
        expect(await Directory('$outputPath/test').exists(), isTrue);
        expect(await Directory('$outputPath/test/domain').exists(), isTrue);
      });

      test('should generate pubspec.yaml', () async {
        final outputPath = '${tempDir.path}/generated_package';

        final result = await generator.generatePackage(
          yamlFilePath: testYamlFile.path,
          outputPath: outputPath,
          packageName: 'test_package',
          description: 'Test package description',
        );

        expect(result.success, isTrue);
        expect(result.files, contains('pubspec.yaml'));

        final pubspecFile = File('$outputPath/pubspec.yaml');
        expect(await pubspecFile.exists(), isTrue);

        final content = await pubspecFile.readAsString();
        expect(content, contains('name: test_package'));
        expect(content, contains('description: Test package description'));
        expect(content, contains('ednet_core'));
        expect(content, contains('test:'));
        expect(content, contains('lints:'));
      });

      test('should generate pubspec with path dependency', () async {
        final outputPath = '${tempDir.path}/generated_package';

        final result = await generator.generatePackage(
          yamlFilePath: testYamlFile.path,
          outputPath: outputPath,
          ednetCorePath: '../../core',
        );

        expect(result.success, isTrue);

        final pubspecFile = File('$outputPath/pubspec.yaml');
        final content = await pubspecFile.readAsString();
        expect(content, contains('path: ../../core'));
      });

      test('should generate analysis_options.yaml', () async {
        final outputPath = '${tempDir.path}/generated_package';

        final result = await generator.generatePackage(
          yamlFilePath: testYamlFile.path,
          outputPath: outputPath,
        );

        expect(result.success, isTrue);
        expect(result.files, contains('analysis_options.yaml'));

        final analysisFile = File('$outputPath/analysis_options.yaml');
        expect(await analysisFile.exists(), isTrue);

        final content = await analysisFile.readAsString();
        expect(content, contains('0/0/0 quality gates'));
        expect(content, contains('include: package:lints/recommended.yaml'));
        expect(content, contains('strong-mode'));
      });

      test('should generate domain entities', () async {
        final outputPath = '${tempDir.path}/generated_package';

        final result = await generator.generatePackage(
          yamlFilePath: testYamlFile.path,
          outputPath: outputPath,
        );

        expect(result.success, isTrue);
        expect(result.files.any((f) => f.contains('lib/src/domain/')), isTrue);

        // Check that entity file was created
        final entityFiles = await Directory(
          '$outputPath/lib/src/domain',
        ).list().where((e) => e is File && e.path.endsWith('.dart')).toList();

        expect(entityFiles, isNotEmpty);
      });

      test('should generate test files', () async {
        final outputPath = '${tempDir.path}/generated_package';

        final result = await generator.generatePackage(
          yamlFilePath: testYamlFile.path,
          outputPath: outputPath,
        );

        expect(result.success, isTrue);
        expect(result.files.any((f) => f.contains('test/domain/')), isTrue);

        // Check that test files were created
        final testFiles = await Directory('$outputPath/test/domain')
            .list()
            .where((e) => e is File && e.path.endsWith('_test.dart'))
            .toList();

        expect(testFiles, isNotEmpty);
      });

      test('should generate barrel exports', () async {
        final outputPath = '${tempDir.path}/generated_package';

        final result = await generator.generatePackage(
          yamlFilePath: testYamlFile.path,
          outputPath: outputPath,
          packageName: 'test_package',
        );

        expect(result.success, isTrue);
        expect(result.files, contains('lib/test_package.dart'));

        final barrelFile = File('$outputPath/lib/test_package.dart');
        expect(await barrelFile.exists(), isTrue);

        final content = await barrelFile.readAsString();
        expect(content, contains('library test_package'));
        expect(
          content,
          contains("import 'package:ednet_core/ednet_core.dart'"),
        );
        expect(content, contains("export 'src/domain/"));
      });

      test('should include all generated files in result', () async {
        final outputPath = '${tempDir.path}/generated_package';

        final result = await generator.generatePackage(
          yamlFilePath: testYamlFile.path,
          outputPath: outputPath,
        );

        expect(result.success, isTrue);
        expect(result.fileCount, greaterThan(0));
        expect(result.files, isNotEmpty);
        expect(result.files, contains('pubspec.yaml'));
        expect(result.files, contains('analysis_options.yaml'));
      });

      test(
        'should use domain name from YAML when package name not provided',
        () async {
          final outputPath = '${tempDir.path}/generated_package';

          final result = await generator.generatePackage(
            yamlFilePath: testYamlFile.path,
            outputPath: outputPath,
          );

          expect(result.success, isTrue);

          final pubspecFile = File('$outputPath/pubspec.yaml');
          final content = await pubspecFile.readAsString();
          expect(content, contains('name: testdomain'));
        },
      );

      test('should handle generation errors gracefully', () async {
        // Create an invalid YAML file
        final invalidYaml = File('${tempDir.path}/invalid.yaml');
        invalidYaml.writeAsStringSync('invalid: yaml: content:');

        final result = await generator.generatePackage(
          yamlFilePath: invalidYaml.path,
          outputPath: '${tempDir.path}/output',
        );

        expect(result.success, isFalse);
        expect(result.hasErrors, isTrue);
      });
    });

    group('PackageDomainModel', () {
      test('should parse YAML content', () {
        // Create a minimal domain for testing
        final yamlContent = '''
domain:
  name: TestDomain

model:
  name: TestModel
  description: Test model

concepts:
  - name: TestConcept
    attributes:
      - name: name
        type: string
''';

        final domain = Domain('TestDomain');
        final yaml = loadYaml(yamlContent) as Map;
        final model = fromJsonToModel('', domain, 'TestModel', yaml);

        expect(domain.code, equals('TestDomain'));
        expect(model.concepts, isNotEmpty);
      });

      test('should extract concepts from YAML', () {
        final domain = Domain('TestDomain');
        final yaml =
            loadYaml('''
concepts:
  - name: Concept1
    attributes:
      - name: field1
        type: string

  - name: Concept2
    attributes:
      - name: field2
        type: int
''')
                as Map;

        final model = fromJsonToModel('', domain, 'TestModel', yaml);

        expect(model.concepts.length, equals(2));
        expect(model.concepts[0].code, equals('Concept1'));
        expect(model.concepts[1].code, equals('Concept2'));
      });
    });

    group('ConceptData', () {
      test('should create from Concept', () {
        final domain = Domain('TestDomain');
        final yaml =
            loadYaml('''
concepts:
  - name: TestConcept
    entry: true
    attributes:
      - name: name
        type: string
        required: true
''')
                as Map;

        final model = fromJsonToModel('', domain, 'TestModel', yaml);
        final concept = model.concepts.first;
        final conceptData = ConceptData.fromConcept(concept);

        expect(conceptData.name, equals('TestConcept'));
        expect(conceptData.isAggregateRoot, isTrue); // entry = aggregate root
        expect(conceptData.attributes, isNotEmpty);
      });

      test('should identify aggregate roots', () {
        final domain = Domain('TestDomain');
        final yaml =
            loadYaml('''
concepts:
  - name: AggregateRoot
    entry: true
    attributes:
      - name: id
        type: string

  - name: RegularEntity
    attributes:
      - name: name
        type: string
''')
                as Map;

        final model = fromJsonToModel('', domain, 'TestModel', yaml);

        expect(model.concepts[0].entry, isTrue); // entry = aggregate root
        expect(model.concepts[1].entry, isFalse);
      });
    });

    group('AttributeData', () {
      test('should create from Property', () {
        final domain = Domain('TestDomain');
        final yaml =
            loadYaml('''
concepts:
  - name: TestConcept
    attributes:
      - name: name
        type: string
        required: true
        default: 'default'
''')
                as Map;

        final model = fromJsonToModel('', domain, 'TestModel', yaml);
        final attr = model.concepts.first.attributes.first;
        final attrData = AttributeData.fromAttribute(attr);

        expect(attrData.name, equals('name'));
        expect(attrData.type, equals('String'));
        expect(attrData.isRequired, isTrue);
        expect(attrData.defaultValue, equals("default"));
      });

      test('should handle enum values', () {
        final domain = Domain('TestDomain');
        final yaml =
            loadYaml('''
concepts:
  - name: TestConcept
    attributes:
      - name: status
        type: string
        enumValues: [pending, active, completed]
''')
                as Map;

        final model = fromJsonToModel('', domain, 'TestModel', yaml);
        final attr = model.concepts.first.attributes.first;
        final attrData = AttributeData.fromAttribute(attr);

        expect(attrData.enumValues, isNotNull);
        expect(attrData.enumValues, contains('pending'));
        expect(attrData.enumValues, contains('active'));
        expect(attrData.enumValues, contains('completed'));
      });

      test('should handle unique constraint', () {
        final domain = Domain('TestDomain');
        final yaml =
            loadYaml('''
concepts:
  - name: TestConcept
    attributes:
      - name: email
        type: string
        unique: true
''')
                as Map;

        final model = fromJsonToModel('', domain, 'TestModel', yaml);
        final attr = model.concepts.first.attributes.first;
        final attrData = AttributeData.fromAttribute(attr);

        expect(attrData.isUnique, isTrue);
      });
    });

    group('PackageGenerationResult', () {
      test('should track success status', () {
        final result = PackageGenerationResult();
        expect(result.success, isFalse);

        result.success = true;
        expect(result.success, isTrue);
      });

      test('should track generated files', () {
        final result = PackageGenerationResult();
        expect(result.files, isEmpty);
        expect(result.fileCount, equals(0));

        result.addFile('file1.dart');
        result.addFile('file2.dart');

        expect(result.fileCount, equals(2));
        expect(result.files, contains('file1.dart'));
        expect(result.files, contains('file2.dart'));
      });

      test('should track errors', () {
        final result = PackageGenerationResult();
        expect(result.errors, isEmpty);
        expect(result.hasErrors, isFalse);

        result.addError('Error 1');
        result.addError('Error 2');

        expect(result.hasErrors, isTrue);
        expect(result.errors.length, equals(2));
        expect(result.errors, contains('Error 1'));
      });

      test('should provide string representation', () {
        final result = PackageGenerationResult();
        result.success = true;
        result.addFile('file1.dart');
        result.addFile('file2.dart');

        final str = result.toString();
        expect(str, contains('success: true'));
        expect(str, contains('files: 2'));
      });

      test('should include errors in string representation', () {
        final result = PackageGenerationResult();
        result.addError('Test error');

        final str = result.toString();
        expect(str, contains('errors: 1'));
        expect(str, contains('Test error'));
      });
    });
  });
}
