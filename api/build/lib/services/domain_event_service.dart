import 'dart:io';

import 'package:uuid/uuid.dart';

import '../infrastructure/repositories/company_repository.dart';
import '../infrastructure/repositories/domain_event_repository.dart';
import '../infrastructure/repositories/inquiry_repository.dart';
import '../models/models.dart';
import 'notification_service.dart';

class DomainEventService {
  DomainEventService({
    required this.repository,
    required this.notifications,
    required this.companies,
    required this.inquiries,
  });

  final DomainEventRepository repository;
  final NotificationService notifications;
  final CompanyRepository companies;
  final InquiryRepository inquiries;

  Future<void> emit({
    required String type,
    required String entityType,
    required String entityId,
    String status = 'success',
    String? actorId,
    Map<String, dynamic>? payload,
  }) async {
    final event = DomainEventRecord(
      id: const Uuid().v4(),
      type: type,
      status: status,
      entityType: entityType,
      entityId: entityId,
      actorId: actorId,
      payload: payload,
      createdAt: DateTime.now().toUtc(),
    );
    await repository.create(event);
    await _handle(event);
  }

  Future<void> emitFailure({
    required String type,
    required String entityType,
    required String entityId,
    String? actorId,
    Map<String, dynamic>? payload,
  }) async {
    await emit(
      type: type,
      entityType: entityType,
      entityId: entityId,
      status: 'failure',
      actorId: actorId,
      payload: payload,
    );
  }

  Future<void> _handle(DomainEventRecord event) async {
    if (_notificationsDisabled()) {
      return;
    }
    if (event.status != 'success') {
      return;
    }
    switch (event.type) {
      case 'company.registered':
        final company = await companies.findById(event.entityId);
        if (company != null) {
          await notifications.notifyConsultantsOnCompanyRegistered(company);
        }
        break;
      case 'company.updated':
        final company = await companies.findById(event.entityId);
        if (company != null) {
          await notifications.notifyConsultantsOnCompanyUpdated(company);
        }
        break;
      case 'company.activated':
        final company = await companies.findById(event.entityId);
        if (company != null) {
          await notifications.notifyConsultantsOnCompanyActivated(company);
          await notifications.notifyAdminsOnCompanyActivated(company);
        }
        break;
      case 'company.deactivated':
        final company = await companies.findById(event.entityId);
        if (company != null) {
          await notifications.notifyConsultantsOnCompanyDeactivated(company);
          await notifications.notifyAdminsOnCompanyDeactivated(company);
        }
        break;
      case 'user.removed':
        final company = await companies.findById(event.entityId);
        if (company != null) {
          final payload = event.payload ?? {};
          final userEmail = payload['userEmail'] as String?;
          final removedByEmail = payload['removedByEmail'] as String?;
          await notifications.notifyUserRemovedByEmails(
            company: company,
            userEmail: userEmail,
            removedByEmail: removedByEmail,
          );
        }
        break;
      case 'inquiry.assigned':
        final inquiry = await inquiries.findById(event.entityId);
        final payload = event.payload ?? {};
        final providerCompanyIds = (payload['providerCompanyIds'] as List?)
                ?.map((e) => e.toString())
                .toList() ??
            const <String>[];
        if (inquiry != null && providerCompanyIds.isNotEmpty) {
          await notifications.notifyProvidersOnInquiryAssigned(
            inquiry: inquiry,
            providerCompanyIds: providerCompanyIds,
          );
        }
        break;
      case 'branch.updated':
        final payload = event.payload ?? {};
        await notifications.notifyProvidersOnBranchUpdated(
          branchId: event.entityId,
          oldName: payload['oldName'] as String? ?? '',
          newName: payload['newName'] as String? ?? '',
        );
        break;
      case 'branch.deleted':
        final payload = event.payload ?? {};
        await notifications.notifyProvidersOnBranchDeleted(
          branchId: event.entityId,
          name: payload['name'] as String? ?? '',
        );
        break;
      case 'category.updated':
        final payload = event.payload ?? {};
        await notifications.notifyProvidersOnCategoryUpdated(
          categoryId: event.entityId,
          branchId: payload['branchId'] as String? ?? '',
          oldName: payload['oldName'] as String? ?? '',
          newName: payload['newName'] as String? ?? '',
        );
        break;
      case 'category.deleted':
        final payload = event.payload ?? {};
        await notifications.notifyProvidersOnCategoryDeleted(
          categoryId: event.entityId,
          branchId: payload['branchId'] as String? ?? '',
          name: payload['name'] as String? ?? '',
        );
        break;
      default:
        break;
    }
  }
}

bool _notificationsDisabled() {
  final disabled =
      const bool.fromEnvironment('DISABLE_NOTIFICATIONS', defaultValue: false) ||
          (Platform.environment['DISABLE_NOTIFICATIONS'] ?? '')
                  .toLowerCase() ==
              'true';
  return disabled;
}
