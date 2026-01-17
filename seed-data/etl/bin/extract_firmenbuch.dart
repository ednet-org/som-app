/// Firmenbuch extraction CLI.
/// Extracts company data from Firmenbuch HVD files.
library;

import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:logging/logging.dart';

import 'package:etl/extractors/firmenbuch_extractor.dart';

final _log = Logger('ExtractFirmenbuch');

void main(List<String> args) async {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    final time = record.time.toIso8601String().substring(11, 19);
    print('[$time] ${record.level.name}: ${record.message}');
  });

  final parser = ArgParser()
    ..addOption('input', abbr: 'i', help: 'Input file (JSON or XML)', mandatory: true)
    ..addOption('format', abbr: 'f', allowed: ['json', 'xml'], help: 'Input format (auto-detected if not specified)')
    ..addOption('output', abbr: 'o', help: 'Output JSON file')
    ..addFlag('stats', abbr: 's', help: 'Print statistics only')
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show help');

  ArgResults results;
  try {
    results = parser.parse(args);
  } catch (e) {
    print('Error: $e');
    print('');
    print('Usage: dart run bin/extract_firmenbuch.dart [options]');
    print('');
    print(parser.usage);
    exit(1);
  }

  if (results['help'] as bool) {
    print('Firmenbuch HVD Extractor');
    print('');
    print('Usage: dart run bin/extract_firmenbuch.dart [options]');
    print('');
    print(parser.usage);
    exit(0);
  }

  final inputPath = results['input'] as String;
  final outputPath = results['output'] as String?;
  var format = results['format'] as String?;
  final statsOnly = results['stats'] as bool;

  if (!await File(inputPath).exists()) {
    print('Error: Input file not found: $inputPath');
    exit(1);
  }

  // Auto-detect format if not specified
  if (format == null) {
    if (inputPath.endsWith('.json')) {
      format = 'json';
    } else if (inputPath.endsWith('.xml')) {
      format = 'xml';
    } else {
      print('Error: Cannot auto-detect format. Please specify --format');
      exit(1);
    }
  }

  try {
    await extract(
      inputPath: inputPath,
      outputPath: outputPath,
      format: format,
      statsOnly: statsOnly,
    );
  } catch (e, stack) {
    _log.severe('Extraction failed: $e');
    _log.fine('Stack trace: $stack');
    exit(1);
  }
}

Future<void> extract({
  required String inputPath,
  String? outputPath,
  required String format,
  required bool statsOnly,
}) async {
  _log.info('Extracting from $inputPath (format: $format)');

  final extractor = FirmenbuchExtractor();
  FirmenbuchExtractionResult result;

  if (format == 'json') {
    result = await extractor.extractFromJsonFile(inputPath);
  } else {
    result = await extractor.extractFromXmlFile(inputPath);
  }

  // Print statistics
  _log.info('Extraction complete');
  print('');
  print('=== Statistics ===');
  print('Total records: ${result.totalRecords}');
  print('Valid records: ${result.validRecords}');
  print('Skipped (no name): ${result.skippedNoName}');
  print('Skipped (no address): ${result.skippedNoAddress}');

  // Count by legal form
  final legalForms = <String, int>{};
  for (final entity in result.entities) {
    final form = entity.legalForm ?? 'Unknown';
    legalForms[form] = (legalForms[form] ?? 0) + 1;
  }

  if (legalForms.isNotEmpty) {
    print('');
    print('By Legal Form:');
    final sorted = legalForms.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    for (final entry in sorted.take(10)) {
      print('  ${entry.key}: ${entry.value}');
    }
  }

  if (!statsOnly && outputPath != null) {
    _log.info('Writing output to $outputPath');

    final encoder = const JsonEncoder.withIndent('  ');
    final data = result.entities.map((e) {
      final map = <String, dynamic>{
        'firmenbuchNr': e.firmenbuchNr,
        'name': e.name,
      };
      if (e.legalForm != null) map['legalForm'] = e.legalForm;
      if (e.uidNr != null) map['uidNr'] = e.uidNr;
      if (e.address != null) map['address'] = e.address!.toJson();
      if (e.active != null) map['active'] = e.active;
      return map;
    }).toList();

    await File(outputPath).writeAsString(encoder.convert(data));
    _log.info('Wrote ${result.entities.length} entities');
  }
}
