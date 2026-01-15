import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for UsersApi
void main() {
  final instance = Openapi().getUsersApi();

  group(UsersApi, () {
    // Register a new user for a company
    //
    //Future companiesCompanyIdRegisterUserPost(String companyId, UserRegistration userRegistration) async
    test('test companiesCompanyIdRegisterUserPost', () async {
      // TODO
    });

    // List company users
    //
    //Future<BuiltList<UserDto>> companiesCompanyIdUsersGet(String companyId) async
    test('test companiesCompanyIdUsersGet', () async {
      // TODO
    });

    // Deactivate user
    //
    //Future companiesCompanyIdUsersUserIdDelete(String companyId, String userId) async
    test('test companiesCompanyIdUsersUserIdDelete', () async {
      // TODO
    });

    // Get user
    //
    //Future<UserDto> companiesCompanyIdUsersUserIdGet(String companyId, String userId) async
    test('test companiesCompanyIdUsersUserIdGet', () async {
      // TODO
    });

    // Update user
    //
    //Future<UserDto> companiesCompanyIdUsersUserIdUpdatePut(String companyId, String userId, UserDto userDto) async
    test('test companiesCompanyIdUsersUserIdUpdatePut', () async {
      // TODO
    });

    // Load user and company details
    //
    //Future<UsersLoadUserWithCompanyGet200Response> usersLoadUserWithCompanyGet(String userId, { String companyId }) async
    test('test usersLoadUserWithCompanyGet', () async {
      // TODO
    });

  });
}
