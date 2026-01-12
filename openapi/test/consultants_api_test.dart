import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:openapi/openapi.dart';
import 'package:test/test.dart';

Openapi _openapiWithResponder(Response<dynamic> Function(RequestOptions) responder) {
  final interceptor = InterceptorsWrapper(
    onRequest: (options, handler) {
      try {
        handler.resolve(responder(options));
      } catch (error) {
        handler.reject(
          DioError(
            requestOptions: options,
            error: error,
            type: DioErrorType.other,
          ),
          true,
        );
      }
    },
  );

  return Openapi(
    dio: Dio(BaseOptions(baseUrl: 'http://localhost')),
    interceptors: [interceptor],
  );
}

/// tests for ConsultantsApi
void main() {
  group(ConsultantsApi, () {
    test('consultantsGet returns consultants list', () async {
      final api = _openapiWithResponder((options) {
        expect(options.method, 'GET');
        expect(options.path, '/consultants');
        return Response(
          requestOptions: options,
          statusCode: 200,
          data: [
            {
              'id': 'user-1',
              'companyId': 'company-1',
              'email': 'consultant@example.com',
              'firstName': 'Con',
              'lastName': 'Sultant',
              'salutation': 'Mr',
              'roles': [3]
            }
          ],
        );
      }).getConsultantsApi();

      final response = await api.consultantsGet();
      expect(response.data, isNotNull);
      expect(response.data!.length, 1);
      expect(response.data!.first.email, 'consultant@example.com');
      expect(response.data!.first.roles, isNotNull);
      expect(response.data!.first.roles!.first, 3);
    });

    test('consultantsPost sends registration payload', () async {
      final api = _openapiWithResponder((options) {
        expect(options.method, 'POST');
        expect(options.path, '/consultants');
        final data = options.data as Map<String, dynamic>;
        expect(data['email'], 'consultant@example.com');
        expect(data['firstName'], 'Con');
        expect(data['roles'], [3]);
        return Response(
          requestOptions: options,
          statusCode: 204,
          data: null,
        );
      }).getConsultantsApi();

      final registration = UserRegistration((b) => b
        ..email = 'consultant@example.com'
        ..firstName = 'Con'
        ..lastName = 'Sultant'
        ..salutation = 'Mr'
        ..roles.add(UserRegistrationRolesEnum.number3));

      await api.consultantsPost(userRegistration: registration);
    });

    test('consultantsRegisterCompanyPost sends nested payload', () async {
      final api = _openapiWithResponder((options) {
        expect(options.method, 'POST');
        expect(options.path, '/consultants/registerCompany');
        final data = options.data as Map<String, dynamic>;
        final company = data['company'] as Map<String, dynamic>;
        expect(company['name'], 'Acme GmbH');
        expect(company['type'], 0);
        final address = company['address'] as Map<String, dynamic>;
        expect(address['city'], 'Vienna');
        final users = data['users'] as List<dynamic>;
        expect(users.length, 1);
        return Response(
          requestOptions: options,
          statusCode: 204,
          data: null,
        );
      }).getConsultantsApi();

      final company = CompanyRegistration((b) => b
        ..name = 'Acme GmbH'
        ..uidNr = 'ATU12345678'
        ..registrationNr = 'FN12345'
        ..companySize = CompanyRegistrationCompanySizeEnum.number0
        ..type = CompanyRegistrationTypeEnum.number0
        ..address.update((a) => a
          ..country = 'AT'
          ..city = 'Vienna'
          ..street = 'Main Street'
          ..number = '1'
          ..zip = '1010'));

      final user = UserRegistration((b) => b
        ..email = 'admin@acme.at'
        ..firstName = 'Ada'
        ..lastName = 'Admin'
        ..salutation = 'Ms'
        ..roles.add(UserRegistrationRolesEnum.number4));

      final request = ConsultantsRegisterCompanyPostRequest((b) => b
        ..company.replace(company)
        ..users = ListBuilder<UserRegistration>([user]));

      await api.consultantsRegisterCompanyPost(
        consultantsRegisterCompanyPostRequest: request,
      );
    });
  });
}
