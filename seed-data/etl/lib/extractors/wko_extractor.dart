/// WKO Firmen A-Z data extractor.
/// Converts WKO scraped data into BusinessEntity objects.
library;

import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:yaml/yaml.dart';

import '../config/data_sources.dart';
import '../models/business_entity.dart';
import '../scrapers/wko_scraper.dart';
import '../transformers/phone_normalizer.dart';
import '../transformers/pii_filter.dart';

final _log = Logger('WkoExtractor');

/// Result of WKO extraction.
class WkoExtractionResult {
  WkoExtractionResult({
    required this.entities,
    required this.totalScraped,
    required this.validEntities,
    required this.skippedNoName,
    required this.skippedNoAddress,
    required this.byNaceCode,
    required this.byBundesland,
    required this.piiReport,
  });

  final List<BusinessEntity> entities;
  final int totalScraped;
  final int validEntities;
  final int skippedNoName;
  final int skippedNoAddress;
  final Map<String, int> byNaceCode;
  final Map<String, int> byBundesland;
  final PiiAuditReport piiReport;
}

/// NACE code mapping entry.
class NaceMapping {
  NaceMapping({
    required this.naceCode,
    required this.naceName,
    required this.somCategory,
    required this.productTags,
    required this.providerType,
  });

  factory NaceMapping.fromYaml(Map<String, dynamic> yaml) {
    return NaceMapping(
      naceCode: yaml['nace'] as String,
      naceName: yaml['nace_name'] as String,
      somCategory: yaml['som_category'] as String,
      productTags: (yaml['product_tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      providerType: yaml['provider_type'] as String? ?? 'GROSSHAENDLER',
    );
  }

  final String naceCode;
  final String naceName;
  final String somCategory;
  final List<String> productTags;
  final String providerType;
}

/// WKO branch to NACE mapping.
class WkoToNaceMapper {
  WkoToNaceMapper(this._mappings);

  final Map<String, NaceMapping> _mappings;

  /// Load mapper from YAML file.
  static Future<WkoToNaceMapper> fromYamlFile(String path) async {
    final file = File(path);
    final content = await file.readAsString();
    return fromYamlString(content);
  }

  /// Load mapper from YAML string.
  static WkoToNaceMapper fromYamlString(String yaml) {
    final doc = loadYaml(yaml) as YamlMap;
    final mappingsYaml = doc['mappings'] as YamlList? ?? [];
    final mappings = <String, NaceMapping>{};

    for (final entry in mappingsYaml) {
      final mapping = NaceMapping.fromYaml(
        Map<String, dynamic>.from(entry as YamlMap),
      );
      // Index by WKO branch keywords
      final wkoBranches = entry['wko_branches'] as YamlList?;
      if (wkoBranches != null) {
        for (final branch in wkoBranches) {
          mappings[branch.toString().toLowerCase()] = mapping;
        }
      }
      // Also index by NACE code
      mappings[mapping.naceCode] = mapping;
    }

    return WkoToNaceMapper(mappings);
  }

  /// Map WKO branch name to NACE mapping.
  NaceMapping? mapBranch(String branch) {
    final normalized = branch.toLowerCase().trim();

    // Direct match
    if (_mappings.containsKey(normalized)) {
      return _mappings[normalized];
    }

    // Partial match (contains)
    for (final entry in _mappings.entries) {
      if (normalized.contains(entry.key) || entry.key.contains(normalized)) {
        return entry.value;
      }
    }

    return null;
  }

  /// Map NACE code prefix to a default mapping.
  NaceMapping? mapNacePrefix(String nacePrefix) {
    // Find first mapping that starts with the prefix
    for (final entry in _mappings.entries) {
      if (entry.value.naceCode.startsWith(nacePrefix)) {
        return entry.value;
      }
    }
    return null;
  }
}

/// WKO data extractor.
class WkoExtractor {
  WkoExtractor({
    this.naceMapper,
  });

  final WkoToNaceMapper? naceMapper;

  /// Extract entities from a JSON file containing WKO scraping results.
  Future<WkoExtractionResult> extractFromFile(String path) async {
    final file = File(path);
    final content = await file.readAsString();
    return extractFromJson(content);
  }

  /// Extract entities from JSON string.
  WkoExtractionResult extractFromJson(String jsonString) {
    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    final businessesData = data['businesses'] as List<dynamic>;

    final businesses = businessesData
        .map((b) => WkoBusinessListing.fromJson(b as Map<String, dynamic>))
        .toList();

    return extract(businesses);
  }

  /// Extract entities from WKO business listings.
  WkoExtractionResult extract(List<WkoBusinessListing> listings) {
    final entities = <BusinessEntity>[];
    var skippedNoName = 0;
    var skippedNoAddress = 0;
    final byNaceCode = <String, int>{};
    final byBundesland = <String, int>{};
    var piiReport = const PiiAuditReport(
      allowedPhones: 0,
      filteredPhones: 0,
      allowedEmails: 0,
      filteredEmails: 0,
      allowedWebsites: 0,
      filteredReasons: {},
    );

    for (final listing in listings) {
      // Validate name
      if (listing.name.trim().isEmpty) {
        skippedNoName++;
        continue;
      }

      // Validate address (at least postcode or city)
      if (listing.postcode == null && listing.city == null) {
        skippedNoAddress++;
        continue;
      }

      // Build address
      final bundesland = _mapBundesland(listing.bundesland, listing.postcode);
      final address = Address(
        postcode: listing.postcode,
        city: listing.city,
        street: listing.address,
        bundesland: bundesland,
      );

      // Track by Bundesland
      if (bundesland != null) {
        final bl = bundesland.toJson();
        byBundesland[bl] = (byBundesland[bl] ?? 0) + 1;
      }

      // Extract contacts
      final contacts = _extractContacts(listing);

      // Filter PII
      final contactReport = PiiFilter.auditContacts(contacts);
      piiReport = piiReport.merge(contactReport);
      final filteredContacts = PiiFilter.filterContacts(contacts);

      // Map to NACE and taxonomy
      final (naceCodes, taxonomy, providerType) = _mapToTaxonomy(listing);

      // Track by NACE code
      for (final nace in naceCodes) {
        byNaceCode[nace.code] = (byNaceCode[nace.code] ?? 0) + 1;
      }

      // Create provenance
      final provenance = Provenance(
        sourceId: WkoDataSource.id,
        sourceName: WkoDataSource.name,
        sourceUrl: listing.detailUrl ?? WkoDataSource.url,
        fetchedAt: DateTime.now().toUtc().toIso8601String(),
        license: WkoDataSource.license,
        licenseUrl: WkoDataSource.licenseUrl,
        fields: [
          'name',
          'address',
          if (filteredContacts.phones.isNotEmpty) 'phones',
          if (filteredContacts.emails.isNotEmpty) 'emails',
          if (filteredContacts.websites.isNotEmpty) 'websites',
          'classification',
        ],
      );

      final entity = BusinessEntity(
        name: listing.name.trim(),
        providerType: providerType,
        companySize: CompanySize.unknown,
        addresses: [address],
        contacts: filteredContacts,
        externalIds: ExternalIds(wkoMemberId: listing.wkoId),
        classification: Classification(naceCodes: naceCodes),
        taxonomy: taxonomy,
        provenance: [provenance],
      );

      entities.add(entity);
    }

    _log.info(
      'Extracted ${entities.length}/${listings.length} entities from WKO',
    );
    _log.info('  Skipped no name: $skippedNoName');
    _log.info('  Skipped no address: $skippedNoAddress');

    return WkoExtractionResult(
      entities: entities,
      totalScraped: listings.length,
      validEntities: entities.length,
      skippedNoName: skippedNoName,
      skippedNoAddress: skippedNoAddress,
      byNaceCode: byNaceCode,
      byBundesland: byBundesland,
      piiReport: piiReport,
    );
  }

  /// Map Bundesland string to enum.
  Bundesland? _mapBundesland(String? bundeslandStr, String? postcode) {
    if (bundeslandStr != null) {
      final normalized = bundeslandStr.toLowerCase().trim();
      switch (normalized) {
        case 'wien':
          return Bundesland.wien;
        case 'niederoesterreich':
        case 'niederösterreich':
          return Bundesland.niederoesterreich;
        case 'oberoesterreich':
        case 'oberösterreich':
          return Bundesland.oberoesterreich;
        case 'salzburg':
          return Bundesland.salzburg;
        case 'tirol':
          return Bundesland.tirol;
        case 'vorarlberg':
          return Bundesland.vorarlberg;
        case 'kaernten':
        case 'kärnten':
          return Bundesland.kaernten;
        case 'steiermark':
          return Bundesland.steiermark;
        case 'burgenland':
          return Bundesland.burgenland;
      }
    }

    // Fall back to postcode-based inference
    return Bundesland.fromPostcode(postcode);
  }

  /// Extract contacts from WKO listing.
  Contacts _extractContacts(WkoBusinessListing listing) {
    final phones = <PhoneContact>[];
    final emails = <EmailContact>[];
    final websites = <WebsiteContact>[];

    // Phone
    if (listing.phone != null) {
      final normalized = PhoneNormalizer.normalize(listing.phone!);
      if (normalized != null) {
        final type = PhoneNormalizer.isMobile(normalized)
            ? PhoneType.mobile
            : PhoneType.main;
        phones.add(PhoneContact(
          value: normalized,
          type: type,
          sourceUrl: listing.detailUrl,
        ));
      }
    }

    // Email
    if (listing.email != null && listing.email!.contains('@')) {
      emails.add(EmailContact(
        value: listing.email!.trim().toLowerCase(),
        type: EmailType.general,
        sourceUrl: listing.detailUrl,
      ));
    }

    // Website
    if (listing.website != null) {
      var url = listing.website!.trim();
      if (!url.startsWith('http')) {
        url = 'https://$url';
      }
      websites.add(WebsiteContact(
        value: url,
        type: WebsiteType.main,
        sourceUrl: listing.detailUrl,
      ));
    }

    return Contacts(
      phones: phones,
      emails: emails,
      websites: websites,
    );
  }

  /// Map WKO listing to NACE codes and taxonomy.
  (List<NaceCode>, Taxonomy, ProviderType) _mapToTaxonomy(
    WkoBusinessListing listing,
  ) {
    final naceCodes = <NaceCode>[];
    String? branchId;
    String? branchName;
    String? categoryId;
    String? categoryName;
    var productTags = <String>[];
    var providerType = ProviderType.grosshaendler;

    // Try to map branches using NACE mapper
    if (naceMapper != null) {
      for (final branch in listing.branches) {
        final mapping = naceMapper!.mapBranch(branch);
        if (mapping != null) {
          naceCodes.add(NaceCode(
            code: mapping.naceCode,
            description: mapping.naceName,
            primary: naceCodes.isEmpty, // First one is primary
          ));

          // Set category info from first matched mapping
          if (categoryName == null) {
            categoryName = mapping.somCategory;
            categoryId = _slugify(mapping.somCategory);
            branchId = 'grosshandel';
            branchName = 'Großhandel';
            productTags = mapping.productTags;

            if (mapping.providerType == 'HAENDLER') {
              providerType = ProviderType.haendler;
            } else if (mapping.providerType == 'DIENSTLEISTER') {
              providerType = ProviderType.dienstleister;
            }
          }

          break; // Use first match
        }
      }
    }

    // Default NACE code for wholesale if no specific mapping
    if (naceCodes.isEmpty) {
      naceCodes.add(NaceCode(
        code: '46',
        description: 'Großhandel (ohne Handel mit Kraftfahrzeugen)',
        primary: true,
      ));
    }

    // Build taxonomy
    final taxonomy = Taxonomy(
      branchId: branchId ?? 'grosshandel',
      branchName: branchName ?? 'Großhandel',
      categoryId: categoryId,
      categoryName: categoryName,
      productTags: productTags,
      inference: TaxonomyInference(
        method: InferenceMethod.naceMapping,
        confidence: categoryName != null ? 0.9 : 0.7,
        matchedTags: listing.branches,
      ),
    );

    return (naceCodes, taxonomy, providerType);
  }

  /// Convert string to URL-safe slug.
  String _slugify(String input) {
    return input
        .toLowerCase()
        .replaceAll(RegExp(r'[äÄ]'), 'ae')
        .replaceAll(RegExp(r'[öÖ]'), 'oe')
        .replaceAll(RegExp(r'[üÜ]'), 'ue')
        .replaceAll('ß', 'ss')
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
  }
}
