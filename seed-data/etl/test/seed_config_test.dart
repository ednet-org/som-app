import 'dart:io';

import 'package:etl/loaders/seed_config.dart';
import 'package:test/test.dart';

void main() {
  test('SeedConfig honors skipTaxonomy flag', () async {
    final dir = await Directory.systemTemp.createTemp('seed-config-test');
    final envFile = File('${dir.path}/.env.local');
    await envFile.writeAsString('''
SUPABASE_URL=http://localhost
SUPABASE_SERVICE_KEY=local-key
''');

    final config = SeedConfig.fromEnvironment(
      environment: SeedEnvironment.local,
      inputPath: dir.path,
      skipTaxonomy: true,
    );

    expect(config.skipTaxonomy, isTrue);
  });

  test('SeedConfig defaults skipTaxonomy to false', () async {
    final dir = await Directory.systemTemp.createTemp('seed-config-test');
    final envFile = File('${dir.path}/.env.local');
    await envFile.writeAsString('''
SUPABASE_URL=http://localhost
SUPABASE_SERVICE_KEY=local-key
''');

    final config = SeedConfig.fromEnvironment(
      environment: SeedEnvironment.local,
      inputPath: dir.path,
    );

    expect(config.skipTaxonomy, isFalse);
  });
}
