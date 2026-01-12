import 'package:test/test.dart';
import '../../lib/ednet_core.dart';

void main() {
  group('ApplicationService Unit Tests', () {
    late DomainSession session;
    late CommandBus commandBus;
    late EventBus eventBus;
    late ApplicationService applicationService;
    late TestUser testUser;
    late TestUser adminUser;

    setUp(() {
      // Create test domain model
      final domain = Domain('TestDomain');
      final model = Model(domain, 'TestModel');
      domain.models.add(model);
      final domainModels = DomainModels(domain);

      session = DomainSession(domainModels);
      commandBus = CommandBus();
      eventBus = EventBus();

      // Set up infrastructure connections
      eventBus.setCommandBus(commandBus);
      commandBus.setEventPublisher(eventBus);

      // Configure observability for testing (silent to prevent massive logs)
      ObservabilityMixin.configureGlobalObservability(
        ObservabilityConfiguration(
          defaultLevel: ObservabilityLevel.error,
          channels: [ConsoleObservabilityChannel()],
        ),
      );

      // Create the flagship application service
      applicationService = ApplicationService(
        session: session,
        commandBus: commandBus,
        eventBus: eventBus,
      );

      // Create test users with different permissions
      testUser = TestUser(
        id: 'user123',
        displayName: 'Test User',
        roles: [
          Role('user', [
            const Permission('Order', 'read'),
            const Permission('Order', 'create'),
          ]),
        ],
      );

      adminUser = TestUser(
        id: 'admin456',
        displayName: 'Admin User',
        roles: [
          Role('admin', [const Permission('*', '*')]),
        ],
      );
    });

    group('Basic Command Execution', () {
      test(
        'executeCommand should execute command and provide observability',
        () async {
          // Arrange
          final command = TestCommand('createOrder', {'productId': '123'});
          final handler = TestCommandHandler(
            (TestCommand cmd) async => CommandResult.success(
              data: {'orderId': 'order_${cmd.data['productId']}'},
            ),
          );
          commandBus.registerHandler<TestCommand>(handler);

          // Act
          final result = await SecurityContext.runWithSubject(
            testUser,
            () async {
              return await applicationService.executeCommand(command);
            },
          );

          // Assert
          expect(result.isSuccess, isTrue);
          expect(result.data?['orderId'], equals('order_123'));
        },
      );

      test('executeCommand should handle failures gracefully', () async {
        // Arrange
        final command = TestCommand('failingCommand', {});
        final handler = TestCommandHandler(
          (TestCommand cmd) async => CommandResult.failure('Simulated failure'),
        );
        commandBus.registerHandler<TestCommand>(handler);

        // Act
        final result = await SecurityContext.runWithSubject(testUser, () async {
          return await applicationService.executeCommand(command);
        });

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.errorMessage, equals('Simulated failure'));
      });
    });

    group('Security Integration', () {
      test('executeSecureCommand should enforce permissions', () async {
        // Arrange
        final command = TestCommand('adminCommand', {});
        final handler = TestCommandHandler(
          (TestCommand cmd) async =>
              CommandResult.success(data: {'result': 'admin operation'}),
        );
        commandBus.registerHandler<TestCommand>(handler);

        // Act - user without admin permissions
        final userResult = await SecurityContext.runWithSubject(
          testUser,
          () async {
            return await applicationService.executeSecureCommand(command, [
              'Admin:*',
            ]);
          },
        );

        // Act - admin user
        final adminResult = await SecurityContext.runWithSubject(
          adminUser,
          () async {
            return await applicationService.executeSecureCommand(command, [
              'Admin:*',
            ]);
          },
        );

        // Assert
        expect(userResult.isFailure, isTrue);
        expect(userResult.errorMessage, contains('Security check failed'));
        expect(adminResult.isSuccess, isTrue);
      });

      test('hasPermissions should check user permissions correctly', () async {
        await SecurityContext.runWithSubject(testUser, () async {
          // Test user has Order:read and Order:create
          expect(applicationService.hasPermissions(['Order:read']), isTrue);
          expect(applicationService.hasPermissions(['Order:create']), isTrue);
          expect(
            applicationService.hasPermissions(['Order:read', 'Order:create']),
            isTrue,
          );
          expect(applicationService.hasPermissions(['Admin:*']), isFalse);
        });

        await SecurityContext.runWithSubject(adminUser, () async {
          // Admin has all permissions
          expect(applicationService.hasPermissions(['Order:read']), isTrue);
          expect(applicationService.hasPermissions(['Admin:*']), isTrue);
          expect(
            applicationService.hasPermissions(['AnyResource:anyOperation']),
            isTrue,
          );
        });
      });

      test('hasAnyPermission should work correctly', () async {
        await SecurityContext.runWithSubject(testUser, () async {
          expect(
            applicationService.hasAnyPermission(['Order:read', 'Admin:*']),
            isTrue,
          );
          expect(
            applicationService.hasAnyPermission(['Admin:*', 'SuperAdmin:*']),
            isFalse,
          );
        });
      });

      test(
        'getCurrentSubject should return current security subject',
        () async {
          await SecurityContext.runWithSubject(testUser, () async {
            final subject = applicationService.getCurrentSubject();
            expect(subject.id, equals('user123'));
            expect(subject.displayName, equals('Test User'));
          });
        },
      );
    });

    group('Privilege Escalation', () {
      test(
        'runWithSystemPrivileges should temporarily elevate permissions',
        () async {
          await SecurityContext.runWithSubject(testUser, () async {
            // Normal user operation should fail
            expect(applicationService.hasPermissions(['System:*']), isFalse);

            // System privileges should work
            final result = await applicationService.runWithSystemPrivileges(
              () async {
                expect(applicationService.hasPermissions(['System:*']), isTrue);
                return 'system operation completed';
              },
            );

            expect(result, equals('system operation completed'));
            // Permissions should be restored
            expect(applicationService.hasPermissions(['System:*']), isFalse);
          });
        },
      );

      test('runWithSubject should switch security context', () async {
        await SecurityContext.runWithSubject(testUser, () async {
          expect(applicationService.getCurrentSubject().id, equals('user123'));

          final result = await applicationService.runWithSubject(
            adminUser,
            () async {
              expect(
                applicationService.getCurrentSubject().id,
                equals('admin456'),
              );
              return 'switched context operation';
            },
          );

          expect(result, equals('switched context operation'));
          expect(applicationService.getCurrentSubject().id, equals('user123'));
        });
      });
    });

    group('Workflow Execution', () {
      test(
        'executeWorkflow should execute multiple commands in sequence',
        () async {
          // Arrange
          final commands = [
            TestCommand('step1', {'data': 'first'}),
            TestCommand('step2', {'data': 'second'}),
            TestCommand('step3', {'data': 'third'}),
          ];

          final handler = TestCommandHandler(
            (TestCommand cmd) async => CommandResult.success(
              data: {'step': cmd.name, 'processed': cmd.data['data']},
            ),
          );
          commandBus.registerHandler<TestCommand>(handler);

          // Act
          final results = await SecurityContext.runWithSubject(
            testUser,
            () async {
              return await applicationService.executeWorkflow(commands);
            },
          );

          // Assert
          expect(results.length, equals(3));
          expect(results.every((r) => r.isSuccess), isTrue);
          expect(results[0].data?['step'], equals('step1'));
          expect(results[1].data?['step'], equals('step2'));
          expect(results[2].data?['step'], equals('step3'));
        },
      );

      test('executeWorkflow should stop on first failure', () async {
        // Arrange
        final commands = [
          TestCommand('step1', {'data': 'first'}),
          TestCommand('step2', {'data': 'failing'}),
          TestCommand('step3', {'data': 'third'}),
        ];

        final handler = TestCommandHandler((TestCommand cmd) async {
          if (cmd.data['data'] == 'failing') {
            return CommandResult.failure('Step 2 failed');
          }
          return CommandResult.success(data: {'step': cmd.name});
        });
        commandBus.registerHandler<TestCommand>(handler);

        // Act
        final results = await SecurityContext.runWithSubject(
          testUser,
          () async {
            return await applicationService.executeWorkflow(commands);
          },
        );

        // Assert
        expect(results.length, equals(2)); // Should stop at failure
        expect(results[0].isSuccess, isTrue);
        expect(results[1].isFailure, isTrue);
        expect(results[1].errorMessage, equals('Step 2 failed'));
      });
    });

    group('Performance Metrics', () {
      test(
        'executeCommandWithMetrics should collect performance data',
        () async {
          // Arrange
          final command = TestCommand('timedCommand', {});
          final handler = TestCommandHandler((TestCommand cmd) async {
            // Simulate some processing time
            await Future.delayed(const Duration(milliseconds: 10));
            return CommandResult.success(data: {'result': 'timed operation'});
          });
          commandBus.registerHandler<TestCommand>(handler);

          // Act
          final result = await SecurityContext.runWithSubject(
            testUser,
            () async {
              return await applicationService.executeCommandWithMetrics(
                command,
              );
            },
          );

          // Assert
          expect(result.isSuccess, isTrue);
          expect(result.data, isNotNull);
          expect(result.data?['metrics'], isNotNull);
          final metrics = result.data?['metrics'] as Map<String, dynamic>?;
          expect(metrics?['executionTimeMs'], isA<int>());
          expect(metrics?['commandType'], equals('TestCommand'));
        },
      );
    });

    group('Error Handling and Observability', () {
      test('should provide comprehensive observability on errors', () async {
        // Arrange
        final command = TestCommand('errorCommand', {});
        final handler = TestCommandHandler((TestCommand cmd) async {
          throw Exception('Unexpected error');
        });
        commandBus.registerHandler<TestCommand>(handler);

        // Act
        late CommandResult result;
        await SecurityContext.runWithSubject(testUser, () async {
          result = await applicationService.executeCommand(command);
        });

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.errorMessage, contains('Handler execution failed'));
        expect(result.errorMessage, contains('Unexpected error'));
      });

      test('should handle security exceptions gracefully', () async {
        // Arrange
        final command = TestCommand('secureCommand', {});
        final handler = TestCommandHandler(
          (TestCommand cmd) async => CommandResult.success(),
        );
        commandBus.registerHandler<TestCommand>(handler);

        // Act
        final result = await SecurityContext.runWithSubject(testUser, () async {
          return await applicationService.executeSecureCommand(command, [
            'NonExistentResource:operation',
          ]);
        });

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.errorMessage, contains('Security check failed'));
      });
    });

    group('Interface Compliance', () {
      test('should implement all IApplicationService methods', () {
        expect(applicationService, isA<IApplicationService>());

        // Verify all interface methods are callable
        expect(() => applicationService.executeCommand, returnsNormally);
        expect(() => applicationService.executeSecureCommand, returnsNormally);
        expect(
          () => applicationService.executeCommandOnAggregate,
          returnsNormally,
        );
        expect(
          () => applicationService.executeCommandOnNewAggregate,
          returnsNormally,
        );
        expect(() => applicationService.executeWorkflow, returnsNormally);
        expect(
          () => applicationService.executeCommandWithMetrics,
          returnsNormally,
        );
        expect(
          () => applicationService.executeCommandWithValidation,
          returnsNormally,
        );
        expect(() => applicationService.executeOnAggregate, returnsNormally);
        expect(() => applicationService.hasPermissions, returnsNormally);
        expect(() => applicationService.hasAnyPermission, returnsNormally);
        expect(() => applicationService.getCurrentSubject, returnsNormally);
        expect(
          () => applicationService.runWithSystemPrivileges,
          returnsNormally,
        );
        expect(() => applicationService.runWithSubject, returnsNormally);
      });
    });
  });
}

