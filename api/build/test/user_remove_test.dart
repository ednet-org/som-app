import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/audit_service.dart';
import 'package:som_api/services/domain_event_service.dart';
import 'package:som_api/services/notification_service.dart';
import '../routes/Companies/[companyId]/users/[userId]/remove.dart' as route;
import 'test_utils.dart';

void main() {
  group('POST /Companies/{companyId}/users/{userId}/remove', () {
    late InMemoryCompanyRepository companies;
    late InMemoryUserRepository users;
    late TestEmailService email;
    late NotificationService notifications;

    setUp(() async {
      companies = InMemoryCompanyRepository();
      users = InMemoryUserRepository();
      email = TestEmailService();
      notifications = NotificationService(
        ads: InMemoryAdsRepository(),
        users: users,
        companies: companies,
        providers: InMemoryProviderRepository(),
        inquiries: InMemoryInquiryRepository(),
        offers: InMemoryOfferRepository(),
        email: email,
      );
      final company = await seedCompany(companies);
      await seedUser(
        users,
        company,
        email: 'admin@som.test',
        roles: const ['admin'],
      );
      await seedUser(
        users,
        company,
        email: 'member@som.test',
        roles: const ['buyer'],
      );
    });

    test('requires admin', () async {
      final company = (await companies.listAll()).first;
      final member = await users.findByEmail('member@som.test');
      final token = buildTestJwt(userId: member!.id);
      final context = TestRequestContext(
        path: '/Companies/${company.id}/users/${member.id}/remove',
        method: HttpMethod.post,
        headers: {'authorization': 'Bearer $token'},
      );
      context.provide<UserRepository>(users);
      context.provide<CompanyRepository>(companies);
      context.provide<NotificationService>(notifications);
      context.provide<DomainEventService>(
        DomainEventService(
          repository: InMemoryDomainEventRepository(),
          notifications: notifications,
          companies: companies,
          inquiries: InMemoryInquiryRepository(),
        ),
      );
      final response =
          await route.onRequest(context.context, company.id, member.id);
      expect(response.statusCode, 403);
    });

    test('removes user and sends notification', () async {
      final company = (await companies.listAll()).first;
      final admin = await users.findByEmail('admin@som.test');
      final member = await users.findByEmail('member@som.test');
      final token = buildTestJwt(userId: admin!.id);
      final context = TestRequestContext(
        path: '/Companies/${company.id}/users/${member!.id}/remove',
        method: HttpMethod.post,
        headers: {'authorization': 'Bearer $token'},
      );
      context.provide<UserRepository>(users);
      context.provide<CompanyRepository>(companies);
      context.provide<NotificationService>(notifications);
      final auditRepo = InMemoryAuditLogRepository();
      context.provide<AuditService>(AuditService(repository: auditRepo));
      context.provide<DomainEventService>(
        DomainEventService(
          repository: InMemoryDomainEventRepository(),
          notifications: notifications,
          companies: companies,
          inquiries: InMemoryInquiryRepository(),
        ),
      );
      final response =
          await route.onRequest(context.context, company.id, member.id);
      expect(response.statusCode, 200);

      final updated = await users.findById(member.id);
      expect(updated?.isActive, isFalse);
      expect(updated?.removedAt, isNotNull);
      expect(email.sent.any((message) => message.to == member.email), isTrue);

      final entries = await auditRepo.listRecent();
      expect(entries.first.action, 'user.removed');
    });
  });
}
