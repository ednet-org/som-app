/// Validation CLI.
/// Validates output JSON files against the schema and quality gates.
library;

import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';

import 'package:etl/config/data_sources.dart';

void main(List<String> args) async {
  final parser = ArgParser()
    ..addOption('dir', abbr: 'd', defaultsTo: 'out', help: 'Output directory to validate')
    ..addFlag('verbose', abbr: 'v', help: 'Verbose output')
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show help');

  ArgResults results;
  try {
    results = parser.parse(args);
  } catch (e) {
    print('Error: $e');
    print('');
    print('Usage: dart run bin/validate.dart [options] [directory]');
    print('');
    print(parser.usage);
    exit(1);
  }

  if (results['help'] as bool) {
    print('Output Validator');
    print('');
    print('Usage: dart run bin/validate.dart [options] [directory]');
    print('');
    print(parser.usage);
    exit(0);
  }

  var outputDir = results['dir'] as String;
  if (results.rest.isNotEmpty) {
    outputDir = results.rest.first;
  }

  final verbose = results['verbose'] as bool;

  final exitCode = await validate(outputDir: outputDir, verbose: verbose);
  exit(exitCode);
}

Future<int> validate({required String outputDir, required bool verbose}) async {
  print('Validating output in $outputDir');
  print('');

  final dir = Directory(outputDir);
  if (!await dir.exists()) {
    print('ERROR: Directory not found: $outputDir');
    return 1;
  }

  var errors = 0;
  var warnings = 0;

  // Check manifest exists
  final manifestFile = File('$outputDir/manifest.json');
  if (!await manifestFile.exists()) {
    print('ERROR: manifest.json not found');
    errors++;
  } else {
    print('✓ manifest.json exists');

    // Validate manifest structure
    try {
      final manifestJson = jsonDecode(await manifestFile.readAsString());
      if (manifestJson['generated_at'] == null) {
        print('ERROR: manifest missing generated_at');
        errors++;
      }
      if (manifestJson['sources'] == null) {
        print('ERROR: manifest missing sources');
        errors++;
      }
      if (manifestJson['output_file'] == null) {
        print('ERROR: manifest missing output_file');
        errors++;
      }
      if (manifestJson['totals'] == null) {
        print('ERROR: manifest missing totals');
        errors++;
      }
      if (errors == 0) {
        print('✓ manifest.json structure valid');
      }
    } catch (e) {
      print('ERROR: manifest.json invalid JSON: $e');
      errors++;
    }
  }

  // Check report exists
  final reportFile = File('$outputDir/report.md');
  if (!await reportFile.exists()) {
    print('WARNING: report.md not found');
    warnings++;
  } else {
    print('✓ report.md exists');
  }

  // Find and validate businesses.json
  final businessesFile = File('$outputDir/businesses.json');
  if (!await businessesFile.exists()) {
    print('ERROR: businesses.json not found');
    errors++;
  } else {
    print('✓ businesses.json exists');

    final stat = await businessesFile.stat();
    print('  Size: ${(stat.size / (1024 * 1024)).toStringAsFixed(1)} MB');

    var totalEntities = 0;
    var invalidCoords = 0;
    var invalidPostcodes = 0;
    var missingProvenance = 0;
    final uniqueIds = <String>{};
    var duplicateIds = 0;

    // Validate content
    try {
      final content = await businessesFile.readAsString();
      final entities = jsonDecode(content) as List;
      totalEntities = entities.length;

      for (final entity in entities) {
        // Check for duplicate IDs
        final id = entity['id'] as String?;
        if (id != null) {
          if (uniqueIds.contains(id)) {
            duplicateIds++;
            if (verbose) {
              print('    WARNING: Duplicate ID: $id');
            }
          } else {
            uniqueIds.add(id);
          }
        }

        // Check provenance
        if (entity['provenance'] == null || (entity['provenance'] as List).isEmpty) {
          missingProvenance++;
        }

        // Check coordinates
        final geo = entity['geo'];
        if (geo != null) {
          final lat = (geo['lat'] as num).toDouble();
          final lon = (geo['lon'] as num).toDouble();
          if (lat < QualityLimits.minLat || lat > QualityLimits.maxLat ||
              lon < QualityLimits.minLon || lon > QualityLimits.maxLon) {
            invalidCoords++;
            if (verbose) {
              print('    WARNING: Invalid coords in ${entity['id']}: $lat, $lon');
            }
          }
        }

        // Check postcodes
        final addresses = entity['addresses'] as List?;
        if (addresses != null) {
          for (final addr in addresses) {
            final postcode = addr['postcode'] as String?;
            if (postcode != null && !QualityLimits.postcodePattern.hasMatch(postcode)) {
              invalidPostcodes++;
              if (verbose) {
                print('    WARNING: Invalid postcode in ${entity['id']}: $postcode');
              }
            }
          }
        }

        // Check required fields
        if (entity['id'] == null) {
          print('    ERROR: Entity missing id');
          errors++;
        }
        if (entity['name'] == null) {
          print('    ERROR: Entity missing name');
          errors++;
        }
        if (entity['providerType'] == null) {
          print('    ERROR: Entity missing providerType');
          errors++;
        }
      }

      print('  Total entities: $totalEntities');
      print('  Unique IDs: ${uniqueIds.length}');

      if (duplicateIds > 0) {
        print('ERROR: $duplicateIds duplicate IDs found');
        errors++;
      } else {
        print('✓ All IDs are unique');
      }

      if (invalidCoords > 0) {
        print('WARNING: $invalidCoords entities with coordinates outside Austria');
        warnings += invalidCoords;
      }

      if (invalidPostcodes > 0) {
        print('WARNING: $invalidPostcodes addresses with invalid postcodes');
        warnings += invalidPostcodes;
      }

      if (missingProvenance > 0) {
        print('ERROR: $missingProvenance entities missing provenance');
        errors++;
      }
    } catch (e) {
      print('ERROR: businesses.json invalid JSON: $e');
      errors++;
    }
  }

  // Summary
  print('');
  print('=== Validation Summary ===');
  print('Errors: $errors');
  print('Warnings: $warnings');

  if (errors > 0) {
    print('');
    print('VALIDATION FAILED');
    return 1;
  } else if (warnings > 0) {
    print('');
    print('VALIDATION PASSED WITH WARNINGS');
    return 0;
  } else {
    print('');
    print('VALIDATION PASSED');
    return 0;
  }
}
