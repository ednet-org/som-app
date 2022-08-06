import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for UsersApi
void main() {
  final instance = Openapi().getUsersApi();

  group(UsersApi, () {
    //Future usersLoadUserWithCompanyGet({ String userId, String companyId }) async
    test('test usersLoadUserWithCompanyGet', () async {
      // TODO
    });

  });
}
