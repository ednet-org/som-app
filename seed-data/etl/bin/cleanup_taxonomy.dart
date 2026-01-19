import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:args/args.dart';
import 'package:etl/mappers/entity_to_record.dart';
import 'package:etl/utils/name_normalizer.dart';
import 'package:http/http.dart' as http;

class BranchEntry {
  BranchEntry({
    required this.id,
    required this.name,
    required this.status,
    this.externalId,
  }) {
    normalizedName = normalizeTaxonomyName(name);
    normalizedLoose = normalizeTaxonomyNameLoose(name);
  }

  final String id;
  final String name;
  final String status;
  final String? externalId;

  late final String normalizedName;
  late final String normalizedLoose;
  String? newExternalId;
  String? newId;

  bool get isActive => status == 'active';
}

class CategoryEntry {
  CategoryEntry({
    required this.id,
    required this.branchId,
    required this.name,
    required this.status,
    this.externalId,
  }) {
    normalizedName = normalizeTaxonomyName(name);
    normalizedLoose = normalizeTaxonomyNameLoose(name);
  }

  final String id;
  String branchId;
  final String name;
  final String status;
  final String? externalId;

  late final String normalizedName;
  late final String normalizedLoose;
  String? newExternalId;
  String? newId;

  bool get isActive => status == 'active';
}

class DisjointSet {
  final Map<String, String> _parent = {};

  void add(String id) {
    _parent.putIfAbsent(id, () => id);
  }

  String find(String id) {
    final parent = _parent[id];
    if (parent == null) {
      _parent[id] = id;
      return id;
    }
    if (parent == id) {
      return id;
    }
    final root = find(parent);
    _parent[id] = root;
    return root;
  }

  void union(String a, String b) {
    final rootA = find(a);
    final rootB = find(b);
    if (rootA == rootB) {
      return;
    }
    _parent[rootB] = rootA;
  }
}

class PairScore {
  PairScore(this.a, this.b, this.score);
  final int a;
  final int b;
  final double score;
}

