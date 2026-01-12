import 'dart:io';
import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

void main() {
  group('E2E Package Generation', () {
    late Directory testDir;
    late File yamlFile;

    setUp(() {
      // Create test directory and YAML file
      testDir = Directory('/tmp/ednet_gen_test');
      if (!testDir.existsSync()) {
        testDir.createSync(recursive: true);
      }

      yamlFile = File('/tmp/ednet_gen_test/platform_core_simple.yaml');
      yamlFile.writeAsStringSync('''
domain:
  name: PlatformCore
  description: Platform core domain

model:
  name: CoreModel
  description: Core domain model

concepts:
  - name: User
    description: Platform user
    entry: true
    attributes:
      - name: username
        type: string
        required: true
      - name: email
        type: string
        required: true
      - name: status
        type: string
        default: 'active'
''');
    });

    tearDown(() {
      // Clean up test directory
      if (testDir.existsSync()) {
        testDir.deleteSync(recursive: true);
      }
    });

    test(
      'Generate platform_core package from simplified YAML',
      () async {
        final generator = PackageGenerator();

        final yamlPath = '/tmp/ednet_gen_test/platform_core_simple.yaml';
        final outputPath = '/tmp/ednet_gen_test/generated_platform_core';

        // Clean up if exists
        final outputDir = Directory(outputPath);
        if (await outputDir.exists()) {
          await outputDir.delete(recursive: true);
        }

        print('\n=== Generating package from: $yamlPath ===');
        print('Output directory: $outputPath\n');

        final result = await generator.generatePackage(
          yamlFilePath: yamlPath,
          outputPath: outputPath,
          packageName: 'platform_core',
          description: 'Generated EDNet Platform Core domain package',
          ednetCorePath: '/Users/slavisam/projects/cms/packages/core',
        );

        print('Generation Result:');
        print('  Success: ${result.success}');
        print('  Files generated: ${result.fileCount}\n');

        if (result.hasErrors) {
          print('ERRORS:');
          for (final error in result.errors) {
            print('  - $error');
          }
          if (result.stackTrace != null) {
            print('\nStack trace:');
            print(result.stackTrace);
          }
        } else {
          print('Generated files:');
          for (final file in result.files.take(10)) {
            print('  - $file');
          }
          if (result.files.length > 10) {
            print('  ... and ${result.files.length - 10} more files');
          }
        }

        expect(
          result.success,
          isTrue,
          reason: 'Package generation should succeed',
        );
        expect(result.hasErrors, isFalse, reason: 'Should have no errors');
        expect(
          result.fileCount,
          greaterThan(0),
          reason: 'Should generate files',
        );

        // Verify critical files exist
        expect(await File('$outputPath/pubspec.yaml').exists(), isTrue);
        expect(
          await File('$outputPath/analysis_options.yaml').exists(),
          isTrue,
        );
        expect(await Directory('$outputPath/lib/src/domain').exists(), isTrue);
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });
}
