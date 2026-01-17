/// WKO Sitemap URL extractor.
/// Downloads all regional sitemaps and extracts business URLs.
library;

import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:args/args.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

final _log = Logger('WkoSitemaps');

/// Regional sitemaps available at WKO.
const sitemaps = [
  // Wien
  'sitemap_wien_01.xml.gz',
  'sitemap_wien_02.xml.gz',
  'sitemap_wien_03.xml.gz',
  // Niederösterreich
  'sitemap_niederoesterreich_01.xml.gz',
  'sitemap_niederoesterreich_02.xml.gz',
  'sitemap_niederoesterreich_03.xml.gz',
  // Oberösterreich
  'sitemap_oberoesterreich_01.xml.gz',
  'sitemap_oberoesterreich_02.xml.gz',
  'sitemap_oberoesterreich_03.xml.gz',
  // Salzburg
  'sitemap_salzburg_01.xml.gz',
  // Steiermark
  'sitemap_steiermark_01.xml.gz',
  'sitemap_steiermark_02.xml.gz',
  'sitemap_steiermark_03.xml.gz',
  // Kärnten
  'sitemap_kaernten_01.xml.gz',
  // Tirol
  'sitemap_tirol_01.xml.gz',
  'sitemap_tirol_02.xml.gz',
  // Vorarlberg
  'sitemap_vorarlberg_01.xml.gz',
  // Burgenland
  'sitemap_burgenland_01.xml.gz',
];

void main(List<String> args) async {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    final time = record.time.toIso8601String().substring(11, 19);
    print('[$time] ${record.level.name}: ${record.message}');
  });

  final parser = ArgParser()
    ..addOption('output', abbr: 'o', defaultsTo: 'raw/wko-urls.json')
    ..addFlag('help', abbr: 'h', negatable: false);

  final results = parser.parse(args);

  if (results['help'] as bool) {
    print('WKO Sitemap URL Extractor');
    print('');
    print('Downloads all WKO regional sitemaps and extracts business URLs.');
    print('');
    print('Usage: dart run bin/download_wko_sitemaps.dart [options]');
    print('');
    print(parser.usage);
    exit(0);
  }

  final outputPath = results['output'] as String;
  final client = http.Client();
  final allUrls = <String>[];

  try {
    for (final sitemap in sitemaps) {
      _log.info('Downloading $sitemap');
      final url = 'https://firmen.wko.at/sitemap/$sitemap';

      try {
        final response = await client.get(
          Uri.parse(url),
          headers: {
            'User-Agent': 'Mozilla/5.0 (compatible; WKOScraper/1.0)',
            'Accept-Encoding': 'gzip',
          },
        ).timeout(const Duration(seconds: 60));

        if (response.statusCode != 200) {
          _log.warning('Failed to download $sitemap: HTTP ${response.statusCode}');
          continue;
        }

        // Decompress gzip
        final decompressed = GZipDecoder().decodeBytes(response.bodyBytes);
        final xml = utf8.decode(decompressed);

        // Extract URLs with firmaid (business detail pages)
        final urlPattern = RegExp(r'<loc>([^<]+firmaid=[^<]+)</loc>');
        final matches = urlPattern.allMatches(xml);

        var count = 0;
        for (final match in matches) {
          final extractedUrl = match.group(1);
          if (extractedUrl != null) {
            allUrls.add(extractedUrl);
            count++;
          }
        }

        _log.info('  Found $count business URLs');

        // Rate limit
        await Future<void>.delayed(const Duration(milliseconds: 500));
      } catch (e) {
        _log.warning('Error processing $sitemap: $e');
      }
    }

    // Remove duplicates
    final uniqueUrls = allUrls.toSet().toList();
    _log.info('Total URLs: ${allUrls.length}, Unique: ${uniqueUrls.length}');

    // Save to file
    final output = {
      'extractedAt': DateTime.now().toUtc().toIso8601String(),
      'totalUrls': uniqueUrls.length,
      'urls': uniqueUrls,
    };

    final file = File(outputPath);
    await file.parent.create(recursive: true);
    await file.writeAsString(const JsonEncoder.withIndent('  ').convert(output));

    _log.info('Saved ${uniqueUrls.length} URLs to $outputPath');
  } finally {
    client.close();
  }
}