Future<void> main(List<String> args) async {
  final parser = ArgParser()
    ..addOption(
      'branches-file',
      defaultsTo: '../out/taxonomy/branches.json',
      help: 'Exported branches JSON from the database.',
    )
    ..addOption(
      'categories-file',
      defaultsTo: '../out/taxonomy/categories.json',
      help: 'Exported categories JSON from the database.',
    )
    ..addOption(
      'input-jsonl',
      defaultsTo: '../out/enrichment_gpt41_merged.jsonl',
      help: 'Merged enrichment JSONL file.',
    )
    ..addOption(
      'output-jsonl',
      defaultsTo: '../out/enrichment_gpt41_merged_clean.jsonl',
      help: 'Cleaned enrichment JSONL output file.',
    )
    ..addOption(
      'output-branches',
      defaultsTo: '../out/taxonomy/branches_clean.json',
      help: 'Cleaned branches JSON output file.',
    )
    ..addOption(
      'output-categories',
      defaultsTo: '../out/taxonomy/categories_clean.json',
      help: 'Cleaned categories JSON output file.',
    )
    ..addOption(
      'plan-out',
      defaultsTo: '../out/taxonomy/merge_plan.json',
      help: 'Merge plan JSON output file.',
    )
    ..addFlag(
      'llm',
      defaultsTo: true,
      help: 'Use local LLM to confirm semantic duplicates.',
    )
    ..addOption(
      'llm-model',
      defaultsTo: 'qwen2.5:14b',
      help: 'Ollama model for semantic duplicate checks.',
    )
    ..addOption(
      'max-llm-branches',
      defaultsTo: '200',
      help: 'Maximum LLM comparisons for branches.',
    )
    ..addOption(
      'max-llm-categories',
      defaultsTo: '100',
      help: 'Maximum LLM comparisons for categories.',
    )
    ..addFlag(
      'llm-categories',
      defaultsTo: true,
      help: 'Enable LLM duplicate checks for categories.',
    )
    ..addOption(
      'max-token-group',
      defaultsTo: '200',
      help: 'Skip tokens that appear in more than this many entries.',
    )
    ..addOption(
      'min-jaccard',
      defaultsTo: '0.6',
      help: 'Minimum token Jaccard similarity to consider.',
    )
    ..addOption(
      'min-dice',
      defaultsTo: '0.9',
      help: 'Minimum Dice coefficient to consider.',
    )
    ..addFlag(
      'dry-run',
      defaultsTo: false,
      help: 'Do not write outputs.',
    );

  final results = parser.parse(args);
  final branchesPath = results['branches-file'] as String;
  final categoriesPath = results['categories-file'] as String;
  final inputJsonl = results['input-jsonl'] as String;
  final outputJsonl = results['output-jsonl'] as String;
  final outputBranches = results['output-branches'] as String;
  final outputCategories = results['output-categories'] as String;
  final planOut = results['plan-out'] as String;
  final useLlm = results['llm'] as bool;
  final llmModel = results['llm-model'] as String;
  final maxLlmBranches =
      int.tryParse(results['max-llm-branches'] as String) ?? 200;
  final maxLlmCategories =
      int.tryParse(results['max-llm-categories'] as String) ?? 100;
  final llmCategories = results['llm-categories'] as bool;
  final maxTokenGroup =
      int.tryParse(results['max-token-group'] as String) ?? 200;
  final minJaccard = double.tryParse(results['min-jaccard'] as String) ?? 0.6;
  final minDice = double.tryParse(results['min-dice'] as String) ?? 0.9;
  final dryRun = results['dry-run'] as bool;

  final mapper = EntityToRecordMapper();

  final branches = _loadBranches(branchesPath);
  final categories = _loadCategories(categoriesPath);
  final enrichment = await _loadJsonl(inputJsonl);

  final branchUsage = _countUsage(
    enrichment,
    (row) => row['branchId'] as String?,
  );
  final categoryUsage = _countUsageList(
    enrichment,
    (row) => (row['categoryIds'] as List?)?.whereType<String>().toList() ?? [],
  );

  final branchMapResult = await _dedupeBranches(
    branches,
    branchUsage,
    mapper,
    useLlm: useLlm,
    llmModel: llmModel,
    maxLlm: maxLlmBranches,
    minJaccard: minJaccard,
    minDice: minDice,
    maxTokenGroup: maxTokenGroup,
  );

  final branchesClean = branchMapResult.cleaned;
  final branchIdMap = branchMapResult.idMap;

  final categoriesMapped = _applyBranchMapping(categories, branchIdMap);

  final categoryMapResult = await _dedupeCategories(
    categoriesMapped,
    branchesClean,
    categoryUsage,
    mapper,
    useLlm: useLlm && llmCategories,
    llmModel: llmModel,
    maxLlm: maxLlmCategories,
    minJaccard: minJaccard,
    minDice: minDice,
    maxTokenGroup: maxTokenGroup,
  );

  final categoriesClean = categoryMapResult.cleaned;
  final categoryIdMap = categoryMapResult.idMap;

  final enrichmentClean = _rewriteEnrichment(
    enrichment,
    branchesClean,
    categoriesClean,
    branchIdMap,
    categoryIdMap,
  );

  final plan = {
    'generatedAt': DateTime.now().toUtc().toIso8601String(),
    'llm': useLlm,
    'llmModel': llmModel,
    'branches': {
      'total': branches.length,
      'cleaned': branchesClean.length,
      'merged': branchMapResult.mergedCount,
    },
    'categories': {
      'total': categories.length,
      'cleaned': categoriesClean.length,
      'merged': categoryMapResult.mergedCount,
    },
    'branchIdMap': branchIdMap,
    'categoryIdMap': categoryIdMap,
  };

  stdout.writeln('Branches: ${branches.length} -> ${branchesClean.length}');
  stdout.writeln('Categories: ${categories.length} -> ${categoriesClean.length}');
  stdout.writeln('Enrichment rows: ${enrichment.length}');

  if (dryRun) {
    stdout.writeln('Dry run enabled; no files written.');
    return;
  }

  _writeJson(outputBranches, branchesClean.map(_branchToJson).toList());
  _writeJson(outputCategories, categoriesClean.map(_categoryToJson).toList());
  await _writeJsonl(outputJsonl, enrichmentClean);
  _writeJson(planOut, plan);
}

