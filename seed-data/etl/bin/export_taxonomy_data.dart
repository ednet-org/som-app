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

  final branches = await supabase.client
      .from('branches')
      .select('id,name,normalized_name,external_id,status') as List<dynamic>;
  final categories = await supabase.client
      .from('categories')
      .select('id,branch_id,name,normalized_name,external_id,status') as List<dynamic>;

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
