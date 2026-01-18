/// Main orchestrator for database seeding operations.
library;

import 'dart:convert';
import 'dart:io';

import '../models/business_entity.dart';
import 'company_loader.dart';
import 'provider_loader.dart';
import 'seed_config.dart';
import 'supabase_client.dart';
import 'taxonomy_loader.dart';

/// Orchestrates the complete database seeding process.
class DatabaseSeeder {
  DatabaseSeeder._({
    required SeedSupabaseClient client,
    required SeedConfig config,
    required CompanyLoader companyLoader,
    required TaxonomyLoader taxonomyLoader,
    required ProviderLoader providerLoader,
  })  : _client = client,
        _config = config,
        _companyLoader = companyLoader,
        _taxonomyLoader = taxonomyLoader,
        _providerLoader = providerLoader;

  /// Create and initialize a database seeder.
  static Future<DatabaseSeeder> create(SeedConfig config) async {
    final client = await SeedSupabaseClient.initialize(config);
    return DatabaseSeeder._(
      client: client,
      config: config,
      companyLoader: CompanyLoader(client: client, config: config),
      taxonomyLoader: TaxonomyLoader(client: client, config: config),
      providerLoader: ProviderLoader(client: client, config: config),
    );
  }

  final SeedSupabaseClient _client;
  final SeedConfig _config;
  final CompanyLoader _companyLoader;
  final TaxonomyLoader _taxonomyLoader;
  final ProviderLoader _providerLoader;

  /// Run the complete seeding process.
  ///
  /// [inputPath] - Path to the businesses.json file.
  /// [onProgress] - Callback for progress updates.
  Future<SeedResult> seed({
    required String inputPath,
    void Function(String stage, int current, int total, String message)?
        onProgress,
  }) async {
    final stopwatch = Stopwatch()..start();

    onProgress?.call('load', 0, 0, 'Loading entities from $inputPath...');

    // Load entities from JSON
    final entities = await _loadEntities(inputPath, onProgress);
    final loadTime = stopwatch.elapsedMilliseconds;
    stopwatch.reset();

    onProgress?.call('companies', 0, entities.length, 'Seeding companies...');

    // Seed companies
    final companyResult = await _companyLoader.load(
      entities: entities,
      onProgress: (processed, total, message) {
        onProgress?.call('companies', processed, total, message);
      },
    );
    final companyTime = stopwatch.elapsedMilliseconds;
    stopwatch.reset();

    onProgress?.call('taxonomy', 0, entities.length, 'Seeding taxonomy...');

    final taxonomyResult = await _taxonomyLoader.load(
      entities: entities,
      onProgress: (processed, total, message) {
        onProgress?.call('taxonomy', processed, total, message);
      },
    );
    final taxonomyTime = stopwatch.elapsedMilliseconds;
    stopwatch.reset();

    onProgress?.call(
        'providers', 0, entities.length, 'Seeding provider profiles...');

    // Seed provider profiles
    final providerResult = await _providerLoader.load(
      entities: entities,
      onProgress: (processed, total, message) {
        onProgress?.call('providers', processed, total, message);
      },
    );
    final providerTime = stopwatch.elapsedMilliseconds;

    stopwatch.stop();

    return SeedResult(
      entityCount: entities.length,
      companyResult: companyResult,
      taxonomyResult: taxonomyResult,
      providerResult: providerResult,
      loadTimeMs: loadTime,
      companyTimeMs: companyTime,
      taxonomyTimeMs: taxonomyTime,
      providerTimeMs: providerTime,
      dryRun: _config.dryRun,
    );
  }

  /// Verify existing seed data.
  Future<VerificationResult> verify() async {
    final companyVerification = await _companyLoader.verify();
    final providerVerification = await _providerLoader.verify();

    return VerificationResult(
      companies: companyVerification,
      providers: providerVerification,
    );
  }