class DedupeResult<T> {
  DedupeResult({
    required this.cleaned,
    required this.idMap,
    required this.mergedCount,
  });

  final List<T> cleaned;
  final Map<String, String> idMap;
  final int mergedCount;
}

Future<DedupeResult<BranchEntry>> _dedupeBranches(
  List<BranchEntry> branches,
  Map<String, int> usage,
  EntityToRecordMapper mapper, {
  required bool useLlm,
  required String llmModel,
  required int maxLlm,
  required double minJaccard,
  required double minDice,
  required int maxTokenGroup,
}) async {
  final dsu = DisjointSet();
  for (final branch in branches) {
    dsu.add(branch.id);
    branch.newExternalId =
        branch.isActive ? (branch.externalId ?? branch.normalizedName) : branch.normalizedName;
    branch.newId = branch.isActive
        ? branch.id
        : mapper.generateBranchId(branch.newExternalId ?? branch.normalizedName);
  }

  final groupsByLoose = <String, List<BranchEntry>>{};
  for (final branch in branches) {
    groupsByLoose.putIfAbsent(branch.normalizedLoose, () => []).add(branch);
  }
  for (final group in groupsByLoose.values) {
    if (group.length < 2) continue;
    final first = group.first.id;
    for (final branch in group.skip(1)) {
      dsu.union(first, branch.id);
    }
  }

  if (useLlm) {
    stdout.writeln('Building branch candidate pairs...');
    final candidates = _candidatePairs(
      branches,
      minJaccard: minJaccard,
      minDice: minDice,
      maxPairsPerItem: 5,
      maxTokenGroupSize: maxTokenGroup,
    );
    stdout.writeln('Branch LLM candidates: ${candidates.length}');
    var llmCount = 0;
    for (final pair in candidates) {
      if (llmCount >= maxLlm) break;
      final a = branches[pair.a];
      final b = branches[pair.b];
      if (dsu.find(a.id) == dsu.find(b.id)) continue;
      final same = await _llmSame(
        llmModel,
        'branch',
        a.name,
        b.name,
      );
      llmCount++;
      if (llmCount % 25 == 0) {
        stdout.writeln('Branch LLM progress: $llmCount/$maxLlm');
      }
      if (same) {
        dsu.union(a.id, b.id);
      }
    }
  }

  final grouped = <String, List<BranchEntry>>{};
  for (final branch in branches) {
    final root = dsu.find(branch.id);
    grouped.putIfAbsent(root, () => []).add(branch);
  }

  final idMap = <String, String>{};
  final cleaned = <BranchEntry>[];
  var mergedCount = 0;

  for (final group in grouped.values) {
    final canonical = _pickBranchCanonical(group, usage);
    final canonicalId = canonical.isActive ? canonical.id : canonical.newId!;
    for (final branch in group) {
      idMap[branch.id] = canonicalId;
      if (branch.id != canonical.id) {
        mergedCount++;
      }
    }

    final merged = BranchEntry(
      id: canonicalId,
      name: canonical.name,
      status: canonical.status,
      externalId: canonical.isActive
          ? (canonical.externalId ?? canonical.newExternalId)
          : canonical.newExternalId,
    );
    cleaned.add(merged);
  }

  cleaned.sort((a, b) => a.name.compareTo(b.name));

  return DedupeResult(
    cleaned: cleaned,
    idMap: idMap,
    mergedCount: mergedCount,
  );
}

