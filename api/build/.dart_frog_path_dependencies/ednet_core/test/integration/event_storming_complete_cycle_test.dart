import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';
import 'dart:convert';
import '../helpers/execution_tracer.dart';
import '../test_helpers.dart';

/// Comprehensive Event Storming Integration Tests
/// Demonstrates complete command-event-policy cycles with pivotal events,
/// saga orchestration, role-based policies, and meta-modeling synergy

// ============================================================================
// DOMAIN EVENTS (Event Storming Orange Stickies)
// ============================================================================

/// Pivotal Event: Customer Journey Started (Saga Trigger)
class CustomerJourneyStarted implements IDomainEvent {
  @override
  final String id = Oid().toString();
  @override
  final String name = 'CustomerJourneyStarted';
  @override
  final DateTime timestamp = DateTime.now();
  @override
  String aggregateId;
  @override
  String aggregateType = 'CustomerJourney';
  @override
  int aggregateVersion = 1;
  @override
  Entity? entity;

  final String customerId;
  final String customerType; // 'individual', 'business'
  final String region;
  String? sagaId;

  CustomerJourneyStarted({
    required this.customerId,
    required this.customerType,
    required this.region,
    this.sagaId,
  }) : aggregateId = Oid().toString();

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'customerId': customerId,
    'customerType': customerType,
    'region': region,
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
      Event(name, 'Customer journey initiated', [], entity, toJson());
}

class ComplianceCheckRequired implements IDomainEvent {
  @override
  final String id = Oid().toString();
  @override
  final String name = 'ComplianceCheckRequired';
  @override
  final DateTime timestamp = DateTime.now();
  @override
  String aggregateId;
  @override
  String aggregateType = 'Compliance';
  @override
  int aggregateVersion = 1;
  @override
  Entity? entity;

  final String customerId;
  final String requiredChecks;
  final String priority;
  String? sagaId;

  ComplianceCheckRequired({
    required this.customerId,
    required this.requiredChecks,
    required this.priority,
    this.sagaId,
  }) : aggregateId = Oid().toString();

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'customerId': customerId,
    'requiredChecks': requiredChecks,
    'priority': priority,
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
      Event(name, 'Compliance check required', [], entity, toJson());
}

class ComplianceCheckCompleted implements IDomainEvent {
  @override
  final String id = Oid().toString();
  @override
  final String name = 'ComplianceCheckCompleted';
  @override
  final DateTime timestamp = DateTime.now();
  @override
  String aggregateId;
  @override
  String aggregateType = 'Compliance';
  @override
  int aggregateVersion = 1;
  @override
  Entity? entity;

  final String customerId;
  final String checkType;
  final String result;
  final String priority;
  String? sagaId;

  ComplianceCheckCompleted({
    required this.customerId,
    required this.checkType,
    required this.result,
    required this.priority,
    this.sagaId,
  }) : aggregateId = Oid().toString();

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'customerId': customerId,
    'checkType': checkType,
    'result': result,
    'priority': priority,
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
  Event toBaseEvent() => Event(
    name,
    'Compliance check completed successfully',
    [],
    entity,
    toJson(),
  );
}

class DocumentsSubmitted implements IDomainEvent {
  @override
  final String id = Oid().toString();
  @override
  final String name = 'DocumentsSubmitted';
  @override
  final DateTime timestamp = DateTime.now();
  @override
  String aggregateId;
  @override
  String aggregateType = 'Document';
  @override
  int aggregateVersion = 1;
  @override
  Entity? entity;

  final String customerId;
  final List<String> documentTypes;
  final String submissionChannel;
  String? sagaId;

  DocumentsSubmitted({
    required this.customerId,
    required this.documentTypes,
    required this.submissionChannel,
    this.sagaId,
  }) : aggregateId = Oid().toString();

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'customerId': customerId,
    'documentTypes': documentTypes,
    'submissionChannel': submissionChannel,
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
      Event(name, 'Documents submitted', [], entity, toJson());
}

/// Pivotal Event: Account Activated (Saga End)
class AccountActivated implements IDomainEvent {
  @override
  final String id = Oid().toString();
  @override
  final String name = 'AccountActivated';
  @override
  final DateTime timestamp = DateTime.now();
  @override
  String aggregateId;
  @override
  String aggregateType = 'Account';
  @override
  int aggregateVersion = 1;
  @override
  Entity? entity;

  final String customerId;
  final String accountId;
  final String accountType;
  String? sagaId;

  AccountActivated({
    required this.customerId,
    required this.accountId,
    required this.accountType,
    this.sagaId,
  }) : aggregateId = accountId;

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'customerId': customerId,
    'accountId': accountId,
    'accountType': accountType,
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
      Event(name, 'Account successfully activated', [], entity, toJson());
}

// ============================================================================
// COMMANDS (Event Storming Blue Stickies)
// ============================================================================

class InitiateComplianceCheckCommand implements ICommandBusCommand {
  @override
  final String id = Oid().toString();
  final String customerId;
  final String checkType;
  final String triggeredBy;

  InitiateComplianceCheckCommand({
    required this.customerId,
    required this.checkType,
    required this.triggeredBy,
  });

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'customerId': customerId,
    'checkType': checkType,
    'triggeredBy': triggeredBy,
  };
}

class CompleteComplianceCheckCommand implements ICommandBusCommand {
  @override
  final String id = Oid().toString();
  final String customerId;
  final String checkType;
  final String result;

