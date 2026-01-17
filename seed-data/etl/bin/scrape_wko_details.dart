/// WKO Detail Page Scraper.
/// Idempotent scraper that fetches business details from WKO.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:args/args.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

import 'package:etl/scrapers/wko_scraper.dart';

final _log = Logger('WkoDetailScraper');

/// State for resumable scraping.
class ScrapingState {
  ScrapingState({
    required this.processedUrls,
    required this.businesses,
    required this.errors,
    this.lastProcessedAt,
  });

  factory ScrapingState.fromJson(Map<String, dynamic> json) {
    return ScrapingState(
      processedUrls: Set<String>.from(json['processedUrls'] as List),
      businesses: (json['businesses'] as List)
          .map((b) => WkoBusinessListing.fromJson(b as Map<String, dynamic>))
          .toList(),
      errors: List<String>.from(json['errors'] as List),
      lastProcessedAt: json['lastProcessedAt'] as String?,
    );
  }

  factory ScrapingState.empty() => ScrapingState(
        processedUrls: {},
        businesses: [],
        errors: [],
      );

  final Set<String> processedUrls;
  final List<WkoBusinessListing> businesses;
  final List<String> errors;
  final String? lastProcessedAt;

  Map<String, dynamic> toJson() => {
        'processedUrls': processedUrls.toList(),
        'businesses': businesses.map((b) => b.toJson()).toList(),
        'errors': errors,
        'lastProcessedAt': DateTime.now().toUtc().toIso8601String(),
      };
}

/// Wholesale branch keywords for filtering.
const wholesaleKeywords = [
  'großhandel',
  'grosshandel',
  'wholesale',
  'handelsagentur',
  'handelsagent',
  'handelsvermittlung',
  'import',
  'export',
  'außenhandel',
  'aussenhandel',
];

