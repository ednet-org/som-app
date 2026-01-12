part of ednet_core;

/// Core DDD ontology for semantic test data generation
///
/// Provides foundational domain-driven design patterns, entity types,
/// value objects, domain events, and commands organized by ontological principles.
class DomainOntology {
  /// Core entity archetypes across all domains
  static const entityArchetypes = <String, EntityArchetype>{
    'Person': EntityArchetype(
      name: 'Person',
      category: 'Actor',
      attributes: ['id', 'firstName', 'lastName', 'email', 'dateOfBirth'],
      invariants: ['email must be unique', 'age must be >= 0'],
      relationships: ['has Address', 'has ContactInfo'],
    ),
    'Organization': EntityArchetype(
      name: 'Organization',
      category: 'Actor',
      attributes: ['id', 'name', 'taxId', 'establishedDate'],
      invariants: ['taxId must be unique', 'name is required'],
      relationships: ['has Address', 'employs Person'],
    ),
    'Product': EntityArchetype(
      name: 'Product',
      category: 'Thing',
      attributes: ['id', 'name', 'description', 'price', 'sku'],
      invariants: ['sku must be unique', 'price must be >= 0'],
      relationships: ['belongs to Category', 'has Inventory'],
    ),
    'Order': EntityArchetype(
      name: 'Order',
      category: 'Transaction',
      attributes: ['id', 'orderNumber', 'orderDate', 'totalAmount', 'status'],
      invariants: ['orderNumber must be unique', 'totalAmount >= 0'],
      relationships: ['placed by Customer', 'contains OrderItems'],
    ),
    'Payment': EntityArchetype(
      name: 'Payment',
      category: 'Transaction',
      attributes: ['id', 'amount', 'paymentDate', 'method', 'status'],
      invariants: ['amount > 0', 'paymentDate <= today'],
      relationships: ['for Order', 'by Customer'],
    ),
    'Document': EntityArchetype(
      name: 'Document',
      category: 'Information',
      attributes: ['id', 'title', 'content', 'createdDate', 'type'],
      invariants: ['title is required', 'type must be valid'],
      relationships: ['authored by Person', 'belongs to Category'],
    ),
    'Address': EntityArchetype(
      name: 'Address',
      category: 'ValueObject',
      attributes: ['street', 'city', 'state', 'postalCode', 'country'],
      invariants: ['postalCode format valid', 'country code valid'],
      relationships: [],
    ),
    'Appointment': EntityArchetype(
      name: 'Appointment',
      category: 'Event',
      attributes: ['id', 'scheduledDate', 'duration', 'status', 'type'],
      invariants: ['scheduledDate >= today', 'duration > 0'],
      relationships: ['scheduled by Person', 'involves Service'],
    ),
  };

  /// Domain event patterns
  static const eventPatterns = <String, EventPattern>{
    'Created': EventPattern(
      name: 'Created',
      category: 'Lifecycle',
      semantics: 'Entity has been created',
      typicalData: ['entityId', 'timestamp', 'createdBy'],
      consequences: ['Notify interested parties', 'Update read models'],
    ),
    'Updated': EventPattern(
      name: 'Updated',
      category: 'Lifecycle',
      semantics: 'Entity state has changed',
      typicalData: ['entityId', 'timestamp', 'updatedBy', 'changes'],
      consequences: ['Notify subscribers', 'Sync read models'],
    ),
    'Deleted': EventPattern(
      name: 'Deleted',
      category: 'Lifecycle',
      semantics: 'Entity has been removed',
      typicalData: ['entityId', 'timestamp', 'deletedBy', 'reason'],
      consequences: ['Archive data', 'Update indexes'],
    ),
    'Approved': EventPattern(
      name: 'Approved',
      category: 'Workflow',
      semantics: 'Request or entity has been approved',
      typicalData: ['entityId', 'timestamp', 'approvedBy', 'decision'],
      consequences: ['Proceed to next stage', 'Notify stakeholders'],
    ),
    'Rejected': EventPattern(
      name: 'Rejected',
      category: 'Workflow',
      semantics: 'Request or entity has been rejected',
      typicalData: ['entityId', 'timestamp', 'rejectedBy', 'reason'],
      consequences: ['Halt workflow', 'Notify requester'],
    ),
    'Submitted': EventPattern(
      name: 'Submitted',
      category: 'Workflow',
      semantics: 'Request or form has been submitted',
      typicalData: ['entityId', 'timestamp', 'submittedBy'],
      consequences: ['Trigger validation', 'Initiate review'],
    ),
    'Completed': EventPattern(
      name: 'Completed',
      category: 'Workflow',
      semantics: 'Process or task has finished',
      typicalData: ['entityId', 'timestamp', 'completedBy', 'outcome'],
      consequences: ['Close task', 'Update metrics'],
    ),
    'Cancelled': EventPattern(
      name: 'Cancelled',
      category: 'Workflow',
      semantics: 'Process or transaction has been cancelled',
      typicalData: ['entityId', 'timestamp', 'cancelledBy', 'reason'],
      consequences: ['Rollback changes', 'Refund if applicable'],
    ),
    'Expired': EventPattern(
      name: 'Expired',
      category: 'Time-based',
      semantics: 'Entity or offer has exceeded validity period',
      typicalData: ['entityId', 'timestamp', 'expiryDate'],
      consequences: ['Archive entity', 'Notify owner'],
    ),
    'Scheduled': EventPattern(
      name: 'Scheduled',
      category: 'Time-based',
      semantics: 'Event or task has been scheduled',
      typicalData: ['entityId', 'timestamp', 'scheduledDate', 'scheduledBy'],
      consequences: ['Add to calendar', 'Set reminders'],
    ),
  };

