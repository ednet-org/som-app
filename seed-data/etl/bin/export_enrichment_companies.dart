import 'dart:convert';
import 'dart:io';

import 'package:etl/loaders/seed_config.dart';
import 'package:etl/loaders/supabase_client.dart';

const _materialProviderTypes = [
  'haendler',
  'grosshaendler',
  'hersteller',
  'HAENDLER',
  'GROSSHAENDLER',
  'HERSTELLER',
];

Future<void> main(List<String> args) async {
  final env = args.isNotEmpty ? args.first : 'local';
  final outputJson = args.length > 1 ? args[1] : '../seed/taxonomy/enrichment_companies.json';
  final outputCsv = args.length > 2 ? args[2] : '../seed/taxonomy/enrichment_companies.csv';

  final environment = SeedEnvironment.values.firstWhere(
    (e) => e.name == env,
    orElse: () => SeedEnvironment.local,
  );

  final config = SeedConfig.fromEnvironment(environment: environment);
  final supabase = await SeedSupabaseClient.initialize(config);

  const pageSize = 1000;
  var offset = 0;
  final rows = <Map<String, dynamic>>[];

  while (true) {
    final result = await supabase.client
        .from('provider_profiles')
        .select('company_id,provider_type,companies!inner(id,name,website_url)')
        .inFilter('provider_type', _materialProviderTypes)
        .range(offset, offset + pageSize - 1) as List<dynamic>;

    if (result.isEmpty) break;

    for (final row in result.cast<Map<String, dynamic>>()) {
      final company = row['companies'] as Map<String, dynamic>;
      rows.add({
        'companyId': row['company_id'],
        'providerType': row['provider_type'],
        'name': company['name'],
        'websiteUrl': company['website_url'],
      });
    }
    if (result.length < pageSize) break;
    offset += pageSize;
  }

  rows.sort((a, b) => (a['name'] as String? ?? '').compareTo(b['name'] as String? ?? ''));

  final jsonFile = File(outputJson);
  jsonFile.parent.createSync(recursive: true);
  jsonFile.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(rows));

  final csvFile = File(outputCsv);
  csvFile.parent.createSync(recursive: true);
  final csvSink = csvFile.openWrite();
  csvSink.writeln('company_id,provider_type,name,website_url');
  for (final row in rows) {
    final companyId = row['companyId'] ?? '';
    final providerType = row['providerType'] ?? '';
    final name = (row['name'] ?? '').toString().replaceAll('"', '""');
    final website = (row['websiteUrl'] ?? '').toString().replaceAll('"', '""');
    csvSink.writeln('"$companyId","$providerType","$name","$website"');
  }
  await csvSink.flush();
  await csvSink.close();

  stdout.writeln('Exported ${rows.length} companies.');
  stdout.writeln('JSON: ${jsonFile.path}');
  stdout.writeln('CSV: ${csvFile.path}');
}
