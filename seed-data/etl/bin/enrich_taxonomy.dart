#!/usr/bin/env dart

/// One-off taxonomy enrichment using OpenAI classifications.
///
/// This script analyzes existing provider companies and proposes
/// pending branch/category mappings for admin review.
///
/// Usage:
///   OPENAI_API_KEY=... dart run bin/enrich_taxonomy.dart --env local
///   OPENAI_API_KEY=... dart run bin/enrich_taxonomy.dart --env local --max-companies 500
///   OPENAI_API_KEY=... dart run bin/enrich_taxonomy.dart --dry-run
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:args/args.dart';
import 'package:etl/loaders/seed_config.dart';
import 'package:etl/loaders/supabase_client.dart';
import 'package:etl/mappers/entity_to_record.dart';
import 'package:http/http.dart' as http;

const _defaultModel = 'gpt-5-nano';
const _materialProviderTypes = [
  'haendler',
  'grosshaendler',
  'hersteller',
  'HAENDLER',
  'GROSSHAENDLER',
  'HERSTELLER',
];

Future<void> main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption(
      'env',
      abbr: 'e',
      help: 'Target environment (local, staging, production)',
      allowed: ['local', 'staging', 'production'],
      defaultsTo: 'local',
    )
    ..addOption(
      'max-companies',
      abbr: 'm',
      help: 'Maximum number of companies to process',
      defaultsTo: '200',
    )
    ..addOption(
      'offset',
      abbr: 'o',
      help: 'Offset into the provider list',
      defaultsTo: '0',
    )
    ..addOption(
      'model',
      help: 'OpenAI model to use',
      defaultsTo: _defaultModel,
    )
    ..addOption(
      'openai-api',
      help: 'OpenAI API to use (auto selects responses for gpt-5 models)',
      allowed: ['auto', 'chat', 'responses'],
      defaultsTo: 'auto',
    )
    ..addOption(
      'openai-reasoning-effort',
      help: 'Reasoning effort for responses API (gpt-5/o-series only)',
      allowed: ['none', 'minimal', 'low', 'medium', 'high', 'xhigh'],
      defaultsTo: 'minimal',
    )
    ..addOption(
      'dump-openai-request',
      help: 'Write the first OpenAI request payload to this file',
    )
    ..addFlag(
      'dump-openai-request-only',
      help: 'Write the first OpenAI request payload and exit',
      negatable: false,
    )
    ..addOption(
      'temperature',
      help: 'Sampling temperature (model-dependent)',
      defaultsTo: '0.2',
    )
    ..addOption(
      'companies-file',
      help:
          'Path to JSON file with provider records (companyId/name/website/providerType)',
    )
    ..addOption(
      'company-ids-file',
      help:
          'Path to JSON file with company IDs to enrich (strings or {companyId} objects)',
    )
    ..addOption(
      'branches-file',
      help: 'Path to JSON file with branch records',
    )
    ..addOption(
      'categories-file',
      help: 'Path to JSON file with category records',
    )
    ..addFlag(
      'skip-mappings',
      help: 'Skip loading company mappings (treat as empty)',
      negatable: false,
    )
    ..addFlag(
      'omit-branches',
      help: 'Do not send branch list to the model (free-form branch names)',
      negatable: false,
    )
    ..addOption(
      'output',
      abbr: 'f',
      help: 'Output JSONL file path',
      defaultsTo: '../out/taxonomy_suggestions.jsonl',
    )
    ..addOption(
      'sleep-ms',
      help: 'Delay between OpenAI requests in milliseconds',
      defaultsTo: '250',
    )
    ..addOption(
      'openai-batch-size',
      help: 'Number of companies per OpenAI request',
      defaultsTo: '100',
    )
    ..addOption(
      'openai-timeout-seconds',
      help: 'OpenAI request timeout in seconds',
      defaultsTo: '60',
    )
    ..addOption(
      'openai-retries',
      help: 'Number of retries per OpenAI request',
      defaultsTo: '2',
    )
    ..addOption(
      'openai-retry-delay-ms',
      help: 'Base delay between retries in milliseconds',
      defaultsTo: '2000',
    )
    ..addOption(
      'parallelism',
      help: 'Number of concurrent OpenAI requests',
      defaultsTo: '1',
    )
    ..addFlag(
      'dry-run',
      abbr: 'd',
      help: 'Run without writing to the database',
      negatable: false,
    )
    ..addFlag(
      'fail-on-unsupported',
      help: 'Exit immediately if the model or response format is unsupported',
      negatable: false,
    )
    ..addFlag(
      'help',
      abbr: 'h',
      help: 'Show this help message',
      negatable: false,
    );

  final ArgResults args;
  try {
    args = parser.parse(arguments);
  } on FormatException catch (e) {
    stderr.writeln('Error: ${e.message}');
    stderr.writeln();
    _printUsage(parser);
    exit(1);
  }

  if (args['help'] as bool) {
    _printUsage(parser);
    exit(0);
  }

  final envName = args['env'] as String;
  final environment = SeedEnvironment.values.firstWhere(
    (e) => e.name == envName,
  );
  final maxCompanies = int.tryParse(args['max-companies'] as String) ?? 200;
  final offset = int.tryParse(args['offset'] as String) ?? 0;
  final model = args['model'] as String;
  final companiesFile = args['companies-file'] as String?;
  final companyIdsFile = args['company-ids-file'] as String?;
  final branchesFile = args['branches-file'] as String?;
  final categoriesFile = args['categories-file'] as String?;
  final skipMappings = args['skip-mappings'] as bool;
  final omitBranches = args['omit-branches'] as bool;
  final openaiApi = args['openai-api'] as String;
  final reasoningEffort = args['openai-reasoning-effort'] as String;
  final dumpRequestPath = args['dump-openai-request'] as String?;
  final dumpRequestOnly = args['dump-openai-request-only'] as bool;
  final sleepMs = int.tryParse(args['sleep-ms'] as String) ?? 250;
  var temperature = double.tryParse(args['temperature'] as String) ?? 0.2;
  if (model.startsWith('gpt-5') && temperature != 1.0) {
    print('Note: gpt-5 models only support temperature=1.0. Overriding.');
    temperature = 1.0;
  }
  final useResponsesApi = openaiApi == 'responses' ||
      (openaiApi == 'auto' && model.startsWith('gpt-5'));
  final compactMode = model.startsWith('gpt-5');
  final dryRun = args['dry-run'] as bool;
  final outputPath = args['output'] as String;
  final parallelism = int.tryParse(args['parallelism'] as String) ?? 1;
  final openaiBatchSize =
      int.tryParse(args['openai-batch-size'] as String) ?? 100;
  final openaiTimeoutSeconds =
      int.tryParse(args['openai-timeout-seconds'] as String) ?? 120;
  final openaiRetries =
      int.tryParse(args['openai-retries'] as String) ?? 2;
  final openaiRetryDelayMs =
      int.tryParse(args['openai-retry-delay-ms'] as String) ?? 2000;

  final openaiKey = Platform.environment['OPENAI_API_KEY'];
  if (openaiKey == null || openaiKey.isEmpty) {
    stderr.writeln(
      'OPENAI_API_KEY is not set in the environment. '
      'Export it before running this script.',
    );
    exit(1);
  }

  print('=' * 60);
  print('SOM Taxonomy Enrichment');
  print('=' * 60);
  print('Environment: ${environment.name}');
  print('Model: $model');
  print('Max companies: $maxCompanies');
  print('Offset: $offset');
  print('Dry run: $dryRun');
  print('Parallelism: $parallelism');
  print('OpenAI batch size: $openaiBatchSize');
  print('OpenAI timeout seconds: $openaiTimeoutSeconds');
  print('OpenAI retries: $openaiRetries');
  print('=' * 60);
  print('');

  final useSupabase = companiesFile == null ||
      branchesFile == null ||
      categoriesFile == null ||
      (!skipMappings && companyIdsFile == null);
  SeedSupabaseClient? supabase;
  if (useSupabase) {
    final config = SeedConfig.fromEnvironment(environment: environment);
    supabase = await SeedSupabaseClient.initialize(config);
  }
  final mapper = EntityToRecordMapper();
  final failOnUnsupported = args['fail-on-unsupported'] as bool;
  final openai = _OpenAiClient(
    apiKey: openaiKey,
    model: model,
    temperature: temperature,
    failOnUnsupported: failOnUnsupported,
    timeout: Duration(seconds: openaiTimeoutSeconds),
    useResponsesApi: useResponsesApi,
    reasoningEffort: reasoningEffort,
    compactMode: compactMode,
    dumpRequestPath: dumpRequestPath,
    dumpRequestOnly: dumpRequestOnly,
  );
  final writer = _SuggestionWriter(
    File(outputPath),
  );

  try {
    final branches = branchesFile == null
        ? (supabase == null
            ? <String, _BranchInfo>{}
            : await _loadBranches(supabase))
        : _loadBranchesFromFile(branchesFile);
    final categories = categoriesFile == null
        ? (supabase == null
            ? <String, _CategoryInfo>{}
            : await _loadCategories(supabase))
        : _loadCategoriesFromFile(categoriesFile);

    final companyIdsFromFile =
        companyIdsFile == null ? null : _loadCompanyIds(companyIdsFile);
    var providers = companiesFile == null
        ? await _loadProviders(
            supabase!,
            offset: offset,
            limit: maxCompanies,
            companyIds: companyIdsFromFile,
          )
        : _loadProvidersFromFile(companiesFile);
    if (companyIdsFromFile != null && providers.isNotEmpty) {
      final allowed = companyIdsFromFile.toSet();
      providers = providers
          .where((row) =>
              row.companyId != null && allowed.contains(row.companyId))
          .toList();
    }
    if (providers.isEmpty) {
      print('No providers found for enrichment.');
      return;
    }

    final providerCompanyIds =
        providers.map((row) => row.companyId).whereType<String>().toList();
    final mappings = skipMappings || supabase == null
        ? _emptyMappings(providerCompanyIds)
        : await _loadMappings(supabase, providerCompanyIds);

    var processed = 0;
    var applied = 0;

    final candidates = <_ProviderRow>[];
    for (final provider in providers) {
      final companyId = provider.companyId;
      if (companyId == null || companyId.isEmpty) continue;
      final mapping = mappings[companyId] ?? _CompanyMappings.empty();
      if (mapping.hasActiveBranch && mapping.hasActiveCategory) {
        continue;
      }
      candidates.add(provider);
    }

    Future<void> processBatch(List<_ProviderRow> batch) async {
      if (batch.isEmpty) return;
      print('Batch start: size=${batch.length}');
      processed += batch.length;

      final prompt = _buildBatchPrompt(
        providers: batch,
        branches: branches.values.toList(),
        categories: categories.values.toList(),
        mappings: mappings,
        compactMode: compactMode,
        omitBranches: omitBranches,
      );

      List<_ClassificationResult>? results;
      for (var attempt = 0; attempt <= openaiRetries; attempt++) {
        results = await openai.classifyBatch(prompt);
        if (results != null) break;
        final delay = openaiRetryDelayMs * (attempt + 1);
        stderr.writeln(
          'OpenAI batch failed (attempt ${attempt + 1}/${openaiRetries + 1}). '
          'Retrying in ${delay}ms.',
        );
        await Future<void>.delayed(Duration(milliseconds: delay));
      }
      if (results == null || results.isEmpty) {
        stderr.writeln(
          'OpenAI batch failed permanently. Skipping ${batch.length} companies.',
        );
        return;
      }
      final resultByCompany = <String, _Classification>{};
      for (final result in results) {
        resultByCompany[result.companyId] = result.classification;
      }

      var batchApplied = 0;
      for (final provider in batch) {
        final companyId = provider.companyId;
        if (companyId == null || companyId.isEmpty) continue;
        final classification = resultByCompany[companyId];
        if (classification == null) continue;
        final mapping = mappings[companyId] ?? _CompanyMappings.empty();
        final suggestion = await _applySuggestion(
          supabase: supabase,
          mapper: mapper,
          provider: provider,
          branches: branches,
          categories: categories,
          mapping: mapping,
          classification: classification,
          dryRun: dryRun,
        );

        if (suggestion != null) {
          applied += 1;
          batchApplied += 1;
          await writer.write(suggestion);
        }
      }

      print(
        'Batch done: processed=${batch.length} applied=$batchApplied '
        'totalProcessed=$processed totalApplied=$applied',
      );

      if (sleepMs > 0) {
        await Future<void>.delayed(Duration(milliseconds: sleepMs));
      }
    }

    final batches = <List<_ProviderRow>>[];
    for (var i = 0; i < candidates.length; i += openaiBatchSize) {
      final end = min(i + openaiBatchSize, candidates.length);
      batches.add(candidates.sublist(i, end));
    }

    if (parallelism <= 1) {
      for (final batch in batches) {
        await processBatch(batch);
      }
    } else {
      final semaphore = _AsyncSemaphore(parallelism);
      final tasks = <Future<void>>[];
      for (final batch in batches) {
        await semaphore.acquire();
        tasks.add(() async {
          try {
            await processBatch(batch);
          } finally {
            semaphore.release();
          }
        }());
      }
      await Future.wait(tasks);
    }

    print('');
    print('Processed: $processed');
    print('Suggestions applied: $applied');
    print('Output: ${writer.file.path}');
  } on _DumpOnlyException {
    print('OpenAI request dumped to ${dumpRequestPath ?? 'unknown path'}');
  } finally {
    await writer.close();
    await supabase?.close();
  }
}

