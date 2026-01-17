/// OSM extraction CLI.
/// Extracts business POIs from OSM GeoJSON files.
library;

import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;

import 'package:etl/extractors/osm_extractor.dart';
import 'package:etl/mappers/osm_to_som_taxonomy.dart';
import 'package:etl/mappers/provider_type_mapper.dart';

final _log = Logger('ExtractOSM');

void main(List<String> args) async {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    final time = record.time.toIso8601String().substring(11, 19);
    print('[$time] ${record.level.name}: ${record.message}');
  });

  final parser = ArgParser()
    ..addOption('input', abbr: 'i', help: 'Input GeoJSON file', mandatory: true)
    ..addOption('output', abbr: 'o', help: 'Output JSON file')
    ..addOption('mappings', abbr: 'm', defaultsTo: 'mappings', help: 'Mappings directory')
    ..addFlag('stats', abbr: 's', help: 'Print statistics only')
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show help');

  ArgResults results;
  try {
    results = parser.parse(args);
  } catch (e) {
    print('Error: $e');
    print('');
    print('Usage: dart run bin/extract_osm.dart [options]');
    print('');
    print(parser.usage);
    exit(1);
  }

  if (results['help'] as bool) {
    print('OSM Business POI Extractor');
    print('');
    print('Usage: dart run bin/extract_osm.dart [options]');
    print('');
    print(parser.usage);
    exit(0);
  }

  final inputPath = results['input'] as String;
  final outputPath = results['output'] as String?;
  final mappingsDir = results['mappings'] as String;
  final statsOnly = results['stats'] as bool;

  if (!await File(inputPath).exists()) {
    print('Error: Input file not found: $inputPath');
    exit(1);
  }

  try {
    await extract(
      inputPath: inputPath,
      outputPath: outputPath,
      mappingsDir: mappingsDir,
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
  required String mappingsDir,
  required bool statsOnly,
}) async {
  _log.info('Loading mappings');

  final taxonomyMapperPath = path.join(mappingsDir, 'osm_to_som_branch.yaml');
  final providerTypeMapperPath = path.join(mappingsDir, 'osm_to_provider_type.yaml');

  OsmToSomTaxonomyMapper taxonomyMapper;
  ProviderTypeMapper providerTypeMapper;

  if (await File(taxonomyMapperPath).exists()) {
    taxonomyMapper = await OsmToSomTaxonomyMapper.fromYamlFile(taxonomyMapperPath);
  } else {
    taxonomyMapper = OsmToSomTaxonomyMapper.fromYamlString('mappings: []');
  }

  if (await File(providerTypeMapperPath).exists()) {
    providerTypeMapper = await ProviderTypeMapper.fromYamlFile(providerTypeMapperPath);
  } else {
    providerTypeMapper = ProviderTypeMapper.simple();
  }

  _log.info('Extracting from $inputPath');

  final extractor = OsmExtractor(
    taxonomyMapper: taxonomyMapper,
    providerTypeMapper: providerTypeMapper,
  );

  final result = await extractor.extractFromFile(inputPath);

  // Print statistics
  _log.info('Extraction complete');
  print('');
  print('=== Statistics ===');
  print('Total features: ${result.totalFeatures}');
  print('Valid features: ${result.validFeatures}');
  print('Skipped (no name): ${result.skippedNoName}');
  print('Skipped (no location): ${result.skippedNoLocation}');
  print('Skipped (outside Austria): ${result.skippedOutsideAustria}');
  print('');
  print('PII Filtering:');
  print('  Phones allowed: ${result.piiReport.allowedPhones}');
  print('  Phones filtered: ${result.piiReport.filteredPhones}');
  print('  Emails allowed: ${result.piiReport.allowedEmails}');
  print('  Emails filtered: ${result.piiReport.filteredEmails}');
  print('  Websites: ${result.piiReport.allowedWebsites}');

  if (!statsOnly && outputPath != null) {
    _log.info('Writing output to $outputPath');

    final encoder = const JsonEncoder.withIndent('  ');
    final json = encoder.convert(result.entities.map((e) => e.toJson()).toList());

    await File(outputPath).writeAsString(json);
    _log.info('Wrote ${result.entities.length} entities');
  }
}
