/// WKO Firmen A-Z web scraper.
/// Extracts business information from the Austrian Chamber of Commerce directory.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:retry/retry.dart';

final _log = Logger('WkoScraper');

/// Result of scraping a single WKO listing page.
class WkoPageResult {
  WkoPageResult({
    required this.businesses,
    required this.totalResults,
    required this.currentPage,
    required this.hasNextPage,
  });

  final List<WkoBusinessListing> businesses;
  final int totalResults;
  final int currentPage;
  final bool hasNextPage;
}

/// A single business listing from WKO Firmen A-Z.
class WkoBusinessListing {
  WkoBusinessListing({
    required this.name,
    required this.wkoId,
    this.address,
    this.postcode,
    this.city,
    this.bundesland,
    this.phone,
    this.email,
    this.website,
    this.branches = const [],
    this.detailUrl,
    this.firmenbuchNr,
    this.gln,
  });

  factory WkoBusinessListing.fromJson(Map<String, dynamic> json) {
    return WkoBusinessListing(
      name: json['name'] as String,
      wkoId: json['wkoId'] as String,
      address: json['address'] as String?,
      postcode: json['postcode'] as String?,
      city: json['city'] as String?,
      bundesland: json['bundesland'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
      branches: (json['branches'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      detailUrl: json['detailUrl'] as String?,
      firmenbuchNr: json['firmenbuchNr'] as String?,
      gln: json['gln'] as String?,
    );
  }

  final String name;
  final String wkoId;
  final String? address;
  final String? postcode;
  final String? city;
  final String? bundesland;
  final String? phone;
  final String? email;
  final String? website;
  final List<String> branches;
  final String? detailUrl;
  final String? firmenbuchNr;
  final String? gln;

  Map<String, dynamic> toJson() => {
        'name': name,
        'wkoId': wkoId,
        if (address != null) 'address': address,
        if (postcode != null) 'postcode': postcode,
        if (city != null) 'city': city,
        if (bundesland != null) 'bundesland': bundesland,
        if (phone != null) 'phone': phone,
        if (email != null) 'email': email,
        if (website != null) 'website': website,
        if (branches.isNotEmpty) 'branches': branches,
        if (detailUrl != null) 'detailUrl': detailUrl,
        if (firmenbuchNr != null) 'firmenbuchNr': firmenbuchNr,
        if (gln != null) 'gln': gln,
      };
}

/// Configuration for WKO scraping.
class WkoScraperConfig {
  WkoScraperConfig({
    this.baseUrl = 'https://firmen.wko.at',
    this.requestDelayMs = 1000,
    this.randomDelayMs = 500,
    this.maxRetries = 3,
    this.maxBusinessesPerCategory = 1000,
    this.fetchDetailPages = false,
    this.userAgent =
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
  });

  final String baseUrl;
  final int requestDelayMs;
  final int randomDelayMs;
  final int maxRetries;
  final int maxBusinessesPerCategory;
  final bool fetchDetailPages;
  final String userAgent;
}

/// Result of a WKO scraping session.
class WkoScrapingResult {
  WkoScrapingResult({
    required this.businesses,
    required this.totalScraped,
    required this.uniqueBusinesses,
    required this.byBundesland,
    required this.byCategory,
    required this.errors,
    required this.scrapedAt,
  });

  final List<WkoBusinessListing> businesses;
  final int totalScraped;
  final int uniqueBusinesses;
  final Map<String, int> byBundesland;
  final Map<String, int> byCategory;
  final List<String> errors;
  final DateTime scrapedAt;

  Map<String, dynamic> toJson() => {
        'totalScraped': totalScraped,
        'uniqueBusinesses': uniqueBusinesses,
        'byBundesland': byBundesland,
        'byCategory': byCategory,
        'errors': errors,
        'scrapedAt': scrapedAt.toUtc().toIso8601String(),
        'businesses': businesses.map((b) => b.toJson()).toList(),
      };
}

/// Austrian Bundesländer for WKO URLs.
class WkoBundesland {
  static const wien = 'wien';
  static const niederoesterreich = 'nieder%C3%B6sterreich';
  static const oberoesterreich = 'ober%C3%B6sterreich';
  static const salzburg = 'salzburg';
  static const tirol = 'tirol';
  static const vorarlberg = 'vorarlberg';
  static const kaernten = 'k%C3%A4rnten';
  static const steiermark = 'steiermark';
  static const burgenland = 'burgenland';

  static const all = [
    wien,
    niederoesterreich,
    oberoesterreich,
    salzburg,
    tirol,
    vorarlberg,
    kaernten,
    steiermark,
    burgenland,
  ];

  /// Get human-readable name from URL slug.
  static String getName(String slug) {
    switch (slug) {
      case wien:
        return 'Wien';
      case niederoesterreich:
        return 'Niederösterreich';
      case oberoesterreich:
        return 'Oberösterreich';
      case salzburg:
        return 'Salzburg';
      case tirol:
        return 'Tirol';
      case vorarlberg:
        return 'Vorarlberg';
      case kaernten:
        return 'Kärnten';
      case steiermark:
        return 'Steiermark';
      case burgenland:
        return 'Burgenland';
      default:
        return slug;
    }
  }
}

/// WKO wholesale category URLs.
/// Uses the correct URL-encoded German characters (ß = %C3%9F, ö = %C3%B6).
class WkoWholesaleCategories {
  /// All wholesale categories with URL-encoded names.
  /// Format: [url_slug, display_name, nace_code]
  static const categories = [
    // General wholesale
    ['gro%C3%9Fhandel', 'Großhandel', '46'],

    // NACE 46.2 - Agricultural raw materials
    ['agrarhandel', 'Agrarhandel', '46.2'],

    // NACE 46.3 - Food, beverages, tobacco
    ['lebensmittelgro%C3%9Fhandel', 'Lebensmittelgroßhandel', '46.3'],
    ['getr%C3%A4nkegro%C3%9Fhandel', 'Getränkegroßhandel', '46.34'],
    ['weinhandel', 'Weinhandel', '46.34'],
    ['tabakgro%C3%9Fhandel', 'Tabakgroßhandel', '46.35'],

    // NACE 46.4 - Household goods
    ['textilgro%C3%9Fhandel', 'Textilgroßhandel', '46.41'],
    ['bekleidungsgro%C3%9Fhandel', 'Bekleidungsgroßhandel', '46.42'],
    ['schuhgro%C3%9Fhandel', 'Schuhgroßhandel', '46.42'],
    ['elektrogro%C3%9Fhandel', 'Elektrogroßhandel', '46.43'],
    ['m%C3%B6belgro%C3%9Fhandel', 'Möbelgroßhandel', '46.47'],
    ['arzneimittelgro%C3%9Fhandel', 'Arzneimittelgroßhandel', '46.46'],

    // NACE 46.5 - ICT equipment
    ['edv-handel', 'EDV-Handel', '46.51'],
    ['computergro%C3%9Fhandel', 'Computergroßhandel', '46.51'],
    ['softwarehandel', 'Softwarehandel', '46.51'],

    // NACE 46.6 - Machinery
    ['maschinenhandel', 'Maschinenhandel', '46.6'],
    ['landmaschinenhandel', 'Landmaschinenhandel', '46.61'],
    ['baumaschinenhandel', 'Baumaschinenhandel', '46.63'],

    // NACE 46.7 - Other specialized
    ['brennstoffhandel', 'Brennstoffhandel', '46.71'],
    ['mineral%C3%B6lhandel', 'Mineralölhandel', '46.71'],
    ['metallhandel', 'Metallhandel', '46.72'],
    ['baustoffgro%C3%9Fhandel', 'Baustoffgroßhandel', '46.73'],
    ['holzgro%C3%9Fhandel', 'Holzgroßhandel', '46.73'],
    ['sanit%C3%A4rgro%C3%9Fhandel', 'Sanitärgroßhandel', '46.73'],
    ['chemikaliengro%C3%9Fhandel', 'Chemikaliengroßhandel', '46.75'],
    ['altwarenhandel', 'Altwarenhandel', '46.77'],

    // NACE 46.1 - Agents
    ['handelsagent', 'Handelsagent', '46.1'],
    ['handelsagentur', 'Handelsagentur', '46.1'],

    // Import/Export
    ['importhandel', 'Importhandel', '46'],
    ['exporthandel', 'Exporthandel', '46'],
    ['au%C3%9Fenhandel', 'Außenhandel', '46'],
  ];

  /// Get just the URL slugs.
  static List<String> get slugs => categories.map((c) => c[0]).toList();
}

/// WKO Firmen A-Z scraper.
class WkoScraper {
  WkoScraper({WkoScraperConfig? config})
      : config = config ?? WkoScraperConfig(),
        _client = http.Client(),
        _random = math.Random();

  final WkoScraperConfig config;
  final http.Client _client;
  final math.Random _random;

  /// Scrape wholesale businesses from WKO for given categories and regions.
  Future<WkoScrapingResult> scrapeWholesale({
    List<String>? bundeslaender,
    List<String>? categories,
    void Function(int current, int total)? onProgress,
  }) async {
    final targetBundeslaender = bundeslaender ?? WkoBundesland.all;
    final targetCategories = categories ?? WkoWholesaleCategories.slugs;
    final allBusinesses = <WkoBusinessListing>[];
    final errors = <String>[];
    final byBundesland = <String, int>{};
    final byCategory = <String, int>{};
    final seenIds = <String>{};

    final totalTasks = targetBundeslaender.length * targetCategories.length;
    var completedTasks = 0;

    for (final category in targetCategories) {
      for (final bundesland in targetBundeslaender) {
        try {
          final blName = WkoBundesland.getName(bundesland);
          _log.info('Scraping $category / $blName');

          final businesses = await _scrapeCategoryForBundesland(
            category: category,
            bundesland: bundesland,
          );

          for (final business in businesses) {
            if (!seenIds.contains(business.wkoId)) {
              seenIds.add(business.wkoId);
              allBusinesses.add(business);

              final bl = business.bundesland ?? blName;
              byBundesland[bl] = (byBundesland[bl] ?? 0) + 1;
              byCategory[category] = (byCategory[category] ?? 0) + 1;
            }
          }

          _log.info(
              'Found ${businesses.length} businesses for $category/$blName');
        } catch (e) {
          final errorMsg = 'Error scraping $category/$bundesland: $e';
          _log.warning(errorMsg);
          errors.add(errorMsg);
        }

        completedTasks++;
        onProgress?.call(completedTasks, totalTasks);
      }
    }

    return WkoScrapingResult(
      businesses: allBusinesses,
      totalScraped: allBusinesses.length,
      uniqueBusinesses: seenIds.length,
      byBundesland: byBundesland,
      byCategory: byCategory,
      errors: errors,
      scrapedAt: DateTime.now().toUtc(),
    );
  }

  /// Scrape a specific category for a Bundesland.
  Future<List<WkoBusinessListing>> _scrapeCategoryForBundesland({
    required String category,
    required String bundesland,
  }) async {
    final businesses = <WkoBusinessListing>[];

    // Build the search URL
    final url = '${config.baseUrl}/$category/$bundesland';

    try {
      final response = await _fetchWithRetry(url);
      final document = html_parser.parse(response.body);

      // Extract firm IDs and basic info from search results
      final firmIds = _extractFirmIds(document, response.body);
      _log.fine('Found ${firmIds.length} firm IDs on page');

      // Parse listings from search result page
      final listings = _parseSearchResults(document, bundesland);
      businesses.addAll(listings);

      // Apply rate limiting
      await _delay();
    } catch (e) {
      _log.warning('Error fetching $url: $e');
      rethrow;
    }

    return businesses;
  }

  /// Extract firm IDs from HTML content.
  List<String> _extractFirmIds(Document document, String htmlContent) {
    final firmIds = <String>[];

    // Extract from firmaid parameters in URLs
    final firmaidPattern =
        RegExp(r'firmaid=([a-f0-9\-]{36})', caseSensitive: false);
    for (final match in firmaidPattern.allMatches(htmlContent)) {
      final id = match.group(1);
      if (id != null && !firmIds.contains(id)) {
        firmIds.add(id);
      }
    }

    return firmIds;
  }

  /// Parse business listings from search results page.
  List<WkoBusinessListing> _parseSearchResults(
      Document document, String bundesland) {
    final businesses = <WkoBusinessListing>[];

    // Find all links with firmaid parameter (these are business detail links)
    final links = document.querySelectorAll('a[href*="firmaid="]');

    final processedIds = <String>{};

    for (final link in links) {
      final href = link.attributes['href'] ?? '';

      // Extract firmaid
      final firmaidMatch =
          RegExp(r'firmaid=([a-f0-9\-]{36})', caseSensitive: false)
              .firstMatch(href);
      if (firmaidMatch == null) continue;

      final firmId = firmaidMatch.group(1)!;
      if (processedIds.contains(firmId)) continue;
      processedIds.add(firmId);

      // Get the parent container for this listing
      Element? container = link.parent;
      while (container != null && !_isListingContainer(container)) {
        container = container.parent;
      }

      if (container == null) {
        // Just use the link text as company name
        final name = link.text.trim();
        if (name.isNotEmpty && !name.contains('Treffer')) {
          businesses.add(WkoBusinessListing(
            name: name,
            wkoId: firmId,
            bundesland: WkoBundesland.getName(bundesland),
            detailUrl: _normalizeUrl(href),
          ));
        }
        continue;
      }

      // Extract data from container
      final business = _parseListingContainer(container, firmId, bundesland);
      if (business != null) {
        businesses.add(business);
      }
    }

    return businesses;
  }

  /// Check if element is a listing container.
  bool _isListingContainer(Element element) {
    final classes = element.className.toLowerCase();
    return classes.contains('result') ||
        classes.contains('listing') ||
        classes.contains('company') ||
        classes.contains('firma') ||
        element.localName == 'article' ||
        element.localName == 'section';
  }

  /// Parse a single listing container.
  WkoBusinessListing? _parseListingContainer(
      Element container, String firmId, String bundesland) {
    // Find company name (usually in h2, h3, or link)
    String? name;
    final headings =
        container.querySelectorAll('h2, h3, h4, a[href*="firmaid="]');
    for (final h in headings) {
      final text = h.text.trim();
      if (text.isNotEmpty && !text.contains('Treffer') && text.length > 2) {
        name = text;
        break;
      }
    }

    if (name == null || name.isEmpty) return null;

    // Extract address info
    String? address;
    String? postcode;
    String? city;

    // Look for address elements
    final addressElements = container
        .querySelectorAll('[class*="address"], [class*="adresse"], p, span');
    for (final elem in addressElements) {
      final text = elem.text.trim();

      // Look for Austrian postcode pattern (4 digits)
      final postcodeMatch = RegExp(r'\b(\d{4})\b').firstMatch(text);
      if (postcodeMatch != null && postcode == null) {
        postcode = postcodeMatch.group(1);

        // Try to extract city after postcode
        final afterPostcode = text.substring(postcodeMatch.end).trim();
        if (afterPostcode.isNotEmpty) {
          city = afterPostcode.split(RegExp(r'[,\n]'))[0].trim();
        }

        // Try to extract street before postcode
        final beforePostcode = text.substring(0, postcodeMatch.start).trim();
        if (beforePostcode.isNotEmpty) {
          address = beforePostcode.replaceAll(RegExp(r'[,\n]+$'), '').trim();
        }
      }
    }

    // Extract phone
    String? phone;
    final phoneLinks = container.querySelectorAll('a[href^="tel:"]');
    if (phoneLinks.isNotEmpty) {
      phone =
          phoneLinks.first.attributes['href']?.replaceFirst('tel:', '').trim();
    }
    if (phone == null) {
      final phonePattern =
          RegExp(r'(\+43[\s\-]?[\d\s\-/]+|\b0\d{1,4}[\s\-/]?\d+[\s\-/]?\d+)');
      for (final elem in container.querySelectorAll('span, p, div')) {
        final match = phonePattern.firstMatch(elem.text);
        if (match != null) {
          phone = match.group(0)?.trim();
          break;
        }
      }
    }

    // Extract email
    String? email;
    final emailLinks = container.querySelectorAll('a[href^="mailto:"]');
    if (emailLinks.isNotEmpty) {
      email = emailLinks.first.attributes['href']
          ?.replaceFirst('mailto:', '')
          .split('?')[0]
          .trim();
    }

    // Extract website
    String? website;
    final websiteLinks = container
        .querySelectorAll('a[href^="http"]:not([href*="firmen.wko.at"])');
    for (final link in websiteLinks) {
      final href = link.attributes['href'];
      if (href != null && !href.contains('mailto:') && !href.contains('tel:')) {
        website = href;
        break;
      }
    }

    // Get detail URL
    final detailLink = container.querySelector('a[href*="firmaid="]');
    final detailUrl = detailLink?.attributes['href'];

    return WkoBusinessListing(
      name: name,
      wkoId: firmId,
      address: address,
      postcode: postcode,
      city: city,
      bundesland: WkoBundesland.getName(bundesland),
      phone: phone,
      email: email,
      website: website,
      detailUrl: _normalizeUrl(detailUrl),
    );
  }

  /// Fetch URL with retry logic.
  Future<http.Response> _fetchWithRetry(String url) async {
    final retry = RetryOptions(
      maxAttempts: config.maxRetries,
      delayFactor: const Duration(seconds: 2),
    );

    return retry.retry(
      () async {
        final response = await _client.get(
          Uri.parse(url),
          headers: {
            'User-Agent': config.userAgent,
            'Accept':
                'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
            'Accept-Language': 'de-AT,de;q=0.9,en;q=0.8',
            'Accept-Encoding': 'gzip, deflate',
            'Connection': 'keep-alive',
          },
        ).timeout(const Duration(seconds: 30));

        if (response.statusCode == 404) {
          // Return empty response for 404 (no results for this category/region)
          _log.fine('404 for $url - no results');
          return response;
        }

        if (response.statusCode != 200) {
          throw HttpException(
            'HTTP ${response.statusCode} for $url',
            uri: Uri.parse(url),
          );
        }

        return response;
      },
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
  }

  /// Apply rate limiting delay.
  Future<void> _delay() async {
    final delay = config.requestDelayMs + _random.nextInt(config.randomDelayMs);
    await Future<void>.delayed(Duration(milliseconds: delay));
  }

  /// Normalize URL.
  String? _normalizeUrl(String? url) {
    if (url == null || url.isEmpty) return null;

    var normalized = url.trim();
    if (normalized.startsWith('//')) {
      normalized = 'https:$normalized';
    } else if (normalized.startsWith('/')) {
      normalized = '${config.baseUrl}$normalized';
    } else if (!normalized.startsWith('http')) {
      normalized = 'https://$normalized';
    }

    return normalized;
  }

  /// Close the HTTP client.
  void close() {
    _client.close();
  }
}

/// Save scraped results to JSON file.
Future<void> saveWkoResults(
  WkoScrapingResult result,
  String outputPath,
) async {
  final file = File(outputPath);
  await file.parent.create(recursive: true);

  final jsonString =
      const JsonEncoder.withIndent('  ').convert(result.toJson());
  await file.writeAsString(jsonString);
}

/// Load previously scraped results from JSON file.
Future<List<WkoBusinessListing>> loadWkoResults(String path) async {
  final file = File(path);
  if (!await file.exists()) {
    return [];
  }

  final content = await file.readAsString();
  final data = jsonDecode(content) as Map<String, dynamic>;
  final businessesData = data['businesses'] as List<dynamic>;

  return businessesData
      .map((b) => WkoBusinessListing.fromJson(b as Map<String, dynamic>))
      .toList();
}
