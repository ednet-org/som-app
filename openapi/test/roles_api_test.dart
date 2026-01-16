import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for RolesApi
void main() {
  final instance = Openapi().getRolesApi();

  group(RolesApi, () {
    // List roles
    //
    //Future<BuiltList<Role>> rolesGet() async
    test('test rolesGet', () async {
      // TODO
    });

    // Create role
    //
    //Future<Role> rolesPost(RoleInput roleInput) async
    test('test rolesPost', () async {
      // TODO
    });

    // Delete role
    //
    //Future rolesRoleIdDelete(String roleId) async
    test('test rolesRoleIdDelete', () async {
      // TODO
    });

    // Update role
    //
    //Future<Role> rolesRoleIdPut(String roleId, RoleInput roleInput) async
    test('test rolesRoleIdPut', () async {
      // TODO
    });

  });
}
