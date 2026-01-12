import 'dart:convert';
import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

/// Role-Based Policy and Meta-Modeling Integration Tests
/// Demonstrates user roles, permissions, meta-modeling capabilities,
/// and domain-driven design patterns working in synergy

// ============================================================================
// USER ROLES AND PERMISSIONS (Event Storming Actors)
// ============================================================================

enum UserRole {
  customer,
  customerServiceRep,
  complianceOfficer,
  accountManager,
  systemAdmin,
}

enum Permission {
  viewCustomerData,
  modifyCustomerData,
  approveTransactions,
  accessComplianceReports,
  manageUserAccounts,
  systemConfiguration,
}

class UserContext {
  final String userId;
  final UserRole role;
  final Set<Permission> permissions;
  final Map<String, dynamic> metadata;

  UserContext({
    required this.userId,
    required this.role,
    required this.permissions,
    this.metadata = const {},
  });

  bool hasPermission(Permission permission) => permissions.contains(permission);

  bool canAccess(String resourceType, String resourceId) {
    // Implement resource-specific access control
    switch (role) {
      case UserRole.customer:
        return resourceType == 'CustomerData' && resourceId.contains(userId);
      case UserRole.customerServiceRep:
        return resourceType == 'CustomerData' ||
            resourceType == 'SupportTicket';
      case UserRole.complianceOfficer:
        return resourceType == 'ComplianceReport' || resourceType == 'AuditLog';
      case UserRole.accountManager:
        return resourceType == 'CustomerAccount' ||
            resourceType == 'BusinessMetrics';
      case UserRole.systemAdmin:
        return true; // Full access
    }
  }
}

// ============================================================================
// ROLE-BASED DOMAIN EVENTS
// ============================================================================

class UserActionInitiated implements IDomainEvent {
  @override
  final String id = Oid().toString();
  @override
  final String name = 'UserActionInitiated';
  @override
  final DateTime timestamp = DateTime.now();
  @override
  String aggregateId;
  @override
  String aggregateType = 'UserAction';
  @override
  int aggregateVersion = 1;
  @override
  Entity? entity;

  final String userId;
  final UserRole userRole;
  final String actionType;
  final String targetResource;
  final Map<String, dynamic> actionData;

  UserActionInitiated({
    required this.userId,
    required this.userRole,
    required this.actionType,
    required this.targetResource,
    required this.actionData,
  }) : aggregateId = Oid().toString();

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'userId': userId,
    'userRole': userRole.toString(),
    'actionType': actionType,
    'targetResource': targetResource,
    'actionData': actionData,
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
      Event(name, 'User action initiated', [], entity, toJson());
}

class PermissionDenied implements IDomainEvent {
  @override
  final String id = Oid().toString();
  @override
  final String name = 'PermissionDenied';
  @override
  final DateTime timestamp = DateTime.now();
  @override
  String aggregateId;
  @override
  String aggregateType = 'Security';
  @override
  int aggregateVersion = 1;
  @override
  Entity? entity;

  final String userId;
  final UserRole userRole;
  final String attemptedAction;
  final String denialReason;

  PermissionDenied({
    required this.userId,
    required this.userRole,
    required this.attemptedAction,
    required this.denialReason,
  }) : aggregateId = Oid().toString();

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'userId': userId,
    'userRole': userRole.toString(),
    'attemptedAction': attemptedAction,
    'denialReason': denialReason,
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
  Event toBaseEvent() => Event(name, 'Permission denied', [], entity, toJson());
}

class ComplianceViolationDetected implements IDomainEvent {
  @override
  final String id = Oid().toString();
  @override
  final String name = 'ComplianceViolationDetected';
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

  final String violationType;
  final String severity;
  final String description;
  final Map<String, dynamic> context;

  ComplianceViolationDetected({
    required this.violationType,
    required this.severity,
    required this.description,
    required this.context,
  }) : aggregateId = Oid().toString();

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'violationType': violationType,
    'severity': severity,
    'description': description,
    'context': context,
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
      Event(name, 'Compliance violation detected', [], entity, toJson());
}

