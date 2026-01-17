/// Main ETL pipeline orchestrator.
/// Runs the complete extraction, transformation, and loading process.
library;

import 'dart:io';

import 'package:args/args.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;

import 'package:etl/config/data_sources.dart';
import 'package:etl/extractors/firmenbuch_extractor.dart';
import 'package:etl/extractors/osm_extractor.dart';
import 'package:etl/extractors/wko_extractor.dart';
import 'package:etl/loaders/json_shard_writer.dart';
import 'package:etl/loaders/manifest_generator.dart';
import 'package:etl/loaders/report_generator.dart';
import 'package:etl/mappers/osm_to_som_taxonomy.dart';
import 'package:etl/mappers/provider_type_mapper.dart';
import 'package:etl/models/business_entity.dart';
import 'package:etl/transformers/address_parser.dart';
import 'package:etl/transformers/pii_filter.dart';

final _log = Logger('ETLPipeline');

void main(List<String> args) async {
  // Setup logging
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    final time = record.time.toIso8601String().substring(11, 19);
    print('[$time] ${record.level.name}: ${record.message}');
  });

  // Parse arguments
  final parser = ArgParser()
    ..addOption('osm-geojson', abbr: 'o', help: 'Path to OSM GeoJSON file')
    ..addOption('firmenbuch-json', abbr: 'f', help: 'Path to Firmenbuch JSON file')
    ..addOption('firmenbuch-xml', help: 'Path to Firmenbuch XML file')
    ..addOption('wko-json', abbr: 'w', help: 'Path to WKO scraper output JSON file')
    ..addOption('output', abbr: 'd', defaultsTo: 'out', help: 'Output directory')
    ..addOption('mappings', abbr: 'm', defaultsTo: 'mappings', help: 'Mappings directory')
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show help');

  final results = parser.parse(args);

  if (results['help'] as bool) {
    print('Austrian B2B Business Seed Database ETL Pipeline');
    print('');
    print('Usage: dart run bin/run_pipeline.dart [options]');
    print('');
    print(parser.usage);
    exit(0);
  }

  final osmPath = results['osm-geojson'] as String?;
  final firmenbuchJsonPath = results['firmenbuch-json'] as String?;
  final firmenbuchXmlPath = results['firmenbuch-xml'] as String?;
  final wkoJsonPath = results['wko-json'] as String?;
  final outputDir = results['output'] as String;
  final mappingsDir = results['mappings'] as String;

  if (osmPath == null &&
      firmenbuchJsonPath == null &&
      firmenbuchXmlPath == null &&
      wkoJsonPath == null) {
    print('Error: At least one data source must be specified.');
    print('Use --help for usage information.');
    exit(1);
  }

  try {
    await runPipeline(
      osmGeoJsonPath: osmPath,
      firmenbuchJsonPath: firmenbuchJsonPath,
      firmenbuchXmlPath: firmenbuchXmlPath,
      wkoJsonPath: wkoJsonPath,
      outputDir: outputDir,
      mappingsDir: mappingsDir,
    );
  } catch (e, stack) {
    _log.severe('Pipeline failed: $e');
    _log.fine('Stack trace: $stack');
    exit(1);
  }
}