void main(List<String> args) async {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    final time = record.time.toIso8601String().substring(11, 19);
    print('[$time] ${record.level.name}: ${record.message}');
  });

  final parser = ArgParser()
    ..addOption('urls', abbr: 'u', defaultsTo: 'raw/wko-urls.json', help: 'URL list file')
    ..addOption('state', abbr: 's', defaultsTo: 'raw/wko-state.json', help: 'State file for resuming')
    ..addOption('output', abbr: 'o', defaultsTo: 'raw/wko-wholesale.json', help: 'Output file')
    ..addOption('delay', abbr: 'd', defaultsTo: '1000', help: 'Delay between requests (ms)')
    ..addOption('batch', abbr: 'b', defaultsTo: '100', help: 'Save state every N URLs')
    ..addOption('max', abbr: 'm', help: 'Max URLs to process (for testing)')
    ..addFlag('wholesale-only', abbr: 'w', defaultsTo: true, help: 'Only keep wholesale businesses')
    ..addFlag('verbose', abbr: 'v', negatable: false)
    ..addFlag('help', abbr: 'h', negatable: false);

  final results = parser.parse(args);

  if (results['help'] as bool) {
    print('WKO Detail Page Scraper');
    print('');
    print('Fetches business details from WKO and filters for wholesale.');
    print('This process is idempotent - can be stopped and resumed.');
    print('');
    print('Usage:');
    print('  1. First run: dart run bin/download_wko_sitemaps.dart');
    print('  2. Then run: dart run bin/scrape_wko_details.dart');
    print('');
    print(parser.usage);
    exit(0);
  }

  if (results['verbose'] as bool) {
    Logger.root.level = Level.FINE;
  }

  final urlsPath = results['urls'] as String;
  final statePath = results['state'] as String;
  final outputPath = results['output'] as String;
  final delayMs = int.tryParse(results['delay'] as String) ?? 1000;
  final batchSize = int.tryParse(results['batch'] as String) ?? 100;
  final maxUrls = results['max'] != null ? int.tryParse(results['max'] as String) : null;
  final wholesaleOnly = results['wholesale-only'] as bool;

  // Load URLs
  final urlsFile = File(urlsPath);
  if (!await urlsFile.exists()) {
    print('URL file not found: $urlsPath');
    print('Run: dart run bin/download_wko_sitemaps.dart first');
    exit(1);
  }

  final urlsData = jsonDecode(await urlsFile.readAsString()) as Map<String, dynamic>;
  final allUrls = List<String>.from(urlsData['urls'] as List);
  _log.info('Loaded ${allUrls.length} URLs from $urlsPath');

  // Load or create state
  final stateFile = File(statePath);
  ScrapingState state;
  if (await stateFile.exists()) {
    state = ScrapingState.fromJson(
      jsonDecode(await stateFile.readAsString()) as Map<String, dynamic>,
    );
    _log.info('Resumed from state: ${state.processedUrls.length} already processed');
    _log.info('  Businesses collected: ${state.businesses.length}');
    _log.info('  Errors: ${state.errors.length}');
  } else {
    state = ScrapingState.empty();
    _log.info('Starting fresh');
  }

  // Filter URLs not yet processed
  var urlsToProcess = allUrls.where((url) => !state.processedUrls.contains(url)).toList();
  if (maxUrls != null && urlsToProcess.length > maxUrls) {
    urlsToProcess = urlsToProcess.take(maxUrls).toList();
  }
  _log.info('URLs to process: ${urlsToProcess.length}');

  if (urlsToProcess.isEmpty) {
    _log.info('All URLs already processed!');
    await _saveOutput(state, outputPath, wholesaleOnly);
    exit(0);
  }

  final client = http.Client();
  final random = math.Random();
  var processed = 0;

  try {
    for (final url in urlsToProcess) {
      try {
        final business = await _fetchBusinessDetail(client, url);

        if (business != null) {
          // Filter for wholesale if enabled
          final isWholesale = _isWholesaleBusiness(business);
          if (!wholesaleOnly || isWholesale) {
            state.businesses.add(business);
            if (isWholesale) {
              _log.fine('Added wholesale: ${business.name}');
            } else {
              _log.fine('Added: ${business.name}');
            }
          } else {
            _log.fine('Skipped non-wholesale: ${business.name}');
          }
        }

        state.processedUrls.add(url);
      } catch (e) {
        final error = 'Error processing $url: $e';
        _log.warning(error);
        state.errors.add(error);
        state.processedUrls.add(url); // Mark as processed to avoid retrying
      }

      processed++;

      // Progress report
      if (processed % 10 == 0) {
        final total = urlsToProcess.length;
        final pct = (processed * 100 / total).toStringAsFixed(1);
        stdout.write('\rProgress: $processed/$total ($pct%) - ${state.businesses.length} wholesale found');
      }

      // Save state periodically
      if (processed % batchSize == 0) {
        await _saveState(state, statePath);
        _log.info('\nSaved state at $processed URLs');
      }

      // Rate limiting with jitter
      final delay = delayMs + random.nextInt(500);
      await Future<void>.delayed(Duration(milliseconds: delay));
    }

    print(''); // New line after progress
    _log.info('Scraping complete');
    _log.info('Total processed: ${state.processedUrls.length}');
    _log.info('Wholesale businesses: ${state.businesses.length}');
    _log.info('Errors: ${state.errors.length}');

    // Save final state and output
    await _saveState(state, statePath);
    await _saveOutput(state, outputPath, wholesaleOnly);

  } finally {
    client.close();
  }
}

/// User agents to rotate.
const _userAgents = [
  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15',
  'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:121.0) Gecko/20100101 Firefox/121.0',
];

var _currentUserAgentIndex = 0;
var _consecutiveErrors = 0;

