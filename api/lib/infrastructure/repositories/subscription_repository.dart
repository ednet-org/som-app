import '../../models/models.dart';
import '../db.dart';

class SubscriptionRepository {
  SubscriptionRepository(this._db);

  final Database _db;

  void createPlan(SubscriptionPlanRecord plan) {
    _db.execute(
      '''
      INSERT INTO subscription_plans (
        id, name, sort_priority, is_active, price_in_subunit, rules_json, created_at
      ) VALUES (?, ?, ?, ?, ?, ?, ?)
      ''',
      [
        plan.id,
        plan.name,
        plan.sortPriority,
        plan.isActive ? 1 : 0,
        plan.priceInSubunit,
        encodeJson(plan.rules),
        plan.createdAt.toIso8601String(),
      ],
    );
  }

  List<SubscriptionPlanRecord> listPlans() {
    final rows = _db.select(
      'SELECT * FROM subscription_plans ORDER BY sort_priority',
    );
    return rows.map(_mapPlan).toList();
  }

  SubscriptionPlanRecord? findPlanById(String id) {
    final rows = _db.select(
      'SELECT * FROM subscription_plans WHERE id = ?',
      [id],
    );
    if (rows.isEmpty) {
      return null;
    }
    return _mapPlan(rows.first);
  }

  bool hasPlans() {
    final rows = _db.select('SELECT 1 FROM subscription_plans LIMIT 1');
    return rows.isNotEmpty;
  }

  void createSubscription(SubscriptionRecord subscription) {
    _db.execute(
      '''
      INSERT INTO subscriptions (
        id, company_id, plan_id, status, payment_interval, start_date, end_date, created_at
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
      ''',
      [
        subscription.id,
        subscription.companyId,
        subscription.planId,
        subscription.status,
        subscription.paymentInterval,
        subscription.startDate.toIso8601String(),
        subscription.endDate.toIso8601String(),
        subscription.createdAt.toIso8601String(),
      ],
    );
  }

  SubscriptionRecord? findSubscriptionByCompany(String companyId) {
    final rows = _db.select(
      'SELECT * FROM subscriptions WHERE company_id = ? ORDER BY created_at DESC LIMIT 1',
      [companyId],
    );
    if (rows.isEmpty) {
      return null;
    }
    final row = rows.first;
    return SubscriptionRecord(
      id: row['id'] as String,
      companyId: row['company_id'] as String,
      planId: row['plan_id'] as String,
      status: row['status'] as String,
      paymentInterval: row['payment_interval'] as String,
      startDate: DateTime.parse(row['start_date'] as String),
      endDate: DateTime.parse(row['end_date'] as String),
      createdAt: DateTime.parse(row['created_at'] as String),
    );
  }

  SubscriptionPlanRecord _mapPlan(Map<String, Object?> row) {
    return SubscriptionPlanRecord(
      id: row['id'] as String,
      name: row['name'] as String,
      sortPriority: row['sort_priority'] as int,
      isActive: (row['is_active'] as int) == 1,
      priceInSubunit: row['price_in_subunit'] as int,
      rules: (decodeJsonList(row['rules_json'] as String))
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      createdAt: DateTime.parse(row['created_at'] as String),
    );
  }
}
