import 'package:supabase/supabase.dart';

import '../../models/models.dart';

class CompanyRepository {
  CompanyRepository(this._client);

  final SupabaseClient _client;

  Future<void> create(CompanyRecord company) async {
    await _client.from('companies').insert({
      'id': company.id,
      'name': company.name,
      'type': company.type,
      'address_json': company.address.toJson(),
      'uid_nr': company.uidNr,
      'registration_nr': company.registrationNr,
      'company_size': company.companySize,
      'website_url': company.websiteUrl,
      'terms_accepted_at': company.termsAcceptedAt?.toIso8601String(),
      'privacy_accepted_at': company.privacyAcceptedAt?.toIso8601String(),
      'status': company.status,
      'created_at': company.createdAt.toIso8601String(),
      'updated_at': company.updatedAt.toIso8601String(),
    });
  }

  Future<CompanyRecord?> findById(String id) async {
    final rows =
        await _client.from('companies').select().eq('id', id) as List<dynamic>;
    if (rows.isEmpty) {
      return null;
    }
    return _mapRow(rows.first as Map<String, dynamic>);
  }

  Future<List<CompanyRecord>> listAll() async {
    final rows =
        await _client.from('companies').select().order('name') as List<dynamic>;
    return rows.map((row) => _mapRow(row as Map<String, dynamic>)).toList();
  }

  Future<void> update(CompanyRecord company) async {
    await _client.from('companies').update({
      'name': company.name,
      'type': company.type,
      'address_json': company.address.toJson(),
      'uid_nr': company.uidNr,
      'registration_nr': company.registrationNr,
      'company_size': company.companySize,
      'website_url': company.websiteUrl,
      'terms_accepted_at': company.termsAcceptedAt?.toIso8601String(),
      'privacy_accepted_at': company.privacyAcceptedAt?.toIso8601String(),
      'status': company.status,
      'updated_at': company.updatedAt.toIso8601String(),
    }).eq('id', company.id);
  }

  CompanyRecord _mapRow(Map<String, dynamic> row) {
    return CompanyRecord(
      id: row['id'] as String,
      name: row['name'] as String,
      type: row['type'] as String,
      address: Address.fromJson(decodeJsonMap(row['address_json'])),
      uidNr: row['uid_nr'] as String,
      registrationNr: row['registration_nr'] as String,
      companySize: row['company_size'] as String,
      websiteUrl: row['website_url'] as String?,
      termsAcceptedAt: parseDateOrNull(row['terms_accepted_at']),
      privacyAcceptedAt: parseDateOrNull(row['privacy_accepted_at']),
      status: row['status'] as String,
      createdAt: parseDate(row['created_at']),
      updatedAt: parseDate(row['updated_at']),
    );
  }

  Future<bool> existsByName(String name) async {
    final rows = await _client
        .from('companies')
        .select('id')
        .ilike('name', name)
        .limit(1) as List<dynamic>;
    return rows.isNotEmpty;
  }

  Future<CompanyRecord?> findByRegistrationNr(String registrationNr) async {
    final rows = await _client
        .from('companies')
        .select()
        .eq('registration_nr', registrationNr)
        .limit(1) as List<dynamic>;
    if (rows.isEmpty) {
      return null;
    }
    return _mapRow(rows.first as Map<String, dynamic>);
  }
}