Future<Map<String, _BranchInfo>> _loadBranches(
  SeedSupabaseClient supabase,
) async {
  final rows = await supabase.client
      .from('branches')
      .select('id,name,status,normalized_name,external_id')
      .order('name') as List<dynamic>;
  final map = <String, _BranchInfo>{};
  for (final row in rows.cast<Map<String, dynamic>>()) {
    final name = row['name'] as String? ?? '';
    final normalized = row['normalized_name'] as String? ?? _normalize(name);
    final info = _BranchInfo(
      id: row['id'] as String,
      name: name,
      status: row['status'] as String? ?? 'active',
      normalizedName: normalized,
      externalId: row['external_id'] as String?,
    );
    map[normalized] = info;
  }
  return map;
}

Map<String, _BranchInfo> _loadBranchesFromFile(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    throw StateError('Branches file not found: $path');
  }
  final raw = jsonDecode(file.readAsStringSync());
  final map = <String, _BranchInfo>{};
  if (raw is List) {
    for (final entry in raw) {
      if (entry is! Map<String, dynamic>) continue;
      final name = entry['name'] as String? ?? '';
      if (name.isEmpty) continue;
      final normalized = entry['normalized_name'] as String? ?? _normalize(name);
      map[normalized] = _BranchInfo(
        id: entry['id'] as String? ?? '',
        name: name,
        status: entry['status'] as String? ?? 'active',
        normalizedName: normalized,
        externalId: entry['external_id'] as String?,
      );
    }
  }
  return map;
}