  /// Load entities from JSON file with streaming for memory efficiency.
  Future<List<BusinessEntity>> _loadEntities(
    String inputPath,
    void Function(String stage, int current, int total, String message)?
        onProgress,
  ) async {
    final file = File(inputPath);
    if (!file.existsSync()) {
      throw SeedError('Input file not found: $inputPath');
    }

    final fileSize = file.lengthSync();
    onProgress?.call('load', 0, fileSize,
        'Reading JSON file (${_formatBytes(fileSize)})...');

    // For large files, we read and parse in one go
    // Future optimization: use streaming JSON parser
    final content = await file.readAsString();
    onProgress?.call('load', fileSize, fileSize, 'Parsing JSON...');

    final jsonList = jsonDecode(content) as List<dynamic>;
    final entities = <BusinessEntity>[];

    for (var i = 0; i < jsonList.length; i++) {
      final json = jsonList[i] as Map<String, dynamic>;
      entities.add(BusinessEntity.fromJson(json));

      if (i % 10000 == 0) {
        onProgress?.call('load', i, jsonList.length,
            'Parsing entities: $i/${jsonList.length}');
      }
    }

    return entities;
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// Close the database connection.
  Future<void> close() async {
    await _client.close();
  }
}

/// Result of the complete seeding operation.
class SeedResult {
  SeedResult({
    required this.entityCount,
    required this.companyResult,
    required this.taxonomyResult,
    required this.providerResult,
    required this.loadTimeMs,
    required this.companyTimeMs,
    required this.taxonomyTimeMs,
    required this.providerTimeMs,
    required this.dryRun,
  });

  final int entityCount;
  final CompanyLoadResult companyResult;
  final TaxonomyLoadResult taxonomyResult;
  final ProviderLoadResult providerResult;
  final int loadTimeMs;
  final int companyTimeMs;
  final int taxonomyTimeMs;
  final int providerTimeMs;
  final bool dryRun;

  int get totalTimeMs =>
      loadTimeMs + companyTimeMs + taxonomyTimeMs + providerTimeMs;

  bool get success =>
      companyResult.success && taxonomyResult.success && providerResult.success;

  @override
  String toString() {
    final buffer = StringBuffer()
      ..writeln('=' * 60)
      ..writeln(dryRun ? 'SEED RESULT (DRY RUN)' : 'SEED RESULT')
      ..writeln('=' * 60)
      ..writeln()
      ..writeln('Entities processed: $entityCount')
      ..writeln()
      ..writeln('Timing:')
      ..writeln('  Load entities: ${_formatMs(loadTimeMs)}')
      ..writeln('  Seed companies: ${_formatMs(companyTimeMs)}')
      ..writeln('  Seed taxonomy: ${_formatMs(taxonomyTimeMs)}')
      ..writeln('  Seed providers: ${_formatMs(providerTimeMs)}')
      ..writeln('  Total: ${_formatMs(totalTimeMs)}')
      ..writeln()
      ..writeln('Companies:')
      ..writeln(companyResult)
      ..writeln()
      ..writeln('Taxonomy:')
      ..writeln(taxonomyResult)
      ..writeln()
      ..writeln('Providers:')
      ..writeln(providerResult)
      ..writeln()
      ..writeln('=' * 60)
      ..writeln(success ? 'SUCCESS' : 'COMPLETED WITH ERRORS')
      ..writeln('=' * 60);
    return buffer.toString();
  }

  String _formatMs(int ms) {
    if (ms < 1000) return '${ms}ms';
    if (ms < 60000) return '${(ms / 1000).toStringAsFixed(1)}s';
    final minutes = ms ~/ 60000;
    final seconds = (ms % 60000) / 1000;
    return '${minutes}m ${seconds.toStringAsFixed(1)}s';
  }
}

/// Result of verification operation.
class VerificationResult {
  VerificationResult({
    required this.companies,
    required this.providers,
  });

  final CompanyVerification companies;
  final ProviderVerification providers;

  @override
  String toString() {
    final separator = '=' * 60;
    return '$separator\nVERIFICATION RESULT\n$separator\n\n$companies\n\n$providers\n\n$separator';
  }
}

/// Seeding error.
class SeedError implements Exception {
  SeedError(this.message);
  final String message;

  @override
  String toString() => 'SeedError: $message';
}