Future<DedupeResult<CategoryEntry>> _dedupeCategories(
  List<CategoryEntry> categories,
  List<BranchEntry> branches,
  Map<String, int> usage,
  EntityToRecordMapper mapper, {
  required bool useLlm,
  required String llmModel,
  required int maxLlm,
  required double minJaccard,
  required double minDice,
  required int maxTokenGroup,
}) async {
  final branchById = {for (final b in branches) b.id: b};
  final dsu = DisjointSet();

  for (final category in categories) {
    dsu.add(category.id);
    final branch = branchById[category.branchId];
    final branchExternalId = branch?.externalId ?? branch?.normalizedName ?? '';
    category.newExternalId = category.isActive
        ? (category.externalId ??
            'name:$branchExternalId:${category.normalizedName}')
        : 'name:$branchExternalId:${category.normalizedName}';
    category.newId = category.isActive
        ? category.id
        : mapper.generateCategoryId(category.newExternalId!);
  }

  final groupsByLoose = <String, List<CategoryEntry>>{};
  for (final category in categories) {
    final key = '${category.branchId}|${category.normalizedLoose}';
    groupsByLoose.putIfAbsent(key, () => []).add(category);
  }
  for (final group in groupsByLoose.values) {
    if (group.length < 2) continue;
    final first = group.first.id;
    for (final category in group.skip(1)) {
      dsu.union(first, category.id);
    }
  }

  if (useLlm) {
    stdout.writeln('Building category candidate pairs...');
    final candidates = _candidatePairs(
      categories,
      minJaccard: minJaccard,
      minDice: minDice,
      maxPairsPerItem: 5,
      groupKey: (entry) => (entry as CategoryEntry).branchId,
      maxTokenGroupSize: maxTokenGroup,
    );
    stdout.writeln('Category LLM candidates: ${candidates.length}');
    var llmCount = 0;
    for (final pair in candidates) {
      if (llmCount >= maxLlm) break;
      final a = categories[pair.a];
      final b = categories[pair.b];
      if (dsu.find(a.id) == dsu.find(b.id)) continue;
      final branchName = branchById[a.branchId]?.name;
      final same = await _llmSame(
        llmModel,
        'category',
        a.name,
        b.name,
        context: branchName,
      );
      llmCount++;
      if (llmCount % 25 == 0) {
        stdout.writeln('Category LLM progress: $llmCount/$maxLlm');
      }
      if (same) {
        dsu.union(a.id, b.id);
      }
    }
  }

  final grouped = <String, List<CategoryEntry>>{};
  for (final category in categories) {
    final root = dsu.find(category.id);
    grouped.putIfAbsent(root, () => []).add(category);
  }

  final idMap = <String, String>{};
  final cleaned = <CategoryEntry>[];
  var mergedCount = 0;

  for (final group in grouped.values) {
    final canonical = _pickCategoryCanonical(group, usage);
    final canonicalId = canonical.isActive ? canonical.id : canonical.newId!;
    for (final category in group) {
      idMap[category.id] = canonicalId;
      if (category.id != canonical.id) {
        mergedCount++;
      }
    }

    final merged = CategoryEntry(
      id: canonicalId,
      branchId: canonical.branchId,
      name: canonical.name,
      status: canonical.status,
      externalId: canonical.isActive
          ? (canonical.externalId ?? canonical.newExternalId)
          : canonical.newExternalId,
    );
    cleaned.add(merged);
  }

  cleaned.sort((a, b) {
    final branchCompare = a.branchId.compareTo(b.branchId);
    if (branchCompare != 0) return branchCompare;
    return a.name.compareTo(b.name);
  });

  return DedupeResult(
    cleaned: cleaned,
    idMap: idMap,
    mergedCount: mergedCount,
  );
}

