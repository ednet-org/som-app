import 'dart:convert';
import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

/// Complete integration test for Event Sourcing Foundation
/// Tests the full cycle: Commands → Events → Policies → Sagas → Commands

/// Domain events for integration testing
class CustomerRegistrationStarted implements IDomainEvent {
  @override
  final String id = Oid().toString();
  @override
  final String name = 'CustomerRegistrationStarted';
  @override
  final DateTime timestamp = DateTime.now();
  @override
  String aggregateId;
  @override
  String aggregateType = 'Customer';
  @override
  int aggregateVersion = 1;
  @override
  Entity? entity;

  final String email;
  final String customerName;
  String? sagaId;

  CustomerRegistrationStarted({
    required this.email,
    required this.customerName,
    this.sagaId,
  }) : aggregateId = Oid().toString();

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'customerName': customerName,
    'sagaId': sagaId,
  };

  @override
  Map<String, dynamic> get eventData {
    final json = toJson();
    final data = Map<String, dynamic>.from(json);

    // Remove metadata fields to leave just the event data
    data.remove('id');
    data.remove('timestamp');
    data.remove('name');
    data.remove('aggregateId');
    data.remove('aggregateType');
    data.remove('aggregateVersion');

    return data;
  }

  @override
  Event toBaseEvent() =>
      Event(name, 'Customer registration started', [], entity, toJson());
}

class EmailVerificationSent implements IDomainEvent {
  @override
  final String id = Oid().toString();
  @override
  final String name = 'EmailVerificationSent';
  @override
  final DateTime timestamp = DateTime.now();
  @override
  String aggregateId;
  @override
  String aggregateType = 'Email';
  @override
  int aggregateVersion = 1;
  @override
  Entity? entity;

  final String email;
  final String verificationToken;
  String? sagaId;

  EmailVerificationSent({
    required this.email,
    required this.verificationToken,
    this.sagaId,
  }) : aggregateId = Oid().toString();

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'verificationToken': verificationToken,
    'sagaId': sagaId,
  };

  @override
  Map<String, dynamic> get eventData {
    final json = toJson();
    final data = Map<String, dynamic>.from(json);

    // Remove metadata fields to leave just the event data
    data.remove('id');
    data.remove('timestamp');
    data.remove('name');
    data.remove('aggregateId');
    data.remove('aggregateType');
    data.remove('aggregateVersion');

    return data;
  }

  // Add a data property for saga correlation
  Map<String, dynamic> get data => toJson();

  @override
  Event toBaseEvent() =>
      Event(name, 'Email verification sent', [], entity, toJson());
}

class EmailVerified implements IDomainEvent {
  @override
  final String id = Oid().toString();
  @override
  final String name = 'EmailVerified';
  @override
  final DateTime timestamp = DateTime.now();
  @override
  String aggregateId;
  @override
  String aggregateType = 'Customer';
  @override
  int aggregateVersion = 2;
  @override
  Entity? entity;

  final String email;
  String? sagaId;

  EmailVerified({required this.email, this.sagaId})
    : aggregateId = Oid().toString();

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'sagaId': sagaId,
  };

  @override
  Map<String, dynamic> get eventData {
    final json = toJson();
    final data = Map<String, dynamic>.from(json);

    // Remove metadata fields to leave just the event data
    data.remove('id');
    data.remove('timestamp');
    data.remove('name');
    data.remove('aggregateId');
    data.remove('aggregateType');
    data.remove('aggregateVersion');

    return data;
  }

  // Add a data property for saga correlation
  Map<String, dynamic> get data => toJson();

  @override
  Event toBaseEvent() => Event(name, 'Email verified', [], entity, toJson());
}

class CustomerActivated implements IDomainEvent {
  @override
  final String id = Oid().toString();
  @override
  final String name = 'CustomerActivated';
  @override
  final DateTime timestamp = DateTime.now();
  @override
  String aggregateId;
  @override
  String aggregateType = 'Customer';
  @override
  int aggregateVersion = 2;
  @override
  Entity? entity;

  final String customerId;
  final String email;
  String? sagaId;

