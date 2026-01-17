/// Business entity model for Austrian B2B database.
library;

import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Provider type classification.
enum ProviderType {
  haendler,
  hersteller,
  dienstleister,
  grosshaendler,
  unknown;

  String toJson() => name.toUpperCase();

  static ProviderType fromJson(String value) {
    return ProviderType.values.firstWhere(
      (e) => e.name.toUpperCase() == value.toUpperCase(),
      orElse: () => ProviderType.unknown,
    );
  }
}

/// Company size classification.
enum CompanySize {
  e0_10,
  e11_50,
  e51_100,
  e101_250,
  e251_500,
  e500_plus,
  unknown;

  String toJson() {
    switch (this) {
      case CompanySize.e0_10:
        return 'E0_10';
      case CompanySize.e11_50:
        return 'E11_50';
      case CompanySize.e51_100:
        return 'E51_100';
      case CompanySize.e101_250:
        return 'E101_250';
      case CompanySize.e251_500:
        return 'E251_500';
      case CompanySize.e500_plus:
        return 'E500_PLUS';
      case CompanySize.unknown:
        return 'UNKNOWN';
    }
  }

  static CompanySize fromJson(String value) {
    switch (value.toUpperCase()) {
      case 'E0_10':
        return CompanySize.e0_10;
      case 'E11_50':
        return CompanySize.e11_50;
      case 'E51_100':
        return CompanySize.e51_100;
      case 'E101_250':
        return CompanySize.e101_250;
      case 'E251_500':
        return CompanySize.e251_500;
      case 'E500_PLUS':
        return CompanySize.e500_plus;
      default:
        return CompanySize.unknown;
    }
  }
}

/// Austrian Bundesland (state).
enum Bundesland {
  wien,
  niederoesterreich,
  oberoesterreich,
  salzburg,
  tirol,
  vorarlberg,
  kaernten,
  steiermark,
  burgenland;

  String toJson() {
    switch (this) {
      case Bundesland.wien:
        return 'Wien';
      case Bundesland.niederoesterreich:
        return 'Niederoesterreich';
      case Bundesland.oberoesterreich:
        return 'Oberoesterreich';
      case Bundesland.salzburg:
        return 'Salzburg';
      case Bundesland.tirol:
        return 'Tirol';
      case Bundesland.vorarlberg:
        return 'Vorarlberg';
      case Bundesland.kaernten:
        return 'Kaernten';
      case Bundesland.steiermark:
        return 'Steiermark';
      case Bundesland.burgenland:
        return 'Burgenland';
    }
  }

  static Bundesland? fromJson(String? value) {
    if (value == null) return null;
    switch (value) {
      case 'Wien':
        return Bundesland.wien;
      case 'Niederoesterreich':
        return Bundesland.niederoesterreich;
      case 'Oberoesterreich':
        return Bundesland.oberoesterreich;
      case 'Salzburg':
        return Bundesland.salzburg;
      case 'Tirol':
        return Bundesland.tirol;
      case 'Vorarlberg':
        return Bundesland.vorarlberg;
      case 'Kaernten':
        return Bundesland.kaernten;
      case 'Steiermark':
        return Bundesland.steiermark;
      case 'Burgenland':
        return Bundesland.burgenland;
      default:
        return null;
    }
  }

  /// Infer Bundesland from Austrian postcode.
  static Bundesland? fromPostcode(String? postcode) {
    if (postcode == null || postcode.length != 4) return null;
    final prefix = int.tryParse(postcode.substring(0, 1));
    if (prefix == null) return null;

    switch (prefix) {
      case 1:
        return Bundesland.wien;
      case 2:
        return Bundesland.niederoesterreich;
      case 3:
        return Bundesland.niederoesterreich;
      case 4:
        return Bundesland.oberoesterreich;
      case 5:
        return Bundesland.salzburg;
      case 6:
        return Bundesland.tirol;
      case 7:
        return Bundesland.burgenland;
      case 8:
        return Bundesland.steiermark;
      case 9:
        return Bundesland.kaernten;
      default:
        return null;
    }
  }
}