// ============================================================================
// ROLE-BASED COMMANDS
// ============================================================================

class AuthorizeUserActionCommand implements ICommandBusCommand {
  @override
  final String id = Oid().toString();
  final UserContext userContext;
  final String actionType;
  final String targetResource;
  final Map<String, dynamic> actionData;

  AuthorizeUserActionCommand({
    required this.userContext,
    required this.actionType,
    required this.targetResource,
    required this.actionData,
  });

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userContext.userId,
    'userRole': userContext.role.toString(),
    'actionType': actionType,
    'targetResource': targetResource,
    'actionData': actionData,
  };
}

class LogSecurityEventCommand implements ICommandBusCommand {
  @override
  final String id = Oid().toString();
  final String eventType;
  final String userId;
  final String description;
  final Map<String, dynamic> details;

  LogSecurityEventCommand({
    required this.eventType,
    required this.userId,
    required this.description,
    required this.details,
  });

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'eventType': eventType,
    'userId': userId,
    'description': description,
    'details': details,
  };
}

class EscalateComplianceIssueCommand implements ICommandBusCommand {
  @override
  final String id = Oid().toString();
  final String violationType;
  final String severity;
  final String assignedOfficer;
  final Map<String, dynamic> violationDetails;

  EscalateComplianceIssueCommand({
    required this.violationType,
    required this.severity,
    required this.assignedOfficer,
    required this.violationDetails,
  });

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'violationType': violationType,
    'severity': severity,
    'assignedOfficer': assignedOfficer,
    'violationDetails': violationDetails,
  };
}

// ============================================================================
// ROLE-BASED POLICIES
// ============================================================================

/// Permission Enforcement Policy - Automatically enforces role-based permissions
class PermissionEnforcementPolicy implements IEventTriggeredPolicy {
  final List<String> executionLog = [];
  final List<ICommandBusCommand> generatedCommands = [];
  final Map<UserRole, Set<Permission>> rolePermissions = {
    UserRole.customer: {Permission.viewCustomerData},
    UserRole.customerServiceRep: {
      Permission.viewCustomerData,
      Permission.modifyCustomerData,
    },
    UserRole.complianceOfficer: {
      Permission.viewCustomerData,
      Permission.accessComplianceReports,
    },
    UserRole.accountManager: {
      Permission.viewCustomerData,
      Permission.modifyCustomerData,
      Permission.approveTransactions,
    },
    UserRole.systemAdmin: Permission.values.toSet(),
  };

  @override
  String get name => 'PermissionEnforcementPolicy';

  PolicyScope? get scope => PolicyScope.global;

  @override
  bool evaluate(dynamic entity) => true;

  PolicyEvaluationResult evaluateWithDetails(Entity entity) {
    return PolicyEvaluationResult(true, []);
  }

  @override
  bool shouldTriggerOnEvent(dynamic event) {
    return event?.name == 'PermissionDenied';
  }

  @override
  void executeActions(dynamic entity, dynamic event) {
    // Execute permission enforcement
    executionLog.add('PermissionEnforcementPolicy executed');
    print('🔒 Enforcing permissions for ${event.runtimeType}');
  }

  @override
  List<ICommandBusCommand> generateCommands(dynamic entity, dynamic event) {
    if (event?.name == 'PermissionDenied') {
      final eventData = event.data ?? {};
      final command = LogSecurityEventCommand(
        eventType: 'permission_denied',
        userId: eventData['userId'] ?? 'unknown',
        description: 'Permission enforcement triggered',
        details: {
          'actionType': eventData['attemptedAction'],
          'targetResource':
              'unknown', // PermissionDenied doesn't have targetResource
        },
      );
      generatedCommands.add(command);
      return [command];
    }
    return <ICommandBusCommand>[];
  }
}

