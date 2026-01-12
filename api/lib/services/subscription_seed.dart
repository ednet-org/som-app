import 'package:uuid/uuid.dart';

import '../infrastructure/clock.dart';
import '../infrastructure/repositories/subscription_repository.dart';
import '../models/models.dart';

class SubscriptionSeeder {
  SubscriptionSeeder({required this.repository, required this.clock});

  final SubscriptionRepository repository;
  final Clock clock;

  void seedDefaults() {
    if (repository.hasPlans()) {
      return;
    }
    final now = clock.nowUtc();
    repository.createPlan(
      SubscriptionPlanRecord(
        id: const Uuid().v4(),
        name: 'SOM Standard',
        sortPriority: 1,
        isActive: true,
        priceInSubunit: 3990,
        rules: [
          {'id': const Uuid().v4(), 'upperLimit': 1, 'restriction': 0},
          {'id': const Uuid().v4(), 'upperLimit': 0, 'restriction': 1},
          {'id': const Uuid().v4(), 'upperLimit': 0, 'restriction': 2},
        ],
        createdAt: now,
      ),
    );
    repository.createPlan(
      SubscriptionPlanRecord(
        id: const Uuid().v4(),
        name: 'SOM Premium',
        sortPriority: 2,
        isActive: true,
        priceInSubunit: 7990,
        rules: [
          {'id': const Uuid().v4(), 'upperLimit': 5, 'restriction': 0},
          {'id': const Uuid().v4(), 'upperLimit': 1, 'restriction': 1},
          {'id': const Uuid().v4(), 'upperLimit': 0, 'restriction': 2},
        ],
        createdAt: now,
      ),
    );
    repository.createPlan(
      SubscriptionPlanRecord(
        id: const Uuid().v4(),
        name: 'SOM Enterprise',
        sortPriority: 3,
        isActive: true,
        priceInSubunit: 14990,
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
