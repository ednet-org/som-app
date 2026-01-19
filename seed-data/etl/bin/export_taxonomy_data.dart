import 'dart:convert';
import 'dart:io';

import 'package:etl/loaders/seed_config.dart';
import 'package:etl/loaders/supabase_client.dart';

Future<void> main(List<String> args) async {
  final env = args.isNotEmpty ? args.first : 'local';
  final branchesOut = args.length > 1 ? args[1] : '../seed/taxonomy/branches.json';
  final categoriesOut = args.length > 2 ? args[2] : '../seed/taxonomy/categories.json';

  final environment = SeedEnvironment.values.firstWhere(
    (e) => e.name == env,
    orElse: () => SeedEnvironment.local,
  );

  final config = SeedConfig.fromEnvironment(environment: environment);
  final supabase = await SeedSupabaseClient.initialize(config);

  final branches = await _fetchAll(
    supabase.client,
    'branches',
    'id,name,normalized_name,external_id,status',
  );
  final categories = await _fetchAll(
    supabase.client,
    'categories',
    'id,branch_id,name,normalized_name,external_id,status',
  );

  final branchesFile = File(branchesOut);
  branchesFile.parent.createSync(recursive: true);
  branchesFile.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(branches));

  final categoriesFile = File(categoriesOut);
  categoriesFile.parent.createSync(recursive: true);
  categoriesFile.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(categories));

  stdout.writeln('Branches: ${branches.length} -> ${branchesFile.path}');
  stdout.writeln('Categories: ${categories.length} -> ${categoriesFile.path}');

  await supabase.close();
}

Future<List<Map<String, dynamic>>> _fetchAll(
  dynamic client,
  String table,
  String columns,
) async {
  const pageSize = 1000;
  final rows = <Map<String, dynamic>>[];
  var from = 0;
  while (true) {
    final result = await client
        .from(table)
        .select(columns)
        .range(from, from + pageSize - 1) as List<dynamic>;
    if (result.isEmpty) break;
    rows.addAll(result.cast<Map<String, dynamic>>());
    if (result.length < pageSize) break;
    from += pageSize;
  }
  return rows;
}