  CustomerActivated({
    required this.customerId,
    required this.email,
    this.sagaId,
  }) : aggregateId = customerId;

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'customerId': customerId,
    'email': email,
    'sagaId': sagaId,
  };

  @override
  Map<String, dynamic> get eventData {
    final json = toJson();
    final data = Map<String, dynamic>.from(json);

    // Remove metadata fields to leave just the event data
    data.remove('id');
    data.remove('timestamp');
    data.remove('name');
    data.remove('aggregateId');
    data.remove('aggregateType');
    data.remove('aggregateVersion');

    return data;
  }

  @override
  Event toBaseEvent() =>
      Event(name, 'Customer activated', [], entity, toJson());
}

/// Command definitions
class StartCustomerRegistrationCommand implements ICommandBusCommand {
  @override
  final String id = Oid().toString();
  final String email;
  final String customerName;

  StartCustomerRegistrationCommand({
    required this.email,
    required this.customerName,
  });

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'customerName': customerName,
  };
}

class SendEmailVerificationCommand implements ICommandBusCommand {
  @override
  final String id = Oid().toString();
  final String email;
  final String? sagaId;

  SendEmailVerificationCommand(this.email, {this.sagaId});

  @override
  Map<String, dynamic> toJson() => {'id': id, 'email': email, 'sagaId': sagaId};
}

class ActivateCustomerCommand implements ICommandBusCommand {
  @override
  final String id = Oid().toString();
  final String customerId;
  final String email;

  ActivateCustomerCommand({required this.customerId, required this.email});

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'customerId': customerId,
    'email': email,
  };
}

/// Enhanced Aggregate Root for Customer
class CustomerAggregate extends EnhancedAggregateRoot<CustomerAggregate> {
  String? email;
  String? customerName;
  String status = 'Draft';
  DateTime? registeredAt;

  // For testing: store event history
  final List<dynamic> eventHistory = [];

  CustomerAggregate() {
    concept = CustomerConcept();
  }

  /// Command: Start registration
  CommandResult startRegistration(String email, String customerName) {
    if (status != 'Draft') {
      return CommandResult.failure('Customer already registered');
    }

    if (email.isEmpty || customerName.isEmpty) {
      return CommandResult.failure('Email and name are required');
    }

    this.email = email;
    this.customerName = customerName;
    registeredAt = DateTime.now();

    recordEventLegacy(
      'CustomerRegistrationStarted',
      'Customer registration process started',
      ['EmailVerificationHandler', 'RegistrationSagaHandler'],
      data: {
        'email': email,
        'customerName': customerName,
        'registeredAt': registeredAt!.toIso8601String(),
        'aggregateId': oid.toString(),
        'aggregateType': 'Customer',
      },
    );

    return CommandResult.success(
      data: {'customerId': oid.toString(), 'email': email},
    );
  }

  /// Command: Activate customer
  CommandResult activate() {
    if (status != 'PendingVerification') {
      return CommandResult.failure('Customer must be pending verification');
    }

    recordEventLegacy(
      'CustomerActivated',
      'Customer account activated',
      ['NotificationHandler', 'AnalyticsHandler'],
      data: {
        'customerId': oid.toString(),
        'email': email,
        'activatedAt': DateTime.now().toIso8601String(),
        'aggregateId': oid.toString(),
        'aggregateType': 'Customer',
      },
    );

    return CommandResult.success();
  }

  @override
  void applyEvent(dynamic event) {
    // Store event in history for testing
    eventHistory.add(event);

    switch (event.name) {
      case 'CustomerRegistrationStarted':
        status = 'PendingVerification';
        // Restore state from event data
        if (event.data != null) {
          email = event.data['email'];
          customerName = event.data['customerName'];
          if (event.data['registeredAt'] != null) {
            registeredAt = DateTime.parse(event.data['registeredAt']);
          }
        }
        break;
      case 'CustomerActivated':
        status = 'Active';
        break;
    }
  }

  /// Test helper: Rehydrate from event history
  @override
  void rehydrateFromEventHistory(List<dynamic> events) {
    // Call parent method which handles version incrementation
    super.rehydrateFromEventHistory(events);
  }