  CompleteComplianceCheckCommand({
    required this.customerId,
    required this.checkType,
    required this.result,
  });

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'customerId': customerId,
    'checkType': checkType,
    'result': result,
  };
}

class ProcessDocumentSubmissionCommand implements ICommandBusCommand {
  @override
  final String id = Oid().toString();
  final String customerId;
  final List<String> documentTypes;
  final String channel;

  ProcessDocumentSubmissionCommand({
    required this.customerId,
    required this.documentTypes,
    required this.channel,
  });

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'customerId': customerId,
    'documentTypes': documentTypes,
    'channel': channel,
  };
}

class ActivateAccountCommand implements ICommandBusCommand {
  @override
  final String id = Oid().toString();
  final String customerId;
  final String accountType;

  ActivateAccountCommand({required this.customerId, required this.accountType});

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'customerId': customerId,
    'accountType': accountType,
  };
}

class NotifyCustomerCommand implements ICommandBusCommand {
  @override
  final String id = Oid().toString();
  final String customerId;
  final String messageType;
  final Map<String, dynamic> data;

  NotifyCustomerCommand({
    required this.customerId,
    required this.messageType,
    required this.data,
  });

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'customerId': customerId,
    'messageType': messageType,
    'data': data,
  };
}

// ============================================================================
// POLICIES (Event Storming Purple Stickies)
// ============================================================================

/// Business Customer Compliance Policy (Purple Sticky: Policy)
class BusinessCustomerCompliancePolicy implements IEventTriggeredPolicy {
  final List<String> executionLog = [];
  final List<ICommandBusCommand> generatedCommands = [];

  @override
  String get name => 'BusinessCustomerCompliancePolicy';

  PolicyScope? get scope => PolicyScope.entity;

  @override
  bool evaluate(dynamic entity) => true;

  PolicyEvaluationResult evaluateWithDetails(Entity entity) {
    return PolicyEvaluationResult(true, []);
  }

  @override
  bool shouldTriggerOnEvent(dynamic event) {
    return event is ComplianceCheckRequired;
  }

  @override
  void executeActions(dynamic entity, dynamic event) {
    // Execute compliance verification actions
    executionLog.add('BusinessCustomerCompliancePolicy executed');
    print('📋 Executing business customer compliance verification');
  }

  @override
  List<ICommandBusCommand> generateCommands(dynamic entity, dynamic event) {
    if (event is ComplianceCheckRequired) {
      // When compliance is required, complete it immediately with 'passed' result
      // (In real systems, this would involve actual verification steps)
      final command = CompleteComplianceCheckCommand(
        customerId: event.customerId,
        checkType: event.requiredChecks,
        result: 'passed', // Simplified for testing
      );
      generatedCommands.add(command);
      return [command];
    }
    return <ICommandBusCommand>[];
  }
}

/// Document Verification Policy (Purple Sticky: Policy)
/// Fixed to avoid infinite loop by not triggering commands that would generate the same event
class DocumentVerificationPolicy implements IEventTriggeredPolicy {
  final List<String> executionLog = [];
  final List<ICommandBusCommand> generatedCommands = [];

  @override
  String get name => 'DocumentVerificationPolicy';

  PolicyScope? get scope => PolicyScope.entity;

  @override
  bool evaluate(dynamic entity) => true;

  PolicyEvaluationResult evaluateWithDetails(Entity entity) {
    return PolicyEvaluationResult(true, []);
  }

  @override
  bool shouldTriggerOnEvent(dynamic event) {
    return event is DocumentsSubmitted;
  }

  @override
  void executeActions(dynamic entity, dynamic event) {
    // Execute document verification actions (logging only, no commands)
    executionLog.add('DocumentVerificationPolicy executed');
    print(
      '📄 Executing document verification (verification only, no reprocessing)',
    );
  }

  @override
  List<ICommandBusCommand> generateCommands(dynamic entity, dynamic event) {
    // INFINITE LOOP FIX: Don't generate ProcessDocumentSubmissionCommand which would
    // cause processDocuments() to be called again, creating another DocumentsSubmitted event.
    // Document verification should verify documents, not reprocess them.

    // Instead, if needed, we could generate a different command like:
    // - VerifyDocumentCommand (which doesn't create new DocumentsSubmitted events)
    // - NotifyDocumentVerificationCommand
    // - etc.

    return <ICommandBusCommand>[]; // No commands to avoid infinite loop
  }
}

/// Welcome Customer Policy (Purple Sticky: Policy)
class WelcomeCustomerPolicy implements IEventTriggeredPolicy {
  final List<String> executionLog = [];
  final List<ICommandBusCommand> generatedCommands = [];

  @override
  String get name => 'WelcomeCustomerPolicy';

  PolicyScope? get scope => PolicyScope.entity;

  @override
  bool evaluate(dynamic entity) => true;

  PolicyEvaluationResult evaluateWithDetails(Entity entity) {
    return PolicyEvaluationResult(true, []);
  }

  @override
  bool shouldTriggerOnEvent(dynamic event) {
    return event is AccountActivated;
  }

  @override
  void executeActions(dynamic entity, dynamic event) {
    // Execute welcome actions
    executionLog.add('WelcomeCustomerPolicy executed');
    print('🎉 Executing welcome customer actions');
  }

