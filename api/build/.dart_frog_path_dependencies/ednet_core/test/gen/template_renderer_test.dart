import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

void main() {
  group('TemplateRenderer', () {
    late TemplateRenderer renderer;

    setUp(() {
      renderer = TemplateRenderer();
    });

    group('Basic Rendering', () {
      test('should create renderer instance', () {
        expect(renderer, isNotNull);
        expect(renderer, isA<TemplateRenderer>());
      });

      test('should have default templates path', () {
        expect(renderer.templatesPath, equals('lib/gen/templates'));
      });

      test('should support custom templates path', () {
        final customRenderer = TemplateRenderer(templatesPath: 'custom/path');
        expect(customRenderer.templatesPath, equals('custom/path'));
      });
    });

    group('Entity Template', () {
      test('should render basic entity without children or parents', () {
        final data = {
          'entityName': 'User',
          'entityCollectionName': 'Users',
          'hasChildren': false,
          'hasIdAttributes': false,
          'parents': <Map<String, dynamic>>[],
          'attributes': [
            {'code': 'name', 'type': 'String', 'isId': false},
            {'code': 'email', 'type': 'String', 'isId': false},
          ],
          'children': <Map<String, dynamic>>[],
          'hasSingleIdAttribute': false,
        };

        final result = renderer.render('entity', data);

        expect(result, contains('abstract class UserGen extends Entity<User>'));
        expect(result, contains('UserGen(Concept concept)'));
        expect(result, contains('String get name'));
        expect(result, contains('String get email'));
        expect(result, contains('User newEntity() => User(concept)'));
        expect(result, contains('Users newEntities() => Users(concept)'));
      });

      test('should render entity with children', () {
        final data = {
          'entityName': 'Department',
          'entityCollectionName': 'Departments',
          'hasChildren': true,
          'hasIdAttributes': false,
          'parents': <Map<String, dynamic>>[],
          'attributes': [
            {'code': 'name', 'type': 'String', 'isId': false},
          ],
          'children': [
            {
              'childCode': 'employees',
              'childConceptName': 'Employee',
              'childConceptVar': 'employee',
              'childCollectionName': 'Employees',
              'needsConcept': true,
            },
          ],
          'hasSingleIdAttribute': false,
        };

        final result = renderer.render('entity', data);

        expect(
          result,
          contains('abstract class DepartmentGen extends Entity<Department>'),
        );
        expect(result, contains('final employeeConcept ='));
        expect(
          result,
          contains("concept.model.concepts.singleWhereCode('Employee')"),
        );
        expect(
          result,
          contains("setChild('employees', Employees(employeeConcept!))"),
        );
        expect(result, contains('Employees get employees'));
      });

      test('should render entity with ID attributes', () {
        final data = {
          'entityName': 'Product',
          'entityCollectionName': 'Products',
          'hasChildren': false,
          'hasIdAttributes': true,
          'idParams': [
            {'type': 'Concept', 'name': 'concept', 'isLast': false},
            {'type': 'String', 'name': 'sku', 'isLast': true},
          ],
          'idParents': <Map<String, dynamic>>[],
          'idAttributes': [
            {'code': 'sku'},
          ],
          'parents': <Map<String, dynamic>>[],
          'attributes': [
            {'code': 'sku', 'type': 'String', 'isId': false},
            {'code': 'name', 'type': 'String', 'isId': false},
          ],
          'children': <Map<String, dynamic>>[],
          'hasSingleIdAttribute': true,
          'compareMethod': 'sku',
          'compareExpression': 'sku.compareTo(other.sku)',
        };

        final result = renderer.render('entity', data);

        expect(
          result,
          contains('ProductGen.withId(Concept concept, String sku)'),
        );
        expect(result, contains("setAttribute('sku', sku)"));
        expect(
          result,
          contains(
            'int skuCompareTo(Product other) => sku.compareTo(other.sku)',
          ),
        );
      });

      test('should render entity with parent relationships', () {
        final data = {
          'entityName': 'Task',
          'entityCollectionName': 'Tasks',
          'hasChildren': false,
          'hasIdAttributes': false,
          'parents': [
            {
              'code': 'project',
              'parentType': 'Project',
              'accessorName': 'project',
            },
          ],
          'attributes': [
            {'code': 'title', 'type': 'String', 'isId': false},
          ],
          'children': <Map<String, dynamic>>[],
          'hasSingleIdAttribute': false,
        };

        final result = renderer.render('entity', data);

        expect(result, contains('Reference get projectReference'));
        expect(result, contains('Project get project'));
        expect(result, contains("getParent('project')! as Project"));
        expect(
          result,
          contains("set project(Project p) => setParent('project', p)"),
        );
      });

      test('should render entity with Id attribute type', () {
        final data = {
          'entityName': 'Account',
          'entityCollectionName': 'Accounts',
          'hasChildren': false,
          'hasIdAttributes': false,
          'parents': <Map<String, dynamic>>[],
          'attributes': [
            {'code': 'id', 'type': 'Id', 'isId': true},
            {'code': 'balance', 'type': 'double', 'isId': false},
          ],
          'children': <Map<String, dynamic>>[],
          'hasSingleIdAttribute': false,
        };

        final result = renderer.render('entity', data);

        expect(result, contains('Id? get id => getAttribute(\'id\') as Id?'));
        expect(result, contains('set id(Id? a) => setAttribute(\'id\', a)'));
        expect(result, contains('double get balance'));
      });
    });

    group('Entities Collection Template', () {
      test('should render entities collection', () {
        final data = {'collectionName': 'Users', 'entityName': 'User'};

        final result = renderer.render('entities_collection', data);

        expect(
          result,
          contains('abstract class UsersGen extends Entities<User>'),
        );
        expect(result, contains('UsersGen(Concept concept)'));
        expect(result, contains('Users newEntities() => Users(concept)'));
        expect(result, contains('User newEntity() => User(concept)'));
      });
    });

    group('Template Caching', () {
      test('should cache templates after first load', () {
        final data = {'collectionName': 'Products', 'entityName': 'Product'};

        // First render - loads template
        final result1 = renderer.render('entities_collection', data);

        // Second render - uses cached template
        final result2 = renderer.render('entities_collection', data);

        expect(result1, equals(result2));
      });

      test('should clear template cache', () {
        final data = {'collectionName': 'Products', 'entityName': 'Product'};

        renderer.render('entities_collection', data);
        renderer.clearCache();

        // Should still work after cache clear
        final result = renderer.render('entities_collection', data);
        expect(
          result,
          contains('abstract class ProductsGen extends Entities<Product>'),
        );
      });
    });

    group('Error Handling', () {
      test('should throw ArgumentError for unknown template', () {
        expect(
          () => renderer.render('unknown_template', {}),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should provide helpful error message for unknown template', () {
        try {
          renderer.render('nonexistent', {});
          fail('Should have thrown ArgumentError');
        } catch (e) {
          expect(e.toString(), contains('Unknown template: nonexistent'));
        }
      });
    });

    group('CEP - Command Handler Template', () {
      // Helper to create default command handler data
      Map<String, dynamic> defaultCommandData(Map<String, dynamic> overrides) {
        return {
          'commandName': 'TestCommand',
          'entityName': 'TestEntity',
          'hasDependencies': false,
          'hasValidation': false,
          'usesRepository': false,
          'commandFields': <Map<String, dynamic>>[],
          ...overrides,
        };
      }

      test('should render basic command handler without dependencies', () {
        final data = {
          'commandName': 'CreateUser',
          'entityName': 'User',
          'hasDependencies': false,
          'usesRepository': false,
          'hasValidation': false,
          'commandFields': <Map<String, dynamic>>[],
          'businessLogic': <Map<String, dynamic>>[],
          'hasResultData': false,
          'hasToJson': false,
          'hasFromJson': false,
        };

        final result = renderer.renderCommandHandler(data);

        expect(
          result,
          contains(
            'class CreateUserCommandHandler implements ICommandHandler<CreateUserCommand>',
          ),
        );
        expect(result, contains('CreateUserCommandHandler();'));
        expect(
          result,
          contains('Future<CommandResult> handle(CreateUserCommand command)'),
        );
        expect(
          result,
          contains(
            'bool canHandle(dynamic command) => command is CreateUserCommand',
          ),
        );
      });

      test('should render command handler with dependencies', () {
        final data = {
          'commandName': 'UpdateProduct',
          'entityName': 'Product',
          'hasDependencies': true,
          'dependencies': [
            {'type': 'ProductRepository', 'name': 'repository'},
            {'type': 'EventBus', 'name': 'eventBus'},
          ],
          'usesRepository': false,
          'hasValidation': false,
          'commandFields': <Map<String, dynamic>>[],
          'businessLogic': <Map<String, dynamic>>[],
          'hasResultData': false,
          'hasToJson': false,
          'hasFromJson': false,
        };

        final result = renderer.renderCommandHandler(data);

        expect(result, contains('final ProductRepository repository;'));
        expect(result, contains('final EventBus eventBus;'));
        expect(result, contains('UpdateProductCommandHandler({'));
        expect(result, contains('required this.repository,'));
        expect(result, contains('required this.eventBus,'));
      });

      test('should render command handler with validation rules', () {
        final data = {
          'commandName': 'RegisterUser',
          'entityName': 'User',
          'hasDependencies': false,
          'hasValidation': true,
          'validations': [
            {
              'isRequired': true,
              'hasCondition': false,
              'field': 'email',
              'errorMessage': 'Email is required',
            },
            {
              'isRequired': false,
              'hasCondition': true,
              'condition': 'command.age < 18',
              'errorMessage': 'Must be 18 or older',
            },
          ],
          'usesRepository': false,
          'commandFields': <Map<String, dynamic>>[],
          'businessLogic': <Map<String, dynamic>>[],
          'hasResultData': false,
          'hasToJson': false,
          'hasFromJson': false,
        };

        final result = renderer.renderCommandHandler(data);

        expect(result, contains('// Validation'));
        expect(result, contains('if (command.email == null)'));
        expect(
          result,
          contains("return CommandResult.failure('Email is required')"),
        );
        expect(result, contains('if (command.age < 18)'));
        expect(
          result,
          contains("return CommandResult.failure('Must be 18 or older')"),
        );
      });

      test('should render command handler with repository usage', () {
        final data = {
          'commandName': 'ActivateAccount',
          'entityName': 'Account',
          'hasDependencies': true,
          'dependencies': [
            {'type': 'AccountRepository', 'name': 'repository'},
          ],
          'hasValidation': false,
          'usesRepository': true,
          'repositoryName': 'repository',
          'aggregateVar': 'account',
          'aggregateId': 'accountId',
          'commandMethod': 'activate',
          'commandParams': [],
          'checksResult': true,
          'commandFields': <Map<String, dynamic>>[],
          'publishesEvents': false,
          'hasResultData': false,
          'hasToJson': false,
          'hasFromJson': false,
        };

        final result = renderer.renderCommandHandler(data);

        expect(result, contains('// Load aggregate from repository'));
        expect(
          result,
          contains(
            'final account = await repository.findById(command.accountId)',
          ),
        );
        expect(result, contains('if (account == null)'));
        expect(
          result,
          contains("return CommandResult.failure('Account not found')"),
        );
        expect(result, contains('final result = account.activate()'));
        expect(result, contains('await repository.save(account)'));
      });

      test('should render command handler with event publishing', () {
        final data = {
          'commandName': 'PlaceOrder',
          'entityName': 'Order',
          'hasDependencies': true,
          'dependencies': [
            {'type': 'OrderRepository', 'name': 'repository'},
            {'type': 'EventBus', 'name': 'eventBus'},
          ],
          'hasValidation': false,
          'usesRepository': true,
          'repositoryName': 'repository',
          'aggregateVar': 'order',
          'aggregateId': 'orderId',
          'commandMethod': 'place',
          'commandParams': [],
          'checksResult': false,
          'publishesEvents': true,
          'hasEventBus': true,
          'commandFields': <Map<String, dynamic>>[],
          'hasResultData': false,
          'hasToJson': false,
          'hasFromJson': false,
        };

        final result = renderer.renderCommandHandler(data);

        expect(result, contains('// Publish domain events'));
        expect(
          result,
          contains('for (final event in order.uncommittedEvents)'),
        );
        expect(result, contains('await eventBus.publish(event)'));
        expect(result, contains('order.markEventsAsCommitted()'));
      });

      test('should render command class with fields', () {
        final data = {
          'commandName': 'CreateProduct',
          'entityName': 'Product',
          'hasDependencies': false,
          'usesRepository': false,
          'hasValidation': false,
          'commandFields': [
            {'type': 'String', 'name': 'name'},
            {'type': 'double', 'name': 'price'},
            {'type': 'int', 'name': 'quantity'},
          ],
          'businessLogic': <Map<String, dynamic>>[],
          'hasResultData': false,
          'hasToJson': false,
          'hasFromJson': false,
        };

        final result = renderer.renderCommandHandler(data);

        expect(
          result,
          contains('class CreateProductCommand implements ICommandBusCommand'),
        );
        expect(result, contains('final String id;'));
        expect(result, contains('final DateTime timestamp;'));
        expect(result, contains('final String name;'));
        expect(result, contains('final double price;'));
        expect(result, contains('final int quantity;'));
        expect(result, contains('required this.name,'));
        expect(result, contains('required this.price,'));
        expect(result, contains('required this.quantity,'));
      });

      test('should render command with toJson serialization', () {
        final data = {
          'commandName': 'UpdateProfile',
          'entityName': 'Profile',
          'hasDependencies': false,
          'usesRepository': false,
          'hasValidation': false,
          'hasToJson': true,
          'hasFromJson': false,
          'commandFields': [
            {'type': 'String', 'name': 'userId'},
            {'type': 'String', 'name': 'displayName'},
          ],
          'businessLogic': <Map<String, dynamic>>[],
          'hasResultData': false,
        };

        final result = renderer.renderCommandHandler(data);

        expect(result, contains('Map<String, dynamic> toJson() =>'));
        expect(result, contains("'id': id"));
        expect(result, contains("'timestamp': timestamp.toIso8601String()"));
        expect(result, contains("'userId': userId"));
        expect(result, contains("'displayName': displayName"));
      });

      test('should render command with fromJson deserialization', () {
        final data = {
          'commandName': 'DeleteItem',
          'entityName': 'Item',
          'hasDependencies': false,
          'usesRepository': false,
          'hasValidation': false,
          'hasToJson': false,
          'hasFromJson': true,
          'commandFields': [
            {'type': 'String', 'name': 'itemId'},
          ],
          'businessLogic': <Map<String, dynamic>>[],
          'hasResultData': false,
        };

        final result = renderer.renderCommandHandler(data);

        expect(
          result,
          contains(
            'factory DeleteItemCommand.fromJson(Map<String, dynamic> json)',
          ),
        );
        expect(result, contains("id: json['id'] as String"));
        expect(
          result,
          contains("timestamp: DateTime.parse(json['timestamp'] as String)"),
        );
        expect(result, contains("itemId: json['itemId'] as String"));
      });
    });

    group('CEP - Event Handler Template', () {
      test('should render basic event handler without dependencies', () {
        final data = {
          'eventName': 'UserCreated',
          'eventType': 'UserCreated',
          'hasDependencies': false,
          'hasLogging': false,
          'updatesReadModel': false,
          'triggersSideEffects': false,
          'triggersCommands': false,
          'updatesProjection': false,
          'customLogic': false,
          'hasErrorHandling': false,
          'hasMetadata': false,
          'eventFields': <Map<String, dynamic>>[],
          'hasToJson': false,
          'hasFromJson': false,
          'hasToString': false,
          'hasEquality': false,
        };

        final result = renderer.renderEventHandler(data);

        expect(
          result,
          contains(
            'class UserCreatedEventHandler implements IEventHandler<UserCreatedEvent>',
          ),
        );
        expect(result, contains('UserCreatedEventHandler();'));
        expect(
          result,
          contains("String get handlerName => 'UserCreatedEventHandler'"),
        );
        expect(result, contains('Future<void> handle(UserCreatedEvent event)'));
        expect(
          result,
          contains(
            'bool canHandle(IDomainEvent event) => event is UserCreatedEvent',
          ),
        );
      });

      test('should render event handler with dependencies', () {
        final data = {
          'eventName': 'OrderPlaced',
          'eventType': 'OrderPlaced',
          'hasDependencies': true,
          'dependencies': [
            {'type': 'EmailService', 'name': 'emailService'},
            {'type': 'Logger', 'name': 'logger'},
          ],
          'hasLogging': false,
          'updatesReadModel': false,
          'triggersSideEffects': false,
          'triggersCommands': false,
          'updatesProjection': false,
          'customLogic': false,
          'hasErrorHandling': false,
          'hasMetadata': false,
          'eventFields': <Map<String, dynamic>>[],
          'hasToJson': false,
          'hasFromJson': false,
          'hasToString': false,
          'hasEquality': false,
        };

        final result = renderer.renderEventHandler(data);

        expect(result, contains('final EmailService emailService;'));
        expect(result, contains('final Logger logger;'));
        expect(result, contains('OrderPlacedEventHandler({'));
        expect(result, contains('required this.emailService,'));
        expect(result, contains('required this.logger,'));
      });

      test('should render event handler with logging', () {
        final data = {
          'eventName': 'PaymentProcessed',
          'eventType': 'PaymentProcessed',
          'hasDependencies': false,
          'hasLogging': true,
          'logger': 'logger',
          'updatesReadModel': false,
          'triggersSideEffects': false,
          'triggersCommands': false,
          'updatesProjection': false,
          'customLogic': false,
          'hasErrorHandling': false,
          'hasMetadata': false,
          'eventFields': <Map<String, dynamic>>[],
          'hasToJson': false,
          'hasFromJson': false,
          'hasToString': false,
          'hasEquality': false,
        };

        final result = renderer.renderEventHandler(data);

        expect(result, contains('// Log event processing'));
        expect(
          result,
          contains(
            "logger.info('Processing PaymentProcessedEvent: \${event.id}')",
          ),
        );
        expect(
          result,
          contains(
            "logger.info('Successfully processed PaymentProcessedEvent: \${event.id}')",
          ),
        );
      });

      test('should render event handler with read model updates', () {
        final data = {
          'eventName': 'ProductUpdated',
          'eventType': 'ProductUpdated',
          'hasDependencies': false,
          'hasLogging': false,
          'updatesReadModel': true,
          'readModelUpdates': [
            {
              'readModelName': 'productView',
              'updateParams': [
                {'key': 'id', 'value': 'productId'},
                {'key': 'name', 'value': 'name'},
              ],
            },
          ],
          'triggersSideEffects': false,
          'triggersCommands': false,
          'updatesProjection': false,
          'customLogic': false,
          'hasErrorHandling': false,
          'hasMetadata': false,
          'eventFields': <Map<String, dynamic>>[],
          'hasToJson': false,
          'hasFromJson': false,
          'hasToString': false,
          'hasEquality': false,
        };

        final result = renderer.renderEventHandler(data);

        expect(result, contains('// Update read model'));
        expect(result, contains('await productView.update('));
        expect(result, contains('id: event.productId,'));
        expect(result, contains('name: event.name,'));
      });

      test('should render event handler with side effects', () {
        final data = {
          'eventName': 'OrderConfirmed',
          'eventType': 'OrderConfirmed',
          'hasDependencies': false,
          'hasLogging': false,
          'updatesReadModel': false,
          'triggersSideEffects': true,
          'sideEffects': [
            {
              'sendsEmail': true,
              'emailService': 'emailService',
              'emailRecipient': 'customerEmail',
              'emailSubject': 'Order Confirmed',
              'emailBody': 'Your order has been confirmed',
              'emailParams': [],
              'sendsNotification': false,
              'callsExternalService': false,
              'customSideEffect': false,
            },
          ],
          'triggersCommands': false,
          'updatesProjection': false,
          'customLogic': false,
          'hasErrorHandling': false,
          'hasMetadata': false,
          'eventFields': <Map<String, dynamic>>[],
          'hasToJson': false,
          'hasFromJson': false,
          'hasToString': false,
          'hasEquality': false,
        };

        final result = renderer.renderEventHandler(data);

        expect(result, contains('// Execute side effects'));
        expect(result, contains('await emailService.send('));
        expect(result, contains('to: event.customerEmail,'));
        expect(result, contains("subject: 'Order Confirmed'"));
        expect(result, contains("body: 'Your order has been confirmed'"));
      });

      test('should render event class with fields', () {
        final data = {
          'eventName': 'ItemAdded',
          'eventType': 'ItemAdded',
          'hasDependencies': false,
          'eventFields': [
            {'type': 'String', 'name': 'itemId'},
            {'type': 'String', 'name': 'itemName'},
            {'type': 'int', 'name': 'quantity'},
          ],
          'hasLogging': false,
          'updatesReadModel': false,
          'triggersSideEffects': false,
          'triggersCommands': false,
          'updatesProjection': false,
          'customLogic': false,
          'hasErrorHandling': false,
          'hasMetadata': false,
          'hasToJson': false,
          'hasFromJson': false,
          'hasToString': false,
          'hasEquality': false,
        };

        final result = renderer.renderEventHandler(data);

        expect(
          result,
          contains('class ItemAddedEvent implements IDomainEvent'),
        );
        expect(result, contains('final String id;'));
        expect(result, contains('final DateTime occurredAt;'));
        expect(result, contains('final String aggregateId;'));
        expect(result, contains('final String itemId;'));
        expect(result, contains('final String itemName;'));
        expect(result, contains('final int quantity;'));
      });

      test('should render event with metadata', () {
        final data = {
          'eventName': 'UserLoggedIn',
          'eventType': 'UserLoggedIn',
          'hasDependencies': false,
          'hasLogging': false,
          'updatesReadModel': false,
          'hasMetadata': true,
          'metadataFields': [
            {'key': 'ipAddress', 'value': "'192.168.1.1'"},
            {'key': 'userAgent', 'value': "'Mozilla/5.0'"},
          ],
          'eventFields': [],
          'triggersSideEffects': false,
          'triggersCommands': false,
          'updatesProjection': false,
          'customLogic': false,
          'hasErrorHandling': false,
          'hasToJson': false,
          'hasFromJson': false,
          'hasToString': false,
          'hasEquality': false,
        };

        final result = renderer.renderEventHandler(data);

        expect(result, contains('Map<String, dynamic> get metadata =>'));
        expect(result, contains("'ipAddress': '192.168.1.1'"));
        expect(result, contains("'userAgent': 'Mozilla/5.0'"));
      });

      test('should render event with equality operators', () {
        final data = {
          'eventName': 'AccountClosed',
          'eventType': 'AccountClosed',
          'hasDependencies': false,
          'hasLogging': false,
          'updatesReadModel': false,
          'hasEquality': true,
          'eventFields': [],
          'triggersSideEffects': false,
          'triggersCommands': false,
          'updatesProjection': false,
          'customLogic': false,
          'hasErrorHandling': false,
          'hasMetadata': false,
          'hasToJson': false,
          'hasFromJson': false,
          'hasToString': false,
        };

        final result = renderer.renderEventHandler(data);

        expect(result, contains('bool operator ==(Object other)'));
        expect(result, contains('other is AccountClosedEvent'));
        expect(result, contains('id == other.id'));
        expect(result, contains('aggregateId == other.aggregateId'));
        expect(
          result,
          contains('int get hashCode => id.hashCode ^ aggregateId.hashCode'),
        );
      });
    });

    group('CEP - Policy Engine Template', () {
      test('should render basic policy without rules', () {
        final data = {
          'policyName': 'AgeVerification',
          'policyDescription': 'Verifies user age requirements',
          'hasDependencies': false,
          'hasScope': false,
          'hasTypeCheck': false,
          'hasSimpleEvaluation': true,
          'hasRules': false,
          'hasCompositeRules': false,
          'hasCustomEvaluation': false,
          'hasValidMessage': false,
          'includesPassedRules': false,
          'hasValidateMethod': false,
          'hasCanApplyMethod': false,
          'defaultResult': 'true',
          'rules': <Map<String, dynamic>>[],
        };

        final result = renderer.renderPolicy(data);

        expect(
          result,
          contains('class AgeVerificationPolicy implements IPolicy'),
        );
        expect(result, contains('AgeVerificationPolicy();'));
        expect(result, contains("String get name => 'AgeVerification'"));
        expect(
          result,
          contains(
            "String get description => 'Verifies user age requirements'",
          ),
        );
        expect(result, contains('bool evaluate(Entity entity)'));
        expect(
          result,
          contains('PolicyEvaluationResult evaluateWithDetails(Entity entity)'),
        );
      });

      test('should render policy with dependencies', () {
        final data = {
          'policyName': 'CreditCheck',
          'policyDescription': 'Checks credit eligibility',
          'hasDependencies': true,
          'dependencies': [
            {'type': 'CreditService', 'name': 'creditService'},
            {'type': 'RiskCalculator', 'name': 'riskCalculator'},
          ],
          'hasScope': false,
          'hasTypeCheck': false,
          'hasSimpleEvaluation': true,
          'hasRules': false,
          'hasCompositeRules': false,
          'hasCustomEvaluation': false,
          'hasValidMessage': false,
          'includesPassedRules': false,
          'hasValidateMethod': false,
          'hasCanApplyMethod': false,
          'defaultResult': 'false',
          'rules': <Map<String, dynamic>>[],
        };

        final result = renderer.renderPolicy(data);

        expect(result, contains('final CreditService creditService;'));
        expect(result, contains('final RiskCalculator riskCalculator;'));
        expect(result, contains('CreditCheckPolicy({'));
        expect(result, contains('required this.creditService,'));
        expect(result, contains('required this.riskCalculator,'));
      });

      test('should render policy with scope', () {
        final data = {
          'policyName': 'EntityLevelPolicy',
          'policyDescription': 'Applies at entity level',
          'hasDependencies': false,
          'hasScope': true,
          'scopeValue': 'entity',
          'hasTypeCheck': false,
          'hasSimpleEvaluation': true,
          'hasRules': false,
          'hasCompositeRules': false,
          'hasCustomEvaluation': false,
          'hasValidMessage': false,
          'includesPassedRules': false,
          'hasValidateMethod': false,
          'hasCanApplyMethod': false,
          'defaultResult': 'true',
          'rules': <Map<String, dynamic>>[],
        };

        final result = renderer.renderPolicy(data);

        expect(
          result,
          contains('PolicyScope? get scope => PolicyScope.entity'),
        );
      });

      test('should render policy with type checking', () {
        final data = {
          'policyName': 'UserPolicy',
          'policyDescription': 'Policy for users',
          'hasDependencies': false,
          'hasScope': false,
          'hasTypeCheck': true,
          'entityType': 'User',
          'hasSimpleEvaluation': false,
          'hasRules': false,
          'hasCompositeRules': false,
          'hasCustomEvaluation': false,
          'hasValidMessage': false,
          'includesPassedRules': false,
          'hasValidateMethod': false,
          'hasCanApplyMethod': false,
          'rules': <Map<String, dynamic>>[],
        };

        final result = renderer.renderPolicy(data);

        expect(result, contains('if (entity is! User)'));
        expect(result, contains('return false;'));
        expect(result, contains('final typedEntity = entity as User;'));
      });

      test('should render policy with simple rules', () {
        final data = {
          'policyName': 'MinimumAge',
          'policyDescription': 'Minimum age requirement',
          'hasDependencies': false,
          'hasScope': false,
          'hasTypeCheck': false,
          'hasSimpleEvaluation': true,
          'hasRules': false,
          'hasCompositeRules': false,
          'hasCustomEvaluation': false,
          'hasValidMessage': false,
          'includesPassedRules': false,
          'hasValidateMethod': false,
          'hasCanApplyMethod': false,
          'defaultResult': 'false',
          'rules': [
            {
              'isSimpleCondition': true,
              'ruleName': 'AgeCheck',
              'condition': 'entity.age >= 18',
              'expectedResult': 'true',
            },
          ],
        };

        final result = renderer.renderPolicy(data);

        expect(result, contains('// Rule: AgeCheck'));
        expect(result, contains('if (entity.age >= 18)'));
        expect(result, contains('return true;'));
      });

      test('should render policy with detailed rules evaluation', () {
        final data = {
          'policyName': 'ComplexValidation',
          'policyDescription': 'Complex validation rules',
          'hasDependencies': false,
          'hasScope': false,
          'hasTypeCheck': false,
          'hasSimpleEvaluation': false,
          'hasRules': true,
          'hasCompositeRules': false,
          'hasCustomEvaluation': false,
          'hasValidMessage': false,
          'includesPassedRules': false,
          'hasValidateMethod': false,
          'hasCanApplyMethod': false,
          'rules': [
            {
              'ruleName': 'EmailFormat',
              'ruleVar': 'emailFormat',
              'isCustomCondition': true,
              'isAndCondition': false,
              'isOrCondition': false,
              'customCondition': 'typedEntity.email.contains("@")',
              'violationMessage': 'Invalid email format',
              'hasSeverity': false,
              'hasContext': false,
              'hasRuleDescription': false,
            },
            {
              'ruleName': 'PasswordStrength',
              'ruleVar': 'passwordStrength',
              'isCustomCondition': false,
              'isAndCondition': true,
              'isOrCondition': false,
              'conditions': [
                {
                  'condition': 'typedEntity.password.length >= 8',
                  'isNotLast': true,
                },
                {
                  'condition':
                      'typedEntity.password.contains(RegExp(r"[A-Z]"))',
                  'isNotLast': false,
                },
              ],
              'violationMessage':
                  'Password must be at least 8 characters with uppercase',
              'hasSeverity': false,
              'hasContext': false,
              'hasRuleDescription': false,
            },
          ],
        };

        final result = renderer.renderPolicy(data);

        expect(result, contains('// Rule: EmailFormat'));
        expect(
          result,
          contains('final emailFormatPassed = typedEntity.email.contains("@")'),
        );
        expect(result, contains("message: 'Invalid email format'"));
        expect(result, contains('// Rule: PasswordStrength'));
        expect(result, contains('final passwordStrengthPassed ='));
      });

      test('should render policy with validate method', () {
        final data = {
          'policyName': 'StrictPolicy',
          'policyDescription': 'Strict validation policy',
          'hasDependencies': false,
          'hasScope': false,
          'hasTypeCheck': false,
          'hasSimpleEvaluation': true,
          'hasRules': false,
          'hasCompositeRules': false,
          'hasCustomEvaluation': false,
          'hasValidMessage': false,
          'includesPassedRules': false,
          'defaultResult': 'true',
          'rules': <Map<String, dynamic>>[],
          'hasValidateMethod': true,
          'hasCanApplyMethod': false,
        };

        final result = renderer.renderPolicy(data);

        expect(result, contains('void validate(Entity entity)'));
        expect(result, contains('final result = evaluateWithDetails(entity)'));
        expect(result, contains('if (!result.isValid)'));
        expect(result, contains('throw PolicyViolationException'));
      });
    });

    group('Renderer Enhancements', () {
      test('should have renderCommandHandler convenience method', () {
        expect(renderer.renderCommandHandler, isNotNull);

        final result = renderer.renderCommandHandler({
          'commandName': 'Test',
          'entityName': 'TestEntity',
          'hasDependencies': false,
          'usesRepository': false,
          'hasValidation': false,
          'commandFields': <Map<String, dynamic>>[],
          'businessLogic': <Map<String, dynamic>>[],
          'hasResultData': false,
          'hasToJson': false,
          'hasFromJson': false,
        });

        expect(result, contains('TestCommandHandler'));
      });

      test('should have renderEventHandler convenience method', () {
        expect(renderer.renderEventHandler, isNotNull);

        final result = renderer.renderEventHandler({
          'eventName': 'Test',
          'eventType': 'Test',
          'hasDependencies': false,
          'hasLogging': false,
          'updatesReadModel': false,
          'triggersSideEffects': false,
          'triggersCommands': false,
          'updatesProjection': false,
          'customLogic': false,
          'hasErrorHandling': false,
          'hasMetadata': false,
          'hasToJson': false,
          'hasFromJson': false,
          'hasEquality': false,
          'hasToString': false,
          'eventFields': <Map<String, dynamic>>[],
        });

        expect(result, contains('TestEventHandler'));
      });

      test('should have renderPolicy convenience method', () {
        expect(renderer.renderPolicy, isNotNull);

        final result = renderer.renderPolicy({
          'policyName': 'Test',
          'policyDescription': 'Test policy',
          'hasDependencies': false,
          'hasScope': false,
          'hasTypeCheck': false,
          'hasSimpleEvaluation': true,
          'hasRules': false,
          'hasCompositeRules': false,
          'hasCustomEvaluation': false,
          'hasValidMessage': false,
          'includesPassedRules': false,
          'hasValidateMethod': false,
          'hasCanApplyMethod': false,
          'defaultResult': 'true',
          'rules': <Map<String, dynamic>>[],
        });

        expect(result, contains('TestPolicy'));
      });

      test('should check if template exists with hasTemplate', () {
        expect(renderer.hasTemplate('entity'), isTrue);
        expect(renderer.hasTemplate('command_handler'), isTrue);
        expect(renderer.hasTemplate('event_handler'), isTrue);
        expect(renderer.hasTemplate('policy_engine'), isTrue);
        expect(renderer.hasTemplate('nonexistent'), isFalse);
      });

      test('should list all available templates', () {
        final templates = renderer.availableTemplates;
        expect(templates, isNotEmpty);
        expect(templates.length, 11);
        expect(templates, contains('entity'));
        expect(templates, contains('entities_collection'));
        expect(templates, contains('aggregate_root'));
        expect(templates, contains('event_sourced'));
        expect(templates, contains('command_handler'));
        expect(templates, contains('event_handler'));
        expect(templates, contains('policy_engine'));
        expect(templates.length, equals(11));
      });

      test('should support useFileTemplates flag', () {
        final fileRenderer = TemplateRenderer(useFileTemplates: true);
        expect(fileRenderer.useFileTemplates, isTrue);

        final embeddedRenderer = TemplateRenderer(useFileTemplates: false);
        expect(embeddedRenderer.useFileTemplates, isFalse);
      });
    });
  });
}
