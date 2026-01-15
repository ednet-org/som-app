import 'package:uuid/uuid.dart';

import '../infrastructure/clock.dart';
import '../infrastructure/repositories/role_repository.dart';
import '../models/models.dart';

class RoleSeeder {
  RoleSeeder({required this.repository, required this.clock});

  final RoleRepository repository;
  final Clock clock;

  Future<void> seedDefaults() async {
    await _ensureRole('buyer', 'Buyer user');
    await _ensureRole('provider', 'Provider user');
    await _ensureRole('consultant', 'Consultant user');
    await _ensureRole('admin', 'Admin user');
  }

  Future<void> _ensureRole(String name, String description) async {
    final existing = await repository.findByName(name);
    if (existing != null) {
      return;
    }
    final now = clock.nowUtc();
    await repository.create(
      RoleRecord(
        id: const Uuid().v4(),
        name: name,
        description: description,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }
}