/// Test command implementation
class TestCommand implements ICommandBusCommand {
  @override
  final String id = Oid().toString();

  final String name;

  final Map<String, dynamic> data;

  TestCommand(this.name, this.data);

  @override
  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'data': data};
}

/// Test command handler implementation
class TestCommandHandler implements ICommandHandler<TestCommand> {
  final Future<CommandResult> Function(TestCommand) _handlerFunction;

  TestCommandHandler(this._handlerFunction);

  @override
  Future<CommandResult> handle(TestCommand command) {
    return _handlerFunction(command);
  }

  @override
  bool canHandle(dynamic command) => command is TestCommand;
}

/// Test user implementation
class TestUser implements SecuritySubject {
  @override
  final String id;

  @override
  final String displayName;

  @override
  final List<Role> roles;

  TestUser({required this.id, required this.displayName, required this.roles});

  @override
  bool hasPermission(Permission permission) {
    return roles.any((role) => role.hasPermission(permission));
  }

  @override
  bool hasPermissionString(String permissionString) {
    return hasPermission(Permission.fromString(permissionString));
  }

  @override
  bool hasAnyPermission(List<Permission> permissions) {
    return permissions.any(hasPermission);
  }

  @override
  bool hasAllPermissions(List<Permission> permissions) {
    return permissions.every(hasPermission);
  }

  @override
  bool hasRole(String roleName) {
    return roles.any((role) => role.name == roleName);
  }

  @override
  Set<Permission> getEffectivePermissions() {
    final result = <Permission>{};
    for (var role in roles) {
      result.addAll(role.permissions);
    }
    return result;
  }
}