/// Address model.
class Address {
  Address({
    this.postcode,
    this.city,
    this.street,
    this.houseNumber,
    this.bundesland,
    this.raw,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      postcode: json['postcode'] as String?,
      city: json['city'] as String?,
      street: json['street'] as String?,
      houseNumber: json['houseNumber'] as String?,
      bundesland: Bundesland.fromJson(json['bundesland'] as String?),
      raw: json['raw'] as String?,
    );
  }

  final String? postcode;
  final String? city;
  final String? street;
  final String? houseNumber;
  final Bundesland? bundesland;
  final String? raw;

  Map<String, dynamic> toJson() {
    return {
      'country': 'AT',
      if (postcode != null) 'postcode': postcode,
      if (city != null) 'city': city,
      if (street != null) 'street': street,
      if (houseNumber != null) 'houseNumber': houseNumber,
      if (bundesland != null) 'bundesland': bundesland!.toJson(),
      if (raw != null) 'raw': raw,
    };
  }

  /// Normalized key for deduplication.
  String get normalizedKey {
    final parts = [
      postcode?.toLowerCase().trim() ?? '',
      street?.toLowerCase().trim() ?? '',
      houseNumber?.toLowerCase().trim() ?? '',
    ];
    return parts.join('|');
  }

  Address copyWith({
    String? postcode,
    String? city,
    String? street,
    String? houseNumber,
    Bundesland? bundesland,
    String? raw,
  }) {
    return Address(
      postcode: postcode ?? this.postcode,
      city: city ?? this.city,
      street: street ?? this.street,
      houseNumber: houseNumber ?? this.houseNumber,
      bundesland: bundesland ?? this.bundesland,
      raw: raw ?? this.raw,
    );
  }
}

/// Geographic coordinates.
class GeoCoordinates {
  GeoCoordinates({required this.lat, required this.lon});

  factory GeoCoordinates.fromJson(Map<String, dynamic> json) {
    return GeoCoordinates(
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
    );
  }

  final double lat;
  final double lon;

  Map<String, dynamic> toJson() => {'lat': lat, 'lon': lon};

  /// Calculate distance in meters using Haversine formula.
  double distanceTo(GeoCoordinates other) {
    const earthRadius = 6371000.0; // meters
    final lat1Rad = lat * 3.141592653589793 / 180;
    final lat2Rad = other.lat * 3.141592653589793 / 180;
    final deltaLat = (other.lat - lat) * 3.141592653589793 / 180;
    final deltaLon = (other.lon - lon) * 3.141592653589793 / 180;

    final a = _sin(deltaLat / 2) * _sin(deltaLat / 2) +
        _cos(lat1Rad) * _cos(lat2Rad) * _sin(deltaLon / 2) * _sin(deltaLon / 2);
    final c = 2 * _atan2(_sqrt(a), _sqrt(1 - a));
    return earthRadius * c;
  }

  static double _sin(double x) {
    // Taylor series approximation for sin
    var result = 0.0;
    var term = x;
    for (var i = 1; i <= 10; i++) {
      result += term;
      term *= -x * x / ((2 * i) * (2 * i + 1));
    }
    return result;
  }

  static double _cos(double x) {
    return _sin(x + 3.141592653589793 / 2);
  }

  static double _sqrt(double x) {
    if (x <= 0) return 0;
    var guess = x / 2;
    for (var i = 0; i < 20; i++) {
      guess = (guess + x / guess) / 2;
    }
    return guess;
  }

  static double _atan2(double y, double x) {
    if (x > 0) return _atan(y / x);
    if (x < 0 && y >= 0) return _atan(y / x) + 3.141592653589793;
    if (x < 0 && y < 0) return _atan(y / x) - 3.141592653589793;
    if (x == 0 && y > 0) return 3.141592653589793 / 2;
    if (x == 0 && y < 0) return -3.141592653589793 / 2;
    return 0;
  }

  static double _atan(double x) {
    // Taylor series approximation for atan
    if (x.abs() > 1) {
      return 3.141592653589793 / 2 * x.sign - _atan(1 / x);
    }
    var result = 0.0;
    var term = x;
    for (var i = 0; i < 20; i++) {
      result += term / (2 * i + 1);
      term *= -x * x;
    }
    return result;
  }
}

/// Contact type enums.
enum PhoneType {
  main,
  mobile,
  fax,
  other;