  /// Test helper: Create snapshot
  @override
  AggregateSnapshot<CustomerAggregate> createSnapshot() {
    final snapshotData = {
      'email': email,
      'customerName': customerName,
      'status': status,
      'registeredAt': registeredAt?.toIso8601String(),
    };
    return AggregateSnapshot<CustomerAggregate>(
      aggregateId: oid.toString(),
      aggregateType: 'CustomerAggregate',
      version: version,
      stateData: jsonEncode(snapshotData),
      timestamp: DateTime.now(),
    );
  }

  /// Test helper: Restore from snapshot
  @override
  void restoreFromSnapshot(AggregateSnapshot<CustomerAggregate> snapshot) {
    // Call parent method which handles version restoration
    super.restoreFromSnapshot(snapshot);
  }

  /// Test helper: Rehydrate from snapshot + events
  @override
  void rehydrateFromSnapshot(
    AggregateSnapshot<CustomerAggregate> snapshot,
    List<dynamic> events,
  ) {
    // Call parent method which handles version management
    super.rehydrateFromSnapshot(snapshot, events);
  }

  @override
  String toJson() => jsonEncode({
    'oid': oid.toString(),
    'email': email,
    'customerName': customerName,
    'status': status,
    'registeredAt': registeredAt?.toIso8601String(),
  });

  @override
  void fromJson<K extends Entity<K>>(String entityJson) {
    final json = jsonDecode(entityJson) as Map<String, dynamic>;
    email = json['email'];
    customerName = json['customerName'];
    status = json['status'] ?? 'Draft';
    if (json['registeredAt'] != null) {
      registeredAt = DateTime.parse(json['registeredAt']);
    }
  }
}

class CustomerConcept extends Concept {
  CustomerConcept() : super(Model(Domain('Test'), 'TestModel'), 'Customer') {
    entry = true;
    updateOid = true; // Allow OID updates for test scenarios
  }

  String get name => 'Customer';
}

