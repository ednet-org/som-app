/// Maps BusinessEntity to database records.
library;

import 'package:uuid/uuid.dart';

import '../models/business_entity.dart';

/// Maps ETL BusinessEntity objects to database table records.
class EntityToRecordMapper {
  EntityToRecordMapper();

  /// UUID v5 namespace for SOM seed data.
  /// Generated from: Uuid.v5(Uuid.NAMESPACE_DNS, 'som-seed.example.com')
  static const _somNamespace = '6ba7b810-9dad-11d1-80b4-00c04fd430c8';

  final _uuid = Uuid();

  /// Generate deterministic UUID from ETL entity ID using UUID v5.
  ///
  /// This ensures the same ETL entity always maps to the same company UUID,
  /// making seeding idempotent.
  String generateCompanyId(String etlId) {
    return _uuid.v5(_somNamespace, etlId);
  }

  /// Generate deterministic UUID for branch external ids.
  String generateBranchId(String externalId) {
    return _uuid.v5(_somNamespace, 'branch:$externalId');
  }

  /// Generate deterministic UUID for category external ids.
  String generateCategoryId(String externalId) {
    return _uuid.v5(_somNamespace, 'category:$externalId');
  }

  /// Map BusinessEntity to companies table record.
  Map<String, dynamic> toCompanyRecord(BusinessEntity entity) {
    final companyId = generateCompanyId(entity.id);
    final now = DateTime.now().toUtc().toIso8601String();

    return {
      'id': companyId,
      'external_id': entity.id,
      'name': entity.name,
      'type': 'seeded', // Distinguish from user-registered companies
      'address_json': _formatAddressJson(
          entity.addresses.isNotEmpty ? entity.addresses.first : null),
      'uid_nr': entity.externalIds.uidNr ?? '',
      'registration_nr': entity.externalIds.firmenbuchNr ?? '',
      'company_size': entity.companySize.toJson(),
      'website_url': _getPrimaryWebsite(entity.contacts),
      'status': 'active',
      'created_at': now,
      'updated_at': now,
    };
  }

  /// Map BusinessEntity to provider_profiles table record.
  Map<String, dynamic> toProviderProfileRecord(
    BusinessEntity entity,
    String companyId,
  ) {
    final now = DateTime.now().toUtc().toIso8601String();

    return {
      'company_id': companyId,
      'bank_details_json': <String, dynamic>{}, // Empty for seeded providers
      'branches_json': _formatBranchesJson(entity.taxonomy),
      'pending_branches_json': <String, dynamic>{},
      'subscription_plan_id':
          '00000000-0000-0000-0000-000000000000', // Placeholder
      'payment_interval': 'none',
      'provider_type': _mapProviderType(entity.providerType),
      'status': 'seeded', // Special status for seeded providers
      'created_at': now,
      'updated_at': now,
    };
  }

  /// Map BusinessEntity to a combined record for validation/reporting.
  Map<String, dynamic> toValidationRecord(BusinessEntity entity) {
    return {
      'etl_id': entity.id,
      'company_id': generateCompanyId(entity.id),
      'name': entity.name,
      'provider_type': entity.providerType.toJson(),
      'address_city':
          entity.addresses.isNotEmpty ? entity.addresses.first.city : null,
      'address_postcode':
          entity.addresses.isNotEmpty ? entity.addresses.first.postcode : null,
      'has_phone': entity.contacts.phones.isNotEmpty,
      'has_email': entity.contacts.emails.isNotEmpty,
      'has_website': entity.contacts.websites.isNotEmpty,
      'has_uid': entity.externalIds.uidNr != null,
      'has_firmenbuch': entity.externalIds.firmenbuchNr != null,
      'branch_id': entity.taxonomy.branchId,
      'nace_codes': entity.classification.naceCodes.map((n) => n.code).toList(),
    };
  }

  /// Format address as JSONB.
  Map<String, dynamic> _formatAddressJson(Address? address) {
    if (address == null) {
      return {
        'country': 'AT',
        'formatted': 'Austria',
      };
    }

    final formatted = [
      if (address.street != null) address.street,
      if (address.houseNumber != null) address.houseNumber,
      if (address.postcode != null || address.city != null)
        [address.postcode, address.city].where((s) => s != null).join(' '),
      'Austria',
    ].where((s) => s != null && s.isNotEmpty).join(', ');

    return {
      'country': 'AT',
      'street': address.street,
      'house_number': address.houseNumber,
      'postcode': address.postcode,
      'city': address.city,
      'bundesland': address.bundesland?.toJson(),
      'formatted': formatted,
      'raw': address.raw,
    };
  }

