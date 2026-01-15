import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import '../routes/Companies/[companyId]/activate.dart' as route;
import 'test_utils.dart';

void main() {
  group('POST /Companies/{companyId}/activate', () {
    test('reactivates company and users', () async {
      final companies = InMemoryCompanyRepository();
      final users = InMemoryUserRepository();
      final company = await seedCompany(companies);
      await companies.update(CompanyRecord(
        id: company.id,
        name: company.name,
        type: company.type,
        address: company.address,
        uidNr: company.uidNr,
        registrationNr: company.registrationNr,
        companySize: company.companySize,
        websiteUrl: company.websiteUrl,
        termsAcceptedAt: company.termsAcceptedAt,
        privacyAcceptedAt: company.privacyAcceptedAt,
        status: 'inactive',
        createdAt: company.createdAt,
        updatedAt: DateTime.now().toUtc(),
      ));
      final consultantAdmin = await seedUser(
        users,
        company,
        email: 'consultant-admin@example.com',
        roles: const ['consultant', 'admin'],
      );
      final inactiveUser = await seedUser(
        users,
        company,
        email: 'inactive@example.com',
        roles: const ['buyer'],
      );
      await users.update(
        inactiveUser.copyWith(
          isActive: false,
          updatedAt: DateTime.now().toUtc(),
        ),
      );
      final token = buildTestJwt(userId: consultantAdmin.id);

      final context = TestRequestContext(
        path: '/Companies/${company.id}/activate',
        method: HttpMethod.post,
        headers: {'authorization': 'Bearer $token'},
      );
      context.provide<UserRepository>(users);
      context.provide<CompanyRepository>(companies);

      final response = await route.onRequest(context.context, company.id);
      expect(response.statusCode, 200);
      final updatedCompany = await companies.findById(company.id);
      expect(updatedCompany?.status, 'active');
      final updatedUser = await users.findById(inactiveUser.id);
      expect(updatedUser?.isActive, true);
    });
  });
}