List<CategoryEntry> _applyBranchMapping(
  List<CategoryEntry> categories,
  Map<String, String> branchMap,
) {
  for (final category in categories) {
    category.branchId = branchMap[category.branchId] ?? category.branchId;
  }
  return categories;
}

BranchEntry _pickBranchCanonical(
  List<BranchEntry> group,
  Map<String, int> usage,
) {
  final active = group.where((b) => b.isActive).toList();
  final candidates = active.isNotEmpty ? active : group;
  candidates.sort((a, b) {
    final usageA = usage[a.id] ?? 0;
    final usageB = usage[b.id] ?? 0;
    if (usageA != usageB) {
      return usageB.compareTo(usageA);
    }
    if (a.name.length != b.name.length) {
      return a.name.length.compareTo(b.name.length);
    }
    return a.name.compareTo(b.name);
  });
  return candidates.first;
}

CategoryEntry _pickCategoryCanonical(
  List<CategoryEntry> group,
  Map<String, int> usage,
) {
  final active = group.where((c) => c.isActive).toList();
  final candidates = active.isNotEmpty ? active : group;
  candidates.sort((a, b) {
    final usageA = usage[a.id] ?? 0;
    final usageB = usage[b.id] ?? 0;
    if (usageA != usageB) {
      return usageB.compareTo(usageA);
    }
    if (a.name.length != b.name.length) {
      return a.name.length.compareTo(b.name.length);
    }
    return a.name.compareTo(b.name);
  });
  return candidates.first;
}

List<Map<String, dynamic>> _rewriteEnrichment(
  List<Map<String, dynamic>> enrichment,
  List<BranchEntry> branches,
  List<CategoryEntry> categories,
  Map<String, String> branchIdMap,
  Map<String, String> categoryIdMap,
) {
  final branchById = {for (final b in branches) b.id: b};
  final categoryById = {for (final c in categories) c.id: c};

  return enrichment.map((row) {
    final updated = Map<String, dynamic>.from(row);
    final oldBranchId = row['branchId'] as String?;
    final newBranchId = oldBranchId != null
        ? (branchIdMap[oldBranchId] ?? oldBranchId)
        : null;
    if (newBranchId != null) {
      updated['branchId'] = newBranchId;
      final branch = branchById[newBranchId];
      if (branch != null) {
        updated['branch'] = branch.name;
      }
    }

    final oldCategoryIds = (row['categoryIds'] as List?)
            ?.whereType<String>()
            .toList() ??
        [];
    final newCategoryIds = <String>[];
    for (final id in oldCategoryIds) {
      newCategoryIds.add(categoryIdMap[id] ?? id);
    }
    updated['categoryIds'] = newCategoryIds;

    final raw = row['raw'];
    if (raw is Map<String, dynamic>) {
      final rawCopy = Map<String, dynamic>.from(raw);
      final rawBranch = rawCopy['branch'];
      if (rawBranch is Map<String, dynamic> && newBranchId != null) {
        final branch = branchById[newBranchId];
        if (branch != null) {
          rawCopy['branch'] = {
            ...rawBranch,
            'name': branch.name,
          };
        }
      }
      final rawCategories = rawCopy['categories'];
      if (rawCategories is List) {
        for (var i = 0; i < rawCategories.length; i++) {
          final entry = rawCategories[i];
          if (entry is Map<String, dynamic> && i < newCategoryIds.length) {
            final category = categoryById[newCategoryIds[i]];
            if (category != null) {
              rawCategories[i] = {
                ...entry,
                'name': category.name,
              };
            }
          }
        }
      }
      updated['raw'] = rawCopy;
    }

    return updated;
  }).toList();
}

List<BranchEntry> _loadBranches(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    throw StateError('Branches file not found: $path');
  }
  final raw = jsonDecode(file.readAsStringSync());
  if (raw is! List) {
    throw StateError('Invalid branches JSON: $path');
  }
  return raw.whereType<Map>().map((entry) {
    final row = entry.cast<String, dynamic>();
    return BranchEntry(
      id: row['id'] as String,
      name: row['name'] as String,
      status: row['status'] as String? ?? 'active',
      externalId: row['external_id'] as String?,
    );
  }).toList();
}