/// Run the complete ETL pipeline.
Future<void> runPipeline({
  String? osmGeoJsonPath,
  String? firmenbuchJsonPath,
  String? firmenbuchXmlPath,
  String? wkoJsonPath,
  required String outputDir,
  required String mappingsDir,
}) async {
  _log.info('Starting ETL pipeline');

  // Load mappings
  _log.info('Loading taxonomy mappings');
  final taxonomyMapperPath = path.join(mappingsDir, 'osm_to_som_branch.yaml');
  final providerTypeMapperPath = path.join(mappingsDir, 'osm_to_provider_type.yaml');

  OsmToSomTaxonomyMapper taxonomyMapper;
  ProviderTypeMapper providerTypeMapper;

  if (await File(taxonomyMapperPath).exists()) {
    taxonomyMapper = await OsmToSomTaxonomyMapper.fromYamlFile(taxonomyMapperPath);
    _log.info('Loaded taxonomy mappings from $taxonomyMapperPath');
  } else {
    _log.warning('Taxonomy mappings not found, using empty mapper');
    taxonomyMapper = OsmToSomTaxonomyMapper.fromYamlString('mappings: []');
  }

  if (await File(providerTypeMapperPath).exists()) {
    providerTypeMapper = await ProviderTypeMapper.fromYamlFile(providerTypeMapperPath);
    _log.info('Loaded provider type mappings from $providerTypeMapperPath');
  } else {
    _log.info('Using default provider type mapper');
    providerTypeMapper = ProviderTypeMapper.simple();
  }

  // Load WKO NACE mapper if available
  WkoToNaceMapper? wkoNaceMapper;
  final wkoNaceMapperPath = path.join(mappingsDir, 'nace_46_to_som.yaml');
  if (await File(wkoNaceMapperPath).exists()) {
    wkoNaceMapper = await WkoToNaceMapper.fromYamlFile(wkoNaceMapperPath);
    _log.info('Loaded WKO NACE mappings from $wkoNaceMapperPath');
  }

  final allEntities = <BusinessEntity>[];
  final sources = <SourceInfo>[];
  var totalPiiReport = const PiiAuditReport(
    allowedPhones: 0,
    filteredPhones: 0,
    allowedEmails: 0,
    filteredEmails: 0,
    allowedWebsites: 0,
    filteredReasons: {},
  );

  // Extract OSM data
  if (osmGeoJsonPath != null) {
    _log.info('Extracting OSM data from $osmGeoJsonPath');
    final osmExtractor = OsmExtractor(
      taxonomyMapper: taxonomyMapper,
      providerTypeMapper: providerTypeMapper,
    );

    final osmResult = await osmExtractor.extractFromFile(osmGeoJsonPath);
    _log.info('OSM extraction complete: ${osmResult.validFeatures}/${osmResult.totalFeatures} features');
    _log.info('  Skipped no name: ${osmResult.skippedNoName}');
    _log.info('  Skipped no location: ${osmResult.skippedNoLocation}');
    _log.info('  Skipped outside Austria: ${osmResult.skippedOutsideAustria}');

    allEntities.addAll(osmResult.entities);
    totalPiiReport = totalPiiReport.merge(osmResult.piiReport);

    sources.add(SourceInfo(
      id: OsmDataSource.id,
      name: OsmDataSource.name,
      url: OsmDataSource.url,
      license: OsmDataSource.license,
      licenseUrl: OsmDataSource.licenseUrl,
      fetchedAt: DateTime.now().toUtc().toIso8601String(),
      recordCount: osmResult.validFeatures,
    ));
  }

  // Extract Firmenbuch data
  List<FirmenbuchEntity> firmenbuchEntities = [];
  if (firmenbuchJsonPath != null || firmenbuchXmlPath != null) {
    final firmenbuchExtractor = FirmenbuchExtractor();

    if (firmenbuchJsonPath != null) {
      _log.info('Extracting Firmenbuch data from $firmenbuchJsonPath');
      final result = await firmenbuchExtractor.extractFromJsonFile(firmenbuchJsonPath);
      firmenbuchEntities.addAll(result.entities);
      _log.info('Firmenbuch JSON extraction: ${result.validRecords}/${result.totalRecords} records');
    }

    if (firmenbuchXmlPath != null) {
      _log.info('Extracting Firmenbuch data from $firmenbuchXmlPath');
      final result = await firmenbuchExtractor.extractFromXmlFile(firmenbuchXmlPath);
      firmenbuchEntities.addAll(result.entities);
      _log.info('Firmenbuch XML extraction: ${result.validRecords}/${result.totalRecords} records');
    }

    if (firmenbuchEntities.isNotEmpty) {
      sources.add(SourceInfo(
        id: FirmenbuchDataSource.id,
        name: FirmenbuchDataSource.name,
        url: FirmenbuchDataSource.url,
        license: FirmenbuchDataSource.license,
        licenseUrl: FirmenbuchDataSource.licenseUrl,
        fetchedAt: DateTime.now().toUtc().toIso8601String(),
        recordCount: firmenbuchEntities.length,
      ));
    }
  }

  // Extract WKO data
  if (wkoJsonPath != null) {
    _log.info('Extracting WKO data from $wkoJsonPath');
    final wkoExtractor = WkoExtractor(naceMapper: wkoNaceMapper);
    final wkoResult = await wkoExtractor.extractFromFile(wkoJsonPath);

    _log.info(
      'WKO extraction complete: ${wkoResult.validEntities}/${wkoResult.totalScraped} entities',
    );
    _log.info('  Skipped no name: ${wkoResult.skippedNoName}');
    _log.info('  Skipped no address: ${wkoResult.skippedNoAddress}');

    // Log by NACE code
    _log.info('  By NACE code:');
    final sortedNace = wkoResult.byNaceCode.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    for (final entry in sortedNace.take(5)) {
      _log.info('    ${entry.key}: ${entry.value}');
    }

    allEntities.addAll(wkoResult.entities);
    totalPiiReport = totalPiiReport.merge(wkoResult.piiReport);

    sources.add(SourceInfo(
      id: WkoDataSource.id,
      name: WkoDataSource.name,
      url: WkoDataSource.url,
      license: WkoDataSource.license,
      licenseUrl: WkoDataSource.licenseUrl,
      fetchedAt: DateTime.now().toUtc().toIso8601String(),
      recordCount: wkoResult.validEntities,
    ));
  }

  // Enrich OSM entities with Firmenbuch data
  if (firmenbuchEntities.isNotEmpty && allEntities.isNotEmpty) {
    _log.info('Enriching OSM entities with Firmenbuch data');
    allEntities.replaceRange(
      0,
      allEntities.length,
      _enrichWithFirmenbuch(allEntities, firmenbuchEntities),
    );
    _log.info('Enrichment complete');
  }

  // Deduplication
  _log.info('Deduplicating ${allEntities.length} entities');
  final beforeCount = allEntities.length;
  final deduped = _deduplicate(allEntities);
  final afterCount = deduped.length;
  _log.info('Deduplication complete: $beforeCount -> $afterCount entities');

  // Calculate statistics
  final entitiesByBundesland = <String, int>{};
  final entitiesByProviderType = <String, int>{};
  final entitiesByCategory = <String, int>{};

  for (final entity in deduped) {
    // By Bundesland
    for (final addr in entity.addresses) {
      if (addr.bundesland != null) {
        final bl = addr.bundesland!.toJson();
        entitiesByBundesland[bl] = (entitiesByBundesland[bl] ?? 0) + 1;
        break;
      }
    }

    // By provider type
    final pt = entity.providerType.toJson();
    entitiesByProviderType[pt] = (entitiesByProviderType[pt] ?? 0) + 1;

    // By category
    if (entity.taxonomy.categoryName != null) {
      final cat = entity.taxonomy.categoryName!;
      entitiesByCategory[cat] = (entitiesByCategory[cat] ?? 0) + 1;
    }
  }

  // Write output file
  _log.info('Writing output to $outputDir');
  final fileWriter = JsonFileWriter(outputDir: outputDir);
  final outputFile = await fileWriter.write(deduped);
  _log.info('Wrote ${outputFile.recordCount} entities to ${outputFile.filename}');
  _log.info('File size: ${(outputFile.sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB');

  // Generate manifest
  _log.info('Generating manifest');
  final manifestGenerator = ManifestGenerator(outputDir: outputDir);
  final manifest = await manifestGenerator.generate(
    sources: sources,
    outputFile: outputFile,
    stats: ManifestStats(
      totalEntities: deduped.length,
      dedupeMerges: beforeCount - afterCount,
      entitiesByBundesland: entitiesByBundesland,
      entitiesByProviderType: entitiesByProviderType,
      entitiesByCategory: entitiesByCategory,
    ),
  );

  // Generate report
  _log.info('Generating report');
  final reportGenerator = ReportGenerator(outputDir: outputDir);
  await reportGenerator.generate(
    manifest: manifest,
    dedupeStats: DedupeStats(
      beforeCount: beforeCount,
      afterCount: afterCount,
      mergedCount: beforeCount - afterCount,
    ),
    piiReport: totalPiiReport,
    categoryDistribution: entitiesByCategory,
  );

  _log.info('Pipeline complete');
  _log.info('Output: $outputDir/${outputFile.filename}');
  _log.info('Total entities: ${deduped.length}');
}

