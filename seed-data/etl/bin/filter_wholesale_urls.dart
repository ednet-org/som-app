/// Filter WKO URLs to wholesale-related businesses only.
library;

import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';

/// URL patterns that indicate wholesale businesses.
const wholesalePatterns = [
  'grosshandel',
  'gro%c3%9fhandel',
  'großhandel',
  'handelsagentur',
  'handelsagent',
  'handelsvermittl',
  'importhandel',
  'exporthandel',
  'aussenhandel',
  'au%c3%9fenhandel',
  'außenhandel',
  '-handel-',
  'warenhandel',
  'lebensmittelhandel',
  'textilhandel',
  'eisenwarenhandel',
  'baustoffhandel',
  'holzhandel',
  'metallhandel',
  'elektrohandel',
  'maschinenhandel',
  'brennstoffhandel',
  'chemikalienhandel',
];

void main(List<String> args) async {
  final parser = ArgParser()
    ..addOption('input', abbr: 'i', defaultsTo: 'raw/wko-urls.json')
    ..addOption('output', abbr: 'o', defaultsTo: 'raw/wko-wholesale-urls.json')
    ..addFlag('help', abbr: 'h', negatable: false);

  final results = parser.parse(args);

  if (results['help'] as bool) {
    print('Filter WKO URLs to wholesale-related businesses');
    print('');
    print(parser.usage);
    exit(0);
  }

  final inputPath = results['input'] as String;
  final outputPath = results['output'] as String;

  final inputFile = File(inputPath);
  if (!await inputFile.exists()) {
    print('Input file not found: $inputPath');
    exit(1);
  }

  final data = jsonDecode(await inputFile.readAsString()) as Map<String, dynamic>;
  final allUrls = List<String>.from(data['urls'] as List);

  print('Total URLs: ${allUrls.length}');

  // Filter URLs by wholesale patterns
  final wholesaleUrls = <String>[];
  for (final url in allUrls) {
    final urlLower = url.toLowerCase();
    for (final pattern in wholesalePatterns) {
      if (urlLower.contains(pattern)) {
        wholesaleUrls.add(url);
        break;
      }
    }
  }

  print('Wholesale URLs: ${wholesaleUrls.length}');

  // Save filtered URLs
  final output = {
    'extractedAt': DateTime.now().toUtc().toIso8601String(),
    'sourceFile': inputPath,
    'totalUrls': wholesaleUrls.length,
    'patterns': wholesalePatterns,
    'urls': wholesaleUrls,
  };

  final outputFile = File(outputPath);
  await outputFile.parent.create(recursive: true);
  await outputFile.writeAsString(const JsonEncoder.withIndent('  ').convert(output));

  print('Saved to $outputPath');

  // Show distribution by pattern
  print('');
  print('Distribution by pattern:');
  final patternCounts = <String, int>{};
  for (final url in wholesaleUrls) {
    final urlLower = url.toLowerCase();
    for (final pattern in wholesalePatterns) {
      if (urlLower.contains(pattern)) {
        patternCounts[pattern] = (patternCounts[pattern] ?? 0) + 1;
        break;
      }
    }
  }
  final sorted = patternCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
  for (final entry in sorted.take(15)) {
    print('  ${entry.key}: ${entry.value}');
  }
}