Future<Map<String, _CategoryInfo>> _loadCategories(
  SeedSupabaseClient supabase,
) async {
  final rows = await supabase.client
      .from('categories')
      .select('id,branch_id,name,status,normalized_name,external_id')
      .order('name') as List<dynamic>;
  final map = <String, _CategoryInfo>{};
  for (final row in rows.cast<Map<String, dynamic>>()) {
    final name = row['name'] as String? ?? '';
    final normalized = row['normalized_name'] as String? ?? _normalize(name);
    final key = '${row['branch_id']}|$normalized';
    map[key] = _CategoryInfo(
      id: row['id'] as String,
      branchId: row['branch_id'] as String,
      name: name,
      status: row['status'] as String? ?? 'active',
      normalizedName: normalized,
      externalId: row['external_id'] as String?,
    );
  }
  return map;
}

Map<String, _CategoryInfo> _loadCategoriesFromFile(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    throw StateError('Categories file not found: $path');
  }
  final raw = jsonDecode(file.readAsStringSync());
  final map = <String, _CategoryInfo>{};
  if (raw is List) {
    for (final entry in raw) {
      if (entry is! Map<String, dynamic>) continue;
      final name = entry['name'] as String? ?? '';
      final branchId = entry['branch_id'] as String? ?? '';
      if (name.isEmpty || branchId.isEmpty) continue;
      final normalized = entry['normalized_name'] as String? ?? _normalize(name);
      final key = '$branchId|$normalized';
      map[key] = _CategoryInfo(
        id: entry['id'] as String? ?? '',
        branchId: branchId,
        name: name,
        status: entry['status'] as String? ?? 'active',
        normalizedName: normalized,
        externalId: entry['external_id'] as String?,
      );
    }
  }
  return map;
}

Future<List<_ProviderRow>> _loadProviders(
  SeedSupabaseClient supabase, {
  required int offset,
  required int limit,
  List<String>? companyIds,
}) async {
  if (companyIds != null && companyIds.isNotEmpty) {
    final results = <_ProviderRow>[];
    const chunkSize = 50;
    final sliced =
        companyIds.length > limit ? companyIds.take(limit).toList() : companyIds;
    for (var i = 0; i < sliced.length; i += chunkSize) {
      final end = min(i + chunkSize, sliced.length);
      final chunk = sliced.sublist(i, end);
      final rows = await supabase.client
          .from('provider_profiles')
          .select(
              'company_id,provider_type,companies!inner(id,name,website_url,address_json)')
          .inFilter('provider_type', _materialProviderTypes)
          .inFilter('company_id', chunk) as List<dynamic>;
      results.addAll(rows
          .cast<Map<String, dynamic>>()
          .map((row) => _ProviderRow.fromJson(row)));
    }
    return results;
  }

  final rows = await supabase.client
      .from('provider_profiles')
      .select(
          'company_id,provider_type,companies!inner(id,name,website_url,address_json)')
      .inFilter('provider_type', _materialProviderTypes)
      .range(offset, offset + limit - 1) as List<dynamic>;

  return rows
      .cast<Map<String, dynamic>>()
      .map((row) => _ProviderRow.fromJson(row))
      .toList();
}

List<_ProviderRow> _loadProvidersFromFile(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    throw StateError('Companies file not found: $path');
  }
  final raw = jsonDecode(file.readAsStringSync());
  final rows = <_ProviderRow>[];
  if (raw is List) {
    for (final entry in raw) {
      if (entry is! Map<String, dynamic>) continue;
      rows.add(_ProviderRow(
        companyId: entry['companyId'] as String?,
        providerType: entry['providerType'] as String?,
        companyName: entry['name'] as String?,
        websiteUrl: entry['websiteUrl'] as String?,
        city: null,
        zip: null,
      ));
    }
  }
  return rows;
}

