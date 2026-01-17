/// WKO Firmen A-Z scraper CLI.
/// Scrapes wholesale businesses from the WKO business directory.
library;

import 'dart:io';

import 'package:args/args.dart';
import 'package:logging/logging.dart';

import 'package:etl/scrapers/wko_scraper.dart';

final _log = Logger('WkoScraper');

void main(List<String> args) async {
  // Setup logging
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    final time = record.time.toIso8601String().substring(11, 19);
    print('[$time] ${record.level.name}: ${record.message}');
  });

  // Parse arguments
  final parser = ArgParser()
    ..addOption(
      'output',
      abbr: 'o',
      defaultsTo: 'raw/wko-wholesale.json',
      help: 'Output file path',
    )
    ..addOption(
      'bundesland',
      abbr: 'b',
      help: 'Specific Bundesland to scrape (comma-separated for multiple)',
    )
    ..addOption(
      'category',
      abbr: 'c',
      help: 'Specific WKO category to scrape (comma-separated for multiple)',
    )
    ..addOption(
      'delay',
      abbr: 'd',
      defaultsTo: '1500',
      help: 'Delay between requests in milliseconds',
    )
    ..addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'Enable verbose logging',
    )
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Show help',
    );

  final results = parser.parse(args);

  if (results['help'] as bool) {
    print('WKO Firmen A-Z Wholesale Scraper');
    print('');
    print('Scrapes wholesale business information from the Austrian');
    print('Chamber of Commerce business directory (firmen.wko.at).');
    print('');
    print('Usage: dart run bin/scrape_wko.dart [options]');
    print('');
    print(parser.usage);
    print('');
    print('Bundesland options:');
    print('  wien, niederoesterreich, oberoesterreich, salzburg,');
    print('  tirol, vorarlberg, kaernten, steiermark, burgenland');
    print('');
    print('Default categories (wholesale/Großhandel):');
    for (final cat in WkoWholesaleCategories.categories.take(10)) {
      print('  ${cat[0]} (${cat[1]})');
    }
    print('  ... and ${WkoWholesaleCategories.categories.length - 10} more');
    print('');
    print('Example:');
    print('  dart run bin/scrape_wko.dart --output raw/wko.json');
    print('  dart run bin/scrape_wko.dart -b wien -d 2000');
    exit(0);
  }

  if (results['verbose'] as bool) {
    Logger.root.level = Level.FINE;
  }

  final outputPath = results['output'] as String;
  final delayMs = int.tryParse(results['delay'] as String) ?? 1500;

  // Parse bundeslaender - map simple names to URL-encoded versions
  List<String>? bundeslaender;
  if (results['bundesland'] != null) {
    bundeslaender = (results['bundesland'] as String)
        .split(',')
        .map((s) => _mapBundesland(s.trim().toLowerCase()))
        .toList();
  }

  // Parse categories
  List<String>? categories;
  if (results['category'] != null) {
    categories = (results['category'] as String)
        .split(',')
        .map((s) => s.trim())
        .toList();
  }

  _log.info('Starting WKO wholesale scraper');
  _log.info('Output: $outputPath');
  _log.info('Delay: ${delayMs}ms');
  _log.info('Bundeslaender: ${bundeslaender?.length ?? 9} regions');
  _log.info('Categories: ${categories?.length ?? WkoWholesaleCategories.slugs.length} wholesale categories');

  // Create scraper
  final config = WkoScraperConfig(
    requestDelayMs: delayMs,
    randomDelayMs: (delayMs * 0.5).round(),
  );

  final scraper = WkoScraper(config: config);

  try {
    // Scrape
    final result = await scraper.scrapeWholesale(
      bundeslaender: bundeslaender,
      categories: categories,
      onProgress: (current, total) {
        final pct = (current * 100 / total).toStringAsFixed(1);
        stdout.write('\rProgress: $current/$total ($pct%)');
      },
    );

    print(''); // New line after progress
    _log.info('Scraping complete');
    _log.info('Total businesses scraped: ${result.totalScraped}');
    _log.info('Unique businesses: ${result.uniqueBusinesses}');

    // Log by Bundesland
    _log.info('By Bundesland:');
    for (final entry in result.byBundesland.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value))) {
      _log.info('  ${entry.key}: ${entry.value}');
    }

    // Log by category
    _log.info('By Category:');
    for (final entry in result.byCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value))) {
      _log.info('  ${entry.key}: ${entry.value}');
    }

    // Log errors
    if (result.errors.isNotEmpty) {
      _log.warning('Errors encountered: ${result.errors.length}');
      for (final error in result.errors.take(10)) {
        _log.warning('  $error');
      }
      if (result.errors.length > 10) {
        _log.warning('  ... and ${result.errors.length - 10} more');
      }
    }

    // Save results
    _log.info('Saving results to $outputPath');
    await saveWkoResults(result, outputPath);
    _log.info('Done!');

    // Print summary
    print('');
    print('=== WKO Scraping Summary ===');
    print('Total businesses: ${result.uniqueBusinesses}');
    print('Output file: $outputPath');
    print('');
    print('Top Bundeslaender:');
    final sortedBundeslaender = result.byBundesland.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    for (final entry in sortedBundeslaender.take(5)) {
      print('  ${entry.key}: ${entry.value}');
    }
  } catch (e, stack) {
    _log.severe('Scraping failed: $e');
    _log.fine('Stack trace: $stack');
    exit(1);
  } finally {
    scraper.close();
  }
}

/// Map simple bundesland name to URL-encoded version.
String _mapBundesland(String name) {
  switch (name) {
    case 'wien':
      return WkoBundesland.wien;
    case 'niederoesterreich':
    case 'niederösterreich':
      return WkoBundesland.niederoesterreich;
    case 'oberoesterreich':
    case 'oberösterreich':
      return WkoBundesland.oberoesterreich;
    case 'salzburg':
      return WkoBundesland.salzburg;
    case 'tirol':
      return WkoBundesland.tirol;
    case 'vorarlberg':
      return WkoBundesland.vorarlberg;
    case 'kaernten':
    case 'kärnten':
      return WkoBundesland.kaernten;
    case 'steiermark':
      return WkoBundesland.steiermark;
    case 'burgenland':
      return WkoBundesland.burgenland;
    default:
      return name;
  }
}
