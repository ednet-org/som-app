/// Firmenbuch HVD extractor.
/// Extracts company data from Austrian Firmenbuch High Value Dataset.
library;

import 'dart:convert';
import 'dart:io';

import 'package:xml/xml.dart';

import '../config/data_sources.dart';
import '../models/business_entity.dart';
import '../transformers/address_parser.dart';

/// Result of Firmenbuch extraction.
class FirmenbuchExtractionResult {
  FirmenbuchExtractionResult({
    required this.entities,
    required this.totalRecords,
    required this.validRecords,
    required this.skippedNoName,
    required this.skippedNoAddress,
  });

  final List<FirmenbuchEntity> entities;
  final int totalRecords;
  final int validRecords;
  final int skippedNoName;
  final int skippedNoAddress;
}

/// Firmenbuch entity (subset of full BusinessEntity).
/// Used for enrichment matching.
class FirmenbuchEntity {
  FirmenbuchEntity({
    required this.firmenbuchNr,
    required this.name,
    this.legalForm,
    this.uidNr,
    this.address,
    this.active,
  });

  final String firmenbuchNr;
  final String name;
  final String? legalForm;
  final String? uidNr;
  final Address? address;
  final bool? active;

  /// Normalized name for matching.
  String get normalizedName => _normalizeName(name);

