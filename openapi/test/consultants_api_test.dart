import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for ConsultantsApi
void main() {
  final instance = Openapi().getConsultantsApi();

  group(ConsultantsApi, () {
    // List consultants
    //
    //Future<BuiltList<UserDto>> consultantsGet() async
    test('test consultantsGet', () async {
      // TODO
    });

    // Create consultant
    //
    //Future consultantsPost(UserRegistration userRegistration) async
    test('test consultantsPost', () async {
      // TODO
    });

    // Consultant registers company (allow incomplete)
    //
    //Future consultantsRegisterCompanyPost(CompaniesRegisterCompanyPostRequest companiesRegisterCompanyPostRequest) async
    test('test consultantsRegisterCompanyPost', () async {
      // TODO
    });

  });
}
