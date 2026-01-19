import 'dart:convert';
import 'dart:io';

import 'package:etl/utils/name_normalizer.dart';

String _sqlString(String? value) {
  if (value == null) return 'NULL';
  final escaped = value.replaceAll("'", "''");
  return "'$escaped'";
}

Future<Map<String, Map<String, dynamic>>> _loadExisting(
  String path,
  String label,
) async {
  final file = File(path);
  if (!file.existsSync()) {
    stderr.writeln('Missing $label file: $path');
    exit(1);
  }
  final raw = jsonDecode(await file.readAsString());
  if (raw is! List) {
    stderr.writeln('Invalid $label JSON (expected list): $path');
    exit(1);
  }
  final map = <String, Map<String, dynamic>>{};
  for (final entry in raw) {
    if (entry is! Map) continue;
    final row = entry.cast<String, dynamic>();
    final id = row['id'] as String?;
    if (id == null || id.isEmpty) continue;
    map[id] = row;
  }
  return map;
}

String _timestampUtc() {
  final now = DateTime.now().toUtc();
  String two(int value) => value.toString().padLeft(2, '0');
  return '${now.year}${two(now.month)}${two(now.day)}'
      '${two(now.hour)}${two(now.minute)}${two(now.second)}';
}

List<String> _rawCategoryNames(Map<String, dynamic> raw) {
  final categories = raw['categories'] ?? raw['c'];
  if (categories is List) {
    final names = <String>[];
    for (final entry in categories) {
      if (entry is Map<String, dynamic>) {
        final name = entry['name'] as String?;
        if (name != null && name.trim().isNotEmpty) {
          names.add(name.trim());
        }
      } else if (entry is String) {
        if (entry.trim().isNotEmpty) {
          names.add(entry.trim());
        }
      }
    }
    return names;
  }
  return [];
}