List<CategoryEntry> _loadCategories(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    throw StateError('Categories file not found: $path');
  }
  final raw = jsonDecode(file.readAsStringSync());
  if (raw is! List) {
    throw StateError('Invalid categories JSON: $path');
  }
  return raw.whereType<Map>().map((entry) {
    final row = entry.cast<String, dynamic>();
    return CategoryEntry(
      id: row['id'] as String,
      branchId: row['branch_id'] as String,
      name: row['name'] as String,
      status: row['status'] as String? ?? 'active',
      externalId: row['external_id'] as String?,
    );
  }).toList();
}

Future<List<Map<String, dynamic>>> _loadJsonl(String path) async {
  final file = File(path);
  if (!file.existsSync()) {
    throw StateError('Enrichment JSONL not found: $path');
  }
  final lines = await file.readAsLines();
  final rows = <Map<String, dynamic>>[];
  for (final line in lines) {
    if (line.trim().isEmpty) continue;
    final row = jsonDecode(line) as Map<String, dynamic>;
    rows.add(row);
  }
  return rows;
}

Future<void> _writeJsonl(
  String path,
  List<Map<String, dynamic>> rows,
) async {
  final file = File(path);
  file.parent.createSync(recursive: true);
  final sink = file.openWrite();
  for (final row in rows) {
    sink.writeln(jsonEncode(row));
  }
  await sink.flush();
  await sink.close();
}

void _writeJson(String path, Object data) {
  final file = File(path);
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(data));
}

Map<String, int> _countUsage(
  List<Map<String, dynamic>> rows,
  String? Function(Map<String, dynamic>) extract,
) {
  final counts = <String, int>{};
  for (final row in rows) {
    final id = extract(row);
    if (id == null) continue;
    counts[id] = (counts[id] ?? 0) + 1;
  }
  return counts;
}

Map<String, int> _countUsageList(
  List<Map<String, dynamic>> rows,
  List<String> Function(Map<String, dynamic>) extract,
) {
  final counts = <String, int>{};
  for (final row in rows) {
    for (final id in extract(row)) {
      counts[id] = (counts[id] ?? 0) + 1;
    }
  }
  return counts;
}

List<PairScore> _candidatePairs(
  List<dynamic> items, {
  required double minJaccard,
  required double minDice,
  required int maxPairsPerItem,
  String Function(dynamic entry)? groupKey,
  required int maxTokenGroupSize,
}) {
  final tokenIndex = <String, List<int>>{};
  final tokensByIndex = <int, Set<String>>{};

  for (var i = 0; i < items.length; i++) {
    final normalized = (items[i] as dynamic).normalizedName as String;
    final tokens = normalized
        .split(' ')
        .where((t) => t.length >= 3)
        .toSet();
    tokensByIndex[i] = tokens;
    for (final token in tokens) {
      tokenIndex.putIfAbsent(token, () => []).add(i);
    }
  }

  final pairScores = <PairScore>[];
  final seen = <String>{};

  for (var i = 0; i < items.length; i++) {
    final entry = items[i];
    final tokens = tokensByIndex[i] ?? {};
    final candidates = <int>{};
    for (final token in tokens) {
      final group = tokenIndex[token];
      if (group == null) continue;
      if (group.length > maxTokenGroupSize) continue;
      candidates.addAll(group);
    }
    final filtered = candidates.where((c) => c > i);
    final scored = <PairScore>[];

    for (final j in filtered) {
      if (groupKey != null) {
        if (groupKey(entry) != groupKey(items[j])) continue;
      }
      final aTokens = tokensByIndex[i] ?? {};
      final bTokens = tokensByIndex[j] ?? {};
      if (aTokens.isEmpty || bTokens.isEmpty) continue;
      final intersection = aTokens.intersection(bTokens).length;
      final union = aTokens.union(bTokens).length;
      final jaccard = union == 0 ? 0.0 : intersection / union;
      final dice = _diceCoefficient(
        (entry as dynamic).normalizedName as String,
        (items[j] as dynamic).normalizedName as String,
      );
      if (jaccard < minJaccard && dice < minDice) {
        continue;
      }
      scored.add(PairScore(i, j, max(jaccard, dice)));
    }

    scored.sort((a, b) => b.score.compareTo(a.score));
    for (final pair in scored.take(maxPairsPerItem)) {
      final key = '${pair.a}|${pair.b}';
      if (seen.add(key)) {
        pairScores.add(pair);
      }
    }

    if (i > 0 && i % 2000 == 0) {
      stdout.writeln('Candidate pairs: processed $i/${items.length}');
    }
  }

  pairScores.sort((a, b) => b.score.compareTo(a.score));
  return pairScores;
}

