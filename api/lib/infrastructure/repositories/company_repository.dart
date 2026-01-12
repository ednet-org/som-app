import 'package:collection/collection.dart';

import '../../models/models.dart';
import '../db.dart';

class CompanyRepository {
  CompanyRepository(this._db);

  final Database _db;

  void create(CompanyRecord company) {
    _db.execute(
      '''
      INSERT INTO companies (
        id, name, type, address_json, uid_nr, registration_nr, company_size,
        website_url, status, created_at, updated_at
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ''',
      [
        company.id,
        company.name,
        company.type,
        encodeJson(company.address.toJson()),
        company.uidNr,
        company.registrationNr,
        company.companySize,
        company.websiteUrl,
        company.status,
        company.createdAt.toIso8601String(),
        company.updatedAt.toIso8601String(),
      ],
    );
  }

  CompanyRecord? findById(String id) {
    final rows = _db.select('SELECT * FROM companies WHERE id = ?', [id]);
    if (rows.isEmpty) {
      return null;
    }
    return _mapRow(rows.first);
  }

  List<CompanyRecord> listAll() {
    final rows = _db.select('SELECT * FROM companies ORDER BY name');
    return rows.map(_mapRow).toList();
  }

  void update(CompanyRecord company) {
    _db.execute(
      '''
      UPDATE companies SET
        name = ?,
        type = ?,
        address_json = ?,
        uid_nr = ?,
        registration_nr = ?,
        company_size = ?,
        website_url = ?,
        status = ?,
        updated_at = ?
      WHERE id = ?
      ''',
      [
        company.name,
        company.type,
        encodeJson(company.address.toJson()),
        company.uidNr,
        company.registrationNr,
        company.companySize,
        company.websiteUrl,
        company.status,
        company.updatedAt.toIso8601String(),
        company.id,
      ],
    );
  }

  CompanyRecord _mapRow(Map<String, Object?> row) {
    return CompanyRecord(
      id: row['id'] as String,
      name: row['name'] as String,
      type: row['type'] as String,
      address: Address.fromJson(decodeJsonMap(row['address_json'] as String)),
      uidNr: row['uid_nr'] as String,
      registrationNr: row['registration_nr'] as String,
      companySize: row['company_size'] as String,
      websiteUrl: row['website_url'] as String?,
      status: row['status'] as String,
      createdAt: DateTime.parse(row['created_at'] as String),
      updatedAt: DateTime.parse(row['updated_at'] as String),
    );
  }

  bool existsByName(String name) {
    final rows = _db.select(
      'SELECT 1 FROM companies WHERE lower(name) = lower(?) LIMIT 1',
      [name],
    );
    return rows.isNotEmpty;
  }

  CompanyRecord? findByRegistrationNr(String registrationNr) {
    final rows = _db.select(
      'SELECT * FROM companies WHERE registration_nr = ? LIMIT 1',
      [registrationNr],
    );
    return rows.firstOrNull == null ? null : _mapRow(rows.first);
  }
}