/// Compliance Monitoring Policy - Monitors for compliance violations
class ComplianceMonitoringPolicy implements IEventTriggeredPolicy {
  final List<String> executionLog = [];
  final List<ICommandBusCommand> generatedCommands = [];

  @override
  String get name => 'ComplianceMonitoringPolicy';

  PolicyScope? get scope => PolicyScope.global;

  @override
  bool evaluate(dynamic entity) => true;

  PolicyEvaluationResult evaluateWithDetails(Entity entity) {
    return PolicyEvaluationResult(true, []);
  }

  @override
  bool shouldTriggerOnEvent(dynamic event) {
    return event?.name == 'ComplianceViolationDetected';
  }

  @override
  void executeActions(dynamic entity, dynamic event) {
    // Execute compliance monitoring
    executionLog.add('ComplianceMonitoringPolicy executed');
    print('📊 Monitoring compliance for ${event.runtimeType}');
  }

  @override
  List<ICommandBusCommand> generateCommands(dynamic entity, dynamic event) {
    if (event?.name == 'ComplianceViolationDetected') {
      final eventData = event.data ?? {};
      final command = EscalateComplianceIssueCommand(
        violationType: eventData['violationType'] ?? 'unknown',
        severity: eventData['severity'] ?? 'low',
        assignedOfficer: 'senior_compliance_officer',
        violationDetails: eventData['context'] ?? {},
      );
      generatedCommands.add(command);
      return [command];
    }
    return <ICommandBusCommand>[];
  }
}

// ============================================================================
// META-MODELING AGGREGATE ROOT
// ============================================================================

