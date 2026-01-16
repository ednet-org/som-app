import 'package:supabase/supabase.dart';

import '../../models/models.dart';

class ProviderRepository {
  ProviderRepository(this._client);

  final SupabaseClient _client;

  Future<void> createProfile(ProviderProfileRecord profile) async {
    await _client.from('provider_profiles').insert({
      'company_id': profile.companyId,
      'bank_details_json': profile.bankDetails.toJson(),
      'branches_json': profile.branchIds,
      'pending_branches_json': profile.pendingBranchIds,
      'subscription_plan_id': profile.subscriptionPlanId,
      'payment_interval': profile.paymentInterval,
      'provider_type': profile.providerType,
      'status': profile.status,
      'rejection_reason': profile.rejectionReason,
      'rejected_at': profile.rejectedAt?.toIso8601String(),
      'created_at': profile.createdAt.toIso8601String(),
      'updated_at': profile.updatedAt.toIso8601String(),
    });
  }

  Future<ProviderProfileRecord?> findByCompany(String companyId) async {
    final rows = await _client
        .from('provider_profiles')
        .select()
        .eq('company_id', companyId) as List<dynamic>;
    if (rows.isEmpty) {
      return null;
    }
    return _mapRow(rows.first as Map<String, dynamic>);
  }

  Future<void> update(ProviderProfileRecord profile) async {
    await _client.from('provider_profiles').update({
      'bank_details_json': profile.bankDetails.toJson(),
      'branches_json': profile.branchIds,
      'pending_branches_json': profile.pendingBranchIds,
      'subscription_plan_id': profile.subscriptionPlanId,
      'payment_interval': profile.paymentInterval,
      'provider_type': profile.providerType,
      'status': profile.status,
      'rejection_reason': profile.rejectionReason,
      'rejected_at': profile.rejectedAt?.toIso8601String(),
      'updated_at': profile.updatedAt.toIso8601String(),
    }).eq('company_id', profile.companyId);
  }

  Future<List<ProviderProfileRecord>> listByBranch(String branchId) async {
    final rows = await _client.from('provider_profiles').select()
        as List<dynamic>;
    return rows
        .map((row) => _mapRow(row as Map<String, dynamic>))
        .where((profile) =>
            profile.branchIds.contains(branchId) ||
            profile.pendingBranchIds.contains(branchId))
        .toList();
  }

  ProviderProfileRecord _mapRow(Map<String, dynamic> row) {
    return ProviderProfileRecord(
      companyId: row['company_id'] as String,
      bankDetails: BankDetails.fromJson(
        decodeJsonMap(row['bank_details_json']),
      ),
      branchIds: decodeJsonList(row['branches_json'])
          .map((e) => e.toString())
          .toList(),
      pendingBranchIds: decodeJsonList(row['pending_branches_json'])
          .map((e) => e.toString())
          .toList(),
      subscriptionPlanId: row['subscription_plan_id'] as String,
      paymentInterval: row['payment_interval'] as String,
      providerType: row['provider_type'] as String?,
      status: row['status'] as String,
      rejectionReason: row['rejection_reason'] as String?,
      rejectedAt: parseDateOrNull(row['rejected_at']),
      createdAt: parseDate(row['created_at']),
      updatedAt: parseDate(row['updated_at']),
    );
  }
}
