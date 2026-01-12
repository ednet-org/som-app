# Semantic Random Data for BDD Test Generation

## Overview

This directory contains ontologically organized, semantically coherent random data for generating purposeful BDD tests. It provides defaults when users don't provide their own seed data, ensuring generated code passes 0/0/0 quality gates.

## Architecture

### Core Components

1. **`ontology.dart`** - Foundation layer
   - Entity archetypes (Person, Organization, Product, Order, etc.)
   - Event patterns (Created, Updated, Approved, etc.)
   - Command patterns (Create, Update, Delete, etc.)
   - Policy patterns (UniqueConstraint, RequiredFields, etc.)
   - Value object patterns (Email, Money, SKU, etc.)

2. **Domain-specific data** - Business context layers
   - `e_commerce.dart` - Products, orders, customers, shopping workflows
   - `healthcare.dart` - Patients, appointments, medical records, clinical workflows
   - `finance.dart` - Accounts, transactions, payments, banking workflows
   - `education.dart` - Students, courses, enrollments, academic workflows
   - `logistics.dart` - Shipments, warehouses, inventory, supply chain workflows

3. **`semantic_data_provider.dart`** - Integration layer
   - Unified API for all domains
   - Intelligent data generation based on context
   - BDD scenario generation
   - Domain-aware naming conventions

## Usage Examples

### Domain-specific Provider

```dart
// Create e-commerce specific provider
final provider = SemanticDataProvider.ecommerce();

// Generate entity name
final entityName = provider.generateEntityName(); // e.g., "Product", "Order"

// Generate event name
final eventName = provider.generateEventName(); // e.g., "ProductCreated", "OrderShipped"

// Generate command name
final commandName = provider.generateCommandName(); // e.g., "CreateProduct", "PlaceOrder"

// Generate BDD scenario
final scenario = provider.generateBDDScenario();
print('Feature: ${scenario.feature}');
print('Scenario: ${scenario.scenario}');
```

### Generic Provider (Multi-domain)

```dart
// Create generic provider that samples from all domains
final provider = SemanticDataProvider();

// Generate with explicit domain
final healthcareEntity = provider.generateEntityName(domain: 'healthcare');
// Returns: "Patient", "MedicalAppointment", etc.

final financeEvent = provider.generateEventName(domain: 'finance');
// Returns: "AccountOpened", "TransactionCompleted", etc.
```

### Enhanced Random Data Service

```dart
// Use enhanced service with semantic capabilities
final service = SemanticRandomDataService(SemanticDataProvider.ecommerce());

// Generate domain-specific names
final entity = service.entityName(); // "Customer", "Product"
final event = service.eventName(); // "ProductCreated", "OrderPlaced"
final command = service.commandName(); // "CreateOrder", "UpdateProduct"

// Generate test values
final email = service.testValue('customerEmail', 'String');
// Returns: "sarah.johnson@example.com" (from customer personas)

final price = service.testValue('price', 'double');
// Returns: realistic price value
```

### BDD Scenario Generation

```dart
final provider = SemanticDataProvider.ecommerce();
final scenario = provider.generateBDDScenario(domain: 'ecommerce');

// Use scenario for test generation
print('Feature: ${scenario.feature}');
print('Scenario: ${scenario.scenario}');
print('\nGiven:');
scenario.given.forEach((g) => print('  - $g'));
print('\nWhen:');
scenario.when.forEach((w) => print('  - $w'));
print('\nThen:');
scenario.then.forEach((t) => print('  - $t'));
```

Output example:
```
Feature: Product Purchase
Scenario: Customer completes successful purchase

Given:
  - Customer is logged in
  - Product is in stock
  - Customer has valid payment method

When:
  - Customer adds product to cart
  - Customer proceeds to checkout
  - Customer confirms payment

Then:
  - Order is created with status Pending
  - Payment is processed
  - Order status changes to PaymentReceived
  - Customer receives order confirmation email
```

## Integration with Package Generator

The `PackageGenerator` can use semantic data for test generation:

```dart
final generator = PackageGenerator();
final semanticProvider = SemanticDataProvider.ecommerce();

// Generate package with semantic test data
final result = await generator.generatePackage(
  yamlFilePath: 'domain.yaml',
  outputPath: 'generated/',
  semanticDataProvider: semanticProvider, // Provides intelligent defaults
);

// Generated tests will use:
// - Realistic entity names from domain
// - Coherent event/command names
// - BDD scenarios matching domain workflows
// - Test values that make semantic sense
```

## Available Domains

1. **E-commerce** (`ecommerce`)
   - Products, orders, customers, payments, inventory
   - Shopping workflows, order fulfillment
   - Events: ProductCreated, OrderPlaced, PaymentProcessed

2. **Healthcare** (`healthcare`)
   - Patients, appointments, medical records, providers
   - Clinical workflows, diagnosis, treatment
   - Events: PatientRegistered, AppointmentScheduled, DiagnosisMade

3. **Finance** (`finance`)
   - Accounts, transactions, payments, loans
   - Banking workflows, fraud detection
   - Events: AccountOpened, TransactionCompleted, FraudDetected

4. **Education** (`education`)
   - Students, courses, enrollments, assessments
   - Academic workflows, grading, progress tracking
   - Events: StudentEnrolled, AssignmentGraded, CourseCompleted

5. **Logistics** (`logistics`)
   - Shipments, warehouses, inventory, carriers
   - Supply chain workflows, route optimization
   - Events: ShipmentCreated, InventoryAllocated, RouteOptimized

## Ontological Principles

### Entity Archetypes
Organized by category:
- **Actor**: Person, Organization (who acts)
- **Thing**: Product, Document (what is acted upon)
- **Transaction**: Order, Payment (exchanges)
- **Event**: Appointment, Scheduled activity (temporal)
- **ValueObject**: Address, Email (descriptive, immutable)

### Event Patterns
Organized by category:
- **Lifecycle**: Created, Updated, Deleted
- **Workflow**: Submitted, Approved, Rejected, Completed
- **Time-based**: Scheduled, Expired
- **Decision**: Approved, Rejected

### Command Patterns
Organized by category:
- **CRUD**: Create, Update, Delete
- **Workflow**: Submit, Complete, Cancel
- **Decision**: Approve, Reject
- **Planning**: Schedule

## Design Goals

1. **Semantic Coherence**: Data makes sense in domain context
2. **Ontological Organization**: Hierarchical, relationship-aware structure
3. **BDD Readiness**: Scenarios align with real business workflows
4. **0/0/0 Compliance**: Generated code passes all quality gates
5. **Extensibility**: Easy to add new domains and patterns
6. **Realism**: Test data mirrors production scenarios

## Extending the System

### Adding a New Domain

1. Create `new_domain.dart`:
```dart
part of ednet_core;

class NewDomain {
  static const domainEvents = [...];
  static const bddScenarios = <BDDScenario>[...];
  // ... domain-specific data
}
```

2. Add to `ednet_core.dart`:
```dart
part 'gen/random_data/new_domain.dart';
```

3. Update `SemanticDataProvider`:
```dart
factory SemanticDataProvider.newDomain() =>
    SemanticDataProvider(preferredDomain: 'newdomain');
```

### Adding Entity Archetypes

Add to `DomainOntology.entityArchetypes` in `ontology.dart`:

```dart
'NewArchetype': EntityArchetype(
  name: 'NewArchetype',
  category: 'Thing',
  attributes: ['id', 'name', ...],
  invariants: ['business rule', ...],
  relationships: ['has X', 'belongs to Y'],
),
```

## Quality Assurance

All semantic data follows these principles:

✅ **Realistic**: Based on actual business scenarios
✅ **Coherent**: Relationships make semantic sense
✅ **Complete**: All necessary fields for BDD tests
✅ **Validated**: Aligns with DDD patterns
✅ **Testable**: Enables 0/0/0 quality gates

## References

- DDD Entity/Value Object patterns
- BDD Given-When-Then scenarios
- Event Sourcing conventions
- CQRS command patterns
- Domain event standards