double _diceCoefficient(String a, String b) {
  if (a == b) return 1.0;
  if (a.length < 2 || b.length < 2) return 0.0;
  final aBigrams = <String, int>{};
  for (var i = 0; i < a.length - 1; i++) {
    final bg = a.substring(i, i + 2);
    aBigrams[bg] = (aBigrams[bg] ?? 0) + 1;
  }
  var overlap = 0;
  for (var i = 0; i < b.length - 1; i++) {
    final bg = b.substring(i, i + 2);
    final count = aBigrams[bg];
    if (count != null && count > 0) {
      aBigrams[bg] = count - 1;
      overlap++;
    }
  }
  return (2.0 * overlap) / (a.length + b.length - 2);
}

Future<bool> _llmSame(
  String model,
  String kind,
  String a,
  String b, {
  String? context,
}) async {
  final prompt = StringBuffer()
    ..writeln('You are cleaning a B2B provider taxonomy.')
    ..writeln('Decide if the two $kind names refer to the same concept.')
    ..writeln('Answer JSON only: {"same":true|false}.')
    ..writeln('Merge only if they are true synonyms or trivial wording changes.')
    ..writeln('Do NOT merge if one is broader/narrower.')
    ..writeln('Name A: "$a"')
    ..writeln('Name B: "$b"');
  if (context != null) {
    prompt.writeln('Branch context: "$context"');
  }

  try {
    final response = await http.post(
      Uri.parse('http://localhost:11434/api/generate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'model': model,
        'prompt': prompt.toString(),
        'stream': false,
        'options': {'temperature': 0},
      }),
    );
    if (response.statusCode != 200) {
      stderr.writeln('LLM error ${response.statusCode}: ${response.body}');
      return false;
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final text = data['response'] as String? ?? '';
    final jsonText = _extractJson(text);
    if (jsonText == null) {
      stderr.writeln('LLM non-JSON response: $text');
      return false;
    }
    final parsed = jsonDecode(jsonText) as Map<String, dynamic>;
    return parsed['same'] == true;
  } catch (e) {
    stderr.writeln('LLM request failed: $e');
    return false;
  }
}

String? _extractJson(String text) {
  final start = text.indexOf('{');
  final end = text.lastIndexOf('}');
  if (start == -1 || end == -1 || end <= start) {
    return null;
  }
  return text.substring(start, end + 1);
}

Map<String, dynamic> _branchToJson(BranchEntry entry) {
  return {
    'id': entry.id,
    'name': entry.name,
    'normalized_name': entry.normalizedName,
    'external_id': entry.externalId,
    'status': entry.status,
  };
}

Map<String, dynamic> _categoryToJson(CategoryEntry entry) {
  return {
    'id': entry.id,
    'branch_id': entry.branchId,
    'name': entry.name,
    'normalized_name': entry.normalizedName,
    'external_id': entry.externalId,
    'status': entry.status,
  };
}
