/// WKO Firmen A-Z web scraper.
/// Extracts business information from the Austrian Chamber of Commerce directory.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:html/parser.dart' as html_parser;
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
      };
}

/// Configuration for WKO scraping.
class WkoScraperConfig {
  WkoScraperConfig({
    this.baseUrl = 'https://firmen.wko.at',
    this.requestDelayMs = 1000,
    this.randomDelayMs = 500,
    this.maxRetries = 3,
    this.maxPagesPerBranch = 100,
    this.userAgent =
        'Mozilla/5.0 (compatible; SOMDataCollector/1.0; business-directory-research)',
  });

  final String baseUrl;
  final int requestDelayMs;
  final int randomDelayMs;
  final int maxRetries;
  final int maxPagesPerBranch;
  final String userAgent;
}

/// Result of a WKO scraping session.
class WkoScrapingResult {
  WkoScrapingResult({
    required this.businesses,
    required this.totalScraped,
    required this.uniqueBusinesses,
    required this.byBundesland,
    required this.byBranch,
    required this.errors,
    required this.scrapedAt,
  });

  final List<WkoBusinessListing> businesses;
  final int totalScraped;
  final int uniqueBusinesses;
  final Map<String, int> byBundesland;
  final Map<String, int> byBranch;
  final List<String> errors;
  final DateTime scrapedAt;

  Map<String, dynamic> toJson() => {
        'totalScraped': totalScraped,
        'uniqueBusinesses': uniqueBusinesses,
        'byBundesland': byBundesland,
        'byBranch': byBranch,
        'errors': errors,
        'scrapedAt': scrapedAt.toUtc().toIso8601String(),
        'businesses': businesses.map((b) => b.toJson()).toList(),
      };
}

/// Austrian Bundesländer for WKO URLs.
class WkoBundesland {
  static const wien = 'wien';
  static const niederoesterreich = 'niederoesterreich';
  static const oberoesterreich = 'oberoesterreich';
  static const salzburg = 'salzburg';
  static const tirol = 'tirol';
  static const vorarlberg = 'vorarlberg';
  static const kaernten = 'kaernten';
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
}

/// WKO branch codes for NACE 46 (Wholesale).
/// Maps WKO branch URL identifiers to NACE codes.
class WkoWholesaleBranches {
  /// NACE 46.1x - Agents and commission trade
  static const agents = [
    'handelsvermittlung',
    'handelsagenten',
  ];

  /// NACE 46.2x - Wholesale of agricultural raw materials
  static const rawMaterials = [
    'grosshandel-landwirtschaftliche-grundstoffe',
    'grosshandel-getreide',
    'grosshandel-saatgut',
    'grosshandel-futtermittel',
    'grosshandel-blumen-pflanzen',
  ];

  /// NACE 46.3x - Wholesale of food, beverages, tobacco
  static const foodBeverages = [
    'grosshandel-nahrungsmittel',
    'grosshandel-obst-gemuese',
    'grosshandel-fleisch-fleischwaren',
    'grosshandel-milchprodukte',
    'grosshandel-getraenke',
    'grosshandel-tabakwaren',
    'grosshandel-backwaren',
    'grosshandel-suessigkeiten',
  ];

  /// NACE 46.4x - Wholesale of household goods
  static const householdGoods = [
    'grosshandel-textilien',
    'grosshandel-bekleidung',
    'grosshandel-schuhe',
    'grosshandel-elektrogeraete',
    'grosshandel-porzellan',
    'grosshandel-moebel',
    'grosshandel-uhren-schmuck',
  ];

  /// NACE 46.5x - Wholesale of information and communication equipment
  static const ictEquipment = [
    'grosshandel-computer',
    'grosshandel-software',
    'grosshandel-telekommunikation',
    'grosshandel-elektronik',
  ];

  /// NACE 46.6x - Wholesale of machinery, equipment
  static const machinery = [
    'grosshandel-landmaschinen',
    'grosshandel-baumaschinen',
    'grosshandel-bueromaschinen',
    'grosshandel-werkzeugmaschinen',
  ];

  /// NACE 46.7x - Other specialized wholesale
  static const otherSpecialized = [
    'grosshandel-brennstoffe',
    'grosshandel-metalle',
    'grosshandel-chemikalien',
    'grosshandel-baumaterialien',
    'grosshandel-sanitaerbedarf',
    'grosshandel-altmaterialien',
  ];

  /// NACE 46.9x - Non-specialized wholesale
  static const nonSpecialized = [
    'grosshandel',
    'sortimentshandel',
  ];

  /// All wholesale branch identifiers.
  static List<String> get all => [
        ...agents,
        ...rawMaterials,
        ...foodBeverages,
        ...householdGoods,
        ...ictEquipment,
        ...machinery,
        ...otherSpecialized,
        ...nonSpecialized,
      ];
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

