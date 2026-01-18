/// Address parser for Austrian addresses.
/// Parses OSM address tags and raw address strings into structured components.
library;

import '../models/business_entity.dart';

/// Parses Austrian addresses from various formats.
class AddressParser {
  /// OSM address tag keys.
  static const String tagStreet = 'addr:street';
  static const String tagHouseNumber = 'addr:housenumber';
  static const String tagPostcode = 'addr:postcode';
  static const String tagCity = 'addr:city';
  static const String tagCountry = 'addr:country';
  static const String tagFull = 'addr:full';

  /// Pattern for Austrian postcodes (4 digits).
  static final RegExp _postcodePattern = RegExp(r'\b([1-9][0-9]{3})\b');

  // Note: House number pattern is embedded in _parseRawAddress method

  /// Parse address from OSM tags.
  static Address fromOsmTags(Map<String, String> tags) {
    final street = tags[tagStreet]?.trim();
    final houseNumber = tags[tagHouseNumber]?.trim();
    final postcode = tags[tagPostcode]?.trim();
    final city = tags[tagCity]?.trim();
    final fullAddr = tags[tagFull]?.trim();

    // Validate postcode format
    final validPostcode =
        postcode != null && _postcodePattern.hasMatch(postcode)
            ? postcode
            : null;

    // Infer Bundesland from postcode
    final bundesland = Bundesland.fromPostcode(validPostcode);

    // Build raw address string for reference
    final rawParts = <String>[];
    if (street != null) rawParts.add(street);
    if (houseNumber != null) rawParts.add(houseNumber);
    if (validPostcode != null) rawParts.add(validPostcode);
    if (city != null) rawParts.add(city);

    return Address(
      street: street,
      houseNumber: houseNumber,
      postcode: validPostcode,
      city: city,
      bundesland: bundesland,
      raw: fullAddr ?? (rawParts.isNotEmpty ? rawParts.join(', ') : null),
    );
  }

  /// Parse a raw address string.
  static Address fromRawString(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return Address(raw: raw);
    }

    // Try to extract postcode
    String? postcode;
    final postcodeMatch = _postcodePattern.firstMatch(trimmed);
    if (postcodeMatch != null) {
      postcode = postcodeMatch.group(1);
    }

    // Try to extract city (typically after postcode)
    String? city;
    if (postcode != null) {
      final afterPostcode = trimmed
          .substring(
            postcodeMatch!.end,
          )
          .trim();
      if (afterPostcode.isNotEmpty) {
        // City is usually the first word/phrase after postcode
        final cityMatch =
            RegExp(r'^([A-Za-zÄÖÜäöüß\s\-]+)').firstMatch(afterPostcode);
        if (cityMatch != null) {
          city = cityMatch.group(1)?.trim();
        }
      }
    }

    // Try to extract street and house number
    String? street;
    String? houseNumber;

    // Common Austrian format: "Streetname 123" or "Streetname 123a"
    final beforePostcode = postcode != null
        ? trimmed.substring(0, postcodeMatch!.start).trim()
        : trimmed;

    if (beforePostcode.isNotEmpty) {
      // Try to split street and house number
      final houseMatch =
          RegExp(r'^(.+?)\s+(\d+(?:\s*[-/]\s*\d+)?(?:\s*[a-zA-Z])?)$')
              .firstMatch(beforePostcode);

      if (houseMatch != null) {
        street = houseMatch.group(1)?.trim();
        houseNumber = houseMatch.group(2)?.trim();
      } else {
        street = beforePostcode;
      }
    }

    // Remove trailing commas
    street = street?.replaceAll(RegExp(r',\s*$'), '');

    // Infer Bundesland
    final bundesland = Bundesland.fromPostcode(postcode);

    return Address(
      street: street,
      houseNumber: houseNumber,
      postcode: postcode,
      city: city,
      bundesland: bundesland,
      raw: raw,
    );
  }

  /// Normalize an address for comparison/deduplication.
  static String normalizeForComparison(Address address) {
    final parts = <String>[
      _normalizeString(address.street),
      _normalizeString(address.houseNumber),
      address.postcode ?? '',
    ];
    return parts.join('|').toLowerCase();
  }

  /// Normalize a string for comparison.
  static String _normalizeString(String? input) {
    if (input == null) return '';

    var normalized = input.toLowerCase().trim();

    // Normalize common abbreviations
    normalized = normalized
        .replaceAll(RegExp(r'\bstr\.?\b'), 'strasse')
        .replaceAll(RegExp(r'\bg\.?\b'), 'gasse')
        .replaceAll(RegExp(r'\bpl\.?\b'), 'platz')
        .replaceAll(RegExp(r'\bw\.?\b'), 'weg')
        .replaceAll(RegExp(r'\bdr\.?\b'), 'doktor')
        .replaceAll(RegExp(r'\bst\.?\b'), 'sankt');

    // Replace umlauts
    normalized = normalized
        .replaceAll('ä', 'ae')
        .replaceAll('ö', 'oe')
        .replaceAll('ü', 'ue')
        .replaceAll('ß', 'ss');

    // Remove extra whitespace
    normalized = normalized.replaceAll(RegExp(r'\s+'), ' ');

    return normalized;
  }

  /// Check if two addresses are likely the same.
  static bool areSimilar(Address a, Address b) {
    // Same postcode is required
    if (a.postcode != b.postcode) {
      return false;
    }

    // Normalize and compare streets
    final streetA = _normalizeString(a.street);
    final streetB = _normalizeString(b.street);

    if (streetA.isEmpty || streetB.isEmpty) {
      return false;
    }

    // Check for exact street match
    if (streetA == streetB) {
      // Also check house numbers if both present
      final houseA = _normalizeString(a.houseNumber);
      final houseB = _normalizeString(b.houseNumber);

      if (houseA.isEmpty || houseB.isEmpty) {
        return true; // Same street, one missing house number
      }

      return houseA == houseB;
    }

    // Check for fuzzy street match (one contains the other)
    if (streetA.contains(streetB) || streetB.contains(streetA)) {
      return true;
    }

    return false;
  }

  /// Validate that coordinates are within Austria.
  static bool isInAustria(double lat, double lon) {
    return lat >= 46.3 && lat <= 49.0 && lon >= 9.5 && lon <= 17.2;
  }

  /// Validate Austrian postcode format.
  static bool isValidPostcode(String? postcode) {
    if (postcode == null) return false;
    return _postcodePattern.hasMatch(postcode);
  }
}
