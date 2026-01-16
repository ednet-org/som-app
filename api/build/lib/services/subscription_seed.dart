import 'package:uuid/uuid.dart';

import '../infrastructure/clock.dart';
import '../infrastructure/repositories/subscription_repository.dart';
import '../models/models.dart';

class SubscriptionSeeder {
  SubscriptionSeeder({required this.repository, required this.clock});

  final SubscriptionRepository repository;
  final Clock clock;

  Future<void> seedDefaults() async {
    if (await repository.hasPlans()) {
      return;
    }
    final now = clock.nowUtc();
    await repository.createPlan(
      SubscriptionPlanRecord(
        id: const Uuid().v4(),
        name: 'SOM Standard',
        sortPriority: 1,
        isActive: true,
        priceInSubunit: 3990,
        maxUsers: 1,
        setupFeeInSubunit: 4900,
        bannerAdsPerMonth: 0,
        normalAdsPerMonth: 0,
        freeMonths: 0,
        commitmentPeriodMonths: 12,
        rules: [
          {'id': const Uuid().v4(), 'upperLimit': 1, 'restriction': 0},
          {'id': const Uuid().v4(), 'upperLimit': 0, 'restriction': 1},
          {'id': const Uuid().v4(), 'upperLimit': 0, 'restriction': 2},
        ],
        createdAt: now,
      ),
    );
    await repository.createPlan(
      SubscriptionPlanRecord(
        id: const Uuid().v4(),
        name: 'SOM Premium',
        sortPriority: 2,
        isActive: true,
        priceInSubunit: 7990,
        maxUsers: 5,
        setupFeeInSubunit: 0,
        bannerAdsPerMonth: 0,
        normalAdsPerMonth: 1,
        freeMonths: 2,
        commitmentPeriodMonths: 12,
        rules: [
          {'id': const Uuid().v4(), 'upperLimit': 5, 'restriction': 0},
          {'id': const Uuid().v4(), 'upperLimit': 1, 'restriction': 1},
          {'id': const Uuid().v4(), 'upperLimit': 0, 'restriction': 2},
        ],
        createdAt: now,
      ),
    );
    await repository.createPlan(
      SubscriptionPlanRecord(
        id: const Uuid().v4(),
        name: 'SOM Enterprise',
        sortPriority: 3,
        isActive: true,
        priceInSubunit: 14990,
        maxUsers: 15,
        setupFeeInSubunit: 0,
        bannerAdsPerMonth: 1,
        normalAdsPerMonth: 1,
        freeMonths: 2,
        commitmentPeriodMonths: 12,
        rules: [
          {'id': const Uuid().v4(), 'upperLimit': 15, 'restriction': 0},
          {'id': const Uuid().v4(), 'upperLimit': 1, 'restriction': 1},
          {'id': const Uuid().v4(), 'upperLimit': 1, 'restriction': 2},
        ],
        createdAt: now,
      ),
    );
  }
}