  /// Command patterns
  static const commandPatterns = <String, CommandPattern>{
    'Create': CommandPattern(
      name: 'Create',
      category: 'CRUD',
      semantics: 'Create new entity instance',
      requiredData: ['entityData'],
      validations: ['Required fields present', 'Unique constraints'],
      resultingEvents: ['Created'],
    ),
    'Update': CommandPattern(
      name: 'Update',
      category: 'CRUD',
      semantics: 'Modify existing entity',
      requiredData: ['entityId', 'changes'],
      validations: ['Entity exists', 'Valid changes'],
      resultingEvents: ['Updated'],
    ),
    'Delete': CommandPattern(
      name: 'Delete',
      category: 'CRUD',
      semantics: 'Remove entity',
      requiredData: ['entityId'],
      validations: ['Entity exists', 'Can be deleted'],
      resultingEvents: ['Deleted'],
    ),
    'Submit': CommandPattern(
      name: 'Submit',
      category: 'Workflow',
      semantics: 'Submit for approval or processing',
      requiredData: ['entityId', 'submitterId'],
      validations: ['Complete data', 'Valid state'],
      resultingEvents: ['Submitted'],
    ),
    'Approve': CommandPattern(
      name: 'Approve',
      category: 'Decision',
      semantics: 'Approve request or entity',
      requiredData: ['entityId', 'approverId', 'decision'],
      validations: ['Has authority', 'Valid for approval'],
      resultingEvents: ['Approved'],
    ),
    'Reject': CommandPattern(
      name: 'Reject',
      category: 'Decision',
      semantics: 'Reject request or entity',
      requiredData: ['entityId', 'rejectorId', 'reason'],
      validations: ['Has authority', 'Reason provided'],
      resultingEvents: ['Rejected'],
    ),
    'Schedule': CommandPattern(
      name: 'Schedule',
      category: 'Planning',
      semantics: 'Schedule event or task',
      requiredData: ['entityId', 'scheduledDate'],
      validations: ['Date in future', 'No conflicts'],
      resultingEvents: ['Scheduled'],
    ),
    'Cancel': CommandPattern(
      name: 'Cancel',
      category: 'Workflow',
      semantics: 'Cancel process or transaction',
      requiredData: ['entityId', 'reason'],
      validations: ['Cancellable state', 'Reason provided'],
      resultingEvents: ['Cancelled'],
    ),
    'Complete': CommandPattern(
      name: 'Complete',
      category: 'Workflow',
      semantics: 'Mark as completed',
      requiredData: ['entityId', 'outcome'],
      validations: ['All steps done', 'Valid completion'],
      resultingEvents: ['Completed'],
    ),
  };