  /// Scrape wholesale businesses from WKO for given Bundesländer.
  Future<WkoScrapingResult> scrapeWholesale({
    List<String>? bundeslaender,
    List<String>? branches,
    void Function(int current, int total)? onProgress,
  }) async {
    final targetBundeslaender = bundeslaender ?? WkoBundesland.all;
    final targetBranches = branches ?? WkoWholesaleBranches.all;
    final allBusinesses = <WkoBusinessListing>[];
    final errors = <String>[];
    final byBundesland = <String, int>{};
    final byBranch = <String, int>{};
    final seenIds = <String>{};

    final totalTasks = targetBundeslaender.length * targetBranches.length;
    var completedTasks = 0;

    for (final bundesland in targetBundeslaender) {
      for (final branch in targetBranches) {
        try {
          _log.info('Scraping $bundesland / $branch');
          final businesses = await _scrapeBranchForBundesland(
            bundesland: bundesland,
            branch: branch,
          );

          for (final business in businesses) {
            if (!seenIds.contains(business.wkoId)) {
              seenIds.add(business.wkoId);
              allBusinesses.add(business);
              byBundesland[bundesland] =
                  (byBundesland[bundesland] ?? 0) + 1;
              byBranch[branch] = (byBranch[branch] ?? 0) + 1;
            }
          }

          _log.info(
            'Found ${businesses.length} businesses for $bundesland/$branch',
          );
        } catch (e) {
          final errorMsg = 'Error scraping $bundesland/$branch: $e';
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
      byBranch: byBranch,
      errors: errors,
      scrapedAt: DateTime.now().toUtc(),
    );
  }

  /// Scrape a specific branch for a Bundesland.
  Future<List<WkoBusinessListing>> _scrapeBranchForBundesland({
    required String bundesland,
    required String branch,
  }) async {
    final businesses = <WkoBusinessListing>[];
    var page = 1;
    var hasMore = true;

    while (hasMore && page <= config.maxPagesPerBranch) {
      final url = _buildSearchUrl(
        bundesland: bundesland,
        branch: branch,
        page: page,
      );

      try {
        final pageResult = await _scrapePage(url, bundesland);
        businesses.addAll(pageResult.businesses);
        hasMore = pageResult.hasNextPage;
        page++;

        // Rate limiting
        await _delay();
      } catch (e) {
        _log.warning('Error on page $page: $e');
        hasMore = false;
      }
    }

    return businesses;
  }

  /// Build WKO search URL for a specific Bundesland and branch.
  String _buildSearchUrl({
    required String bundesland,
    required String branch,
    int page = 1,
  }) {
    // URL pattern: https://firmen.wko.at/-/[bundesland]/?branche=[code]&page=N
    final params = {
      'branche': branch,
      if (page > 1) 'page': page.toString(),
    };

    final queryString =
        params.entries.map((e) => '${e.key}=${e.value}').join('&');

    return '${config.baseUrl}/-/$bundesland/?$queryString';
  }

  /// Scrape a single page of search results.
  Future<WkoPageResult> _scrapePage(String url, String bundesland) async {
    final response = await _fetchWithRetry(url);
    final document = html_parser.parse(response.body);
    final businesses = <WkoBusinessListing>[];

    // Parse business listings from HTML.
    // WKO uses specific CSS classes for business cards.
    final listingElements = document.querySelectorAll(
      '.search-result-item, .company-list-item, .firma-item, article.company',
    );

    for (final element in listingElements) {
      try {
        // Extract company name (multiple possible selectors)
        final nameElement = element.querySelector(
          'h2, h3, .company-name, .firma-name, .title a, a.company-link',
        );
        final name = nameElement?.text.trim();

        if (name == null || name.isEmpty) continue;

        // Extract WKO ID from link
        final linkElement = element.querySelector('a[href*="/firma/"]');
        final href = linkElement?.attributes['href'] ?? '';
        final wkoId = _extractWkoId(href);

        if (wkoId == null) continue;

        // Extract address components
        final addressElement = element.querySelector(
          '.address, .adresse, .location, p.address',
        );
        final addressText = addressElement?.text.trim();
        final (street, postcode, city) = _parseAddress(addressText);

        // Extract contact info
        final phoneElement = element.querySelector(
          '.phone, .telefon, a[href^="tel:"], .contact-phone',
        );
        final phone = _extractPhone(phoneElement);

        final emailElement = element.querySelector(
          '.email, a[href^="mailto:"], .contact-email',
        );
        final email = _extractEmail(emailElement);

        final websiteElement = element.querySelector(
          '.website, a.website-link, .contact-website a',
        );
        final website = _extractWebsite(websiteElement);

        // Extract branches/categories
        final branchElements = element.querySelectorAll(
          '.branch, .branche, .category, .kategorie',
        );
        final branches = branchElements
            .map((e) => e.text.trim())
            .where((b) => b.isNotEmpty)
            .toList();

        // Build detail URL
        final detailUrl =
            href.isNotEmpty ? _normalizeUrl(href) : null;

        businesses.add(WkoBusinessListing(
          name: name,
          wkoId: wkoId,
          address: street,
          postcode: postcode,
          city: city,
          bundesland: bundesland,
          phone: phone,
          email: email,
          website: website,
          branches: branches,
          detailUrl: detailUrl,
        ));
      } catch (e) {
        _log.fine('Error parsing listing element: $e');
      }
    }

    // Check for pagination
    final hasNextPage = _hasNextPage(document);

    // Try to extract total results count
    final totalElement = document.querySelector(
      '.results-count, .total-results, .anzahl',
    );
    final totalText = totalElement?.text ?? '';
    final totalResults = int.tryParse(
          RegExp(r'\d+').firstMatch(totalText)?.group(0) ?? '',
        ) ??
        0;

    // Extract current page
    final pageElement = document.querySelector('.pagination .active, .page.current');
    final currentPage = int.tryParse(pageElement?.text.trim() ?? '1') ?? 1;

    return WkoPageResult(
      businesses: businesses,
      totalResults: totalResults,
      currentPage: currentPage,
      hasNextPage: hasNextPage,
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
        final response = await _client
            .get(
              Uri.parse(url),
              headers: {
                'User-Agent': config.userAgent,
                'Accept':
                    'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
                'Accept-Language': 'de-AT,de;q=0.9,en;q=0.8',
              },
            )
            .timeout(const Duration(seconds: 30));

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
    final delay = config.requestDelayMs +
        _random.nextInt(config.randomDelayMs);
    await Future<void>.delayed(Duration(milliseconds: delay));
  }

  /// Extract WKO ID from URL.
  String? _extractWkoId(String url) {
    // Pattern: /firma/123456/company-name
    final match = RegExp(r'/firma/(\d+)').firstMatch(url);
    return match?.group(1);
  }

  /// Parse address text into components.
  (String?, String?, String?) _parseAddress(String? addressText) {
    if (addressText == null || addressText.isEmpty) {
      return (null, null, null);
    }

    // Austrian postcode pattern: 4 digits
    final postcodeMatch = RegExp(r'(\d{4})').firstMatch(addressText);
    final postcode = postcodeMatch?.group(1);

    // Try to split address
    // Common format: "Straße 123, 1010 Wien"
    final parts = addressText.split(RegExp(r'[,\n]'));
    final street = parts.isNotEmpty ? parts[0].trim() : null;

    // Extract city (usually after postcode)
    String? city;
    if (postcode != null && addressText.contains(postcode)) {
      final afterPostcode = addressText.split(postcode);
      if (afterPostcode.length > 1) {
        city = afterPostcode[1].replaceAll(RegExp(r'^[\s,]+'), '').trim();
        if (city.isEmpty) city = null;
      }
    }

    return (street, postcode, city);
  }

  /// Extract phone number from element.
  String? _extractPhone(dynamic element) {
    if (element == null) return null;

    // Try href first (tel: link)
    final href = element.attributes?['href'] as String?;
    if (href != null && href.startsWith('tel:')) {
      return href.replaceFirst('tel:', '').trim();
    }

    // Fall back to text content
    final text = element.text?.trim();
    if (text == null || text.isEmpty) return null;

    // Extract phone pattern
    final phoneMatch =
        RegExp(r'[\d\s\-\+\(\)/]+').firstMatch(text);
    return phoneMatch?.group(0)?.trim();
  }

  /// Extract email from element.
  String? _extractEmail(dynamic element) {
    if (element == null) return null;

    // Try href first (mailto: link)
    final href = element.attributes?['href'] as String?;
    if (href != null && href.startsWith('mailto:')) {
      return href.replaceFirst('mailto:', '').split('?')[0].trim();
    }

    // Fall back to text content
    final text = element.text?.trim();
    if (text == null || text.isEmpty) return null;

    // Extract email pattern
    final emailMatch = RegExp(r'[\w\.\-]+@[\w\.\-]+\.\w+').firstMatch(text);
    return emailMatch?.group(0);
  }

  /// Extract website from element.
  String? _extractWebsite(dynamic element) {
    if (element == null) return null;

    // Try href first
    final href = element.attributes?['href'] as String?;
    if (href != null &&
        href.isNotEmpty &&
        !href.startsWith('mailto:') &&
        !href.startsWith('tel:')) {
      return _normalizeUrl(href);
    }

    // Fall back to text content
    final text = element.text?.trim();
    if (text != null && text.contains('.')) {
      return _normalizeUrl(text);
    }

    return null;
  }

  /// Normalize URL (add https:// if missing).
  String? _normalizeUrl(String? url) {
    if (url == null || url.isEmpty) return null;

    var normalized = url.trim();
    if (normalized.startsWith('//')) {
      normalized = 'https:$normalized';
    } else if (!normalized.startsWith('http')) {
      // Check if it looks like a relative path
      if (normalized.startsWith('/')) {
        normalized = '${config.baseUrl}$normalized';
      } else {
        normalized = 'https://$normalized';
      }
    }

    return normalized;
  }

  /// Check if there's a next page.
  bool _hasNextPage(dynamic document) {
    // Look for next page link or disabled next button
    final nextLink = document.querySelector(
      '.pagination .next:not(.disabled), '
      'a[rel="next"], '
      '.page-next:not(.disabled)',
    );
    return nextLink != null;
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

  final jsonString = const JsonEncoder.withIndent('  ').convert(result.toJson());
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