  @override
  List<ICommandBusCommand> generateCommands(dynamic entity, dynamic event) {
    if (event is AccountActivated) {
      final command = NotifyCustomerCommand(
        customerId: event.customerId,
        messageType: 'welcome',
        data: {'accountId': event.accountId},
      );
      generatedCommands.add(command);
      return [command];
    }
    return <ICommandBusCommand>[];
  }
}

// ============================================================================
// TEST APPLICATION SERVICE
// ============================================================================

/// Test application service that properly publishes domain events
class TestApplicationService {
  final EventBus _eventBus;

  TestApplicationService(
    EnhancedApplicationService baseService,
    this._eventBus,
  );

  /// Execute operation on aggregate and publish domain events
  Future<CommandResult> executeOnAggregate(
    CustomerOnboardingAggregate aggregate,
    CommandResult Function() operation,
  ) async {
    // Clear any pending domain events
    aggregate.domainEventsToPublish.clear();

    // Execute the operation
    final result = operation();

    // Make a copy of events to avoid concurrent modification
    final eventsToPublish = List<IDomainEvent>.from(
      aggregate.domainEventsToPublish,
    );

    // Clear the events before publishing to avoid conflicts
    aggregate.domainEventsToPublish.clear();

    // Publish the domain events
    for (final domainEvent in eventsToPublish) {
      await _eventBus.publish(domainEvent);
    }

    return result;
  }
}

// ============================================================================
// AGGREGATE ROOTS (Event Storming Yellow Stickies)
// ============================================================================

/// Customer Onboarding Aggregate
class CustomerOnboardingAggregate
    extends EnhancedAggregateRoot<CustomerOnboardingAggregate> {
  String? customerId;
  String? customerType;
  String? region;
  String status = 'NotStarted';
  List<String> completedSteps = [];
  Map<String, dynamic> metadata = {};

  CustomerOnboardingAggregate() {
    concept = CustomerOnboardingConcept();
  }

  /// Domain events that should be published by the application service
  final List<IDomainEvent> domainEventsToPublish = [];

  /// Command: Start Customer Journey
  CommandResult startJourney(
    String customerId,
    String customerType,
    String region,
  ) {
    if (status != 'NotStarted') {
      return CommandResult.failure('Customer journey already started');
    }

    this.customerId = customerId;
    this.customerType = customerType;
    this.region = region;

    recordEventLegacy(
      'CustomerJourneyStarted',
      'Customer onboarding journey initiated',
      ['ComplianceHandler', 'OnboardingSagaHandler'],
      data: {
        'customerId': customerId,
        'customerType': customerType,
        'region': region,
        'startedAt': DateTime.now().toIso8601String(),
      },
    );

    // Add domain event for publishing by application service (to trigger saga and policies)
    final domainEvent = CustomerJourneyStarted(
      customerId: customerId,
      customerType: customerType,
      region: region,
    );
    domainEventsToPublish.add(domainEvent);

    return CommandResult.success(
      data: {'journeyId': oid.toString(), 'customerId': customerId},
    );
  }

  /// Command: Initiate Compliance Check
  CommandResult initiateComplianceCheck(String checkType, String triggeredBy) {
    if (status != 'InProgress') {
      return CommandResult.failure('Journey must be in progress');
    }

    recordEventLegacy(
      'ComplianceCheckRequired',
      'Compliance check required',
      ['CompliancePolicy'],
      data: {
        'customerId': customerId,
        'requiredChecks': checkType,
        'priority': 'high',
        'triggeredBy': triggeredBy,
        'requiredAt': DateTime.now().toIso8601String(),
      },
    );

    // Add domain event for publishing by application service (to trigger policies)
    if (customerId != null) {
      final domainEvent = ComplianceCheckRequired(
        customerId: customerId!,
        requiredChecks: checkType,
        priority: 'high',
      );
      domainEventsToPublish.add(domainEvent);
    }

    return CommandResult.success();
  }

  /// Command: Complete Compliance Check
  CommandResult completeComplianceCheck(String checkType, String result) {
    if (status != 'InProgress') {
      return CommandResult.failure('Journey must be in progress');
    }

    completedSteps.add('compliance_$checkType');
    metadata['compliance_result'] = result;

    recordEventLegacy(
      'ComplianceCheckCompleted',
      'Compliance check completed',
      ['DocumentHandler'],
      data: {
        'customerId': customerId,
        'checkType': checkType,
        'result': result,
        'priority': result == 'passed' ? 'normal' : 'high',
        'completedAt': DateTime.now().toIso8601String(),
      },
    );

    // Add domain event for publishing by application service (to trigger saga and policies)
    if (customerId != null) {
      final domainEvent = ComplianceCheckCompleted(
        customerId: customerId!,
        checkType: checkType,
        result: result,
        priority: result == 'passed' ? 'normal' : 'high',
      );
      domainEventsToPublish.add(domainEvent);
    }

    return CommandResult.success();
  }

  /// Command: Process Documents
  CommandResult processDocuments(List<String> documentTypes, String channel) {
    completedSteps.add('documents_submitted');
    metadata['submission_channel'] = channel;

    // Record internal event for audit
    recordEventLegacy(
      'DocumentsSubmitted',
      'Customer documents submitted',
      ['VerificationHandler'],
      data: {
        'customerId': customerId,
        'documentTypes': documentTypes,
        'submissionChannel': channel,
        'submittedAt': DateTime.now().toIso8601String(),
      },
    );

    // Add domain event for publishing by application service
    if (customerId != null) {
      final domainEvent = DocumentsSubmitted(
        customerId: customerId!,
        documentTypes: documentTypes,
        submissionChannel: channel,
      );
      domainEventsToPublish.add(domainEvent);
    }

    return CommandResult.success();
  }

  /// Command: Activate Account
  CommandResult activateAccount(String accountType) {
    if (!completedSteps.contains('documents_submitted')) {
      return CommandResult.failure('Documents must be submitted first');
    }

    final accountId = Oid().toString();

    recordEventLegacy(
      'AccountActivated',
      'Customer account successfully activated',
      ['NotificationHandler', 'WelcomeHandler'],
      data: {
        'customerId': customerId,
        'accountId': accountId,
        'accountType': accountType,
        'activatedAt': DateTime.now().toIso8601String(),
      },
    );

    // Add domain event for publishing by application service (to trigger saga and policies)
    if (customerId != null) {
      final domainEvent = AccountActivated(
        customerId: customerId!,
        accountId: accountId,
        accountType: accountType,
      );
      domainEventsToPublish.add(domainEvent);
    }

    return CommandResult.success(data: {'accountId': accountId});
  }

  @override
  void applyEvent(dynamic event) {
    switch (event.name) {
      case 'CustomerJourneyStarted':
        status = 'InProgress';
        // Extract customer data from the event for proper state reconstruction
        if (event is CustomerJourneyStarted) {
          customerId = event.customerId;
          customerType = event.customerType;
          region = event.region;
        } else if (event.data != null) {
          // Handle internal Event objects with data map
          customerId = event.data['customerId'];
          customerType = event.data['customerType'];
          region = event.data['region'];
        }
        break;
      case 'AccountActivated':
        status = 'Completed';
        completedSteps.add('account_activated');
        break;
      case 'ComplianceCheckCompleted':
        // Handle compliance completion for state reconstruction
        if (!completedSteps.contains('compliance_business_verification')) {
          completedSteps.add('compliance_business_verification');
        }
        break;
      case 'DocumentsSubmitted':
        // Handle document submission for state reconstruction
        if (!completedSteps.contains('documents_submitted')) {
          completedSteps.add('documents_submitted');
        }
        break;
    }
  }

  @override
  String toJson() {
    return jsonEncode({
      'customerId': customerId,
      'customerType': customerType,
      'region': region,
      'status': status,
      'completedSteps': completedSteps,
      'metadata': metadata,
    });
  }

  @override
  void fromJson<K extends Entity<K>>(String entityJson) {
    final json = jsonDecode(entityJson) as Map<String, dynamic>;
    customerId = json['customerId'] ?? '';
    customerType = json['customerType'] ?? '';
    region = json['region'] ?? '';
    status = json['status'] ?? 'NotStarted';
    completedSteps = List<String>.from(json['completedSteps'] ?? []);
    metadata = Map<String, dynamic>.from(json['metadata'] ?? {});
  }
}

