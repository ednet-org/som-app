import 'package:uuid/uuid.dart';

import '../infrastructure/repositories/audit_log_repository.dart';
import '../models/models.dart';

class AuditService {
  AuditService({required this.repository});

  final AuditLogRepository repository;

  Future<void> log({
    required String action,
    required String entityType,
    required String entityId,
    String? actorId,
    Map<String, dynamic>? metadata,
  }) async {
    final entry = AuditLogRecord(
      id: const Uuid().v4(),
      actorId: actorId,
      action: action,
      entityType: entityType,
      entityId: entityId,
      metadata: metadata,
      createdAt: DateTime.now().toUtc(),
    );
    await repository.create(entry);
  }
}