Future<Map<String, _CompanyMappings>> _loadMappings(
  SeedSupabaseClient supabase,
  List<String> companyIds,
) async {
  if (companyIds.isEmpty) return {};
  final result = <String, _CompanyMappings>{};

  const chunkSize = 50;
  for (var i = 0; i < companyIds.length; i += chunkSize) {
    final end = min(i + chunkSize, companyIds.length);
    final chunk = companyIds.sublist(i, end);

    final branchRows = await supabase.client
        .from('company_branches')
        .select('company_id,branch_id,status')
        .inFilter('company_id', chunk) as List<dynamic>;
    final categoryRows = await supabase.client
        .from('company_categories')
        .select('company_id,category_id,status')
        .inFilter('company_id', chunk) as List<dynamic>;

    for (final row in branchRows.cast<Map<String, dynamic>>()) {
      final companyId = row['company_id'] as String;
      result.putIfAbsent(companyId, _CompanyMappings.empty);
      final status = row['status'] as String? ?? 'active';
      if (status == 'active') {
        result[companyId]!.activeBranchIds.add(row['branch_id'] as String);
      } else {
        result[companyId]!.pendingBranchIds.add(row['branch_id'] as String);
      }
    }
    for (final row in categoryRows.cast<Map<String, dynamic>>()) {
      final companyId = row['company_id'] as String;
      result.putIfAbsent(companyId, _CompanyMappings.empty);
      final status = row['status'] as String? ?? 'active';
      if (status == 'active') {
        result[companyId]!.activeCategoryIds.add(row['category_id'] as String);
      } else {
        result[companyId]!.pendingCategoryIds.add(row['category_id'] as String);
      }
    }
  }

  return result;
}

Map<String, _CompanyMappings> _emptyMappings(List<String> companyIds) {
  final map = <String, _CompanyMappings>{};
  for (final id in companyIds) {
    map[id] = _CompanyMappings.empty();
  }
  return map;
}

Future<_Suggestion?> _applySuggestion({
  required SeedSupabaseClient? supabase,
  required EntityToRecordMapper mapper,
  required _ProviderRow provider,
  required Map<String, _BranchInfo> branches,
  required Map<String, _CategoryInfo> categories,
  required _CompanyMappings mapping,
  required _Classification classification,
  required bool dryRun,
}) async {
  final companyId = provider.companyId;
  if (companyId == null || companyId.isEmpty) return null;

  final branchName = classification.branchName?.trim();
  if (branchName == null || branchName.isEmpty) {
    return null;
  }

  final branchNormalized = _normalize(branchName);
  final existingBranch = branches[branchNormalized];
  final branchStatus = existingBranch == null ? 'new' : 'existing';
  final branchInfo = existingBranch ??
      await _createBranch(
        supabase: supabase,
        mapper: mapper,
        branches: branches,
        name: branchName,
        normalized: branchNormalized,
        dryRun: dryRun,
      );

  if (branchInfo == null) {
    return null;
  }

  if (mapping.activeBranchIds.contains(branchInfo.id) ||
      mapping.pendingBranchIds.contains(branchInfo.id)) {
    // Already mapped to this branch.
  } else if (!dryRun && supabase != null) {
    await supabase.client.from('company_branches').upsert(
      {
        'company_id': companyId,
        'branch_id': branchInfo.id,
        'source': 'openai',
        'confidence': classification.branchConfidence,
        'status': 'pending',
        'created_at': DateTime.now().toUtc().toIso8601String(),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      },
      onConflict: 'company_id,branch_id',
    );
  }

  final categoryIds = <String>[];
  var existingCategoryCount = 0;
  var newCategoryCount = 0;
  final categoryConfidences = <double>[];
  for (final categorySuggestion in classification.categories) {
    final categoryName = categorySuggestion.name.trim();
    if (categoryName.isEmpty) continue;
    final categoryNormalized = _normalize(categoryName);
    final key = '${branchInfo.id}|$categoryNormalized';
    final existingCategory = categories[key];
    if (categorySuggestion.confidence != null) {
      categoryConfidences.add(categorySuggestion.confidence!);
    }
    final categoryInfo = existingCategory ??
        await _createCategory(
          supabase: supabase,
          mapper: mapper,
          categories: categories,
          branch: branchInfo,
          name: categoryName,
          normalized: categoryNormalized,
          dryRun: dryRun,
        );
    if (categoryInfo == null) {
      continue;
    }
    if (mapping.activeCategoryIds.contains(categoryInfo.id) ||
        mapping.pendingCategoryIds.contains(categoryInfo.id)) {
      categoryIds.add(categoryInfo.id);
      if (existingCategory != null) {
        existingCategoryCount += 1;
      } else {
        newCategoryCount += 1;
      }
      continue;
    }
    if (existingCategory != null) {
      existingCategoryCount += 1;
    } else {
      newCategoryCount += 1;
    }
    if (!dryRun && supabase != null) {
      await supabase.client.from('company_categories').upsert(
        {
          'company_id': companyId,
          'category_id': categoryInfo.id,
          'source': 'openai',
          'confidence': categorySuggestion.confidence,
          'status': 'pending',
          'created_at': DateTime.now().toUtc().toIso8601String(),
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        },
        onConflict: 'company_id,category_id',
      );
    }
    categoryIds.add(categoryInfo.id);
  }

  final avgCategoryConfidence = categoryConfidences.isEmpty
      ? null
      : categoryConfidences.reduce((a, b) => a + b) / categoryConfidences.length;

  return _Suggestion(
    companyId: companyId,
    companyName: provider.companyName ?? '',
    website: provider.websiteUrl,
    providerType: provider.providerType ?? '',
    branch: branchInfo.name,
    branchId: branchInfo.id,
    branchStatus: branchStatus,
    branchConfidence: classification.branchConfidence,
    categories: categoryIds,
    existingCategoryCount: existingCategoryCount,
    newCategoryCount: newCategoryCount,
    avgCategoryConfidence: avgCategoryConfidence,
    raw: classification.raw,
  );
}

Future<_BranchInfo?> _createBranch({
  required SeedSupabaseClient? supabase,
  required EntityToRecordMapper mapper,
  required Map<String, _BranchInfo> branches,
  required String name,
  required String normalized,
  required bool dryRun,
}) async {
  final externalId = 'name:$normalized';
  final branchId = mapper.generateBranchId(externalId);
  if (!dryRun && supabase != null) {
    await supabase.client.from('branches').upsert(
      {
        'id': branchId,
        'name': name,
        'external_id': externalId,
        'normalized_name': normalized,
        'status': 'pending',
      },
      onConflict: 'normalized_name',
    );
  }
  final info = _BranchInfo(
    id: branchId,
    name: name,
    status: 'pending',
    normalizedName: normalized,
    externalId: externalId,
  );
  branches[normalized] = info;
  return info;
}