void _writeInsert(
  IOSink sink,
  String table,
  List<String> columns,
  List<List<String>> rows, {
  String? conflict,
}) {
  if (rows.isEmpty) return;
  const chunkSize = 500;
  for (var i = 0; i < rows.length; i += chunkSize) {
    final end = (i + chunkSize > rows.length) ? rows.length : i + chunkSize;
    final chunk = rows.sublist(i, end);
    sink.writeln('INSERT INTO $table (${columns.join(', ')}) VALUES');
    for (var j = 0; j < chunk.length; j++) {
      final values = chunk[j].join(', ');
      final suffix = j == chunk.length - 1 ? '' : ',';
      sink.writeln('  ($values)$suffix');
    }
    if (conflict != null) {
      sink.writeln('ON CONFLICT $conflict DO NOTHING;');
    } else {
      sink.writeln(';');
    }
  }
}

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    stderr.writeln(
      'Usage: dart run bin/generate_enrichment_sql.dart <input_jsonl> [output_sql]\n'
      '  Optional flags:\n'
      '    --branches-file <path>\n'
      '    --categories-file <path>\n'
      '    --output <path>\n'
      '    --migration (write to supabase/migrations)\n'
      '    --include-existing (insert branches/categories even if in reference files)\n'
      '    --migration-dir <path>\n'
      '    --env <name> (ignored; kept for backward compatibility)',
    );
    exit(1);
  }

  String? inputPath;
  String? outputPath;
  var branchesFile = '../seed/taxonomy/branches.json';
  var categoriesFile = '../seed/taxonomy/categories.json';
  var migrationDir = '../../supabase/migrations';
  var writeMigration = false;
  var includeExisting = false;

  for (var i = 0; i < args.length; i++) {
    final arg = args[i];
    if (arg == '--branches-file' && i + 1 < args.length) {
      branchesFile = args[++i];
    } else if (arg == '--categories-file' && i + 1 < args.length) {
      categoriesFile = args[++i];
    } else if (arg == '--output' && i + 1 < args.length) {
      outputPath = args[++i];
    } else if (arg == '--migration') {
      writeMigration = true;
    } else if (arg == '--include-existing') {
      includeExisting = true;
    } else if (arg == '--migration-dir' && i + 1 < args.length) {
      migrationDir = args[++i];
    } else if (arg == '--env' && i + 1 < args.length) {
      i++; // ignored (backward compatibility)
    } else if (arg.startsWith('-')) {
      stderr.writeln('Unknown flag: $arg');
      exit(1);
    } else if (inputPath == null) {
      inputPath = arg;
    } else if (outputPath == null) {
      outputPath = arg;
    } else {
      stderr.writeln('Unexpected argument: $arg');
      exit(1);
    }
  }

  if (inputPath == null) {
    stderr.writeln('Input JSONL is required.');
    exit(1);
  }

  if (outputPath == null) {
    if (writeMigration) {
      final dir = Directory(migrationDir);
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }
      outputPath = '${dir.path}/${_timestampUtc()}_enrichment_taxonomy.sql';
    } else {
      outputPath = '../seed/taxonomy/enrichment_seed.sql';
    }
  }

  final existingBranches = await _loadExisting(branchesFile, 'branches');
  final existingCategories = await _loadExisting(categoriesFile, 'categories');

  final branchRows = <String, List<String>>{};
  final categoryRows = <String, List<String>>{};
  final companyBranchRows = <List<String>>[];
  final companyCategoryRows = <List<String>>[];

  final generatedAt = DateTime.now().toUtc().toIso8601String();

  final file = File(inputPath);
  if (!file.existsSync()) {
    stderr.writeln('Input JSONL not found: $inputPath');
    exit(1);
  }

  final lines = await file.readAsLines();
  for (final line in lines) {
    if (line.trim().isEmpty) continue;
    final data = jsonDecode(line) as Map<String, dynamic>;
    final companyId = data['companyId'] as String?;
    final branchId = data['branchId'] as String?;
    final branchName = (data['branch'] as String?)?.trim();
    final branchConfidence = data['branchConfidence'];
    final raw = (data['raw'] as Map<String, dynamic>?) ?? {};
    if (companyId == null ||
        branchId == null ||
        branchName == null ||
        branchName.isEmpty) {
      continue;
    }

    final branchNormalized = normalizeTaxonomyName(branchName);
    final branchExternalId = branchNormalized;
    if (includeExisting || !existingBranches.containsKey(branchId)) {
      branchRows[branchId] ??= [
        _sqlString(branchId),
        _sqlString(branchName),
        _sqlString(branchExternalId),
        _sqlString(branchNormalized),
        _sqlString('pending'),
      ];
    }

    companyBranchRows.add([
      _sqlString(companyId),
      _sqlString(branchId),
      _sqlString('openai'),
      branchConfidence == null ? 'NULL' : branchConfidence.toString(),
      _sqlString('pending'),
      _sqlString(generatedAt),
      _sqlString(generatedAt),
    ]);

    final categoryIds = (data['categoryIds'] as List<dynamic>? ?? [])
        .whereType<String>()
        .toList();
    final rawNames = _rawCategoryNames(raw);

    for (var i = 0; i < categoryIds.length; i++) {
      final categoryId = categoryIds[i];
      String? categoryName;
      if (i < rawNames.length) {
        categoryName = rawNames[i];
      } else if (existingCategories.containsKey(categoryId)) {
        categoryName = existingCategories[categoryId]!['name'] as String?;
      }
      if (categoryName == null || categoryName.trim().isEmpty) {
        continue;
      }
      final normalized = normalizeTaxonomyName(categoryName);
      final categoryExternalId = 'name:$branchNormalized:$normalized';
      if (includeExisting || !existingCategories.containsKey(categoryId)) {
        categoryRows[categoryId] ??= [
          _sqlString(categoryId),
          _sqlString(branchId),
          _sqlString(categoryName),
          _sqlString(categoryExternalId),
          _sqlString(normalized),
          _sqlString('pending'),
        ];
      }

      companyCategoryRows.add([
        _sqlString(companyId),
        _sqlString(categoryId),
        _sqlString('openai'),
        'NULL',
        _sqlString('pending'),
        _sqlString(generatedAt),
        _sqlString(generatedAt),
      ]);
    }
  }

  final output = File(outputPath);
  output.parent.createSync(recursive: true);
  final sink = output.openWrite();
  sink.writeln('-- Generated enrichment seed');
  sink.writeln('BEGIN;');

  _writeInsert(
    sink,
    'branches',
    ['id', 'name', 'external_id', 'normalized_name', 'status'],
    branchRows.values.toList(),
    conflict: '(normalized_name)',
  );

  _writeInsert(
    sink,
    'categories',
    ['id', 'branch_id', 'name', 'external_id', 'normalized_name', 'status'],
    categoryRows.values.toList(),
    conflict: '(branch_id, normalized_name)',
  );

  _writeInsert(
    sink,
    'company_branches',
    [
      'company_id',
      'branch_id',
      'source',
      'confidence',
      'status',
      'created_at',
      'updated_at'
    ],
    companyBranchRows,
    conflict: '(company_id, branch_id)',
  );

  _writeInsert(
    sink,
    'company_categories',
    [
      'company_id',
      'category_id',
      'source',
      'confidence',
      'status',
      'created_at',
      'updated_at'
    ],
    companyCategoryRows,
    conflict: '(company_id, category_id)',
  );

  sink.writeln('COMMIT;');
  await sink.flush();
  await sink.close();

  stdout.writeln('Branches: ${branchRows.length}');
  stdout.writeln('Categories: ${categoryRows.length}');
  stdout.writeln('Company branches: ${companyBranchRows.length}');
  stdout.writeln('Company categories: ${companyCategoryRows.length}');
  stdout.writeln('SQL written to ${output.path}');
}