/// Enrich business entities with Firmenbuch data.
List<BusinessEntity> _enrichWithFirmenbuch(
  List<BusinessEntity> entities,
  List<FirmenbuchEntity> firmenbuch,
) {
  // Build index by normalized address
  final firmenbuchByAddress = <String, List<FirmenbuchEntity>>{};
  for (final fb in firmenbuch) {
    if (fb.address != null) {
      final key = AddressParser.normalizeForComparison(fb.address!);
      firmenbuchByAddress.putIfAbsent(key, () => []).add(fb);
    }
  }

  return entities.map((entity) {
    // Try to match by address
    for (final addr in entity.addresses) {
      final key = AddressParser.normalizeForComparison(addr);
      final candidates = firmenbuchByAddress[key];

      if (candidates != null) {
        // Find best name match
        final entityNameNorm = _normalizeName(entity.name);
        for (final fb in candidates) {
          final similarity = _nameSimilarity(entityNameNorm, fb.normalizedName);
          if (similarity >= QualityLimits.minTokenOverlap) {
            // Match found - enrich
            return BusinessEntity(
              id: entity.id,
              name: entity.name,
              legalForm: entity.legalForm ?? fb.legalForm,
              providerType: entity.providerType,
              companySize: entity.companySize,
              addresses: entity.addresses,
              geo: entity.geo,
              contacts: entity.contacts,
              externalIds: entity.externalIds.merge(ExternalIds(
                firmenbuchNr: fb.firmenbuchNr,
                uidNr: fb.uidNr,
              )),
              classification: entity.classification,
              taxonomy: entity.taxonomy,
              active: entity.active ?? fb.active,
              provenance: [
                ...entity.provenance,
                Provenance(
                  sourceId: FirmenbuchDataSource.id,
                  sourceName: FirmenbuchDataSource.name,
                  sourceUrl: FirmenbuchDataSource.url,
                  fetchedAt: DateTime.now().toUtc().toIso8601String(),
                  license: FirmenbuchDataSource.license,
                  licenseUrl: FirmenbuchDataSource.licenseUrl,
                  fields: ['firmenbuchNr', 'uidNr', 'legalForm', 'active'],
                ),
              ],
              confidence: entity.confidence,
            );
          }
        }
      }
    }

    return entity;
  }).toList();
}

