import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

void main() {
  group('DomainRole Domain-Driven System Tests', () {
    late DomainRoleRegistry roleRegistry;

    setUp(() {
      roleRegistry = DomainRoleRegistry();
    });

    tearDown(() {
      roleRegistry.clear();
    });

    group('DomainRole Value Object', () {
      test('should create role with basic properties', () {
        final role = DomainRole(
          code: 'test_role',
          name: 'Test Role',
          permissions: {'read', 'write'},
          level: 10,
          description: 'A test role',
        );

        expect(role.code, equals('test_role'));
        expect(role.name, equals('Test Role'));
        expect(role.permissions, containsAll(['read', 'write']));
        expect(role.level, equals(10));
        expect(role.description, equals('A test role'));
      });

      test('should create role with default values', () {
        final role = DomainRole(code: 'simple', name: 'Simple Role');

        expect(role.permissions, isEmpty);
        expect(role.parentRoles, isEmpty);
        expect(role.level, equals(0));
        expect(role.description, isNull);
      });

      test('should copy role with modifications', () {
        final original = DomainRole(
          code: 'original',
          name: 'Original',
          permissions: {'read'},
          level: 5,
        );

        final copy = original.copyWith(
          name: 'Modified',
          permissions: {'read', 'write'},
          level: 10,
        );

        expect(copy.code, equals('original'));
        expect(copy.name, equals('Modified'));
        expect(copy.permissions, containsAll(['read', 'write']));
        expect(copy.level, equals(10));
      });

      test('should get all permissions including inherited ones', () {
        final parentRole = DomainRole(
          code: 'parent',
          name: 'Parent',
          permissions: {'read', 'write'},
        );

        final childRole = DomainRole(
          code: 'child',
          name: 'Child',
          permissions: {'execute'},
          parentRoles: {parentRole},
        );

        expect(
          childRole.allPermissions,
          containsAll(['read', 'write', 'execute']),
        );
      });

      test('should check direct permissions', () {
        final role = DomainRole(
          code: 'tester',
          name: 'Tester',
          permissions: {'read', 'write'},
        );

        expect(role.hasPermission('read'), isTrue);
        expect(role.hasPermission('write'), isTrue);
        expect(role.hasPermission('delete'), isFalse);
      });

      test('should check inherited permissions', () {
        final adminRole = DomainRole(
          code: 'admin',
          name: 'Admin',
          permissions: {'manage_users'},
        );

        final moderatorRole = DomainRole(
          code: 'moderator',
          name: 'Moderator',
          permissions: {'moderate'},
          parentRoles: {adminRole},
        );

        expect(moderatorRole.hasPermission('manage_users'), isTrue);
        expect(moderatorRole.hasPermission('moderate'), isTrue);
      });

      test('should check role inheritance', () {
        final grandparent = DomainRole(
          code: 'grandparent',
          name: 'Grandparent',
        );
        final parent = DomainRole(
          code: 'parent',
          name: 'Parent',
          parentRoles: {grandparent},
        );
        final child = DomainRole(
          code: 'child',
          name: 'Child',
          parentRoles: {parent},
        );

        expect(child.inheritsFrom(parent), isTrue);
        expect(child.inheritsFrom(grandparent), isTrue);
        expect(parent.inheritsFrom(grandparent), isTrue);
        expect(grandparent.inheritsFrom(child), isFalse);
      });

      test('should compare role hierarchy levels', () {
        final juniorRole = DomainRole(
          code: 'junior',
          name: 'Junior',
          level: 10,
        );
        final seniorRole = DomainRole(
          code: 'senior',
          name: 'Senior',
          level: 20,
        );

        expect(juniorRole.isAtLeast(juniorRole), isTrue);
        expect(seniorRole.isAtLeast(juniorRole), isTrue);
        expect(juniorRole.isAtLeast(seniorRole), isFalse);
      });

      test('should implement value equality correctly', () {
        final role1 = DomainRole(
          code: 'test',
          name: 'Test',
          permissions: {'read', 'write'},
          level: 10,
        );

        final role2 = DomainRole(
          code: 'test',
          name: 'Test',
          permissions: {'read', 'write'},
          level: 10,
        );

        final role3 = DomainRole(
          code: 'test',
          name: 'Different',
          permissions: {'read', 'write'},
          level: 10,
        );

        expect(role1, equals(role2));
        expect(role1, isNot(equals(role3)));
      });
    });

    group('DomainRole Registry', () {
      test('should register and retrieve roles', () {
        final role = DomainRole(code: 'test', name: 'Test');
        roleRegistry.registerRole(role);

        expect(roleRegistry.hasRole('test'), isTrue);
        expect(roleRegistry.getRole('test'), equals(role));
        expect(roleRegistry.getRole('nonexistent'), isNull);
      });

      test('should prevent duplicate role registration', () {
        final role1 = DomainRole(code: 'duplicate', name: 'First');
        final role2 = DomainRole(code: 'duplicate', name: 'Second');

        roleRegistry.registerRole(role1);
        expect(() => roleRegistry.registerRole(role2), throwsArgumentError);
      });

      test('should get all registered roles', () {
        final role1 = DomainRole(code: 'role1', name: 'Role 1');
        final role2 = DomainRole(code: 'role2', name: 'Role 2');

        roleRegistry.registerRole(role1);
        roleRegistry.registerRole(role2);

        final allRoles = roleRegistry.allRoles;
        expect(allRoles.length, equals(2));
        expect(allRoles, containsAll([role1, role2]));
      });

      test('should validate role existence', () {
        expect(roleRegistry.isValidRole('nonexistent'), isFalse);

        final role = DomainRole(code: 'valid', name: 'Valid');
        roleRegistry.registerRole(role);

        expect(roleRegistry.isValidRole('valid'), isTrue);
      });

      test('should find roles with specific permissions', () {
        final role1 = DomainRole(
          code: 'editor',
          name: 'Editor',
          permissions: {'create', 'read', 'update'},
        );

        final role2 = DomainRole(
          code: 'viewer',
          name: 'Viewer',
          permissions: {'read'},
        );

        final role3 = DomainRole(
          code: 'admin',
          name: 'Admin',
          permissions: {'create', 'read', 'update', 'delete'},
        );

        roleRegistry.registerRole(role1);
        roleRegistry.registerRole(role2);
        roleRegistry.registerRole(role3);

        final readRoles = roleRegistry.getRolesWithPermission('read');
        expect(readRoles.length, equals(3));

        final createRoles = roleRegistry.getRolesWithPermission('create');
        expect(createRoles.length, equals(2));
        expect(
          createRoles.map((r) => r.code),
          containsAll(['editor', 'admin']),
        );
      });
    });

    group('Standard Domain Roles', () {
      test('should provide standard role definitions', () {
        expect(StandardDomainRoles.admin.code, equals('admin'));
        expect(StandardDomainRoles.admin.permissions, contains('manage_users'));
        expect(StandardDomainRoles.admin.level, equals(100));

        expect(StandardDomainRoles.moderator.code, equals('moderator'));
        expect(
          StandardDomainRoles.moderator.permissions,
          contains('moderate_content'),
        );

        expect(StandardDomainRoles.member.code, equals('member'));
        expect(StandardDomainRoles.member.permissions, contains('read'));
      });

      test('should register standard roles', () {
        StandardDomainRoles.registerStandardDomainRoles(roleRegistry);

        expect(roleRegistry.hasRole('admin'), isTrue);
        expect(roleRegistry.hasRole('moderator'), isTrue);
        expect(roleRegistry.hasRole('member'), isTrue);
        expect(roleRegistry.hasRole('guest'), isTrue);
        expect(roleRegistry.allRoles.length, equals(6));
      });

      test('should setup role hierarchy correctly', () {
        StandardDomainRoles.registerStandardDomainRoles(roleRegistry);
        StandardDomainRoles.setupDomainRoleHierarchy(roleRegistry);

        final moderator = roleRegistry.getRole('moderator')!;
        final member = roleRegistry.getRole('member')!;

        expect(
          moderator.parentRoles.any((role) => role.code == member.code),
          isTrue,
        );
        expect(moderator.inheritsFrom(member), isTrue);
        expect(
          moderator.hasPermission('read'),
          isTrue,
        ); // Inherited from member
      });
    });

    group('Domain Role-Based Policy', () {
      late DomainRoleBasedPolicy policy;
      late Map<String, dynamic> context;

      setUp(() {
        StandardDomainRoles.registerStandardDomainRoles(roleRegistry);
        StandardDomainRoles.setupDomainRoleHierarchy(roleRegistry);

        policy = DomainRoleBasedPolicy(StandardDomainRoles.moderator);
        context = {'roleRegistry': roleRegistry};
      });

      test('should succeed for sufficient role', () {
        context['userRole'] = 'admin'; // Admin has higher level than moderator

        final result = policy.evaluate(PlatformUser(), context);
        expect(result, isTrue);
      });

      test('should fail for insufficient role', () {
        context['userRole'] = 'member'; // Member has lower level than moderator

        final result = policy.evaluate(PlatformUser(), context);
        expect(result, isFalse); // Policy returns false for insufficient role
      });

      test('should check specific permissions', () {
        final permissionPolicy = DomainRoleBasedPolicy(
          StandardDomainRoles.member,
          requiredPermission: 'manage_users',
        );

        context['userRole'] = 'admin'; // Admin has manage_users permission
        final adminResult = permissionPolicy.evaluate(PlatformUser(), context);
        expect(adminResult, isTrue);

        context['userRole'] =
            'member'; // Member doesn't have manage_users permission
        final memberResult = permissionPolicy.evaluate(PlatformUser(), context);
        expect(memberResult, isFalse);
      });

      test('should fail without role registry', () {
        final contextWithoutRegistry = {'userRole': 'admin'};
        final result = policy.evaluate(PlatformUser(), contextWithoutRegistry);
        expect(result, isFalse); // Policy fails without proper context
      });

      test('should fail with invalid role', () {
        context['userRole'] = 'invalid_role';
        final result = policy.evaluate(PlatformUser(), context);
        expect(result, isFalse); // Policy fails with invalid role
      });

      test('should fail without user role', () {
        final contextWithoutUserRole = {'roleRegistry': roleRegistry};
        final result = policy.evaluate(PlatformUser(), contextWithoutUserRole);
        expect(result, isFalse); // Policy fails without user role
      });
    });

    group('Integration with Platform User', () {
      test('should work with PlatformUser role system', () {
        StandardDomainRoles.registerStandardDomainRoles(roleRegistry);

        final user = PlatformUser();
        user.role = 'admin';

        final adminRole = roleRegistry.getRole('admin')!;
        expect(adminRole.hasPermission('manage_users'), isTrue);
        expect(adminRole.level, equals(100));

        // Test role validation through policy
        final policy = DomainRoleBasedPolicy(StandardDomainRoles.admin);
        final context = {'userRole': user.role, 'roleRegistry': roleRegistry};

        final result = policy.evaluate(user, context);
        expect(result, isTrue);
      });

      test('should support role-based business logic', () {
        StandardDomainRoles.registerStandardDomainRoles(roleRegistry);

        final user = PlatformUser();
        user.role = 'moderator';

        final moderatorRole = roleRegistry.getRole('moderator')!;
        expect(moderatorRole.hasPermission('moderate_content'), isTrue);
        expect(
          moderatorRole.hasPermission('view_analytics'),
          isTrue,
        ); // Direct permission
        expect(moderatorRole.level, equals(75));
      });
    });
  });
}
