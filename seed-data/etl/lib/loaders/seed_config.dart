/// Configuration for database seeding operations.
library;

import 'dart:io';

import 'package:dotenv/dotenv.dart';

/// Environment target for seeding.
enum SeedEnvironment {
  local,
  staging,
  production;

  String get envFileName => '.env.$name';
}

/// Configuration for the database seeder.
class SeedConfig {
  SeedConfig._({
    required this.supabaseUrl,
    required this.supabaseServiceKey,
    required this.environment,
    required this.batchSize,
    required this.dryRun,
    required this.verifyOnly,
  });

  /// Load configuration from environment file.
  factory SeedConfig.fromEnvironment({
    required SeedEnvironment environment,
    int batchSize = 500,
    bool dryRun = false,
    bool verifyOnly = false,
    String? inputPath,
  }) {
    final envFile = File('${inputPath ?? '.'}/${environment.envFileName}');
    if (!envFile.existsSync()) {
      throw ConfigurationError(
        'Environment file not found: ${envFile.path}\n'
        'Create ${environment.envFileName} with SUPABASE_URL and SUPABASE_SERVICE_KEY',
      );
    }

    final env = DotEnv(includePlatformEnvironment: true)..load([envFile.path]);
    final supabaseUrl = env['SUPABASE_URL'];
    final supabaseServiceKey = env['SUPABASE_SERVICE_KEY'];

    if (supabaseUrl == null || supabaseUrl.isEmpty) {
      throw ConfigurationError('SUPABASE_URL not set in ${environment.envFileName}');
    }
    if (supabaseServiceKey == null || supabaseServiceKey.isEmpty) {
      throw ConfigurationError(
        'SUPABASE_SERVICE_KEY not set in ${environment.envFileName}',
      );
    }

    return SeedConfig._(
      supabaseUrl: supabaseUrl,
      supabaseServiceKey: supabaseServiceKey,
      environment: environment,
      batchSize: batchSize,
      dryRun: dryRun,
      verifyOnly: verifyOnly,
    );
  }

  /// Supabase project URL.
  final String supabaseUrl;

  /// Supabase service role key (bypasses RLS).
  final String supabaseServiceKey;

  /// Target environment.
  final SeedEnvironment environment;

  /// Number of records per batch insert.
  final int batchSize;

  /// If true, validate data without writing to database.
  final bool dryRun;

  /// If true, only verify existing data counts.
  final bool verifyOnly;

  /// Whether this is a production environment.
  bool get isProduction => environment == SeedEnvironment.production;

  @override
  String toString() {
    return 'SeedConfig('
        'env: ${environment.name}, '
        'batchSize: $batchSize, '
        'dryRun: $dryRun, '
        'verifyOnly: $verifyOnly)';
  }
}

/// Configuration error.
class ConfigurationError implements Exception {
  ConfigurationError(this.message);
  final String message;

  @override
  String toString() => 'ConfigurationError: $message';
}