String _normalizeName(String name) {
  var normalized = name.toLowerCase().trim();
  normalized = normalized
      .replaceAll(RegExp(r'\s+(gmbh|kg|og|ag|e\.u\.|keg|gesnbr|ges\.?m\.?b\.?h\.?)\.?\s*$'), '')
      .replaceAll(RegExp(r'\s+&\s+co\.?\s*'), ' ')
      .replaceAll(RegExp(r'[^\w\s]'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  return normalized;
}

double _nameSimilarity(String a, String b) {
  final tokensA = a.split(' ').where((t) => t.length > 2).toSet();
  final tokensB = b.split(' ').where((t) => t.length > 2).toSet();

  if (tokensA.isEmpty || tokensB.isEmpty) return 0.0;

  final intersection = tokensA.intersection(tokensB);
  final union = tokensA.union(tokensB);

  return intersection.length / union.length;
}

/// Deduplicate entities by ID.
List<BusinessEntity> _deduplicate(List<BusinessEntity> entities) {
  final byId = <String, BusinessEntity>{};

  for (final entity in entities) {
    final existing = byId[entity.id];
    if (existing != null) {
      byId[entity.id] = existing.merge(entity);
    } else {
      byId[entity.id] = entity;
    }
  }

  return byId.values.toList();
}