Future<_CategoryInfo?> _createCategory({
  required SeedSupabaseClient? supabase,
  required EntityToRecordMapper mapper,
  required Map<String, _CategoryInfo> categories,
  required _BranchInfo branch,
  required String name,
  required String normalized,
  required bool dryRun,
}) async {
  final externalId = 'name:${branch.externalId ?? branch.id}:$normalized';
  final categoryId = mapper.generateCategoryId(externalId);
  if (!dryRun && supabase != null) {
    await supabase.client.from('categories').upsert(
      {
        'id': categoryId,
        'branch_id': branch.id,
        'name': name,
        'external_id': externalId,
        'normalized_name': normalized,
        'status': 'pending',
      },
      onConflict: 'branch_id,normalized_name',
    );
  }
  final info = _CategoryInfo(
    id: categoryId,
    branchId: branch.id,
    name: name,
    status: 'pending',
    normalizedName: normalized,
    externalId: externalId,
  );
  categories['${branch.id}|$normalized'] = info;
  return info;
}

String _buildBatchPrompt({
  required List<_ProviderRow> providers,
  required List<_BranchInfo> branches,
  required List<_CategoryInfo> categories,
  required Map<String, _CompanyMappings> mappings,
  required bool compactMode,
  required bool omitBranches,
}) {
  // Keep prompt compact to avoid timeouts for large batches.
  final branchNames =
      omitBranches ? <String>[] : branches.map((b) => b.name).toList();

  final companies = <Map<String, dynamic>>[];
  for (final provider in providers) {
    final companyId = provider.companyId;
    if (companyId == null || companyId.isEmpty) continue;
    if (compactMode) {
      companies.add({
        'id': companyId,
        'n': provider.companyName,
        'w': provider.websiteUrl,
        't': provider.providerType,
      });
    } else {
      companies.add({
        'companyId': companyId,
        'name': provider.companyName,
        'website': provider.websiteUrl,
        'providerType': provider.providerType,
        'city': provider.city,
        'zip': provider.zip,
      });
    }
  }

  if (compactMode) {
    return jsonEncode({
      'c': companies,
      if (!omitBranches) 'b': branchNames,
      'i': omitBranches
          ? 'For each company in c, propose a branch name and up to 3 categories. '
              'If service-only or unclear, set branch to null and categories empty. '
              'Return JSON only.'
          : 'For each company in c, choose the best branch from b and up to 3 categories. '
              'If service-only or unclear, set branch to null and categories empty. '
              'Return JSON only.',
    });
  }

  return jsonEncode({
    'companies': companies,
    if (!omitBranches) 'availableBranches': branchNames,
    'instructions': omitBranches
        ? 'For each company, propose a branch name and up to 3 categories for a MATERIAL-GOODS provider. '
            'If service-only or unclear, set branch to null and categories to empty. '
            'Return results in the same order as provided.'
        : 'For each company, pick the best branch and up to 3 categories for a MATERIAL-GOODS provider. '
            'If service-only or unclear, set branch to null and categories to empty. '
            'Return results in the same order as provided.',
  });
}