  String toJson() => name;
  static PhoneType fromJson(String value) =>
      PhoneType.values.firstWhere((e) => e.name == value, orElse: () => other);
}

enum EmailType {
  general,
  sales,
  support,
  other;

  String toJson() => name;
  static EmailType fromJson(String value) =>
      EmailType.values.firstWhere((e) => e.name == value, orElse: () => other);
}

enum WebsiteType {
  main,
  shop,
  social,
  other;

  String toJson() => name;
  static WebsiteType fromJson(String value) =>
      WebsiteType.values.firstWhere((e) => e.name == value, orElse: () => other);
}

/// Phone contact info.
class PhoneContact {
  PhoneContact({required this.value, this.type = PhoneType.main, this.sourceUrl});

  factory PhoneContact.fromJson(Map<String, dynamic> json) {
    return PhoneContact(
      value: json['value'] as String,
      type: json['type'] != null
          ? PhoneType.fromJson(json['type'] as String)
          : PhoneType.main,
      sourceUrl: json['sourceUrl'] as String?,
    );
  }

  final String value;
  final PhoneType type;
  final String? sourceUrl;

  Map<String, dynamic> toJson() => {
        'value': value,
        'type': type.toJson(),
        if (sourceUrl != null) 'sourceUrl': sourceUrl,
      };
}

/// Email contact info.
class EmailContact {
  EmailContact({
    required this.value,
    this.type = EmailType.general,
    this.sourceUrl,
  });

  factory EmailContact.fromJson(Map<String, dynamic> json) {
    return EmailContact(
      value: json['value'] as String,
      type: json['type'] != null
          ? EmailType.fromJson(json['type'] as String)
          : EmailType.general,
      sourceUrl: json['sourceUrl'] as String?,
    );
  }

  final String value;
  final EmailType type;
  final String? sourceUrl;

  Map<String, dynamic> toJson() => {
        'value': value,
        'type': type.toJson(),
        if (sourceUrl != null) 'sourceUrl': sourceUrl,
      };
}

/// Website contact info.
class WebsiteContact {
  WebsiteContact({
    required this.value,
    this.type = WebsiteType.main,
    this.sourceUrl,
  });

  factory WebsiteContact.fromJson(Map<String, dynamic> json) {
    return WebsiteContact(
      value: json['value'] as String,
      type: json['type'] != null
          ? WebsiteType.fromJson(json['type'] as String)
          : WebsiteType.main,
      sourceUrl: json['sourceUrl'] as String?,
    );
  }

  final String value;
  final WebsiteType type;
  final String? sourceUrl;

  Map<String, dynamic> toJson() => {
        'value': value,
        'type': type.toJson(),
        if (sourceUrl != null) 'sourceUrl': sourceUrl,
      };
}

/// Contacts container.
class Contacts {
  Contacts({
    this.phones = const [],
    this.emails = const [],
    this.websites = const [],
  });

