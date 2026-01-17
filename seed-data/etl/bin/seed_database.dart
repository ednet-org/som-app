#!/usr/bin/env dart
/// CLI for seeding the SOM database with ETL business entities.
///
/// Usage:
///   dart run bin/seed_database.dart --env local
///   dart run bin/seed_database.dart --env staging --batch-size 1000
///   dart run bin/seed_database.dart --dry-run
///   dart run bin/seed_database.dart --verify-only
library;

import 'dart:io';

import 'package:args/args.dart';
import 'package:etl/loaders/database_seeder.dart';
import 'package:etl/loaders/seed_config.dart';

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
      'input',
      abbr: 'i',
      help: 'Path to businesses.json file',
      defaultsTo: '../out/businesses.json',
    )
    ..addOption(
      'batch-size',
      abbr: 'b',
      help: 'Number of records per batch',
      defaultsTo: '500',
    )
    ..addFlag(
      'dry-run',
      abbr: 'd',
      help: 'Validate data without writing to database',
      negatable: false,
    )
    ..addFlag(
      'verify-only',
      abbr: 'v',
      help: 'Only verify existing data counts',
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
  final inputPath = args['input'] as String;
  final batchSize = int.tryParse(args['batch-size'] as String) ?? 500;
  final dryRun = args['dry-run'] as bool;
  final verifyOnly = args['verify-only'] as bool;

  // Production safety check
  if (environment == SeedEnvironment.production && !dryRun && !verifyOnly) {
    stdout.write(
      '\n⚠️  WARNING: You are about to seed PRODUCTION database.\n'
      'This will insert/update 125,010 records.\n\n'
      'Type "CONFIRM" to proceed: ',
    );
    final confirmation = stdin.readLineSync();
    if (confirmation != 'CONFIRM') {
      stderr.writeln('Aborted.');
      exit(1);
    }
    stdout.writeln();
  }

  print('=' * 60);
  print('SOM Database Seeder');
  print('=' * 60);
  print('Environment: ${environment.name}');
  print('Input: $inputPath');
  print('Batch size: $batchSize');
  print('Dry run: $dryRun');
  print('Verify only: $verifyOnly');
  print('=' * 60);
  print('');

  try {
    final config = SeedConfig.fromEnvironment(
      environment: environment,
      batchSize: batchSize,
      dryRun: dryRun,
      verifyOnly: verifyOnly,
    );

    final seeder = await DatabaseSeeder.create(config);

    try {
      if (verifyOnly) {
        print('Verifying existing data...\n');
        final result = await seeder.verify();
        print(result);
      } else {
        final result = await seeder.seed(
          inputPath: inputPath,
          onProgress: (stage, current, total, message) {
            // Clear line and print progress
            stdout.write('\r\x1B[K[$stage] $message');
          },
        );
        // Clear progress line
        stdout.writeln('\r\x1B[K');
        print(result);
      }
    } finally {
      await seeder.close();
    }
  } on ConfigurationError catch (e) {
    stderr.writeln('Configuration error: ${e.message}');
    exit(1);
  } on SeedError catch (e) {
    stderr.writeln('Seed error: ${e.message}');
    exit(1);
  } catch (e, st) {
    stderr.writeln('Unexpected error: $e');
    stderr.writeln(st);
    exit(1);
  }
}

void _printUsage(ArgParser parser) {
  print('Usage: dart run bin/seed_database.dart [options]');
  print('');
  print('Seeds the SOM database with business entities from ETL output.');
  print('');
  print('Options:');
  print(parser.usage);
  print('');
  print('Examples:');
  print('  # Dry run (validate without writing)');
  print('  dart run bin/seed_database.dart --dry-run');
  print('');
  print('  # Seed local database');
  print('  dart run bin/seed_database.dart --env local');
  print('');
  print('  # Seed staging with custom batch size');
  print('  dart run bin/seed_database.dart --env staging --batch-size 1000');
  print('');
  print('  # Verify existing data');
  print('  dart run bin/seed_database.dart --verify-only');
  print('');
  print('  # Production (requires confirmation)');
  print('  dart run bin/seed_database.dart --env production');
  print('');
  print('Environment files:');
  print('  Create .env.local, .env.staging, or .env.production with:');
  print('    SUPABASE_URL=<your-supabase-url>');
  print('    SUPABASE_SERVICE_KEY=<your-service-key>');
}