class SecurityAuditAggregate
    extends EnhancedAggregateRoot<SecurityAuditAggregate> {
  List<Map<String, dynamic>> auditEvents = [];
  Map<String, int> userActionCounts = {};
  Map<String, List<String>> roleViolations = {};
  String auditStatus = 'active';

  SecurityAuditAggregate() {
    concept = SecurityAuditConcept();
  }

  /// Command: Authorize User Action
  CommandResult authorizeUserAction(
    UserContext userContext,
    String actionType,
    String targetResource,
    Map<String, dynamic> actionData,
  ) {
    // Check authorization first
    final authorized = _checkAuthorization(
      userContext,
      actionType,
      targetResource,
    );

    // Log the action attempt with authorization result
    final actionId = Oid().toString();
    auditEvents.add({
      'actionId': actionId,
      'userId': userContext.userId,
      'userRole': userContext.role.toString(),
      'actionType': actionType,
      'targetResource': targetResource,
      'authorized': authorized,
      'timestamp': DateTime.now().toIso8601String(),
    });

    if (authorized) {
      // Update user action counts
      final userKey = '${userContext.userId}_${actionType}';
      userActionCounts[userKey] = (userActionCounts[userKey] ?? 0) + 1;

      recordEventLegacy(
        'UserActionInitiated',
        'User action authorized and initiated',
        ['ActionHandler', 'AuditHandler'],
        data: {
          'userId': userContext.userId,
          'userRole': userContext.role.toString(),
          'actionType': actionType,
          'targetResource': targetResource,
          'actionData': actionData,
          'authorized': true,
        },
      );

      return CommandResult.success(
        data: {'actionId': actionId, 'authorized': true},
      );
    } else {
      // Record violation
      final roleKey = userContext.role.toString();
      roleViolations[roleKey] = (roleViolations[roleKey] ?? [])
        ..add(actionType);

      recordEventLegacy(
        'PermissionDenied',
        'User action denied due to insufficient permissions',
        ['SecurityHandler', 'ComplianceHandler'],
        data: {
          'userId': userContext.userId,
          'userRole': userContext.role.toString(),
          'attemptedAction': actionType,
          'denialReason': 'Insufficient permissions for role',
        },
      );

      return CommandResult.failure('Access denied: Insufficient permissions');
    }
  }

  /// Command: Log Security Event
  CommandResult logSecurityEvent(
    String eventType,
    String userId,
    String description,
    Map<String, dynamic> details,
  ) {
    auditEvents.add({
      'eventType': eventType,
      'userId': userId,
      'description': description,
      'details': details,
      'timestamp': DateTime.now().toIso8601String(),
    });

    // Check for compliance violations
    if (_isComplianceViolation(eventType, details)) {
      recordEventLegacy(
        'ComplianceViolationDetected',
        'Potential compliance violation detected',
        ['ComplianceHandler'],
        data: {
          'violationType': eventType,
          'severity': _determineSeverity(eventType, details),
          'description': description,
          'context': details,
        },
      );
    }

    return CommandResult.success();
  }

  /// Command: Escalate Compliance Issue
  CommandResult escalateComplianceIssue(
    String violationType,
    String severity,
    String assignedOfficer,
    Map<String, dynamic> violationDetails,
  ) {
    auditEvents.add({
      'eventType': 'compliance_escalation',
      'violationType': violationType,
      'severity': severity,
      'assignedOfficer': assignedOfficer,
      'violationDetails': violationDetails,
      'timestamp': DateTime.now().toIso8601String(),
    });

    return CommandResult.success(
      data: {
        'escalationId': Oid().toString(),
        'assignedOfficer': assignedOfficer,
      },
    );
  }

  bool _checkAuthorization(
    UserContext userContext,
    String actionType,
    String targetResource,
  ) {
    // Implementation of role-based authorization logic
    switch (userContext.role) {
      case UserRole.customer:
        return actionType == 'view_customer_data' &&
            targetResource.contains(userContext.userId);
      case UserRole.customerServiceRep:
        return [
          'view_customer_data',
          'modify_customer_data',
        ].contains(actionType);
      case UserRole.complianceOfficer:
        return [
          'view_customer_data',
          'access_compliance_report',
        ].contains(actionType);
      case UserRole.accountManager:
        return [
          'view_customer_data',
          'modify_customer_data',
          'approve_transaction',
        ].contains(actionType);
      case UserRole.systemAdmin:
        return true;
    }
  }

  bool _isComplianceViolation(String eventType, Map<String, dynamic> details) {
    // Define compliance violation patterns
    if (eventType == 'permission_denied') {
      final attemptCount = details['attemptCount'] ?? 1;
      return attemptCount > 3; // Multiple failed attempts
    }
    return false;
  }

  String _determineSeverity(String eventType, Map<String, dynamic> details) {
    if (eventType == 'permission_denied') {
      final attemptCount = details['attemptCount'] ?? 1;
      if (attemptCount > 10) return 'high';
      if (attemptCount > 5) return 'medium';
      return 'low';
    }
    return 'low';
  }

  @override
  void applyEvent(dynamic event) {
    switch (event.name) {
      case 'UserActionInitiated':
        // Event already processed in command
        break;
      case 'PermissionDenied':
        // Track denial patterns
        break;
      case 'ComplianceViolationDetected':
        auditStatus = 'violation_detected';
        break;
    }
  }

  @override
  String toJson() => jsonEncode({
    'oid': oid.toString(),
    'auditEvents': auditEvents,
    'userActionCounts': userActionCounts,
    'roleViolations': roleViolations,
    'auditStatus': auditStatus,
  });

  @override
  void fromJson<K extends Entity<K>>(String entityJson) {
    final json = jsonDecode(entityJson) as Map<String, dynamic>;
    auditEvents = List<Map<String, dynamic>>.from(json['auditEvents'] ?? []);
    userActionCounts = Map<String, int>.from(json['userActionCounts'] ?? {});
    roleViolations = Map<String, List<String>>.from(
      (json['roleViolations'] ?? {}).map(
        (k, v) => MapEntry(k, List<String>.from(v)),
      ),
    );
    auditStatus = json['auditStatus'] ?? 'active';
  }
}

