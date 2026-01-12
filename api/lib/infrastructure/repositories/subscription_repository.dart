import 'package:supabase/supabase.dart';

import '../../models/models.dart';

class SubscriptionRepository {
  SubscriptionRepository(this._client);

  final SupabaseClient _client;

  Future<void> createPlan(SubscriptionPlanRecord plan) async {
    await _client.from('subscription_plans').insert({
      'id': plan.id,
      'name': plan.name,
      'sort_priority': plan.sortPriority,
      'is_active': plan.isActive,
      'price_in_subunit': plan.priceInSubunit,
      'rules_json': plan.rules,
      'created_at': plan.createdAt.toIso8601String(),
    });
  }

  Future<List<SubscriptionPlanRecord>> listPlans() async {
    final rows = await _client
        .from('subscription_plans')
        .select()
        .order('sort_priority') as List<dynamic>;
    return rows.map((row) => _mapPlan(row as Map<String, dynamic>)).toList();
  }

  Future<SubscriptionPlanRecord?> findPlanById(String id) async {
    final rows = await _client.from('subscription_plans').select().eq('id', id)
        as List<dynamic>;
    if (rows.isEmpty) {
      return null;
    }
    return _mapPlan(rows.first as Map<String, dynamic>);
  }

  Future<bool> hasPlans() async {
    final rows = await _client.from('subscription_plans').select('id').limit(1)
        as List<dynamic>;
    return rows.isNotEmpty;
  }

  Future<void> createSubscription(SubscriptionRecord subscription) async {
    await _client.from('subscriptions').insert({
      'id': subscription.id,
      'company_id': subscription.companyId,
      'plan_id': subscription.planId,
      'status': subscription.status,
      'payment_interval': subscription.paymentInterval,
      'start_date': subscription.startDate.toIso8601String(),
      'end_date': subscription.endDate.toIso8601String(),
      'created_at': subscription.createdAt.toIso8601String(),
    });
  }

  Future<SubscriptionRecord?> findSubscriptionByCompany(
    String companyId,
  ) async {
    final rows = await _client
        .from('subscriptions')
        .select()
        .eq('company_id', companyId)
        .order('created_at', ascending: false)
        .limit(1) as List<dynamic>;
    if (rows.isEmpty) {
      return null;
    }
    final row = rows.first as Map<String, dynamic>;
    return SubscriptionRecord(
      id: row['id'] as String,
      companyId: row['company_id'] as String,
      planId: row['plan_id'] as String,
      status: row['status'] as String,
      paymentInterval: row['payment_interval'] as String,
      startDate: parseDate(row['start_date']),
      endDate: parseDate(row['end_date']),
      createdAt: parseDate(row['created_at']),
    );
  }

  SubscriptionPlanRecord _mapPlan(Map<String, dynamic> row) {
    return SubscriptionPlanRecord(
      id: row['id'] as String,
      name: row['name'] as String,
      sortPriority: row['sort_priority'] as int,
      isActive: row['is_active'] as bool? ?? false,
      priceInSubunit: row['price_in_subunit'] as int,
      rules: decodeJsonList(row['rules_json'])
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      createdAt: parseDate(row['created_at']),
    );
  }
}
