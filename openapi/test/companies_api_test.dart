import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for CompaniesApi
void main() {
  final instance = Openapi().getCompaniesApi();

  group(CompaniesApi, () {
    //Future companiesCompanyIdGet(String companyId) async
    test('test companiesCompanyIdGet', () async {
      // TODO
    });

    //Future companiesCompanyIdRegisterUserPost(String companyId, { UserDto userDto }) async
    test('test companiesCompanyIdRegisterUserPost', () async {
      // TODO
    });

    //Future companiesCompanyIdUsersGet(String companyId) async
    test('test companiesCompanyIdUsersGet', () async {
      // TODO
    });

    //Future companiesCompanyIdUsersUserIdDelete(String userId, String companyId) async
    test('test companiesCompanyIdUsersUserIdDelete', () async {
      // TODO
    });

    //Future companiesCompanyIdUsersUserIdGet(String userId, String companyId) async
    test('test companiesCompanyIdUsersUserIdGet', () async {
      // TODO
    });

    //Future companiesCompanyIdUsersUserIdUpdatePut(String userId, String companyId, { UserDto userDto }) async
    test('test companiesCompanyIdUsersUserIdUpdatePut', () async {
      // TODO
    });

    //Future companiesGet() async
    test('test companiesGet', () async {
      // TODO
    });

    //Future registerCompany(RegisterCompanyRequest registerCompanyRequest) async
    test('test registerCompany', () async {
      // TODO
    });

  });
}