/// Customer Registration Saga
class CustomerRegistrationSaga
    extends ProcessManager<CustomerRegistrationState> {
  final List<String> executionLog = [];

  // Static registry to track instances for testing
  static final Map<String, CustomerRegistrationSaga> _instances = {};

  CustomerRegistrationSaga() : super('CustomerRegistrationSaga') {
    // Register this instance for testing
    _instances[sagaId] = this;
  }

  // Test helper to get saga instance by ID
  static CustomerRegistrationSaga? getInstance(String sagaId) =>
      _instances[sagaId];

  // Test helper to get all instances
  static List<CustomerRegistrationSaga> getAllInstances() =>
      _instances.values.toList();

  // Test helper to clear instances
  static void clearInstances() => _instances.clear();

  @override
  CustomerRegistrationState createInitialState() => CustomerRegistrationState();

  @override
  void configureWorkflow() {
    print('🔧 Configuring saga workflow');
    step('StartRegistration')
        .whenEvent<EnhancedDomainEventImpl>()
        .then(handleRegistrationStarted)
        .asStartingStep();

    step('SendVerification').whenEvent<EmailVerificationSent>().then((event) {
      print(
        '🎯 SendVerification step triggered with EmailVerificationSent event',
      );
      return handleVerificationSent(event);
    });

    step('CompleteRegistration').whenEvent<EmailVerified>().then((event) {
      print('🎯 CompleteRegistration step triggered with EmailVerified event');
      return handleEmailVerified(event);
    });

    // Debug: Print event mappings
    print('🔧 Event mappings: ${eventStepMappings}');
  }

  Future<void> handleRegistrationStarted(dynamic event) async {
    if (event?.name != 'CustomerRegistrationStarted') return;

    executionLog.add('handleRegistrationStarted');
    final eventData = event.data ?? {};
    state.email = eventData['email'];
    state.customerName = eventData['customerName'];
    state.customerId = eventData['aggregateId'];
    state.completedSteps.add('StartRegistration');

    // Send command to start email verification
    final command = SendEmailVerificationCommand(
      eventData['email'],
      sagaId: sagaId,
    );
    await sendCommand(command);
  }

  Future<void> handleVerificationSent(EmailVerificationSent event) async {
    print(
      '🎯 Saga handleVerificationSent called with token: ${event.verificationToken}',
    );
    executionLog.add('handleVerificationSent');
    state.verificationToken = event.verificationToken;
  }

  Future<void> handleEmailVerified(EmailVerified event) async {
    print('🎯 Saga handleEmailVerified called with email: ${event.email}');
    executionLog.add('handleEmailVerified');

    // Send command to activate customer
    final command = ActivateCustomerCommand(
      customerId: state.customerId!,
      email: event.email,
    );
    await sendCommand(command);
  }

  @override
  Future<void> handleEvent(dynamic event) async {
    print(
      '🎯 Saga handleEvent: event=${event.runtimeType}, mappings=${eventStepMappings.keys}',
    );
    return super.handleEvent(event);
  }

  @override
  Future<bool> shouldHandleEvent(dynamic event) async {
    final shouldHandle = await super.shouldHandleEvent(event);
    print(
      '🎯 Saga shouldHandleEvent: event=${event.runtimeType}, shouldHandle=$shouldHandle',
    );
    return shouldHandle;
  }

  @override
  Future<bool> correlateEvent(dynamic event) async {
    print(
      '🔍 Saga correlateEvent: event=${event.runtimeType}, email=${state.email}, currentStep=${state.currentStep}',
    );

    // Direct property access for custom event types
    if (event is EmailVerified) {
      if (event.sagaId != null && event.sagaId == sagaId) {
        print(
          '🔍 Correlating EmailVerified by sagaId: ${event.sagaId} == $sagaId',
        );
        return true;
      }
      if (state.email != null && event.email == state.email) {
        print(
          '🔍 Correlating EmailVerified by email: ${event.email} == ${state.email}',
        );
        return true;
      }
    }

    if (event is EmailVerificationSent) {
      if (event.sagaId != null && event.sagaId == sagaId) {
        print(
          '🔍 Correlating EmailVerificationSent by sagaId: ${event.sagaId} == $sagaId',
        );
        return true;
      }
      if (state.email != null && event.email == state.email) {
        print(
          '🔍 Correlating EmailVerificationSent by email: ${event.email} == ${state.email}',
        );
        return true;
      }
    }

    // Event data access for generic events
    final eventData = event.data ?? {};

    if (eventData['sagaId'] != null) {
      print('🔍 Correlating by sagaId: ${eventData['sagaId']} == $sagaId');
      return eventData['sagaId'] == sagaId;
    }

    // For starting events
    if (event?.name == 'CustomerRegistrationStarted' && state.isNew) {
      print('🔍 Correlating starting event');
      return true;
    }

    // Correlate by email
    if (state.email != null) {
      if (event?.name == 'EmailVerificationSent') {
        print(
          '🔍 Correlating EmailVerificationSent by name: ${eventData['email']} == ${state.email}',
        );
        return eventData['email'] == state.email;
      }
      if (event?.name == 'EmailVerified') {
        print(
          '🔍 Correlating EmailVerified by name: ${eventData['email']} == ${state.email}',
        );
        return eventData['email'] == state.email;
      }
    }

    print('🔍 No correlation found');
    return false;
  }
}

class CustomerRegistrationState extends SagaState {
  String? email;
  String? customerName;
  String? customerId;
  String? verificationToken;

  CustomerRegistrationState({String? sagaId, DateTime? startedAt})
    : super(sagaId: sagaId, startedAt: startedAt);

  @override
  Map<String, dynamic> toJson() => {
    'sagaId': sagaId,
    'email': email,
    'customerName': customerName,
    'customerId': customerId,
    'verificationToken': verificationToken,
    'startedAt': startedAt.toIso8601String(),
    'lastUpdated': lastUpdated.toIso8601String(),
    'currentStep': currentStep,
    'isCompleted': isCompleted,
    'hasFailed': hasFailed,
    'completedSteps': completedSteps.toList(),
  };

