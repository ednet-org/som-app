/// OSM data extractor.
/// Extracts business POIs from GeoJSON exported from OSM PBF files.
library;

import 'dart:convert';
import 'dart:io';

import '../config/data_sources.dart';
import '../mappers/osm_to_som_taxonomy.dart';
import '../mappers/provider_type_mapper.dart';
import '../models/business_entity.dart';
import '../transformers/address_parser.dart';
import '../transformers/phone_normalizer.dart';
import '../transformers/pii_filter.dart';

/// Result of OSM extraction.
class OsmExtractionResult {
  OsmExtractionResult({
    required this.entities,
    required this.totalFeatures,
    required this.validFeatures,
    required this.skippedNoName,
    required this.skippedNoLocation,
    required this.skippedOutsideAustria,
    required this.piiReport,
  });

  final List<BusinessEntity> entities;
  final int totalFeatures;
  final int validFeatures;
  final int skippedNoName;
  final int skippedNoLocation;
  final int skippedOutsideAustria;
  final PiiAuditReport piiReport;
}

/// Extracts business entities from OSM GeoJSON data.
class OsmExtractor {
  OsmExtractor({
    required this.taxonomyMapper,
    required this.providerTypeMapper,
    this.sourceUrl,
  });

  final OsmToSomTaxonomyMapper taxonomyMapper;
  final ProviderTypeMapper providerTypeMapper;
  final String? sourceUrl;

  /// Extract entities from a GeoJSON file.
  Future<OsmExtractionResult> extractFromFile(String path) async {
    final file = File(path);
    final content = await file.readAsString();
    return extractFromGeoJson(content);
  }

  /// Extract entities from GeoJSON string.
  OsmExtractionResult extractFromGeoJson(String geoJson) {
    final data = jsonDecode(geoJson) as Map<String, dynamic>;
    final features = data['features'] as List<dynamic>;

    final entities = <BusinessEntity>[];
    var skippedNoName = 0;
    var skippedNoLocation = 0;
    var skippedOutsideAustria = 0;
    var piiReport = const PiiAuditReport(
      allowedPhones: 0,
      filteredPhones: 0,
      allowedEmails: 0,
      filteredEmails: 0,
      allowedWebsites: 0,
      filteredReasons: {},
    );

    for (final feature in features) {
      final f = feature as Map<String, dynamic>;
      final properties = f['properties'] as Map<String, dynamic>? ?? {};
      final geometry = f['geometry'] as Map<String, dynamic>?;

      // Extract name
      final name = properties['name'] as String?;
      if (name == null || name.trim().isEmpty) {
        skippedNoName++;
        continue;
      }

      // Extract coordinates
      GeoCoordinates? geo;
      if (geometry != null) {
        final type = geometry['type'] as String?;
        final coords = geometry['coordinates'];

        if (type == 'Point' && coords is List && coords.length >= 2) {
          final lon = (coords[0] as num).toDouble();
          final lat = (coords[1] as num).toDouble();

          // Validate Austrian bounds
          if (!AddressParser.isInAustria(lat, lon)) {
            skippedOutsideAustria++;
            continue;
          }

          geo = GeoCoordinates(lat: lat, lon: lon);
        } else if (type == 'Polygon' || type == 'MultiPolygon') {
          // Use centroid for polygons
          final centroid = _calculateCentroid(geometry);
          if (centroid != null) {
            if (!AddressParser.isInAustria(centroid.lat, centroid.lon)) {
              skippedOutsideAustria++;
              continue;
            }
            geo = centroid;
          }
        }
      }

      if (geo == null) {
        skippedNoLocation++;
        continue;
      }

      // Extract OSM tags (filter for relevant business tags)
      final osmTags = <String, String>{};
      for (final key in OsmBusinessTags.tagKeys) {
        final value = properties[key] as String?;
        if (value != null) {
          osmTags[key] = value;
        }
      }

      // Check specific tags
      for (final entry in OsmBusinessTags.specificTags.entries) {
        final value = properties[entry.key] as String?;
        if (value != null && entry.value.contains(value)) {
          osmTags[entry.key] = value;
        }
      }

      // Skip if no relevant business tags
      if (osmTags.isEmpty) {
        continue;
      }

      // Extract address from addr:* tags
      final addressTags = <String, String>{};
      for (final key in properties.keys) {
        if (key.startsWith('addr:')) {
          final value = properties[key];
          if (value is String) {
            addressTags[key] = value;
          }
        }
      }
      final address = AddressParser.fromOsmTags(addressTags);

      // Extract contacts
      final contacts = _extractContacts(properties);

      // Filter PII
      final contactReport = PiiFilter.auditContacts(contacts);
      piiReport = piiReport.merge(contactReport);
      final filteredContacts = PiiFilter.filterContacts(contacts);

      // Map to taxonomy
      final taxonomyResult = taxonomyMapper.map(osmTags);
      Taxonomy taxonomy;
      ProviderType providerType;
      final naceCodes = <NaceCode>[];

      if (taxonomyResult != null) {
        taxonomy = taxonomyResult.taxonomy;
        providerType = taxonomyResult.providerType;
        if (taxonomyResult.naceCode != null) {
          naceCodes.add(taxonomyResult.naceCode!);
        }
      } else {
        providerType = providerTypeMapper.map(osmTags);
        taxonomy = Taxonomy(
          inference: TaxonomyInference(
            method: InferenceMethod.osmTagMapping,
            confidence: 0.5,
            matchedTags: osmTags.entries
                .map((e) => '${e.key}=${e.value}')
                .toList(),
          ),
        );
      }

      // Extract external IDs
      final osmId = properties['@id'] as String?;
      final osmType = properties['@type'] as String?;

      ExternalIds externalIds;
      if (osmId != null && osmType != null) {
        externalIds = ExternalIds(
          osmNodeId: osmType == 'node' ? osmId : null,
          osmWayId: osmType == 'way' ? osmId : null,
          osmRelationId: osmType == 'relation' ? osmId : null,
        );
      } else {
        externalIds = ExternalIds();
      }

      // Create provenance
      final provenance = Provenance(
        sourceId: OsmDataSource.id,
        sourceName: OsmDataSource.name,
        sourceUrl: sourceUrl ?? OsmDataSource.url,
        fetchedAt: DateTime.now().toUtc().toIso8601String(),
        license: OsmDataSource.license,
        licenseUrl: OsmDataSource.licenseUrl,
        fields: ['name', 'geo', 'address', 'contacts', 'classification'],
      );

      final entity = BusinessEntity(
        name: name.trim(),
        legalForm: properties['legal_form'] as String?,
        providerType: providerType,
        companySize: CompanySize.unknown,
        addresses: [address],
        geo: geo,
        contacts: filteredContacts,
        externalIds: externalIds,
        classification: Classification(
          osmTags: osmTags,
          naceCodes: naceCodes,
        ),
        taxonomy: taxonomy,
        provenance: [provenance],
      );

      entities.add(entity);
    }

    return OsmExtractionResult(
      entities: entities,
      totalFeatures: features.length,
      validFeatures: entities.length,
      skippedNoName: skippedNoName,
      skippedNoLocation: skippedNoLocation,
      skippedOutsideAustria: skippedOutsideAustria,
      piiReport: piiReport,
    );
  }