  /// Format taxonomy as branches JSONB.
  Map<String, dynamic> _formatBranchesJson(Taxonomy taxonomy) {
    return {
      if (taxonomy.branchId != null) 'branch_id': taxonomy.branchId,
      if (taxonomy.branchName != null) 'branch_name': taxonomy.branchName,
      if (taxonomy.categoryId != null) 'category_id': taxonomy.categoryId,
      if (taxonomy.categoryName != null) 'category_name': taxonomy.categoryName,
      if (taxonomy.productTags.isNotEmpty) 'product_tags': taxonomy.productTags,
    };
  }

  /// Get primary website URL from contacts.
  String? _getPrimaryWebsite(Contacts contacts) {
    if (contacts.websites.isEmpty) return null;

    // Prefer main website type
    final main = contacts.websites.where((w) => w.type == WebsiteType.main);
    if (main.isNotEmpty) return main.first.value;

    return contacts.websites.first.value;
  }

  /// Map ProviderType enum to database value.
  String _mapProviderType(ProviderType type) {
    switch (type) {
      case ProviderType.haendler:
        return 'HAENDLER';
      case ProviderType.hersteller:
        return 'HERSTELLER';
      case ProviderType.dienstleister:
        return 'DIENSTLEISTER';
      case ProviderType.grosshaendler:
        return 'GROSSHAENDLER';
      case ProviderType.unknown:
        return 'UNKNOWN';
    }
  }
}

/// Statistics about mapped records.
class MappingStats {
  MappingStats();

  int totalRecords = 0;
  int withAddress = 0;
  int withPhone = 0;
  int withEmail = 0;
  int withWebsite = 0;
  int withUid = 0;
  int withFirmenbuch = 0;
  int withBranch = 0;
  final Map<String, int> byProviderType = {};
  final Map<String, int> byBundesland = {};

  void addEntity(BusinessEntity entity) {
    totalRecords++;
    if (entity.addresses.isNotEmpty) withAddress++;
    if (entity.contacts.phones.isNotEmpty) withPhone++;
    if (entity.contacts.emails.isNotEmpty) withEmail++;
    if (entity.contacts.websites.isNotEmpty) withWebsite++;
    if (entity.externalIds.uidNr != null) withUid++;
    if (entity.externalIds.firmenbuchNr != null) withFirmenbuch++;
    if (entity.taxonomy.branchId != null) withBranch++;

    final typeKey = entity.providerType.toJson();
    byProviderType[typeKey] = (byProviderType[typeKey] ?? 0) + 1;

    if (entity.addresses.isNotEmpty &&
        entity.addresses.first.bundesland != null) {
      final landKey = entity.addresses.first.bundesland!.toJson();
      byBundesland[landKey] = (byBundesland[landKey] ?? 0) + 1;
    }
  }

  @override
  String toString() {
    final buffer = StringBuffer()
      ..writeln('Mapping Statistics:')
      ..writeln('  Total records: $totalRecords')
      ..writeln('  With address: $withAddress (${_pct(withAddress)}%)')
      ..writeln('  With phone: $withPhone (${_pct(withPhone)}%)')
      ..writeln('  With email: $withEmail (${_pct(withEmail)}%)')
      ..writeln('  With website: $withWebsite (${_pct(withWebsite)}%)')
      ..writeln('  With UID: $withUid (${_pct(withUid)}%)')
      ..writeln('  With Firmenbuch: $withFirmenbuch (${_pct(withFirmenbuch)}%)')
      ..writeln('  With branch: $withBranch (${_pct(withBranch)}%)')
      ..writeln('  By provider type:');
    for (final entry in byProviderType.entries) {
      buffer.writeln('    ${entry.key}: ${entry.value}');
    }
    buffer.writeln('  By Bundesland:');
    for (final entry in byBundesland.entries) {
      buffer.writeln('    ${entry.key}: ${entry.value}');
    }
    return buffer.toString();
  }

  String _pct(int value) {
    if (totalRecords == 0) return '0.0';
    return (value / totalRecords * 100).toStringAsFixed(1);
  }
}