/// Customer Onboarding Concept
class CustomerOnboardingConcept extends Concept {
  CustomerOnboardingConcept()
    : super(Model(Domain('Test'), 'TestModel'), 'CustomerOnboarding') {
    // Set up the concept for customer onboarding
    description =
        'Manages the complete customer onboarding journey with event sourcing';
  }
}

// ============================================================================
// SAGA (Event Storming Process Flow)
// ============================================================================

/// Customer Onboarding Saga - Orchestrates the complete journey
class CustomerOnboardingSaga extends ProcessManager<OnboardingState> {
  final List<String> executionLog = [];

  CustomerOnboardingSaga() : super('CustomerOnboardingSaga');

  @override
  OnboardingState createInitialState() => OnboardingState();

  @override
  void configureWorkflow() {
    step('InitiateJourney')
        .whenEvent<CustomerJourneyStarted>()
        .then(handleJourneyStarted)
        .asStartingStep();

    step(
      'ProcessCompliance',
    ).whenEvent<ComplianceCheckRequired>().then(handleComplianceRequired);

    step(
      'ProcessDocuments',
    ).whenEvent<DocumentsSubmitted>().then(handleDocumentsSubmitted);

    step(
      'CompleteOnboarding',
    ).whenEvent<AccountActivated>().then(handleAccountActivated);
  }

  Future<void> handleJourneyStarted(CustomerJourneyStarted event) async {
    print(
      '🎯 SAGA METHOD: handleJourneyStarted called with customerId=${event.customerId}',
    );
    executionLog.add('handleJourneyStarted');
    state.customerId = event.customerId;
    state.customerType = event.customerType;
    state.region = event.region;
    state.journeySteps.add('journey_initiated');

    // For business customers, automatically initiate compliance check
    if (event.customerType == 'business') {
      final complianceCommand = InitiateComplianceCheckCommand(
        customerId: event.customerId,
        checkType: 'business_verification',
        triggeredBy: 'OnboardingSaga',
      );
      await sendCommand(complianceCommand);
      print(
        '🎯 SAGA METHOD: Sent compliance check command for business customer',
      );
    }

    print(
      '🎯 SAGA METHOD: handleJourneyStarted completed, executionLog=${executionLog}',
    );
  }

  Future<void> handleComplianceRequired(ComplianceCheckRequired event) async {
    executionLog.add('handleComplianceRequired');
    state.journeySteps.add('compliance_initiated');

    // Saga can trigger additional commands if needed
    // For example, schedule follow-up tasks
  }