  /// Extract contacts from OSM properties.
  Contacts _extractContacts(Map<String, dynamic> properties) {
    final phones = <PhoneContact>[];
    final emails = <EmailContact>[];
    final websites = <WebsiteContact>[];

    // Phone numbers
    final phoneKeys = ['phone', 'contact:phone', 'phone:main', 'fax'];
    for (final key in phoneKeys) {
      final value = properties[key] as String?;
      if (value != null) {
        final normalized = PhoneNormalizer.normalize(value);
        if (normalized != null) {
          final type = key.contains('fax')
              ? PhoneType.fax
              : (PhoneNormalizer.isMobile(normalized)
                  ? PhoneType.mobile
                  : PhoneType.main);
          phones.add(PhoneContact(
            value: normalized,
            type: type,
            sourceUrl: sourceUrl,
          ));
        }
      }
    }

    // Email
    final emailKeys = ['email', 'contact:email'];
    for (final key in emailKeys) {
      final value = properties[key] as String?;
      if (value != null && value.contains('@')) {
        emails.add(EmailContact(
          value: value.trim().toLowerCase(),
          type: EmailType.general,
          sourceUrl: sourceUrl,
        ));
      }
    }

    // Website
    final websiteKeys = ['website', 'contact:website', 'url'];
    for (final key in websiteKeys) {
      final value = properties[key] as String?;
      if (value != null) {
        var url = value.trim();
        if (!url.startsWith('http')) {
          url = 'https://$url';
        }
        websites.add(WebsiteContact(
          value: url,
          type: WebsiteType.main,
          sourceUrl: sourceUrl,
        ));
      }
    }

    return Contacts(
      phones: phones,
      emails: emails,
      websites: websites,
    );
  }

  /// Calculate centroid of a polygon.
  GeoCoordinates? _calculateCentroid(Map<String, dynamic> geometry) {
    final type = geometry['type'] as String?;
    final coords = geometry['coordinates'];

    if (type == 'Polygon' && coords is List && coords.isNotEmpty) {
      // Use first ring (outer boundary)
      final ring = coords[0] as List;
      return _ringCentroid(ring);
    } else if (type == 'MultiPolygon' && coords is List && coords.isNotEmpty) {
      // Use first polygon's outer ring
      final polygon = coords[0] as List;
      if (polygon.isNotEmpty) {
        final ring = polygon[0] as List;
        return _ringCentroid(ring);
      }
    }

    return null;
  }

  /// Calculate centroid of a ring (list of coordinates).
  GeoCoordinates? _ringCentroid(List ring) {
    if (ring.isEmpty) return null;

    var sumLon = 0.0;
    var sumLat = 0.0;
    var count = 0;

    for (final point in ring) {
      if (point is List && point.length >= 2) {
        sumLon += (point[0] as num).toDouble();
        sumLat += (point[1] as num).toDouble();
        count++;
      }
    }

    if (count == 0) return null;

    return GeoCoordinates(
      lat: sumLat / count,
      lon: sumLon / count,
    );
  }
}
