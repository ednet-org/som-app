import '../../models/models.dart';
import '../db.dart';

class ProviderRepository {
  ProviderRepository(this._db);

  final Database _db;

  void createProfile(ProviderProfileRecord profile) {
    _db.execute(
      '''
      INSERT INTO provider_profiles (
        company_id, bank_details_json, branches_json, pending_branches_json,
        subscription_plan_id, payment_interval, status, created_at, updated_at
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
      ''',
      [
        profile.companyId,
        encodeJson(profile.bankDetails.toJson()),
        encodeJson(profile.branchIds),
        encodeJson(profile.pendingBranchIds),
        profile.subscriptionPlanId,
        profile.paymentInterval,
        profile.status,
        profile.createdAt.toIso8601String(),
        profile.updatedAt.toIso8601String(),
      ],
    );
  }

  ProviderProfileRecord? findByCompany(String companyId) {
    final rows = _db.select(
      'SELECT * FROM provider_profiles WHERE company_id = ?',
      [companyId],
    );
    if (rows.isEmpty) {
      return null;
    }
    return _mapRow(rows.first);
  }

  void update(ProviderProfileRecord profile) {
    _db.execute(
      '''
      UPDATE provider_profiles SET
        bank_details_json = ?,
        branches_json = ?,
        pending_branches_json = ?,
        subscription_plan_id = ?,
        payment_interval = ?,
        status = ?,
        updated_at = ?
      WHERE company_id = ?
      ''',
      [
        encodeJson(profile.bankDetails.toJson()),
        encodeJson(profile.branchIds),
        encodeJson(profile.pendingBranchIds),
        profile.subscriptionPlanId,
        profile.paymentInterval,
        profile.status,
        profile.updatedAt.toIso8601String(),
        profile.companyId,
      ],
    );
  }

  ProviderProfileRecord _mapRow(Map<String, Object?> row) {
    return ProviderProfileRecord(
      companyId: row['company_id'] as String,
      bankDetails: BankDetails.fromJson(
        decodeJsonMap(row['bank_details_json'] as String),
      ),
      branchIds: decodeJsonList(row['branches_json'] as String)
          .map((e) => e.toString())
          .toList(),
      pendingBranchIds: decodeJsonList(row['pending_branches_json'] as String)
          .map((e) => e.toString())
          .toList(),
      subscriptionPlanId: row['subscription_plan_id'] as String,
      paymentInterval: row['payment_interval'] as String,
      status: row['status'] as String,
      createdAt: DateTime.parse(row['created_at'] as String),
      updatedAt: DateTime.parse(row['updated_at'] as String),
    );
  }
}