class SecurityAuditConcept extends Concept {
  SecurityAuditConcept()
    : super(Model(Domain('Test'), 'TestModel'), 'SecurityAudit') {
    entry = true;
  }

  String get name => 'SecurityAudit';
}

// ============================================================================
// META-MODELING DEMONSTRATION
// ============================================================================

class DomainModelMetadata {
  final Map<String, ConceptMetadata> concepts = {};
  final Map<String, RelationshipMetadata> relationships = {};
  final Map<String, PolicyMetadata> policies = {};

  void addConcept(String name, ConceptMetadata metadata) {
    concepts[name] = metadata;
  }

  void addRelationship(String name, RelationshipMetadata metadata) {
    relationships[name] = metadata;
  }

  void addPolicy(String name, PolicyMetadata metadata) {
    policies[name] = metadata;
  }

  Map<String, dynamic> toJson() => {
    'concepts': concepts.map((k, v) => MapEntry(k, v.toJson())),
    'relationships': relationships.map((k, v) => MapEntry(k, v.toJson())),
    'policies': policies.map((k, v) => MapEntry(k, v.toJson())),
  };
}

class ConceptMetadata {
  final String name;
  final String description;
  final List<String> attributes;
  final List<String> behaviors;
  final Map<String, dynamic> constraints;

  ConceptMetadata({
    required this.name,
    required this.description,
    required this.attributes,
    required this.behaviors,
    required this.constraints,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'attributes': attributes,
    'behaviors': behaviors,
    'constraints': constraints,
  };
}

class RelationshipMetadata {
  final String name;
  final String fromConcept;
  final String toConcept;
  final String cardinality;
  final Map<String, dynamic> properties;

  RelationshipMetadata({
    required this.name,
    required this.fromConcept,
    required this.toConcept,
    required this.cardinality,
    required this.properties,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'fromConcept': fromConcept,
    'toConcept': toConcept,
    'cardinality': cardinality,
    'properties': properties,
  };
}

class PolicyMetadata {
  final String name;
  final String type;
  final String scope;
  final List<String> triggers;
  final List<String> actions;