/// Fetch business detail from a URL with retry and rate limit handling.
Future<WkoBusinessListing?> _fetchBusinessDetail(http.Client client, String url) async {
  final random = math.Random();
  const maxAttempts = 5;

  for (var attempt = 0; attempt < maxAttempts; attempt++) {
    try {
      // Rotate user agent on each attempt
      final userAgent = _userAgents[_currentUserAgentIndex % _userAgents.length];
      _currentUserAgentIndex++;

      final response = await client.get(
        Uri.parse(url),
        headers: {
          'User-Agent': userAgent,
          'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
          'Accept-Language': 'de-AT,de;q=0.9,en-US;q=0.8,en;q=0.7',
          'Accept-Encoding': 'gzip, deflate, br',
          'Connection': 'keep-alive',
          'Cache-Control': 'max-age=0',
          'Sec-Fetch-Dest': 'document',
          'Sec-Fetch-Mode': 'navigate',
          'Sec-Fetch-Site': 'none',
          'Sec-Fetch-User': '?1',
          'Upgrade-Insecure-Requests': '1',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 404) {
        _consecutiveErrors = 0;
        return null; // Business no longer exists
      }

      if (response.statusCode == 403 || response.statusCode == 429) {
        // Rate limited - exponential backoff
        _consecutiveErrors++;
        final backoffSeconds = math.min(60, (1 << _consecutiveErrors) + random.nextInt(5));
        _log.warning('Rate limited (attempt ${attempt + 1}/$maxAttempts), waiting ${backoffSeconds}s');
        await Future<void>.delayed(Duration(seconds: backoffSeconds));
        continue;
      }

      if (response.statusCode != 200) {
        throw HttpException('HTTP ${response.statusCode}', uri: Uri.parse(url));
      }

      _consecutiveErrors = 0; // Reset on success
      return _parseBusinessDetail(response.body, url);
    } on SocketException catch (e) {
      _log.fine('Socket error on attempt ${attempt + 1}: $e');
      if (attempt == maxAttempts - 1) rethrow;
      await Future<void>.delayed(Duration(seconds: 2 * (attempt + 1)));
    } on TimeoutException catch (e) {
      _log.fine('Timeout on attempt ${attempt + 1}: $e');
      if (attempt == maxAttempts - 1) rethrow;
      await Future<void>.delayed(Duration(seconds: 2 * (attempt + 1)));
    }
  }

  throw Exception('Max attempts reached for $url');
}

/// Parse business details from HTML response.
WkoBusinessListing? _parseBusinessDetail(String body, String url) {
  final document = html_parser.parse(body);

  // Extract firmaid from URL
  final firmaidMatch = RegExp(r'firmaid=([a-f0-9\-]{36})', caseSensitive: false).firstMatch(url);
  if (firmaidMatch == null) return null;
  final wkoId = firmaidMatch.group(1)!;

  // Extract business name from h1 or title
  String? name;
  final h1 = document.querySelector('h1');
  if (h1 != null) {
    name = h1.text.trim();
  }
  name ??= document.querySelector('title')?.text.split('|').first.trim();
  if (name == null || name.isEmpty) return null;

  // Extract address
  String? address;
  String? postcode;
  String? city;
  String? bundesland;

  // Look for address in structured data or common patterns
  final addressElements = document.querySelectorAll('[itemprop="address"], .address, .adresse');
  for (final elem in addressElements) {
    final text = elem.text.trim();
    final postcodeMatch = RegExp(r'\b(\d{4})\b').firstMatch(text);
    if (postcodeMatch != null) {
      postcode = postcodeMatch.group(1);
      final afterPostcode = text.substring(postcodeMatch.end).trim();
      if (afterPostcode.isNotEmpty) {
        city = afterPostcode.split(RegExp(r'[,\n]'))[0].trim();
      }
      final beforePostcode = text.substring(0, postcodeMatch.start).trim();
      if (beforePostcode.isNotEmpty) {
        address = beforePostcode.replaceAll(RegExp(r'[,\n]+$'), '').trim();
      }
      break;
    }
  }

  // Try to extract from full page text if not found
  if (postcode == null) {
    final bodyText = document.body?.text ?? '';
    final postcodeMatch = RegExp(r'\b(\d{4})\s+([A-Za-zäöüÄÖÜß]+)').firstMatch(bodyText);
    if (postcodeMatch != null) {
      postcode = postcodeMatch.group(1);
      city = postcodeMatch.group(2);
    }
  }

  // Extract Bundesland from URL or page
  final bundeslandMatch = RegExp(r'firmen\.wko\.at/[^/]+/([^/]+)/').firstMatch(url);
  if (bundeslandMatch != null) {
    bundesland = _decodeBundesland(bundeslandMatch.group(1)!);
  }

  // Extract phone
  String? phone;
  final phoneLinks = document.querySelectorAll('a[href^="tel:"]');
  if (phoneLinks.isNotEmpty) {
    phone = phoneLinks.first.attributes['href']?.replaceFirst('tel:', '').trim();
  }

  // Extract email
  String? email;
  final emailLinks = document.querySelectorAll('a[href^="mailto:"]');
  if (emailLinks.isNotEmpty) {
    email = emailLinks.first.attributes['href']?.replaceFirst('mailto:', '').split('?')[0].trim();
  }

  // Extract website
  String? website;
  final websiteLinks = document.querySelectorAll('a[href^="http"]:not([href*="wko.at"])');
  for (final link in websiteLinks) {
    final href = link.attributes['href'];
    if (href != null && !href.contains('mailto:') && !href.contains('tel:')) {
      website = href;
      break;
    }
  }

  // Extract branches/sectors
  final branches = <String>[];
  final branchElements = document.querySelectorAll('[class*="branche"], [class*="sector"], dt, dd');
  for (final elem in branchElements) {
    final text = elem.text.trim().toLowerCase();
    if (text.contains('handel') || text.contains('trade') || text.contains('gewerbe')) {
      branches.add(elem.text.trim());
    }
  }

  // Look for Firmenbuchnummer
  String? firmenbuchNr;
  final fbMatch = RegExp(r'FN\s*(\d+\s*[a-z])', caseSensitive: false)
      .firstMatch(document.body?.text ?? '');
  if (fbMatch != null) {
    firmenbuchNr = fbMatch.group(1)?.replaceAll(' ', '');
  }

  // Look for GLN
  String? gln;
  final glnMatch = RegExp(r'GLN[:\s]*(\d{13})').firstMatch(document.body?.text ?? '');
  if (glnMatch != null) {
    gln = glnMatch.group(1);
  }

  return WkoBusinessListing(
    name: name,
    wkoId: wkoId,
    address: address,
    postcode: postcode,
    city: city,
    bundesland: bundesland,
    phone: phone,
    email: email,
    website: website,
    branches: branches,
    detailUrl: url,
    firmenbuchNr: firmenbuchNr,
    gln: gln,
  );
}

/// Check if a business is wholesale based on branches and name.
bool _isWholesaleBusiness(WkoBusinessListing business) {
  // Check name
  final nameLower = business.name.toLowerCase();
  for (final keyword in wholesaleKeywords) {
    if (nameLower.contains(keyword)) return true;
  }

  // Check branches
  for (final branch in business.branches) {
    final branchLower = branch.toLowerCase();
    for (final keyword in wholesaleKeywords) {
      if (branchLower.contains(keyword)) return true;
    }
  }

  return false;
}

/// Decode Bundesland from URL slug.
String _decodeBundesland(String slug) {
  final decoded = Uri.decodeComponent(slug);
  switch (decoded.toLowerCase()) {
    case 'wien':
      return 'Wien';
    case 'niederösterreich':
    case 'niederoesterreich':
      return 'Niederösterreich';
    case 'oberösterreich':
    case 'oberoesterreich':
      return 'Oberösterreich';
    case 'salzburg':
      return 'Salzburg';
    case 'tirol':
      return 'Tirol';
    case 'vorarlberg':
      return 'Vorarlberg';
    case 'kärnten':
    case 'kaernten':
      return 'Kärnten';
    case 'steiermark':
      return 'Steiermark';
    case 'burgenland':
      return 'Burgenland';
    default:
      return decoded;
  }
}

/// Save state to file.
Future<void> _saveState(ScrapingState state, String path) async {
  final file = File(path);
  await file.parent.create(recursive: true);
  await file.writeAsString(const JsonEncoder.withIndent('  ').convert(state.toJson()));
}

/// Save final output.
Future<void> _saveOutput(ScrapingState state, String path, bool wholesaleOnly) async {
  final businesses = wholesaleOnly
      ? state.businesses.where(_isWholesaleBusiness).toList()
      : state.businesses;

  final byBundesland = <String, int>{};
  for (final b in businesses) {
    if (b.bundesland != null) {
      byBundesland[b.bundesland!] = (byBundesland[b.bundesland!] ?? 0) + 1;
    }
  }

  final output = {
    'totalScraped': state.processedUrls.length,
    'uniqueBusinesses': businesses.length,
    'byBundesland': byBundesland,
    'errors': state.errors.length,
    'scrapedAt': DateTime.now().toUtc().toIso8601String(),
    'businesses': businesses.map((b) => b.toJson()).toList(),
  };

  final file = File(path);
  await file.parent.create(recursive: true);
  await file.writeAsString(const JsonEncoder.withIndent('  ').convert(output));

  _log.info('Saved ${businesses.length} businesses to $path');
}
