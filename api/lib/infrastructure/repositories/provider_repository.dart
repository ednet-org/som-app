import 'package:supabase/supabase.dart';

import '../../models/models.dart';
import 'company_repository.dart';

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
    final rows =
        await _client.from('provider_profiles').select() as List<dynamic>;
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

  Future<ProviderSearchResult> searchProviders(
    ProviderSearchParams params,
    CompanyRepository companyRepo, {
    List<String>? companyIdsFilter,
  }) async {
    final effectiveLimit = params.limit > 200 ? 200 : params.limit;

    // Build the query with JOINs and filters
    var query = _client.from('provider_profiles').select('''
          company_id,
          bank_details_json,
          branches_json,
          pending_branches_json,
          subscription_plan_id,
          payment_interval,
          provider_type,
          status,
          rejection_reason,
          rejected_at,
          created_at,
          updated_at,
          companies!inner (
            id,
            name,
            type,
            address_json,
            company_size,
            created_at
          )
        ''');

    // Apply filters
    if (params.providerType != null) {
      query = query.eq('provider_type', params.providerType!);
    }
    if (params.status != null) {
      query = query.eq('status', params.status!);
    }
    if (params.claimed != null) {
      if (params.claimed!) {
        query = query.eq('status', 'active');
      } else {
        query = query.neq('status', 'active');
      }
    }
    if (companyIdsFilter != null) {
      if (companyIdsFilter.isEmpty) {
        return ProviderSearchResult(totalCount: 0, items: const []);
      }
      query = query.inFilter('company_id', companyIdsFilter);
    } else if (params.branchId != null) {
      query = query.contains('branches_json', [params.branchId]);
    }

    // Filter by company type (provider or buyer_provider)
    query = query.or('type.eq.provider,type.eq.buyer_provider',
        referencedTable: 'companies');

    if (params.search != null && params.search!.isNotEmpty) {
      query = query.ilike('companies.name', '%${params.search}%');
    }
    if (params.companySize != null) {
      query = query.eq('companies.company_size', params.companySize!);
    }

    // Get total count first (without pagination)
    final countRows = await query as List<dynamic>;

    // Apply zip prefix filter in memory (Supabase doesn't support JSON field LIKE)
    var filteredRows = countRows;
    if (params.zipPrefix != null && params.zipPrefix!.isNotEmpty) {
      filteredRows = countRows.where((row) {
        final company = row['companies'] as Map<String, dynamic>;
        final addressJson = decodeJsonMap(company['address_json']);
        final zip = (addressJson['zip'] as String? ?? '').toLowerCase();
        return zip.startsWith(params.zipPrefix!.toLowerCase());
      }).toList();
    }

    final totalCount = filteredRows.length;

    // Apply pagination
    final paginatedRows =
        filteredRows.skip(params.offset).take(effectiveLimit).toList();

    // Map to ProviderSummaryRecord
    final items = paginatedRows.map((row) {
      final company = row['companies'] as Map<String, dynamic>;
      final addressJson = decodeJsonMap(company['address_json']);

      return ProviderSummaryRecord(
        companyId: row['company_id'] as String,
        companyName: company['name'] as String,
        companySize: company['company_size'] as String,
        providerType: row['provider_type'] as String?,
        postcode: addressJson['zip'] as String? ?? '',
        branchIds: decodeJsonList(row['branches_json'])
            .map((e) => e.toString())
            .toList(),
        pendingBranchIds: decodeJsonList(row['pending_branches_json'])
            .map((e) => e.toString())
            .toList(),
        status: row['status'] as String,
        rejectionReason: row['rejection_reason'] as String?,
        rejectedAt: parseDateOrNull(row['rejected_at']),
        subscriptionPlanId: row['subscription_plan_id'] as String,
        paymentInterval: row['payment_interval'] as String,
        bankDetails: BankDetails.fromJson(
          decodeJsonMap(row['bank_details_json']),
        ),
        registrationDate: parseDate(company['created_at']),
      );
    }).toList();

    return ProviderSearchResult(totalCount: totalCount, items: items);
  }
}