  /// Policy patterns
  static const policyPatterns = <String, PolicyPattern>{
    'UniqueConstraint': PolicyPattern(
      name: 'UniqueConstraint',
      category: 'DataIntegrity',
      description: 'Ensures attribute uniqueness across entity collection',
      applicableTo: ['All entities with unique attributes'],
      rules: ['Check value not exists before create/update'],
    ),
    'RequiredFields': PolicyPattern(
      name: 'RequiredFields',
      category: 'DataIntegrity',
      description: 'Enforces mandatory field presence',
      applicableTo: ['All entities'],
      rules: ['Required fields must have non-null values'],
    ),
    'BusinessHoursOnly': PolicyPattern(
      name: 'BusinessHoursOnly',
      category: 'Temporal',
      description: 'Operations only during business hours',
      applicableTo: ['Time-sensitive operations'],
      rules: ['Check current time within business hours'],
    ),
    'AuthorizationRequired': PolicyPattern(
      name: 'AuthorizationRequired',
      category: 'Security',
      description: 'User must have specific permissions',
      applicableTo: ['Protected operations'],
      rules: ['Verify user has required role/permission'],
    ),
    'AgeRestriction': PolicyPattern(
      name: 'AgeRestriction',
      category: 'Compliance',
      description: 'Enforce age-based restrictions',
      applicableTo: ['Person entities, age-restricted services'],
      rules: ['Calculate age from birthdate', 'Check against minimum age'],
    ),
    'CreditLimit': PolicyPattern(
      name: 'CreditLimit',
      category: 'Financial',
      description: 'Enforce spending or credit limits',
      applicableTo: ['Financial transactions'],
      rules: ['Sum existing transactions', 'Verify under limit'],
    ),
    'SequentialProcessing': PolicyPattern(
      name: 'SequentialProcessing',
      category: 'Workflow',
      description: 'Steps must follow specific order',
      applicableTo: ['Multi-step workflows'],
      rules: ['Check previous step completed', 'Verify state allows next step'],
    ),
  };

  /// Value object patterns
  static const valueObjectPatterns = <String, ValueObjectPattern>{
    'Email': ValueObjectPattern(
      name: 'Email',
      type: 'String',
      format: 'user@domain.tld',
      validationRules: ['RFC 5322 format', 'Valid domain'],
      examples: ['john.doe@example.com', 'admin@company.org'],
    ),
    'PhoneNumber': ValueObjectPattern(
      name: 'PhoneNumber',
      type: 'String',
      format: '+[country][number]',
      validationRules: ['E.164 format', 'Valid country code'],
      examples: ['+1234567890', '+441234567890'],
    ),
    'PostalCode': ValueObjectPattern(
      name: 'PostalCode',
      type: 'String',
      format: 'Country-specific',
      validationRules: ['Country format compliance'],
      examples: ['12345', 'SW1A 1AA', '75001'],
    ),
    'Money': ValueObjectPattern(
      name: 'Money',
      type: 'Composite',
      format: '{amount, currency}',
      validationRules: ['Amount >= 0', 'Valid ISO currency code'],
      examples: ['{100.50, USD}', '{250.00, EUR}'],
    ),
    'DateRange': ValueObjectPattern(
      name: 'DateRange',
      type: 'Composite',
      format: '{startDate, endDate}',
      validationRules: ['endDate >= startDate', 'Valid dates'],
      examples: ['{2024-01-01, 2024-12-31}'],
    ),
    'SKU': ValueObjectPattern(
      name: 'SKU',
      type: 'String',
      format: 'Product identifier',
      validationRules: ['Alphanumeric', 'Unique within catalog'],
      examples: ['PROD-001', 'SKU-ABC-123'],
    ),
  };
}

/// Entity archetype definition
class EntityArchetype {
  final String name;
  final String category;
  final List<String> attributes;
  final List<String> invariants;
  final List<String> relationships;

  const EntityArchetype({
    required this.name,
    required this.category,
    required this.attributes,
    required this.invariants,
    required this.relationships,
  });
}

/// Event pattern definition
class EventPattern {
  final String name;
  final String category;
  final String semantics;
  final List<String> typicalData;
  final List<String> consequences;

  const EventPattern({
    required this.name,
    required this.category,
    required this.semantics,
    required this.typicalData,
    required this.consequences,
  });
}

/// Command pattern definition
class CommandPattern {
  final String name;
  final String category;
  final String semantics;
  final List<String> requiredData;
  final List<String> validations;
  final List<String> resultingEvents;

  const CommandPattern({
    required this.name,
    required this.category,
    required this.semantics,
    required this.requiredData,
    required this.validations,
    required this.resultingEvents,
  });
}

/// Policy pattern definition
class PolicyPattern {
  final String name;
  final String category;
  final String description;
  final List<String> applicableTo;
  final List<String> rules;

  const PolicyPattern({
    required this.name,
    required this.category,
    required this.description,
    required this.applicableTo,
    required this.rules,
  });
}

/// Value object pattern definition
class ValueObjectPattern {
  final String name;
  final String type;
  final String format;
  final List<String> validationRules;
  final List<String> examples;

  const ValueObjectPattern({
    required this.name,
    required this.type,
    required this.format,
    required this.validationRules,
    required this.examples,
  });
}