  @override
  void fromJson(Map<String, dynamic> json) {
    // Note: sagaId and startedAt are final and set in constructor
    email = json['email'];
    customerName = json['customerName'];
    customerId = json['customerId'];
    verificationToken = json['verificationToken'];
    currentStep = json['currentStep'];
    isCompleted = json['isCompleted'] ?? false;
    hasFailed = json['hasFailed'] ?? false;

    if (json['lastUpdated'] != null) {
      lastUpdated = DateTime.parse(json['lastUpdated']);
    }

    completedSteps.clear(); // Clear existing steps
    if (json['completedSteps'] != null) {
      completedSteps.addAll(List<String>.from(json['completedSteps']));
    }
  }
}

/// Event Triggered Policy
class CustomerRegistrationPolicy implements IEventTriggeredPolicy {
  final List<ICommandBusCommand> generatedCommands = [];

  @override
  String get name => 'CustomerRegistrationPolicy';

  String get description =>
      'Generates commands in response to registration events';

  PolicyScope? get scope => PolicyScope.entity;

  @override
  bool evaluate(dynamic entity) => true;

  PolicyEvaluationResult evaluateWithDetails(Entity entity) {
    return PolicyEvaluationResult(true, []);
  }

  @override
  bool shouldTriggerOnEvent(dynamic event) {
    return event?.name == 'CustomerRegistrationStarted';
  }

  @override
  void executeActions(dynamic entity, dynamic event) {
    // Policy actions executed
  }

  @override
  List<ICommandBusCommand> generateCommands(dynamic entity, dynamic event) {
    if (event?.name == 'CustomerRegistrationStarted') {
      final eventData = event.data ?? {};
      final command = SendEmailVerificationCommand(eventData['email']);
      generatedCommands.add(command);
      return [command];
    }
    return [];
  }
}

/// Command Handlers
class StartCustomerRegistrationHandler
    implements ICommandHandler<StartCustomerRegistrationCommand> {
  final List<StartCustomerRegistrationCommand> handledCommands = [];
  final CustomerAggregate customer;

  StartCustomerRegistrationHandler(this.customer);

  @override
  Future<CommandResult> handle(StartCustomerRegistrationCommand command) async {
    handledCommands.add(command);
    return customer.startRegistration(command.email, command.customerName);
  }

  @override
  bool canHandle(dynamic command) =>
      command is StartCustomerRegistrationCommand;
}

class SendEmailVerificationHandler
    implements ICommandHandler<SendEmailVerificationCommand> {
  final List<SendEmailVerificationCommand> handledCommands = [];
  final EventBus eventBus;

  SendEmailVerificationHandler(this.eventBus);

  @override
  Future<CommandResult> handle(SendEmailVerificationCommand command) async {
    handledCommands.add(command);

    // Simulate sending email verification
    final verificationToken = 'token_${DateTime.now().millisecondsSinceEpoch}';

    // Publish event
    final event = EmailVerificationSent(
      email: command.email,
      verificationToken: verificationToken,
      sagaId: command.sagaId,
    );
    await eventBus.publish(event);

    return CommandResult.success(
      data: {'verificationToken': verificationToken},
    );
  }

  @override
  bool canHandle(dynamic command) => command is SendEmailVerificationCommand;
}

class ActivateCustomerHandler
    implements ICommandHandler<ActivateCustomerCommand> {
  final List<ActivateCustomerCommand> handledCommands = [];
  final CustomerAggregate customer;

  ActivateCustomerHandler(this.customer);

  @override
  Future<CommandResult> handle(ActivateCustomerCommand command) async {
    handledCommands.add(command);
    return customer.activate();
  }

  @override
  bool canHandle(dynamic command) => command is ActivateCustomerCommand;
}