  static String _normalizeName(String name) {
    var normalized = name.toLowerCase().trim();

    // Remove common legal form suffixes
    normalized = normalized
        .replaceAll(RegExp(r'\s+(gmbh|kg|og|ag|e\.u\.|keg|gesnbr|ges\.?m\.?b\.?h\.?)\.?\s*$'), '')
        .replaceAll(RegExp(r'\s+&\s+co\.?\s*'), ' ')
        .trim();

    // Remove special characters
    normalized = normalized
        .replaceAll(RegExp(r'[^\w\s]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    return normalized;
  }

  /// Name tokens for fuzzy matching.
  List<String> get nameTokens {
    return normalizedName
        .split(' ')
        .where((t) => t.length > 2)
        .toList();
  }
}

/// Extracts company data from Firmenbuch HVD.
class FirmenbuchExtractor {
  FirmenbuchExtractor({this.sourceUrl});

  final String? sourceUrl;

  /// Extract from JSON file.
  Future<FirmenbuchExtractionResult> extractFromJsonFile(String path) async {
    final file = File(path);
    final content = await file.readAsString();
    return extractFromJson(content);
  }

  /// Extract from JSON string.
  FirmenbuchExtractionResult extractFromJson(String jsonStr) {
    final data = jsonDecode(jsonStr);
    final records = data is List ? data : (data['data'] as List? ?? []);

    final entities = <FirmenbuchEntity>[];
    var skippedNoName = 0;
    var skippedNoAddress = 0;

    for (final record in records) {
      final r = record as Map<String, dynamic>;

      final name = r['name'] as String? ?? r['firma'] as String?;
      if (name == null || name.trim().isEmpty) {
        skippedNoName++;
        continue;
      }

      final firmenbuchNr = r['firmenbuch_nr'] as String? ??
          r['firmenbuchNr'] as String? ??
          r['fn'] as String?;

      if (firmenbuchNr == null) {
        continue;
      }

      // Extract address
      Address? address;
      final addrStr = r['address'] as String? ??
          r['adresse'] as String? ??
          r['sitz'] as String?;

      if (addrStr != null && addrStr.isNotEmpty) {
        address = AddressParser.fromRawString(addrStr);
      } else {
        // Try structured address fields
        final plz = r['plz'] as String? ?? r['postcode'] as String?;
        final ort = r['ort'] as String? ?? r['city'] as String?;
        final strasse = r['strasse'] as String? ?? r['street'] as String?;

        if (plz != null || ort != null || strasse != null) {
          address = Address(
            postcode: plz,
            city: ort,
            street: strasse,
            bundesland: Bundesland.fromPostcode(plz),
          );
        } else {
          skippedNoAddress++;
        }
      }

      final legalForm = r['rechtsform'] as String? ?? r['legal_form'] as String?;
      final uidNr = r['uid'] as String? ?? r['uid_nr'] as String?;
      final activeStr = r['status'] as String? ?? r['active'] as String?;
      final active = activeStr == null
          ? null
          : (activeStr.toLowerCase() == 'aktiv' || activeStr == 'true');

      entities.add(FirmenbuchEntity(
        firmenbuchNr: _normalizedFirmenbuchNr(firmenbuchNr),
        name: name.trim(),
        legalForm: legalForm,
        uidNr: uidNr != null ? _normalizeUid(uidNr) : null,
        address: address,
        active: active,
      ));
    }

    return FirmenbuchExtractionResult(
      entities: entities,
      totalRecords: records.length,
      validRecords: entities.length,
      skippedNoName: skippedNoName,
      skippedNoAddress: skippedNoAddress,
    );
  }

  /// Extract from XML file.
  Future<FirmenbuchExtractionResult> extractFromXmlFile(String path) async {
    final file = File(path);
    final content = await file.readAsString();
    return extractFromXml(content);
  }

  /// Extract from XML string.
  FirmenbuchExtractionResult extractFromXml(String xmlStr) {
    final document = XmlDocument.parse(xmlStr);
    final companies = document.findAllElements('company');

    final entities = <FirmenbuchEntity>[];
    var skippedNoName = 0;
    var skippedNoAddress = 0;

    for (final company in companies) {
      final name = company.getElement('name')?.innerText ??
          company.getElement('firma')?.innerText;

      if (name == null || name.trim().isEmpty) {
        skippedNoName++;
        continue;
      }

      final firmenbuchNr = company.getElement('firmenbuch_nr')?.innerText ??
          company.getElement('fn')?.innerText;

      if (firmenbuchNr == null) {
        continue;
      }

      // Extract address
      Address? address;
      final addrElement = company.getElement('address') ??
          company.getElement('adresse') ??
          company.getElement('sitz');

      if (addrElement != null) {
        final plz = addrElement.getElement('plz')?.innerText ??
            addrElement.getElement('postcode')?.innerText;
        final ort = addrElement.getElement('ort')?.innerText ??
            addrElement.getElement('city')?.innerText;
        final strasse = addrElement.getElement('strasse')?.innerText ??
            addrElement.getElement('street')?.innerText;

        if (plz != null || ort != null || strasse != null) {
          address = Address(
            postcode: plz,
            city: ort,
            street: strasse,
            bundesland: Bundesland.fromPostcode(plz),
          );
        } else {
          // Try raw address text
          final rawAddr = addrElement.innerText.trim();
          if (rawAddr.isNotEmpty) {
            address = AddressParser.fromRawString(rawAddr);
          } else {
            skippedNoAddress++;
          }
        }
      } else {
        skippedNoAddress++;
      }

      final legalForm = company.getElement('rechtsform')?.innerText ??
          company.getElement('legal_form')?.innerText;
      final uidNr = company.getElement('uid')?.innerText;
      final status = company.getElement('status')?.innerText;

      entities.add(FirmenbuchEntity(
        firmenbuchNr: _normalizedFirmenbuchNr(firmenbuchNr),
        name: name.trim(),
        legalForm: legalForm,
        uidNr: uidNr != null ? _normalizeUid(uidNr) : null,
        address: address,
        active: status == null
            ? null
            : (status.toLowerCase() == 'aktiv' || status == 'active'),
      ));
    }

    return FirmenbuchExtractionResult(
      entities: entities,
      totalRecords: companies.length,
      validRecords: entities.length,
      skippedNoName: skippedNoName,
      skippedNoAddress: skippedNoAddress,
    );
  }

  /// Normalize Firmenbuchnummer to standard format "FN 123456a".
  String _normalizedFirmenbuchNr(String fn) {
    var normalized = fn.trim().toUpperCase();

    // Remove "FN" prefix if present
    if (normalized.startsWith('FN')) {
      normalized = normalized.substring(2).trim();
    }

    // Remove spaces
    normalized = normalized.replaceAll(' ', '');

    // Extract number and suffix
    final match = RegExp(r'^(\d+)([a-z])?$', caseSensitive: false)
        .firstMatch(normalized);

    if (match != null) {
      final number = match.group(1);
      final suffix = (match.group(2) ?? '').toLowerCase();
      return 'FN $number$suffix';
    }

    return 'FN $normalized';
  }

  /// Normalize UID to standard format "ATU12345678".
  String _normalizeUid(String uid) {
    var normalized = uid.trim().toUpperCase();

    // Ensure ATU prefix
    if (!normalized.startsWith('ATU')) {
      if (normalized.startsWith('AT')) {
        normalized = 'ATU${normalized.substring(2)}';
      } else {
        normalized = 'ATU$normalized';
      }
    }

    // Remove spaces and non-alphanumeric
    normalized = normalized.replaceAll(RegExp(r'[^A-Z0-9]'), '');

    return normalized;
  }

  /// Create provenance for Firmenbuch data.
  Provenance createProvenance(List<String> fields) {
    return Provenance(
      sourceId: FirmenbuchDataSource.id,
      sourceName: FirmenbuchDataSource.name,
      sourceUrl: sourceUrl ?? FirmenbuchDataSource.url,
      fetchedAt: DateTime.now().toUtc().toIso8601String(),
      license: FirmenbuchDataSource.license,
      licenseUrl: FirmenbuchDataSource.licenseUrl,
      fields: fields,
    );
  }
}