  factory Contacts.fromJson(Map<String, dynamic> json) {
    return Contacts(
      phones: (json['phones'] as List<dynamic>?)
              ?.map((e) => PhoneContact.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      emails: (json['emails'] as List<dynamic>?)
              ?.map((e) => EmailContact.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      websites: (json['websites'] as List<dynamic>?)
              ?.map((e) => WebsiteContact.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  final List<PhoneContact> phones;
  final List<EmailContact> emails;
  final List<WebsiteContact> websites;

  bool get isEmpty => phones.isEmpty && emails.isEmpty && websites.isEmpty;

  Map<String, dynamic> toJson() => {
        if (phones.isNotEmpty) 'phones': phones.map((e) => e.toJson()).toList(),
        if (emails.isNotEmpty) 'emails': emails.map((e) => e.toJson()).toList(),
        if (websites.isNotEmpty)
          'websites': websites.map((e) => e.toJson()).toList(),
      };

  Contacts merge(Contacts other) {
    return Contacts(
      phones: [...phones, ...other.phones],
      emails: [...emails, ...other.emails],
      websites: [...websites, ...other.websites],
    );
  }
}

/// External IDs.
class ExternalIds {
  ExternalIds({
    this.osmNodeId,
    this.osmWayId,
    this.osmRelationId,
    this.firmenbuchNr,
    this.uidNr,
    this.gln,
    this.wkoMemberId,
  });

  factory ExternalIds.fromJson(Map<String, dynamic> json) {
    return ExternalIds(
      osmNodeId: json['osmNodeId'] as String?,
      osmWayId: json['osmWayId'] as String?,
      osmRelationId: json['osmRelationId'] as String?,
      firmenbuchNr: json['firmenbuchNr'] as String?,
      uidNr: json['uidNr'] as String?,
      gln: json['gln'] as String?,
      wkoMemberId: json['wkoMemberId'] as String?,
    );
  }

  final String? osmNodeId;
  final String? osmWayId;
  final String? osmRelationId;
  final String? firmenbuchNr;
  final String? uidNr;
  final String? gln;
  final String? wkoMemberId;

  bool get isEmpty =>
      osmNodeId == null &&
      osmWayId == null &&
      osmRelationId == null &&
      firmenbuchNr == null &&
      uidNr == null &&
      gln == null &&
      wkoMemberId == null;

  Map<String, dynamic> toJson() => {
        if (osmNodeId != null) 'osmNodeId': osmNodeId,
        if (osmWayId != null) 'osmWayId': osmWayId,
        if (osmRelationId != null) 'osmRelationId': osmRelationId,
        if (firmenbuchNr != null) 'firmenbuchNr': firmenbuchNr,
        if (uidNr != null) 'uidNr': uidNr,
        if (gln != null) 'gln': gln,
        if (wkoMemberId != null) 'wkoMemberId': wkoMemberId,
      };

  ExternalIds merge(ExternalIds other) {
    return ExternalIds(
      osmNodeId: osmNodeId ?? other.osmNodeId,
      osmWayId: osmWayId ?? other.osmWayId,
      osmRelationId: osmRelationId ?? other.osmRelationId,
      firmenbuchNr: firmenbuchNr ?? other.firmenbuchNr,
      uidNr: uidNr ?? other.uidNr,
      gln: gln ?? other.gln,
      wkoMemberId: wkoMemberId ?? other.wkoMemberId,
    );
  }
}

/// NACE code.
class NaceCode {
  NaceCode({required this.code, this.description, this.primary = false});

  factory NaceCode.fromJson(Map<String, dynamic> json) {
    return NaceCode(
      code: json['code'] as String,
      description: json['description'] as String?,
      primary: json['primary'] as bool? ?? false,
    );
  }

  final String code;
  final String? description;
  final bool primary;

  Map<String, dynamic> toJson() => {
        'code': code,
        if (description != null) 'description': description,
        if (primary) 'primary': primary,
      };
}

/// Classification data.
class Classification {
  Classification({this.osmTags = const {}, this.naceCodes = const []});

  factory Classification.fromJson(Map<String, dynamic> json) {
    return Classification(
      osmTags: (json['osmTags'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v as String)) ??
          {},
      naceCodes: (json['naceCodes'] as List<dynamic>?)
              ?.map((e) => NaceCode.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  final Map<String, String> osmTags;
  final List<NaceCode> naceCodes;

  bool get isEmpty => osmTags.isEmpty && naceCodes.isEmpty;

  Map<String, dynamic> toJson() => {
        if (osmTags.isNotEmpty) 'osmTags': osmTags,
        if (naceCodes.isNotEmpty)
          'naceCodes': naceCodes.map((e) => e.toJson()).toList(),
      };
}

/// Inference method enum.
enum InferenceMethod {
  osmTagMapping,
  naceMapping,
  nameInference,
  manual;

  String toJson() {
    switch (this) {
      case InferenceMethod.osmTagMapping:
        return 'osm_tag_mapping';
      case InferenceMethod.naceMapping:
        return 'nace_mapping';
      case InferenceMethod.nameInference:
        return 'name_inference';
      case InferenceMethod.manual:
        return 'manual';
    }
  }

  static InferenceMethod fromJson(String value) {
    switch (value) {
      case 'osm_tag_mapping':
        return InferenceMethod.osmTagMapping;
      case 'nace_mapping':
        return InferenceMethod.naceMapping;
      case 'name_inference':
        return InferenceMethod.nameInference;
      case 'manual':
        return InferenceMethod.manual;
      default:
        return InferenceMethod.manual;
    }
  }
}

/// Taxonomy inference info.
class TaxonomyInference {
  TaxonomyInference({
    required this.method,
    this.confidence = 0.0,
    this.matchedTags = const [],
  });

  factory TaxonomyInference.fromJson(Map<String, dynamic> json) {
    return TaxonomyInference(
      method: InferenceMethod.fromJson(json['method'] as String),
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      matchedTags: (json['matchedTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  final InferenceMethod method;
  final double confidence;
  final List<String> matchedTags;

  Map<String, dynamic> toJson() => {
        'method': method.toJson(),
        'confidence': confidence,
        if (matchedTags.isNotEmpty) 'matchedTags': matchedTags,
      };
}

/// Taxonomy mapping.
class Taxonomy {
  Taxonomy({
    this.branchId,
    this.branchName,
    this.categoryId,
    this.categoryName,
    this.productTags = const [],
    this.inference,
  });

  factory Taxonomy.fromJson(Map<String, dynamic> json) {
    return Taxonomy(
      branchId: json['branchId'] as String?,
      branchName: json['branchName'] as String?,
      categoryId: json['categoryId'] as String?,
      categoryName: json['categoryName'] as String?,
      productTags: (json['productTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      inference: json['inference'] != null
          ? TaxonomyInference.fromJson(json['inference'] as Map<String, dynamic>)
          : null,
    );
  }

  final String? branchId;
  final String? branchName;
  final String? categoryId;
  final String? categoryName;
  final List<String> productTags;
  final TaxonomyInference? inference;

  bool get isEmpty =>
      branchId == null &&
      branchName == null &&
      categoryId == null &&
      categoryName == null &&
      productTags.isEmpty;

  Map<String, dynamic> toJson() => {
        if (branchId != null) 'branchId': branchId,
        if (branchName != null) 'branchName': branchName,
        if (categoryId != null) 'categoryId': categoryId,
        if (categoryName != null) 'categoryName': categoryName,
        if (productTags.isNotEmpty) 'productTags': productTags,
        if (inference != null) 'inference': inference!.toJson(),
      };
}

/// Provenance record.
class Provenance {
  Provenance({
    required this.sourceId,
    this.sourceName,
    this.sourceUrl,
    this.contactSourceUrl,
    this.fetchedAt,
    this.license,
    this.licenseUrl,
    this.fields = const [],
  });

  factory Provenance.fromJson(Map<String, dynamic> json) {
    return Provenance(
      sourceId: json['sourceId'] as String,
      sourceName: json['sourceName'] as String?,
      sourceUrl: json['sourceUrl'] as String?,
      contactSourceUrl: json['contactSourceUrl'] as String?,
      fetchedAt: json['fetchedAt'] as String?,
      license: json['license'] as String?,
      licenseUrl: json['licenseUrl'] as String?,
      fields: (json['fields'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  final String sourceId;
  final String? sourceName;
  final String? sourceUrl;
  final String? contactSourceUrl;
  final String? fetchedAt;
  final String? license;
  final String? licenseUrl;
  final List<String> fields;

  Map<String, dynamic> toJson() => {
        'sourceId': sourceId,
        if (sourceName != null) 'sourceName': sourceName,
        if (sourceUrl != null) 'sourceUrl': sourceUrl,
        if (contactSourceUrl != null) 'contactSourceUrl': contactSourceUrl,
        if (fetchedAt != null) 'fetchedAt': fetchedAt,
        if (license != null) 'license': license,
        if (licenseUrl != null) 'licenseUrl': licenseUrl,
        if (fields.isNotEmpty) 'fields': fields,
      };
}

/// Business entity model.
class BusinessEntity {
  BusinessEntity({
    String? id,
    required this.name,
    this.legalForm,
    this.providerType = ProviderType.unknown,
    this.companySize = CompanySize.unknown,
    required this.addresses,
    this.geo,
    Contacts? contacts,
    ExternalIds? externalIds,
    Classification? classification,
    Taxonomy? taxonomy,
    this.active,
    required this.provenance,
    this.confidence,
  })  : id = id ?? _generateId(name, addresses),
        contacts = contacts ?? Contacts(),
        externalIds = externalIds ?? ExternalIds(),
        classification = classification ?? Classification(),
        taxonomy = taxonomy ?? Taxonomy();

  factory BusinessEntity.fromJson(Map<String, dynamic> json) {
    return BusinessEntity(
      id: json['id'] as String?,
      name: json['name'] as String,
      legalForm: json['legalForm'] as String?,
      providerType: json['providerType'] != null
          ? ProviderType.fromJson(json['providerType'] as String)
          : ProviderType.unknown,
      companySize: json['companySize'] != null
          ? CompanySize.fromJson(json['companySize'] as String)
          : CompanySize.unknown,
      addresses: (json['addresses'] as List<dynamic>)
          .map((e) => Address.fromJson(e as Map<String, dynamic>))
          .toList(),
      geo: json['geo'] != null
          ? GeoCoordinates.fromJson(json['geo'] as Map<String, dynamic>)
          : null,
      contacts: json['contacts'] != null
          ? Contacts.fromJson(json['contacts'] as Map<String, dynamic>)
          : null,
      externalIds: json['externalIds'] != null
          ? ExternalIds.fromJson(json['externalIds'] as Map<String, dynamic>)
          : null,
      classification: json['classification'] != null
          ? Classification.fromJson(json['classification'] as Map<String, dynamic>)
          : null,
      taxonomy: json['taxonomy'] != null
          ? Taxonomy.fromJson(json['taxonomy'] as Map<String, dynamic>)
          : null,
      active: json['active'] as bool?,
      provenance: (json['provenance'] as List<dynamic>)
          .map((e) => Provenance.fromJson(e as Map<String, dynamic>))
          .toList(),
      confidence: (json['confidence'] as num?)?.toDouble(),
    );
  }

  final String id;
  final String name;
  final String? legalForm;
  final ProviderType providerType;
  final CompanySize companySize;
  final List<Address> addresses;
  final GeoCoordinates? geo;
  final Contacts contacts;
  final ExternalIds externalIds;
  final Classification classification;
  final Taxonomy taxonomy;
  final bool? active;
  final List<Provenance> provenance;
  final double? confidence;

  /// Generate deterministic ID from entity data.
  static String _generateId(String name, List<Address> addresses) {
    final addr = addresses.isNotEmpty ? addresses.first : null;
    final parts = [
      name.toLowerCase().trim(),
      addr?.postcode ?? '',
      addr?.street?.toLowerCase().trim() ?? '',
      addr?.houseNumber?.toLowerCase().trim() ?? '',
      'AT',
    ];
    final input = parts.join('|');
    final hash = sha256.convert(utf8.encode(input)).toString();
    return 'AT-${hash.substring(0, 16)}';
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'id': id,
      'country': 'AT',
      'name': name,
      if (legalForm != null) 'legalForm': legalForm,
      'providerType': providerType.toJson(),
      'companySize': companySize.toJson(),
      'addresses': addresses.map((e) => e.toJson()).toList(),
      if (geo != null) 'geo': geo!.toJson(),
      if (!contacts.isEmpty) 'contacts': contacts.toJson(),
      if (!externalIds.isEmpty) 'externalIds': externalIds.toJson(),
      if (!classification.isEmpty) 'classification': classification.toJson(),
      if (!taxonomy.isEmpty) 'taxonomy': taxonomy.toJson(),
      if (active != null) 'active': active,
      'provenance': provenance.map((e) => e.toJson()).toList(),
      if (confidence != null) 'confidence': confidence,
    };
    return json;
  }

  /// Merge with another entity, preserving provenance.
  BusinessEntity merge(BusinessEntity other) {
    return BusinessEntity(
      id: id,
      name: name.isNotEmpty ? name : other.name,
      legalForm: legalForm ?? other.legalForm,
      providerType:
          providerType != ProviderType.unknown ? providerType : other.providerType,
      companySize:
          companySize != CompanySize.unknown ? companySize : other.companySize,
      addresses: addresses,
      geo: geo ?? other.geo,
      contacts: contacts.merge(other.contacts),
      externalIds: externalIds.merge(other.externalIds),
      classification: classification,
      taxonomy: taxonomy.isEmpty ? other.taxonomy : taxonomy,
      active: active ?? other.active,
      provenance: [...provenance, ...other.provenance],
      confidence: confidence ?? other.confidence,
    );
  }
}