  Future<void> handleDocumentsSubmitted(DocumentsSubmitted event) async {
    executionLog.add('handleDocumentsSubmitted');
    state.journeySteps.add('documents_processed');
    state.documentsSubmitted = event.documentTypes;

    // After documents are processed, activate account
    final command = ActivateAccountCommand(
      customerId: event.customerId,
      accountType: state.customerType == 'business' ? 'business' : 'personal',
    );
    await sendCommand(command);
  }

  Future<void> handleAccountActivated(AccountActivated event) async {
    executionLog.add('handleAccountActivated');
    state.journeySteps.add('account_activated');
    state.accountId = event.accountId;
    state.isCompleted = true;
  }

  @override
  Future<bool> correlateEvent(dynamic event) async {
    // Debug logging for correlation
    print(
      '🔍 SAGA CORRELATION: event=${event.runtimeType}, sagaId=${sagaId}, state.isNew=${state.isNew}, state.customerId=${state.customerId}',
    );

    if (event.sagaId != null) {
      final result = event.sagaId == sagaId;
      print('🔍 SAGA CORRELATION: sagaId match = $result');
      return result;
    }

    // For starting events
    if (event is CustomerJourneyStarted && state.isNew) {
      print(
        '🔍 SAGA CORRELATION: CustomerJourneyStarted and state.isNew = true',
      );
      return true;
    }

    // Correlate by customer ID
    if (state.customerId != null) {
      if (event is ComplianceCheckRequired) {
        final result = event.customerId == state.customerId;
        print(
          '🔍 SAGA CORRELATION: ComplianceCheckRequired customerId match = $result',
        );
        return result;
      }
      if (event is DocumentsSubmitted) {
        final result = event.customerId == state.customerId;
        print(
          '🔍 SAGA CORRELATION: DocumentsSubmitted customerId match = $result',
        );
        return result;
      }
      if (event is AccountActivated) {
        final result = event.customerId == state.customerId;
        print(
          '🔍 SAGA CORRELATION: AccountActivated customerId match = $result',
        );
        return result;
      }
    }

    print('🔍 SAGA CORRELATION: no match found, returning false');
    return false;
  }
}

class OnboardingState extends SagaState {
  String? customerId;
  String? customerType;
  String? region;
  String? accountId;
  List<String> journeySteps = [];
  List<String> documentsSubmitted = [];

  OnboardingState({String? sagaId, DateTime? startedAt})
    : super(sagaId: sagaId, startedAt: startedAt);

  @override
  Map<String, dynamic> toJson() => {
    'sagaId': sagaId,
    'customerId': customerId,
    'customerType': customerType,
    'region': region,
    'accountId': accountId,
    'journeySteps': journeySteps,
    'documentsSubmitted': documentsSubmitted,
    'startedAt': startedAt.toIso8601String(),
    'lastUpdated': lastUpdated.toIso8601String(),
    'currentStep': currentStep,
    'isCompleted': isCompleted,
    'hasFailed': hasFailed,
    'completedSteps': completedSteps.toList(),
  };

  @override
  void fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    customerType = json['customerType'];
    region = json['region'];
    accountId = json['accountId'];
    journeySteps = List<String>.from(json['journeySteps'] ?? []);
    documentsSubmitted = List<String>.from(json['documentsSubmitted'] ?? []);
    currentStep = json['currentStep'];
    isCompleted = json['isCompleted'] ?? false;
    hasFailed = json['hasFailed'] ?? false;

    if (json['completedSteps'] != null) {
      completedSteps.addAll(List<String>.from(json['completedSteps']));
    }
  }
}

// ============================================================================
// COMMAND HANDLERS (Event Storming Implementation)
// ============================================================================

class InitiateComplianceCheckHandler
    implements ICommandHandler<InitiateComplianceCheckCommand> {
  final List<InitiateComplianceCheckCommand> handledCommands = [];
  final CustomerOnboardingAggregate aggregate;
  final TestApplicationService appService;

  InitiateComplianceCheckHandler(this.aggregate, this.appService);

  @override
  Future<CommandResult> handle(InitiateComplianceCheckCommand command) async {
    handledCommands.add(command);
    return await appService.executeOnAggregate(
      aggregate,
      () => aggregate.initiateComplianceCheck(
        command.checkType,
        command.triggeredBy,
      ),
    );
  }

  @override
  bool canHandle(dynamic command) => command is InitiateComplianceCheckCommand;
}

class CompleteComplianceCheckHandler
    implements ICommandHandler<CompleteComplianceCheckCommand> {
  final List<CompleteComplianceCheckCommand> handledCommands = [];
  final CustomerOnboardingAggregate aggregate;
  final TestApplicationService appService;

  CompleteComplianceCheckHandler(this.aggregate, this.appService);

  @override
  Future<CommandResult> handle(CompleteComplianceCheckCommand command) async {
    handledCommands.add(command);
    return await appService.executeOnAggregate(
      aggregate,
      () =>
          aggregate.completeComplianceCheck(command.checkType, command.result),
    );
  }

  @override
  bool canHandle(dynamic command) => command is CompleteComplianceCheckCommand;
}

class ProcessDocumentSubmissionHandler
    implements ICommandHandler<ProcessDocumentSubmissionCommand> {
  final List<ProcessDocumentSubmissionCommand> handledCommands = [];
  final CustomerOnboardingAggregate aggregate;
  final TestApplicationService appService;

  ProcessDocumentSubmissionHandler(this.aggregate, this.appService);

  @override
  Future<CommandResult> handle(ProcessDocumentSubmissionCommand command) async {
    handledCommands.add(command);
    return await appService.executeOnAggregate(
      aggregate,
      () => aggregate.processDocuments(command.documentTypes, command.channel),
    );
  }

  @override
  bool canHandle(dynamic command) =>
      command is ProcessDocumentSubmissionCommand;
}