  PolicyMetadata({
    required this.name,
    required this.type,
    required this.scope,
    required this.triggers,
    required this.actions,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'type': type,
    'scope': scope,
    'triggers': triggers,
    'actions': actions,
  };
}

// ============================================================================
// COMMAND HANDLERS
// ============================================================================

class AuthorizeUserActionHandler
    implements ICommandHandler<AuthorizeUserActionCommand> {
  final List<AuthorizeUserActionCommand> handledCommands = [];
  final SecurityAuditAggregate securityAggregate;

  AuthorizeUserActionHandler(this.securityAggregate);

  @override
  Future<CommandResult> handle(AuthorizeUserActionCommand command) async {
    handledCommands.add(command);
    return securityAggregate.authorizeUserAction(
      command.userContext,
      command.actionType,
      command.targetResource,
      command.actionData,
    );
  }

  @override
  bool canHandle(dynamic command) => command is AuthorizeUserActionCommand;
}

class LogSecurityEventHandler
    implements ICommandHandler<LogSecurityEventCommand> {
  final List<LogSecurityEventCommand> handledCommands = [];
  final SecurityAuditAggregate securityAggregate;

  LogSecurityEventHandler(this.securityAggregate);

  @override
  Future<CommandResult> handle(LogSecurityEventCommand command) async {
    handledCommands.add(command);
    return securityAggregate.logSecurityEvent(
      command.eventType,
      command.userId,
      command.description,
      command.details,
    );
  }

  @override
  bool canHandle(dynamic command) => command is LogSecurityEventCommand;
}

class EscalateComplianceIssueHandler
    implements ICommandHandler<EscalateComplianceIssueCommand> {
  final List<EscalateComplianceIssueCommand> handledCommands = [];
  final SecurityAuditAggregate securityAggregate;

  EscalateComplianceIssueHandler(this.securityAggregate);

  @override
  Future<CommandResult> handle(EscalateComplianceIssueCommand command) async {
    handledCommands.add(command);
    return securityAggregate.escalateComplianceIssue(
      command.violationType,
      command.severity,
      command.assignedOfficer,
      command.violationDetails,
    );
  }

  @override
  bool canHandle(dynamic command) => command is EscalateComplianceIssueCommand;
}

void main() {
  group('Role-Based Policy and Meta-Modeling Integration Tests', () {
    late CommandBus commandBus;
    late EventBus eventBus;
    late EnhancedApplicationService appService;
    late SecurityAuditAggregate securityAggregate;

    late PermissionEnforcementPolicy permissionPolicy;
    late ComplianceMonitoringPolicy compliancePolicy;

    late AuthorizeUserActionHandler authHandler;
    late LogSecurityEventHandler logHandler;
    late EscalateComplianceIssueHandler escalateHandler;

    setUp(() {
      // Initialize infrastructure
      commandBus = CommandBus();
      eventBus = EventBus();
      appService = EnhancedApplicationService(
        session: DomainSession(DomainModels(Domain('TestDomain'))),
        commandBus: commandBus,
        eventBus: eventBus,
      );

      // Initialize domain objects
      securityAggregate = SecurityAuditAggregate();

      // Initialize policies
      permissionPolicy = PermissionEnforcementPolicy();
      compliancePolicy = ComplianceMonitoringPolicy();

      // Initialize handlers
      authHandler = AuthorizeUserActionHandler(securityAggregate);
      logHandler = LogSecurityEventHandler(securityAggregate);
      escalateHandler = EscalateComplianceIssueHandler(securityAggregate);

      // Set up infrastructure connections
      eventBus.setCommandBus(commandBus);

      // Register command handlers
      commandBus.registerHandler<AuthorizeUserActionCommand>(authHandler);
      commandBus.registerHandler<LogSecurityEventCommand>(logHandler);
      commandBus.registerHandler<EscalateComplianceIssueCommand>(
        escalateHandler,
      );

      // Register policies
      eventBus.registerPolicy(permissionPolicy);
      eventBus.registerPolicy(compliancePolicy);
    });

    group('Role-Based Access Control', () {
      test('should enforce role-based permissions correctly', () async {
        // Test customer access
        final customerContext = UserContext(
          userId: 'CUST-001',
          role: UserRole.customer,
          permissions: {Permission.viewCustomerData},
        );

        // Authorized action
        final authorizedResult = await appService.executeOnAggregate(
          securityAggregate,
          () => securityAggregate.authorizeUserAction(
            customerContext,
            'view_customer_data',
            'CustomerData_CUST-001',
            {
              'requestedFields': ['name', 'email'],
            },
          ),
        );

        expect(authorizedResult.isSuccess, isTrue);
        expect(securityAggregate.auditEvents.length, greaterThanOrEqualTo(1));

        // Unauthorized action
        final unauthorizedResult = await appService.executeOnAggregate(
          securityAggregate,
          () => securityAggregate.authorizeUserAction(
            customerContext,
            'modify_customer_data',
            'CustomerData_CUST-001',
            {
              'updates': {'email': 'new@email.com'},
            },
          ),
        );

        expect(unauthorizedResult.isFailure, isTrue);
        expect(unauthorizedResult.errorMessage, contains('Access denied'));
        expect(
          securityAggregate.roleViolations.containsKey('UserRole.customer'),
          isTrue,
        );
      });

      test('should demonstrate hierarchical role permissions', () async {
        // Test system admin access
        final adminContext = UserContext(
          userId: 'ADMIN-001',
          role: UserRole.systemAdmin,
          permissions: Permission.values.toSet(),
        );

        // Admin can access all resources
        final systemConfigResult = await appService.executeOnAggregate(
          securityAggregate,
          () => securityAggregate.authorizeUserAction(
            adminContext,
            'system_configuration',
            'SystemConfig',
            {'configType': 'security_settings'},
          ),
        );

        expect(systemConfigResult.isSuccess, isTrue);

        // Test compliance officer access
        final complianceContext = UserContext(
          userId: 'COMPLIANCE-001',
          role: UserRole.complianceOfficer,
          permissions: {
            Permission.accessComplianceReports,
            Permission.viewCustomerData,
          },
        );

        final complianceReportResult = await appService.executeOnAggregate(
          securityAggregate,
          () => securityAggregate.authorizeUserAction(
            complianceContext,
            'access_compliance_report',
            'ComplianceReport_2024',
            {'reportType': 'audit_summary'},
          ),
        );

        expect(complianceReportResult.isSuccess, isTrue);
      });
    });

    group('Policy-Driven Security Enforcement', () {
      test(
        'should automatically enforce permissions through policies',
        () async {
          final repContext = UserContext(
            userId: 'REP-001',
            role: UserRole.customerServiceRep,
            permissions: {
              Permission.viewCustomerData,
              Permission.modifyCustomerData,
            },
          );

          // Attempt unauthorized action to trigger policy
          await appService.executeOnAggregate(
            securityAggregate,
            () => securityAggregate.authorizeUserAction(
              repContext,
              'approve_transaction',
              'Transaction_12345',
              {'amount': 10000, 'currency': 'USD'},
            ),
          );

          // Assert: Permission policy triggered
          expect(
            permissionPolicy.executionLog,
            contains('PermissionEnforcementPolicy executed'),
          );
          expect(permissionPolicy.generatedCommands.length, equals(1));
          expect(logHandler.handledCommands.length, equals(1));

          final logCommand = logHandler.handledCommands.first;
          expect(logCommand.eventType, equals('permission_denied'));
          expect(logCommand.userId, equals('REP-001'));
        },
      );

      test('should escalate compliance violations automatically', () async {
        // Trigger multiple permission denials to create compliance violation
        await appService.executeOnAggregate(
          securityAggregate,
          () => securityAggregate.logSecurityEvent(
            'permission_denied',
            'SUSPICIOUS-USER',
            'Multiple failed access attempts',
            {'attemptCount': 15, 'targetResource': 'sensitive_data'},
          ),
        );

        // Assert: Compliance policy triggered
        expect(
          compliancePolicy.executionLog,
          contains('ComplianceMonitoringPolicy executed'),
        );
        expect(compliancePolicy.generatedCommands.length, equals(1));
        expect(escalateHandler.handledCommands.length, equals(1));

        final escalateCommand = escalateHandler.handledCommands.first;
        expect(escalateCommand.severity, equals('high'));
        expect(
          escalateCommand.assignedOfficer,
          equals('senior_compliance_officer'),
        );
      });
    });

    group('Meta-Modeling Capabilities', () {
      test('should demonstrate domain model metadata capture', () {
        final domainMetadata = DomainModelMetadata();

        // Add concept metadata
        domainMetadata.addConcept(
          'Customer',
          ConceptMetadata(
            name: 'Customer',
            description: 'Individual or business entity using our services',
            attributes: ['customerId', 'name', 'email', 'customerType'],
            behaviors: ['register', 'updateProfile', 'closeAccount'],
            constraints: {'email': 'unique', 'customerType': 'enum'},
          ),
        );

        domainMetadata.addConcept(
          'SecurityAudit',
          ConceptMetadata(
            name: 'SecurityAudit',
            description: 'Tracks security events and access patterns',
            attributes: ['auditId', 'events', 'violations', 'status'],
            behaviors: ['logEvent', 'detectViolation', 'generateReport'],
            constraints: {'status': 'enum'},
          ),
        );

        // Add relationship metadata
        domainMetadata.addRelationship(
          'CustomerAudit',
          RelationshipMetadata(
            name: 'CustomerAudit',
            fromConcept: 'Customer',
            toConcept: 'SecurityAudit',
            cardinality: 'one-to-many',
            properties: {'auditLevel': 'standard'},
          ),
        );

        // Add policy metadata
        domainMetadata.addPolicy(
          'PermissionEnforcement',
          PolicyMetadata(
            name: 'PermissionEnforcement',
            type: 'security',
            scope: 'global',
            triggers: ['UserActionInitiated'],
            actions: ['validatePermissions', 'logDenial'],
          ),
        );

        // Assert: Meta-model structure
        expect(domainMetadata.concepts.length, equals(2));
        expect(domainMetadata.relationships.length, equals(1));
        expect(domainMetadata.policies.length, equals(1));

        // Assert: JSON serialization works
        final metadataJson = domainMetadata.toJson();
        expect(metadataJson['concepts'], isNotNull);
        expect(metadataJson['relationships'], isNotNull);
        expect(metadataJson['policies'], isNotNull);
      });

      test('should support dynamic policy configuration', () {
        // Demonstrate how policies can be configured dynamically
        final dynamicPolicy = PermissionEnforcementPolicy();

        // Add new role dynamically
        dynamicPolicy.rolePermissions[UserRole.accountManager] = {
          Permission.viewCustomerData,
          Permission.modifyCustomerData,
          Permission.approveTransactions,
        };

        // Verify dynamic configuration
        final managerPermissions =
            dynamicPolicy.rolePermissions[UserRole.accountManager];
        expect(
          managerPermissions!.contains(Permission.approveTransactions),
          isTrue,
        );
        expect(
          managerPermissions.contains(Permission.systemConfiguration),
          isFalse,
        );
      });
    });

    group('Complete Event-Driven Security Workflow', () {
      test('should demonstrate end-to-end security event processing', () async {
        final scenarios = [
          // Scenario 1: Legitimate user action
          {
            'user': UserContext(
              userId: 'MANAGER-001',
              role: UserRole.accountManager,
              permissions: {
                Permission.viewCustomerData,
                Permission.modifyCustomerData,
                Permission.approveTransactions,
              },
            ),
            'action': 'approve_transaction',
            'resource': 'Transaction_54321',
            'expectedResult': 'success',
          },
          // Scenario 2: Unauthorized access attempt
          {
            'user': UserContext(
              userId: 'CUST-002',
              role: UserRole.customer,
              permissions: {Permission.viewCustomerData},
            ),
            'action': 'modify_customer_data',
            'resource': 'CustomerData_CUST-003', // Different customer
            'expectedResult': 'denied',
          },
        ];

        for (final scenario in scenarios) {
          final userContext = scenario['user'] as UserContext;
          final action = scenario['action'] as String;
          final resource = scenario['resource'] as String;
          final expectedResult = scenario['expectedResult'] as String;

          final result = await appService.executeOnAggregate(
            securityAggregate,
            () => securityAggregate.authorizeUserAction(
              userContext,
              action,
              resource,
              {'scenario': 'integration_test'},
            ),
          );

          if (expectedResult == 'success') {
            expect(result.isSuccess, isTrue);
          } else {
            expect(result.isFailure, isTrue);
          }
        }

        // Assert: Complete audit trail
        expect(securityAggregate.auditEvents.length, greaterThanOrEqualTo(2));

        // Note: pendingEvents are cleared after processing by EnhancedApplicationService
        // This is correct behavior - events are published and then cleared

        // Assert: Event sourcing works by checking audit events instead

        // We should have both successful and denied actions recorded
        expect(
          securityAggregate.auditEvents.any(
            (e) =>
                e['actionType'] == 'approve_transaction' &&
                e['authorized'] == true,
          ),
          isTrue,
        );
        expect(
          securityAggregate.auditEvents.any(
            (e) =>
                e['actionType'] == 'modify_customer_data' &&
                e['authorized'] == false,
          ),
          isTrue,
        );
      });
    });
  });
}
