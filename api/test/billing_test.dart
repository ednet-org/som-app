import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/infrastructure/repositories/billing_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/audit_service.dart';
import 'package:som_api/services/email_service.dart';
import '../routes/billing/index.dart' as route;
import 'test_utils.dart';

void main() {
  group('Billing', () {
    test('consultant creates billing record, provider lists it', () async {
      final billing = InMemoryBillingRepository();
      final users = InMemoryUserRepository();
      final consultantCompany = await seedCompany(
        InMemoryCompanyRepository(),
      );
      final providerCompany = await seedCompany(
        InMemoryCompanyRepository(),
        type: 'provider',
      );
      final consultant = await seedUser(
        users,
        consultantCompany,
        email: 'consultant@som.test',
        roles: const ['consultant'],
      );
      final providerAdmin = await seedUser(
        users,
        providerCompany,
        email: 'provider@som.test',
        roles: const ['provider', 'admin'],
      );

      final consultantToken = buildTestJwt(userId: consultant.id);
      final providerToken = buildTestJwt(userId: providerAdmin.id);

      final createContext = TestRequestContext(
        path: '/billing',
        method: HttpMethod.post,
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $consultantToken',
        },
        body: jsonEncode({
          'companyId': providerCompany.id,
          'amountInSubunit': 4990,
          'currency': 'EUR',
          'periodStart': DateTime.now().toUtc().toIso8601String(),
          'periodEnd': DateTime.now()
              .toUtc()
              .add(const Duration(days: 30))
              .toIso8601String(),
        }),
      );
      final auditRepo = InMemoryAuditLogRepository();
      final audit = AuditService(repository: auditRepo);
      createContext.provide<BillingRepository>(billing);
      createContext.provide<UserRepository>(users);
      createContext.provide<EmailService>(
        EmailService(outboxPath: 'storage/test_outbox'),
      );
      createContext.provide<AuditService>(audit);

      final createResponse = await route.onRequest(createContext.context);
      expect(createResponse.statusCode, 200);
      final entries = await auditRepo.listRecent();
      expect(entries.first.action, 'billing.created');

      final listContext = TestRequestContext(
        path: '/billing',
        method: HttpMethod.get,
        headers: {'authorization': 'Bearer $providerToken'},
      );
      listContext.provide<BillingRepository>(billing);
      listContext.provide<UserRepository>(users);

      final listResponse = await route.onRequest(listContext.context);
      expect(listResponse.statusCode, 200);
      final body = jsonDecode(await listResponse.body()) as List<dynamic>;
      expect(body, isNotEmpty);
      expect(body.first['companyId'], providerCompany.id);
    });
  });
}