String _normalize(String value) {
  return value
      .toLowerCase()
      .replaceAll(RegExp(r'[,_]+'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

List<String> _loadCompanyIds(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    throw StateError('Company IDs file not found: $path');
  }
  final raw = jsonDecode(file.readAsStringSync());
  final ids = <String>[];
  if (raw is List) {
    for (final entry in raw) {
      if (entry is String) {
        if (entry.trim().isNotEmpty) {
          ids.add(entry.trim());
        }
      } else if (entry is Map<String, dynamic>) {
        final id = entry['companyId'] as String?;
        if (id != null && id.trim().isNotEmpty) {
          ids.add(id.trim());
        }
      }
    }
  }
  return ids;
}

void _printUsage(ArgParser parser) {
  print('Usage: dart run bin/enrich_taxonomy.dart [options]');
  print('');
  print('Options:');
  print(parser.usage);
  print('');
  print('Example:');
  print('  OPENAI_API_KEY=... dart run bin/enrich_taxonomy.dart --env local');
}

class _OpenAiClient {
  _OpenAiClient({
    required this.apiKey,
    required this.model,
    required this.temperature,
    required this.failOnUnsupported,
    required this.timeout,
    required this.useResponsesApi,
    required this.reasoningEffort,
    required this.compactMode,
    required this.dumpRequestPath,
    required this.dumpRequestOnly,
  });

  final String apiKey;
  final String model;
  final double temperature;
  final bool failOnUnsupported;
  final Duration timeout;
  final bool useResponsesApi;
  final String reasoningEffort;
  final bool compactMode;
  final String? dumpRequestPath;
  final bool dumpRequestOnly;
  bool _dumped = false;

  Future<_Classification?> classify(String prompt) async {
    if (useResponsesApi) {
      return _classifyResponses(prompt);
    }
    return _classifyChat(prompt);
  }

  Future<_Classification?> _classifyChat(String prompt) async {
    final payload = {
      'model': model,
      'messages': [
        {
          'role': 'system',
          'content':
              'You are a taxonomy classifier for B2B material goods providers. '
                  'Return JSON only. If unclear, return branch null and empty categories.',
        },
        {'role': 'user', 'content': prompt},
      ],
      'temperature': temperature,
      'response_format': {
        'type': 'json_schema',
        'json_schema': {
          'name': 'taxonomy_match',
          'strict': true,
          'schema': {
            'type': 'object',
            'additionalProperties': false,
            'properties': {
              'branch': {
                'type': ['object', 'null'],
                'additionalProperties': false,
                'properties': {
                  'name': {
                    'type': ['string', 'null']
                  },
                  'confidence': {
                    'type': ['number', 'null']
                  },
                },
                'required': ['name', 'confidence'],
              },
              'categories': {
                'type': 'array',
                'items': {
                  'type': 'object',
                  'additionalProperties': false,
                  'properties': {
                    'name': {'type': 'string'},
                    'confidence': {
                      'type': ['number', 'null']
                    },
                  },
                  'required': ['name', 'confidence'],
                },
              },
            },
            'required': ['branch', 'categories'],
          },
        },
      },
    };
    _maybeDump(payload);
    final body = jsonEncode(payload);

    http.Response response;
    try {
      response = await http
          .post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: body,
      )
          .timeout(timeout);
    } on TimeoutException {
      stderr.writeln('OpenAI request timed out after ${timeout.inSeconds}s');
      return null;
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      String? code;
      String? message;
      try {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        code = decoded['error']?['code'] as String?;
        message = decoded['error']?['message'] as String?;
      } catch (_) {
        code = null;
        message = null;
      }
      final suffix = code == null ? '' : ' ($code)';
      if (failOnUnsupported &&
          (code == 'unsupported_value' ||
              code == 'model_not_found' ||
              (message != null &&
                  message.toLowerCase().contains('response_format')))) {
        throw StateError('OpenAI unsupported request: ${message ?? code ?? response.statusCode}');
      }
      stderr.writeln('OpenAI error ${response.statusCode}$suffix');
      return null;
    }

    try {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final content = decoded['choices']?[0]?['message']?['content'] as String?;
      if (content == null || content.isEmpty) {
        return null;
      }
      final rawResult = jsonDecode(content);
      if (rawResult is! Map<String, dynamic>) {
        stderr.writeln('OpenAI response parse error: unexpected payload shape');
        return null;
      }
      return _Classification.fromJson(rawResult, raw: rawResult);
    } catch (e) {
      stderr.writeln('OpenAI response parse error: $e');
      return null;
    }
  }

  Future<List<_ClassificationResult>?> classifyBatch(String prompt) async {
    if (useResponsesApi) {
      return _classifyBatchResponses(prompt);
    }
    return _classifyBatchChat(prompt);
  }

  Future<List<_ClassificationResult>?> _classifyBatchChat(String prompt) async {
    final payload = {
      'model': model,
      'messages': [
        {
          'role': 'system',
          'content':
              'You are a taxonomy classifier for B2B material goods providers. '
                  'Return JSON only. If unclear, return branch null and empty categories.',
        },
        {'role': 'user', 'content': prompt},
      ],
      'temperature': temperature,
      'response_format': {
        'type': 'json_schema',
        'json_schema': {
          'name': 'taxonomy_batch',
          'strict': true,
          'schema': {
            'type': 'object',
            'additionalProperties': false,
            'properties': {
              'results': {
                'type': 'array',
                'items': {
                  'type': 'object',
                  'additionalProperties': false,
                  'properties': {
                    'companyId': {'type': 'string'},
                    'branch': {
                      'type': ['object', 'null'],
                      'additionalProperties': false,
                      'properties': {
                        'name': {'type': ['string', 'null']},
                        'confidence': {'type': ['number', 'null']},
                      },
                      'required': ['name', 'confidence'],
                    },
                    'categories': {
                      'type': 'array',
                      'items': {
                        'type': 'object',
                        'additionalProperties': false,
                        'properties': {
                          'name': {'type': 'string'},
                          'confidence': {'type': ['number', 'null']},
                        },
                        'required': ['name', 'confidence'],
                      },
                    },
                  },
                  'required': ['companyId', 'branch', 'categories'],
                },
              },
            },
            'required': ['results'],
          },
        },
      },
    };
    _maybeDump(payload);
    final body = jsonEncode(payload);

    http.Response response;
    try {
      response = await http
          .post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: body,
      )
          .timeout(timeout);
    } on TimeoutException {
      stderr.writeln('OpenAI request timed out after ${timeout.inSeconds}s');
      return null;
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      String? code;
      String? message;
      try {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        code = decoded['error']?['code'] as String?;
        message = decoded['error']?['message'] as String?;
      } catch (_) {
        code = null;
        message = null;
      }
      final suffix = code == null ? '' : ' ($code)';
      if (failOnUnsupported &&
          (code == 'unsupported_value' ||
              code == 'model_not_found' ||
              (message != null &&
                  message.toLowerCase().contains('response_format')))) {
        throw StateError('OpenAI unsupported request: ${message ?? code ?? response.statusCode}');
      }
      stderr.writeln('OpenAI error ${response.statusCode}$suffix');
      return null;
    }

    try {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final content = decoded['choices']?[0]?['message']?['content'] as String?;
      if (content == null || content.isEmpty) {
        return null;
      }
      final raw = jsonDecode(content);
      if (raw is! Map<String, dynamic>) {
        stderr.writeln('OpenAI response parse error: unexpected payload shape');
        return null;
      }
      final resultsRaw = raw['results'];
      if (resultsRaw is! List) {
        return null;
      }
      final results = <_ClassificationResult>[];
      for (final entry in resultsRaw) {
        if (entry is! Map<String, dynamic>) continue;
        final companyId = entry['companyId'] as String?;
        if (companyId == null || companyId.isEmpty) continue;
        final classification = _Classification.fromJson(entry, raw: entry);
        results.add(_ClassificationResult(
          companyId: companyId,
          classification: classification,
        ));
      }
      return results;
    } catch (e) {
      stderr.writeln('OpenAI response parse error: $e');
      return null;
    }
  }

  Map<String, dynamic> _singleSchema() {
    if (compactMode) {
      return {
        'type': 'object',
        'additionalProperties': false,
        'properties': {
          'b': {'type': ['string', 'null']},
          'c': {
            'type': 'array',
            'items': {'type': 'string'},
          },
        },
        'required': ['b', 'c'],
      };
    }
    return {
      'type': 'object',
      'additionalProperties': false,
      'properties': {
        'branch': {
          'type': ['object', 'null'],
          'additionalProperties': false,
          'properties': {
            'name': {'type': ['string', 'null']},
            'confidence': {'type': ['number', 'null']},
          },
          'required': ['name', 'confidence'],
        },
        'categories': {
          'type': 'array',
          'items': {
            'type': 'object',
            'additionalProperties': false,
            'properties': {
              'name': {'type': 'string'},
              'confidence': {'type': ['number', 'null']},
            },
            'required': ['name', 'confidence'],
          },
        },
      },
      'required': ['branch', 'categories'],
    };
  }

  Map<String, dynamic> _batchSchema() {
    if (compactMode) {
      return {
        'type': 'object',
        'additionalProperties': false,
        'properties': {
          'r': {
            'type': 'array',
            'items': {
              'type': 'object',
              'additionalProperties': false,
              'properties': {
                'id': {'type': 'string'},
                'b': {'type': ['string', 'null']},
                'c': {
                  'type': 'array',
                  'items': {'type': 'string'},
                },
              },
              'required': ['id', 'b', 'c'],
            },
          },
        },
        'required': ['r'],
      };
    }
    return {
      'type': 'object',
      'additionalProperties': false,
      'properties': {
        'results': {
          'type': 'array',
          'items': {
            'type': 'object',
            'additionalProperties': false,
            'properties': {
              'companyId': {'type': 'string'},
              'branch': {
                'type': ['object', 'null'],
                'additionalProperties': false,
                'properties': {
                  'name': {'type': ['string', 'null']},
                  'confidence': {'type': ['number', 'null']},
                },
                'required': ['name', 'confidence'],
              },
              'categories': {
                'type': 'array',
                'items': {
                  'type': 'object',
                  'additionalProperties': false,
                  'properties': {
                    'name': {'type': 'string'},
                    'confidence': {'type': ['number', 'null']},
                  },
                  'required': ['name', 'confidence'],
                },
              },
            },
            'required': ['companyId', 'branch', 'categories'],
          },
        },
      },
      'required': ['results'],
    };
  }

  Future<_Classification?> _classifyResponses(String prompt) async {
    final payload = {
      'model': model,
      'instructions':
          'You are a taxonomy classifier for B2B material goods providers. '
              'Return JSON only. If unclear, return branch null and empty categories.',
      'input': [
        {'role': 'user', 'content': prompt},
      ],
      'temperature': temperature,
      if (model.startsWith('gpt-5') || model.startsWith('o'))
        'reasoning': {'effort': reasoningEffort},
      'text': {
        'format': {
          'type': 'json_schema',
          'name': 'taxonomy_match',
          'strict': true,
          'schema': _singleSchema(),
        },
      },
    };
    _maybeDump(payload);
    final body = jsonEncode(payload);

    http.Response response;
    try {
      response = await http
          .post(
        Uri.parse('https://api.openai.com/v1/responses'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: body,
      )
          .timeout(timeout);
    } on TimeoutException {
      stderr.writeln('OpenAI request timed out after ${timeout.inSeconds}s');
      return null;
    }

    final decoded = _handleResponsesError(response);
    if (decoded == null) {
      return null;
    }

    final content = _extractResponsesText(decoded);
    if (content == null || content.isEmpty) {
      return null;
    }
    try {
      final rawResult = jsonDecode(content);
      if (rawResult is! Map<String, dynamic>) {
        stderr.writeln('OpenAI response parse error: unexpected payload shape');
        return null;
      }
      return _Classification.fromJson(rawResult, raw: rawResult);
    } catch (e) {
      stderr.writeln('OpenAI response parse error: $e');
      return null;
    }
  }

  Future<List<_ClassificationResult>?> _classifyBatchResponses(
    String prompt,
  ) async {
    final payload = {
      'model': model,
      'instructions':
          'You are a taxonomy classifier for B2B material goods providers. '
              'Return JSON only. If unclear, return branch null and empty categories.',
      'input': [
        {'role': 'user', 'content': prompt},
      ],
      'temperature': temperature,
      if (model.startsWith('gpt-5') || model.startsWith('o'))
        'reasoning': {'effort': reasoningEffort},
      'text': {
        'format': {
          'type': 'json_schema',
          'name': 'taxonomy_batch',
          'strict': true,
          'schema': _batchSchema(),
        },
      },
    };
    _maybeDump(payload);
    final body = jsonEncode(payload);

    http.Response response;
    try {
      response = await http
          .post(
        Uri.parse('https://api.openai.com/v1/responses'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: body,
      )
          .timeout(timeout);
    } on TimeoutException {
      stderr.writeln('OpenAI request timed out after ${timeout.inSeconds}s');
      return null;
    }

    final decoded = _handleResponsesError(response);
    if (decoded == null) {
      return null;
    }

    final content = _extractResponsesText(decoded);
    if (content == null || content.isEmpty) {
      return null;
    }
    try {
      final raw = jsonDecode(content);
      if (raw is! Map<String, dynamic>) {
        stderr.writeln('OpenAI response parse error: unexpected payload shape');
        return null;
      }
      final resultsRaw = raw['results'];
      if (resultsRaw is! List) {
        return null;
      }
      final results = <_ClassificationResult>[];
      for (final entry in resultsRaw) {
        if (entry is! Map<String, dynamic>) continue;
        final companyId =
            (entry['companyId'] ?? entry['id']) as String?;
        if (companyId == null || companyId.isEmpty) continue;
        final classification = _Classification.fromJson(entry, raw: entry);
        results.add(_ClassificationResult(
          companyId: companyId,
          classification: classification,
        ));
      }
      return results;
    } catch (e) {
      stderr.writeln('OpenAI response parse error: $e');
      return null;
    }
  }

  Map<String, dynamic>? _handleResponsesError(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      String? code;
      String? message;
      try {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        code = decoded['error']?['code'] as String?;
        message = decoded['error']?['message'] as String?;
      } catch (_) {
        code = null;
        message = null;
      }
      final suffix = code == null ? '' : ' ($code)';
      if (failOnUnsupported &&
          (code == 'unsupported_value' ||
              code == 'model_not_found' ||
              (message != null &&
                  message.toLowerCase().contains('response_format')))) {
        throw StateError(
            'OpenAI unsupported request: ${message ?? code ?? response.statusCode}');
      }
      stderr.writeln('OpenAI error ${response.statusCode}$suffix');
      return null;
    }
    try {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      stderr.writeln('OpenAI response parse error: $e');
      return null;
    }
  }

  String? _extractResponsesText(Map<String, dynamic> decoded) {
    final output = decoded['output'];
    if (output is List) {
      for (final item in output) {
        if (item is! Map<String, dynamic>) continue;
        final content = item['content'];
        if (content is! List) continue;
        for (final part in content) {
          if (part is! Map<String, dynamic>) continue;
          final type = part['type'];
          if (type == 'output_text') {
            return part['text'] as String?;
          }
        }
      }
    }
    final fallback = decoded['output_text'];
    return fallback is String ? fallback : null;
  }

  void _maybeDump(Map<String, dynamic> payload) {
    if (_dumped || dumpRequestPath == null) return;
    final file = File(dumpRequestPath!);
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(
      const JsonEncoder.withIndent('  ').convert(payload),
    );
    _dumped = true;
    if (dumpRequestOnly) {
      throw _DumpOnlyException();
    }
  }
}

class _DumpOnlyException implements Exception {}

class _ClassificationResult {
  _ClassificationResult({
    required this.companyId,
    required this.classification,
  });

  final String companyId;
  final _Classification classification;
}

class _Classification {
  _Classification({
    required this.branchName,
    required this.branchConfidence,
    required this.categories,
    required this.raw,
  });

  final String? branchName;
  final double? branchConfidence;
  final List<_CategorySuggestion> categories;
  final Map<String, dynamic> raw;

  factory _Classification.fromJson(
    Map<String, dynamic> json, {
    required Map<String, dynamic> raw,
  }) {
    final branchRaw = json['branch'] ?? json['b'];
    final branch = branchRaw is Map<String, dynamic> ? branchRaw : null;
    final branchName =
        branch?['name'] as String? ?? (branchRaw is String ? branchRaw : null);
    final branchConfidence =
        (branch?['confidence'] as num?)?.toDouble();

    final categoriesRaw = json['categories'] ?? json['c'];
    final categoriesJson = categoriesRaw is List
        ? categoriesRaw.whereType<Map<String, dynamic>>().toList()
        : <Map<String, dynamic>>[];
    final categoriesStrings =
        categoriesRaw is List ? categoriesRaw.whereType<String>().toList() : <String>[];
    return _Classification(
      branchName: branchName,
      branchConfidence: branchConfidence,
      categories: [
        ...categoriesJson.map((entry) => _CategorySuggestion(
              name: entry['name'] as String? ?? '',
              confidence: (entry['confidence'] as num?)?.toDouble(),
            )),
        ...categoriesStrings.map((name) => _CategorySuggestion(
              name: name,
              confidence: null,
            )),
      ],
      raw: raw,
    );
  }
}

class _CategorySuggestion {
  _CategorySuggestion({
    required this.name,
    required this.confidence,
  });

  final String name;
  final double? confidence;
}

class _ProviderRow {
  _ProviderRow({
    required this.companyId,
    required this.providerType,
    required this.companyName,
    required this.websiteUrl,
    required this.city,
    required this.zip,
  });

  final String? companyId;
  final String? providerType;
  final String? companyName;
  final String? websiteUrl;
  final String? city;
  final String? zip;

  factory _ProviderRow.fromJson(Map<String, dynamic> row) {
    final company = row['companies'] as Map<String, dynamic>? ?? {};
    final addressJson = company['address_json'] as Map<String, dynamic>? ?? {};
    return _ProviderRow(
      companyId: row['company_id'] as String?,
      providerType: row['provider_type'] as String?,
      companyName: company['name'] as String?,
      websiteUrl: company['website_url'] as String?,
      city: addressJson['city'] as String?,
      zip: addressJson['zip'] as String?,
    );
  }
}

class _CompanyMappings {
  _CompanyMappings({
    required this.activeBranchIds,
    required this.pendingBranchIds,
    required this.activeCategoryIds,
    required this.pendingCategoryIds,
  });

  final Set<String> activeBranchIds;
  final Set<String> pendingBranchIds;
  final Set<String> activeCategoryIds;
  final Set<String> pendingCategoryIds;

  bool get hasActiveBranch => activeBranchIds.isNotEmpty;
  bool get hasActiveCategory => activeCategoryIds.isNotEmpty;

  static _CompanyMappings empty() => _CompanyMappings(
        activeBranchIds: <String>{},
        pendingBranchIds: <String>{},
        activeCategoryIds: <String>{},
        pendingCategoryIds: <String>{},
      );
}

class _BranchInfo {
  _BranchInfo({
    required this.id,
    required this.name,
    required this.status,
    required this.normalizedName,
    required this.externalId,
  });

  final String id;
  final String name;
  final String status;
  final String normalizedName;
  final String? externalId;

  static final empty = _BranchInfo(
    id: '',
    name: '',
    status: 'active',
    normalizedName: '',
    externalId: null,
  );
}

class _CategoryInfo {
  _CategoryInfo({
    required this.id,
    required this.branchId,
    required this.name,
    required this.status,
    required this.normalizedName,
    required this.externalId,
  });

  final String id;
  final String branchId;
  final String name;
  final String status;
  final String normalizedName;
  final String? externalId;

  static final empty = _CategoryInfo(
    id: '',
    branchId: '',
    name: '',
    status: 'active',
    normalizedName: '',
    externalId: null,
  );
}

class _Suggestion {
  _Suggestion({
    required this.companyId,
    required this.companyName,
    required this.website,
    required this.providerType,
    required this.branch,
    required this.branchId,
    required this.branchStatus,
    required this.branchConfidence,
    required this.categories,
    required this.existingCategoryCount,
    required this.newCategoryCount,
    required this.avgCategoryConfidence,
    required this.raw,
  });

  final String companyId;
  final String companyName;
  final String? website;
  final String providerType;
  final String branch;
  final String branchId;
  final String branchStatus;
  final double? branchConfidence;
  final List<String> categories;
  final int existingCategoryCount;
  final int newCategoryCount;
  final double? avgCategoryConfidence;
  final Map<String, dynamic> raw;

  Map<String, dynamic> toJson() => {
        'companyId': companyId,
        'companyName': companyName,
        'website': website,
        'providerType': providerType,
        'branch': branch,
        'branchId': branchId,
        'branchStatus': branchStatus,
        'branchConfidence': branchConfidence,
        'categoryIds': categories,
        'existingCategoryCount': existingCategoryCount,
        'newCategoryCount': newCategoryCount,
        'avgCategoryConfidence': avgCategoryConfidence,
        'raw': raw,
        'createdAt': DateTime.now().toUtc().toIso8601String(),
      };
}

class _SuggestionWriter {
  _SuggestionWriter(this.file);

  final File file;
  IOSink? _sink;
  Future<void> _pending = Future.value();

  Future<void> write(_Suggestion suggestion) async {
    file.parent.createSync(recursive: true);
    _sink ??= file.openWrite(mode: FileMode.append);
    _pending = _pending.then((_) {
      _sink!.writeln(jsonEncode(suggestion.toJson()));
    });
    await _pending;
  }

  Future<void> close() async {
    await _sink?.flush();
    await _sink?.close();
  }
}

class _AsyncSemaphore {
  _AsyncSemaphore(this._permits);

  int _permits;
  final List<Completer<void>> _queue = [];

  Future<void> acquire() {
    if (_permits > 0) {
      _permits -= 1;
      return Future.value();
    }
    final completer = Completer<void>();
    _queue.add(completer);
    return completer.future;
  }

  void release() {
    if (_queue.isNotEmpty) {
      _queue.removeAt(0).complete();
      return;
    }
    _permits += 1;
  }
}