void main() {
  group('Event Sourcing Foundation Integration Tests', () {
    late CommandBus commandBus;
    late EventBus eventBus;
    late EnhancedApplicationService appService;
    late CustomerAggregate customer;
    late CustomerRegistrationPolicy policy;

    late StartCustomerRegistrationHandler startHandler;
    late SendEmailVerificationHandler emailHandler;
    late ActivateCustomerHandler activateHandler;

    setUp(() {
      // Clear any previous saga instances
      CustomerRegistrationSaga.clearInstances();

      // Initialize infrastructure
      commandBus = CommandBus();
      eventBus = EventBus();
      appService = EnhancedApplicationService(
        session: DomainSession(DomainModels(Domain('TestDomain'))),
        commandBus: commandBus,
        eventBus: eventBus,
      );

      // Initialize domain objects
      customer = CustomerAggregate();
      CustomerRegistrationSaga(); // Pre-initialize saga class for dynamic instances
      policy = CustomerRegistrationPolicy();

      // Initialize handlers
      startHandler = StartCustomerRegistrationHandler(customer);
      emailHandler = SendEmailVerificationHandler(eventBus);
      activateHandler = ActivateCustomerHandler(customer);

      // Set up infrastructure connections
      eventBus.setCommandBus(commandBus);

      // Register command handlers
      commandBus.registerHandler<StartCustomerRegistrationCommand>(
        startHandler,
      );
      commandBus.registerHandler<SendEmailVerificationCommand>(emailHandler);
      commandBus.registerHandler<ActivateCustomerCommand>(activateHandler);

      // Register saga with event bus
      eventBus.registerSaga(() => CustomerRegistrationSaga());

      // Register policy
      eventBus.registerPolicy(policy);
    });

    group('Complete Customer Registration Flow', () {
      test(
        'should execute complete registration workflow successfully',
        () async {
          // Act 1: Start customer registration
          final startCommand = StartCustomerRegistrationCommand(
            email: 'test@example.com',
            customerName: 'John Doe',
          );

          final startResult = await appService.executeOnAggregate(
            customer,
            () => customer.startRegistration(
              startCommand.email,
              startCommand.customerName,
            ),
          );

          // Assert 1: Registration started
          expect(startResult.isSuccess, isTrue);
          expect(customer.status, equals('PendingVerification'));
          expect(customer.email, equals('test@example.com'));

          // Get the dynamically created saga instance
          final activeSagas = CustomerRegistrationSaga.getAllInstances();
          print('🔍 Active sagas count: ${activeSagas.length}');
          for (int i = 0; i < activeSagas.length; i++) {
            print(
              '🔍 Saga $i: ${activeSagas[i].sagaId}, log: ${activeSagas[i].executionLog}',
            );
          }

          // Find the saga that actually handled the event
          final activeSaga = activeSagas.firstWhere(
            (s) => s.executionLog.contains('handleRegistrationStarted'),
            orElse: () => activeSagas.first,
          );
          expect(
            activeSaga.executionLog,
            contains('handleRegistrationStarted'),
          );

          // Act 2: Simulate email verification (manually trigger)
          final emailVerifiedEvent = EmailVerified(
            email: 'test@example.com',
            sagaId: activeSaga.sagaId,
          );
          await eventBus.publish(emailVerifiedEvent);

          // Assert 2: Customer activated
          expect(activeSaga.executionLog, contains('handleEmailVerified'));
          expect(customer.status, equals('Active'));
          expect(activateHandler.handledCommands.length, equals(1));
        },
      );

      test('should maintain event sourcing audit trail', () async {
        // Act: Execute complete flow
        final startCommand = StartCustomerRegistrationCommand(
          email: 'audit@example.com',
          customerName: 'Audit User',
        );

        await appService.executeOnAggregate(
          customer,
          () => customer.startRegistration(
            startCommand.email,
            startCommand.customerName,
          ),
        );

        // Get the actual saga that was created by event handling
        final activeSagas = CustomerRegistrationSaga.getAllInstances();
        final activeSaga = activeSagas.firstWhere(
          (s) => s.state.email == 'audit@example.com',
          orElse: () => activeSagas.isNotEmpty
              ? activeSagas.first
              : CustomerRegistrationSaga(),
        );

        final emailVerifiedEvent = EmailVerified(
          email: 'audit@example.com',
          sagaId: activeSaga.sagaId,
        );
        await eventBus.publish(emailVerifiedEvent);

        // Assert: Complete audit trail
        // Note: Events are processed and cleared, but state changes are preserved
        expect(
          customer.status,
          equals('Active'),
        ); // Final state after both events
        expect(
          customer.version,
          greaterThanOrEqualTo(2),
        ); // Version incremented
        expect(customer.email, equals('audit@example.com')); // Data preserved

        // Verify handlers were called (indicating events were processed)
        expect(activateHandler.handledCommands.length, equals(1));
        expect(emailHandler.handledCommands.length, greaterThanOrEqualTo(1));
      });

      test('should support state reconstruction from events', () async {
        // Arrange: Create events in original aggregate
        await appService.executeOnAggregate(
          customer,
          () => customer.startRegistration(
            'reconstruct@example.com',
            'Test User',
          ),
        );

        // Get the actual saga that was created by event handling
        final activeSagas = CustomerRegistrationSaga.getAllInstances();
        final activeSaga = activeSagas.firstWhere(
          (s) => s.state.email == 'reconstruct@example.com',
          orElse: () => activeSagas.isNotEmpty
              ? activeSagas.first
              : CustomerRegistrationSaga(),
        );

        final emailVerifiedEvent = EmailVerified(
          email: 'reconstruct@example.com',
          sagaId: activeSaga.sagaId,
        );
        await eventBus.publish(emailVerifiedEvent);

        final originalEvents = List.from(customer.eventHistory);

        // Act: Reconstruct state in new aggregate
        final newCustomer = CustomerAggregate();
        newCustomer.oid = customer.oid; // Same ID
        newCustomer.rehydrateFromEventHistory(originalEvents);

        // Assert: State perfectly reconstructed
        expect(newCustomer.email, equals('reconstruct@example.com'));
        expect(newCustomer.customerName, equals('Test User'));
        expect(newCustomer.status, equals('Active'));
        expect(newCustomer.version, equals(2));
      });

      test('should handle saga state persistence and recovery', () async {
        // Arrange: Start saga
        final startCommand = StartCustomerRegistrationCommand(
          email: 'saga@example.com',
          customerName: 'Saga User',
        );

        await appService.executeOnAggregate(
          customer,
          () => customer.startRegistration(
            startCommand.email,
            startCommand.customerName,
          ),
        );

        // Get the actual saga that was created by event handling
        final activeSagas = CustomerRegistrationSaga.getAllInstances();
        final activeSaga = activeSagas.firstWhere(
          (s) => s.state.email == 'saga@example.com',
          orElse: () => activeSagas.isNotEmpty
              ? activeSagas.first
              : CustomerRegistrationSaga(),
        );

        // Act: Serialize and restore saga state
        final sagaStateJson = activeSaga.state.toJson();
        final newSaga = CustomerRegistrationSaga();
        newSaga.state.fromJson(sagaStateJson);

        // Assert: Saga state preserved
        expect(newSaga.state.email, equals('saga@example.com'));
        expect(newSaga.state.customerName, equals('Saga User'));
        expect(newSaga.state.customerId, equals(customer.oid.toString()));
        expect(newSaga.state.completedSteps, contains('StartRegistration'));
      });

      test('should support snapshot optimization', () async {
        // Arrange: Execute multiple commands to build up events
        await appService.executeOnAggregate(
          customer,
          () => customer.startRegistration(
            'snapshot@example.com',
            'Snapshot User',
          ),
        );

        // Act: Create snapshot after first event
        final snapshot = customer.createSnapshot();

        // Get the actual saga that was created by event handling
        final activeSagas = CustomerRegistrationSaga.getAllInstances();
        final activeSaga = activeSagas.firstWhere(
          (s) => s.state.email == 'snapshot@example.com',
          orElse: () => activeSagas.isNotEmpty
              ? activeSagas.first
              : CustomerRegistrationSaga(),
        );

        // Continue with more events
        final emailVerifiedEvent = EmailVerified(
          email: 'snapshot@example.com',
          sagaId: activeSaga.sagaId,
        );
        await eventBus.publish(emailVerifiedEvent);

        final eventsAfterSnapshot = customer.eventHistory.skip(1).toList();

        // Create new aggregate and restore from snapshot + events
        final newCustomer = CustomerAggregate();
        newCustomer.oid = customer.oid;
        newCustomer.rehydrateFromSnapshot(snapshot, eventsAfterSnapshot);

        // Assert: Snapshot + events = complete state
        expect(newCustomer.email, equals('snapshot@example.com'));
        expect(newCustomer.status, equals('Active'));
        expect(newCustomer.version, equals(customer.version));
      });

      test('should enforce concurrency control', () async {
        // Arrange: Start registration
        await appService.executeOnAggregate(
          customer,
          () => customer.startRegistration(
            'concurrency@example.com',
            'Concurrency User',
          ),
        );

        // Act & Assert: Version mismatch should throw
        expect(
          () => customer.validateVersion(0),
          throwsA(isA<ConcurrencyException>()),
        );
        expect(
          () => customer.validateVersion(2),
          throwsA(isA<ConcurrencyException>()),
        );
        expect(() => customer.validateVersion(1), returnsNormally);
      });
    });

    group('Error Handling and Resilience', () {
      test('should handle command validation failures gracefully', () async {
        // Act: Try to start registration with invalid data
        final result = await appService.executeOnAggregate(
          customer,
          () => customer.startRegistration('', ''), // Invalid empty values
        );

        // Assert: Graceful failure
        expect(result.isFailure, isTrue);
        expect(result.errorMessage, contains('Email and name are required'));
        expect(customer.status, equals('Draft')); // State unchanged
        expect(customer.version, equals(0)); // Version not incremented
      });

      test('should handle business rule violations', () async {
        // Arrange: Start registration first
        await appService.executeOnAggregate(
          customer,
          () => customer.startRegistration(
            'business@example.com',
            'Business User',
          ),
        );

        // Act: Try to start registration again
        final result = await appService.executeOnAggregate(
          customer,
          () =>
              customer.startRegistration('another@example.com', 'Another User'),
        );

        // Assert: Business rule violation
        expect(result.isFailure, isTrue);
        expect(result.errorMessage, contains('Customer already registered'));
        expect(
          customer.email,
          equals('business@example.com'),
        ); // Original email preserved
      });
    });

    group('Performance and Monitoring', () {
      test('should provide workflow execution metrics', () async {
        // Act: Execute workflow with metrics
        final startCommand = StartCustomerRegistrationCommand(
          email: 'metrics@example.com',
          customerName: 'Metrics User',
        );

        final result = await appService.executeCommandWithMetrics(startCommand);

        // Assert: Metrics captured
        expect(result.isSuccess, isTrue);
        expect(result.data!['metrics'], isNotNull);
        expect(result.data!['metrics']['executionTimeMs'], isA<int>());
        expect(
          result.data!['metrics']['commandType'],
          contains('StartCustomerRegistrationCommand'),
        );
      });

      test('should track saga execution progress', () async {
        // Act: Execute saga steps
        final startCommand = StartCustomerRegistrationCommand(
          email: 'progress@example.com',
          customerName: 'Progress User',
        );

        await appService.executeOnAggregate(
          customer,
          () => customer.startRegistration(
            startCommand.email,
            startCommand.customerName,
          ),
        );

        // Get the actual saga that was created by event handling
        final activeSagas = CustomerRegistrationSaga.getAllInstances();
        final activeSaga = activeSagas.firstWhere(
          (s) => s.state.email == 'progress@example.com',
          orElse: () => activeSagas.isNotEmpty
              ? activeSagas.first
              : CustomerRegistrationSaga(),
        );

        // Assert: Progress tracking
        expect(activeSaga.state.completedSteps, contains('StartRegistration'));
        expect(activeSaga.state.completedSteps.length, greaterThan(0));
        expect(
          activeSaga.state.stepStartTimes.containsKey('StartRegistration'),
          isTrue,
        );
        expect(activeSaga.isCompleted, isFalse);
      });
    });
  });
}