class ActivateAccountHandler
    implements ICommandHandler<ActivateAccountCommand> {
  final List<ActivateAccountCommand> handledCommands = [];
  final CustomerOnboardingAggregate aggregate;
  final TestApplicationService appService;

  ActivateAccountHandler(this.aggregate, this.appService);

  @override
  Future<CommandResult> handle(ActivateAccountCommand command) async {
    handledCommands.add(command);
    return await appService.executeOnAggregate(
      aggregate,
      () => aggregate.activateAccount(command.accountType),
    );
  }

  @override
  bool canHandle(dynamic command) => command is ActivateAccountCommand;
}

class NotifyCustomerHandler implements ICommandHandler<NotifyCustomerCommand> {
  final List<NotifyCustomerCommand> handledCommands = [];

  @override
  Future<CommandResult> handle(NotifyCustomerCommand command) async {
    handledCommands.add(command);
    // Simulate notification sending
    return CommandResult.success(
      data: {'notificationSent': true, 'messageType': command.messageType},
    );
  }

  @override
  bool canHandle(dynamic command) => command is NotifyCustomerCommand;
}

void main() {
  group('Event Storming Complete Cycle Integration Tests', () {
    late CommandBus commandBus;
    late EventBus eventBus;
    late EnhancedApplicationService baseAppService;
    late TestApplicationService appService;
    late CustomerOnboardingAggregate onboardingAggregate;
    late CustomerOnboardingSaga onboardingSaga;

    late BusinessCustomerCompliancePolicy compliancePolicy;
    late DocumentVerificationPolicy documentPolicy;
    late WelcomeCustomerPolicy welcomePolicy;

    late InitiateComplianceCheckHandler complianceHandler;
    late CompleteComplianceCheckHandler completeComplianceHandler;
    late ProcessDocumentSubmissionHandler documentHandler;
    late ActivateAccountHandler activateHandler;
    late NotifyCustomerHandler notifyHandler;

    setUp(() {
      // Clear execution tracer for clean test runs
      ExecutionTracer.instance.clear();

      // Note: Test observability events are cleared by TestObservabilityConfig

      // Configure silent observability for test performance
      TestObservabilityConfig.setupForTests(
        config: TestObservabilityConfig.silent(),
      );

      // Initialize infrastructure
      commandBus = CommandBus();
      eventBus = EventBus();
      baseAppService = EnhancedApplicationService(
        session: DomainSession(DomainModels(Domain('TestDomain'))),
        commandBus: commandBus,
        eventBus: eventBus,
      );
      appService = TestApplicationService(baseAppService, eventBus);

      // Initialize domain objects
      onboardingAggregate = CustomerOnboardingAggregate();
      onboardingSaga = CustomerOnboardingSaga();

      // Initialize policies
      compliancePolicy = BusinessCustomerCompliancePolicy();
      documentPolicy = DocumentVerificationPolicy();
      welcomePolicy = WelcomeCustomerPolicy();

      // Initialize handlers
      complianceHandler = InitiateComplianceCheckHandler(
        onboardingAggregate,
        appService,
      );
      completeComplianceHandler = CompleteComplianceCheckHandler(
        onboardingAggregate,
        appService,
      );
      documentHandler = ProcessDocumentSubmissionHandler(
        onboardingAggregate,
        appService,
      );
      activateHandler = ActivateAccountHandler(onboardingAggregate, appService);
      notifyHandler = NotifyCustomerHandler();

      // Set up infrastructure connections
      onboardingSaga.setCommandBus(commandBus);
      onboardingSaga.setEventBus(eventBus);
      eventBus.setCommandBus(commandBus);

      // Register command handlers
      commandBus.registerHandler<InitiateComplianceCheckCommand>(
        complianceHandler,
      );
      commandBus.registerHandler<CompleteComplianceCheckCommand>(
        completeComplianceHandler,
      );
      commandBus.registerHandler<ProcessDocumentSubmissionCommand>(
        documentHandler,
      );
      commandBus.registerHandler<ActivateAccountCommand>(activateHandler);
      commandBus.registerHandler<NotifyCustomerCommand>(notifyHandler);

      // Register saga with event bus
      eventBus.registerSaga(() => onboardingSaga);

      // Register policies
      eventBus.registerPolicy(compliancePolicy);
      eventBus.registerPolicy(documentPolicy);
      eventBus.registerPolicy(welcomePolicy);
    });

    group('Complete Event Storming Workflow', () {
      test(
        'should execute complete business customer onboarding with policy-driven automation',
        () async {
          final tracer = ExecutionTracer.instance;
          const customerId = 'CUST-BUSINESS-001';

          print('🚀 Starting enhanced test with full traceability...');

          try {
            // 1. User Action: Start customer journey (Blue Sticky -> Yellow Sticky)
            print('\n📋 Step 1: Starting customer journey...');
            final journeyResult = await appService.executeOnAggregate(
              onboardingAggregate,
              () => onboardingAggregate.startJourney(
                customerId,
                'business',
                'EU',
              ),
            );

            // Assert: Journey started successfully
            expect(journeyResult.isSuccess, isTrue);
            expect(onboardingAggregate.status, equals('InProgress'));
            expect(onboardingAggregate.customerType, equals('business'));

            print('✅ Journey started successfully');

            // Assert: Saga initiated
            expect(
              onboardingSaga.executionLog,
              contains('handleJourneyStarted'),
            );
            expect(onboardingSaga.state.customerId, equals(customerId));
            print('✅ Saga initiated');

            // Assert: Policy triggered automatically (Purple Sticky)
            expect(
              compliancePolicy.executionLog,
              contains('BusinessCustomerCompliancePolicy executed'),
            );
            expect(compliancePolicy.generatedCommands.length, equals(1));
            expect(complianceHandler.handledCommands.length, equals(1));
            print('✅ Compliance policy triggered and command handled');

            // 2. System generates compliance check events (Orange Sticky)
            expect(
              onboardingAggregate.pendingEvents.length,
              equals(3),
            ); // Journey + Required + Completed
            final complianceRequiredEvent =
                onboardingAggregate.pendingEvents[1];
            expect(
              complianceRequiredEvent.name,
              equals('ComplianceCheckRequired'),
            );
            final complianceCompletedEvent =
                onboardingAggregate.pendingEvents[2];
            expect(
              complianceCompletedEvent.name,
              equals('ComplianceCheckCompleted'),
            );
            print('✅ Compliance events generated (required and completed)');

            // 3. User Action: Submit documents (Blue Sticky)
            print('\n📋 Step 2: Submitting documents...');
            final documentsResult = await appService.executeOnAggregate(
              onboardingAggregate,
              () => onboardingAggregate.processDocuments([
                'passport',
                'business_license',
              ], 'web'),
            );

            expect(documentsResult.isSuccess, isTrue);
            expect(
              onboardingAggregate.completedSteps,
              contains('documents_submitted'),
            );
            print('✅ Documents submitted successfully');

            // Assert: Document policy triggered (Purple Sticky)
            expect(
              documentPolicy.executionLog,
              contains('DocumentVerificationPolicy executed'),
            );
            print('✅ Document policy executed');

            // Document verification policy executes but doesn't generate commands (infinite loop fix)
            print('\n🔍 Analyzing document verification behavior...');
            print(
              'Document policy executed: ${documentPolicy.executionLog.contains('DocumentVerificationPolicy executed')}',
            );
            print(
              'Document policy generated commands: ${documentPolicy.generatedCommands.length}',
            );

            // FIXED: DocumentVerificationPolicy now intentionally generates 0 commands to avoid infinite loop
            // The policy verifies documents but doesn't trigger reprocessing
            expect(
              documentPolicy.generatedCommands.length,
              equals(0),
              reason:
                  'DocumentVerificationPolicy should not generate commands to avoid infinite loop',
            );
            expect(
              documentHandler.handledCommands.length,
              equals(0),
              reason:
                  'No ProcessDocumentSubmissionCommand should be generated to avoid infinite loop',
            );

            // Assert: Saga progressed
            expect(
              onboardingSaga.executionLog,
              contains('handleDocumentsSubmitted'),
            );
            expect(
              onboardingSaga.state.documentsSubmitted,
              contains('passport'),
            );
            print('✅ Saga progressed');

            // 4. Saga automatically triggers account activation (Blue Sticky)
            expect(activateHandler.handledCommands.length, equals(1));
            expect(onboardingAggregate.status, equals('Completed'));
            print('✅ Account activated');

            // Assert: Welcome policy triggered (Purple Sticky)
            expect(
              welcomePolicy.executionLog,
              contains('WelcomeCustomerPolicy executed'),
            );
            expect(notifyHandler.handledCommands.length, equals(1));
            expect(
              notifyHandler.handledCommands.first.messageType,
              equals('welcome'),
            );
            print('✅ Welcome policy triggered');

            // 5. Assert: Complete saga workflow
            expect(onboardingSaga.state.isCompleted, isTrue);
            expect(
              onboardingSaga.state.journeySteps,
              contains('journey_initiated'),
            );
            expect(
              onboardingSaga.state.journeySteps,
              contains('documents_processed'),
            );
            expect(
              onboardingSaga.state.journeySteps,
              contains('account_activated'),
            );
            print('✅ Complete saga workflow verified');

            print('\n🎉 Test completed successfully!');
          } catch (e, stackTrace) {
            print('\n❌ Test failed with error: $e');
            print('Stack trace: $stackTrace');

            print('\n🔍 Analyzing execution traces for debugging...');
            tracer.printExecutionSummary();
            tracer.analyzePolicyFlow();
            tracer.analyzeCommandFlow();
            tracer.printDetailedTraces();

            rethrow; // Re-throw to fail the test
          }
        },
      );

      test('should demonstrate command-event-policy cycle synergy', () async {
        const customerId = 'CUST-INDIVIDUAL-002';

        // Start with individual customer (no automatic compliance check)
        await appService.executeOnAggregate(
          onboardingAggregate,
          () =>
              onboardingAggregate.startJourney(customerId, 'individual', 'US'),
        );

        // Assert: No compliance policy triggered for individual
        expect(compliancePolicy.generatedCommands.length, equals(0));
        expect(complianceHandler.handledCommands.length, equals(0));

        // Manually submit documents
        await appService.executeOnAggregate(
          onboardingAggregate,
          () => onboardingAggregate.processDocuments([
            'drivers_license',
          ], 'mobile'),
        );

        // Assert: Document policy still triggered but doesn't generate commands (infinite loop fix)
        expect(
          documentPolicy.executionLog,
          contains('DocumentVerificationPolicy executed'),
        );
        expect(documentHandler.handledCommands.length, equals(0));

        // Assert: Account activation and welcome flow
        expect(activateHandler.handledCommands.length, equals(1));
        expect(
          welcomePolicy.executionLog,
          contains('WelcomeCustomerPolicy executed'),
        );
        expect(notifyHandler.handledCommands.length, equals(1));
      });

      test('should maintain complete audit trail with event sourcing', () async {
        const customerId = 'CUST-AUDIT-003';

        // Execute complete workflow
        await appService.executeOnAggregate(
          onboardingAggregate,
          () =>
              onboardingAggregate.startJourney(customerId, 'business', 'APAC'),
        );

        await appService.executeOnAggregate(
          onboardingAggregate,
          () => onboardingAggregate.processDocuments([
            'passport',
            'incorporation_cert',
          ], 'api'),
        );

        // Assert: Complete event history (5 events: Journey + ComplianceRequired + ComplianceCompleted + Documents + Account)
        expect(onboardingAggregate.pendingEvents.length, equals(5));

        final eventNames = onboardingAggregate.pendingEvents
            .map((e) => e.name)
            .toList();
        expect(eventNames, contains('CustomerJourneyStarted'));
        expect(eventNames, contains('ComplianceCheckRequired'));
        expect(eventNames, contains('ComplianceCheckCompleted'));
        expect(eventNames, contains('DocumentsSubmitted'));
        expect(eventNames, contains('AccountActivated'));

        // Assert: Event data integrity
        final journeyEvent =
            onboardingAggregate.pendingEvents.first as EnhancedDomainEventImpl;
        expect(journeyEvent.data['customerId'], equals(customerId));
        expect(journeyEvent.data['customerType'], equals('business'));
        expect(journeyEvent.data['region'], equals('APAC'));

        // Assert: State reconstruction capability
        final newAggregate = CustomerOnboardingAggregate();
        // Note: Entity.oid is read-only, so we test reconstruction without setting it
        newAggregate.rehydrateFromEventHistory(
          onboardingAggregate.pendingEvents,
        );

        expect(newAggregate.customerId, equals(customerId));
        expect(newAggregate.status, equals('Completed'));
        expect(newAggregate.completedSteps, contains('documents_submitted'));
      });

      test('should demonstrate pivotal events driving saga lifecycle', () async {
        const customerId = 'CUST-PIVOTAL-004';

        // Pivotal Event 1: Journey Started (Saga Trigger)
        await appService.executeOnAggregate(
          onboardingAggregate,
          () => onboardingAggregate.startJourney(customerId, 'business', 'EU'),
        );

        // Assert: Saga created and started (now in ProcessCompliance step due to business customer compliance)
        expect(onboardingSaga.state.isNew, isFalse);
        expect(onboardingSaga.currentStep, equals('ProcessCompliance'));

        // Process through workflow
        await appService.executeOnAggregate(
          onboardingAggregate,
          () => onboardingAggregate.processDocuments([
            'passport',
            'vat_cert',
          ], 'portal'),
        );

        // Pivotal Event 2: Account Activated (Saga End)
        final accountEvent = onboardingAggregate.pendingEvents.last;
        expect(accountEvent.name, equals('AccountActivated'));

        // Assert: Saga completed
        expect(onboardingSaga.state.isCompleted, isTrue);
        expect(onboardingSaga.executionLog, contains('handleAccountActivated'));
      });

      test('should support complex policy chains and command generation', () async {
        const customerId = 'CUST-COMPLEX-005';

        // Use individual customer to avoid automatic compliance flow completion
        await appService.executeOnAggregate(
          onboardingAggregate,
          () => onboardingAggregate.startJourney(
            customerId,
            'individual',
            'LATAM',
          ),
        );

        // Count total commands generated through policy chain (should be 0 for individual)
        final totalComplianceCommands =
            compliancePolicy.generatedCommands.length;
        final totalDocumentCommands = documentPolicy.generatedCommands.length;
        final totalWelcomeCommands = welcomePolicy.generatedCommands.length;

        // Submit documents to trigger document policy and complete the flow
        await appService.executeOnAggregate(
          onboardingAggregate,
          () => onboardingAggregate.processDocuments([
            'certificate',
            'registration',
          ], 'email'),
        );

        // Assert: Policy chain execution (individual customer doesn't trigger compliance)
        expect(
          compliancePolicy.generatedCommands.length,
          equals(totalComplianceCommands),
        ); // No compliance for individual
        expect(
          documentPolicy.generatedCommands.length,
          equals(totalDocumentCommands),
        ); // No new commands (infinite loop fix)
        expect(
          welcomePolicy.generatedCommands.length,
          equals(totalWelcomeCommands + 1),
        ); // Welcome triggered by account activation

        // Assert: Commands executed in correct order
        expect(
          complianceHandler.handledCommands.length,
          equals(0),
        ); // No compliance for individual
        expect(
          completeComplianceHandler.handledCommands.length,
          equals(0),
        ); // No compliance for individual
        expect(
          documentHandler.handledCommands.length,
          equals(0),
        ); // Fixed: no commands to avoid infinite loop
        expect(
          activateHandler.handledCommands.length,
          equals(1),
        ); // Account activation
        expect(
          notifyHandler.handledCommands.length,
          equals(1),
        ); // Welcome notification
      });
    });
  });
}
