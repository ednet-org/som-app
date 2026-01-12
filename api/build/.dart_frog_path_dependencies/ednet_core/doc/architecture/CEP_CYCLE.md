# Command-Event-Policy (CEP) Cycle Architecture

## Overview

The Command-Event-Policy (CEP) cycle is the core behavioral architecture of EDNet Core, implementing a fully reactive, event-driven domain model based on Domain-Driven Design principles. This architecture enables:

- **Decoupled command execution** through the Command Bus
- **Event-driven state changes** through the Event Bus
- **Reactive policy enforcement** through the Policy Engine
- **Mathematical validation** through Category Theory foundations

This document provides a complete architectural map of the CEP cycle, showing how commands trigger events, events trigger policies, and policies generate new commands, creating a mathematically sound reactive system.

## Architecture Diagram

```
┌──────────────────────────────────────────────────────────────────────────┐
│                     COMMAND-EVENT-POLICY CYCLE                            │
└──────────────────────────────────────────────────────────────────────────┘

    ┌─────────────────┐
    │   ICommand      │ ◄─── Command Interface
    │   - name        │
    │   - doIt()      │
    │   - undo()      │
    │   - redo()      │
    └────────┬────────┘
             │ implements
             │
    ┌────────▼────────┐
    │ IBasicCommand   │ ◄─── Base Implementation
    │ - session       │
    │ - events[]      │
    │ - state         │
    └────────┬────────┘
             │ implements
             │
    ┌────────▼──────────────┐
    │ ICommandBusCommand    │ ◄─── Modern Command Interface
    │ - id: String          │
    │ - toJson()            │
    └────────┬──────────────┘
             │
             │ handled by
             │
    ┌────────▼──────────────────────────────────────────────────┐
    │                    COMMAND BUS                             │
    │  - registerHandler<T>(ICommandHandler<T>)                  │
    │  - execute(ICommandBusCommand): CommandResult              │
    │  - executeAll(ICommandBusCommand): List<CommandResult>     │
    │  - registerValidator<T>(validator)                         │
    │  - addPreExecutionMiddleware(middleware)                   │
    │  - addPostExecutionMiddleware(middleware)                  │
    │  - setEventPublisher(eventPublisher)                       │
    └────────┬──────────────────────────────────────────────────┘
             │
             │ publishes
             │
    ┌────────▼──────────────────────────────────────────────────┐
    │                      EVENT                                 │
    │  Base Class for Legacy Events                              │
    │  - name: String                                            │
    │  - entity: Entity?                                         │
    │  - handlers: List<String>                                  │
    │  - data: Map<String, dynamic>                              │
    │  - trigger(session)                                        │
    └────────┬──────────────────────────────────────────────────┘
             │ extends/implements
             │
    ┌────────▼──────────────────────────────────────────────────┐
    │                   IDomainEvent                             │
    │  Modern Event Interface                                    │
    │  - id: String                                              │
    │  - name: String                                            │
    │  - timestamp: DateTime                                     │
    │  - aggregateId: String                                     │
    │  - aggregateType: String                                   │
    │  - aggregateVersion: int                                   │
    │  - entity: Entity?                                         │
    │  - eventData: Map<String, dynamic>                         │
    │  - toJson()                                                │
    │  - toBaseEvent(): Event                                    │
    └────────┬──────────────────────────────────────────────────┘
             │
             │ published to
             │
    ┌────────▼──────────────────────────────────────────────────┐
    │                    EVENT BUS                               │
    │  - registerHandler<T>(IEventHandler<T>)                    │
    │  - registerPolicy(IEventTriggeredPolicy)                   │
    │  - publish(IDomainEvent)                                   │
    │  - publishAll(List<IDomainEvent>)                          │
    │  - setCommandBus(CommandBus)                               │
    │  - setEventStore(EventStore)                               │
    │  - addPrePublishingMiddleware(middleware)                  │
    │  - addPostPublishingMiddleware(middleware)                 │
    │  - registerSaga<T>(sagaFactory)                            │
    └────────┬──────────────────────────────────────────────────┘
             │
             │ persists to
             │
    ┌────────▼──────────────────────────────────────────────────┐
    │                   EVENT STORE                              │
    │  - store(IDomainEvent)                                     │
    │  - storeAll(List<IDomainEvent>)                            │
    │  - getEventsForAggregate(type, id)                         │
    │  - getEventsByType(type, since?)                           │
    └────────────────────────────────────────────────────────────┘

             │ triggers
             │
    ┌────────▼──────────────────────────────────────────────────┐
    │                     IPolicy                                │
    │  Interface for Domain Policies                             │
    │  - name: String                                            │
    │  - description: String                                     │
    │  - scope: PolicyScope?                                     │
    │  - evaluate(Entity): bool                                  │
    │  - evaluateWithDetails(Entity): PolicyEvaluationResult     │
    └────────┬──────────────────────────────────────────────────┘
             │ specializes to
             │
    ┌────────▼──────────────────────────────────────────────────┐
    │             IEventTriggeredPolicy                          │
    │  Reactive Policy Interface                                 │
    │  - name: String                                            │
    │  - evaluate(entity): bool                                  │
    │  - shouldTriggerOnEvent(event): bool                       │
    │  - executeActions(entity, event)                           │
    │  - generateCommands(entity, event): List<ICommandBusCmd>   │
    └────────┬──────────────────────────────────────────────────┘
             │
             │ managed by
             │
    ┌────────▼──────────────────────────────────────────────────┐
    │                  POLICY ENGINE                             │
    │  - addPolicy(IPolicy)                                      │
    │  - removePolicy(IPolicy)                                   │
    │  - getApplicablePolicies(Entity): List<IPolicy>            │
    │  - getTriggeredPolicies(Entity, Event): List<Policy>       │
    │  - executePolicies(Entity): List<commands>                 │
    │  - processEvent(Entity, Event): List<commands>             │
    │  - executeGeneratedCommands(commands, aggregateRoot)       │
    └────────┬──────────────────────────────────────────────────┘
             │
             │ evaluated by
             │
    ┌────────▼──────────────────────────────────────────────────┐
    │                POLICY EVALUATOR                            │
    │  - evaluate(Entity, policyKey?): PolicyEvaluationResult    │
    │  - getEvaluationTrace(): String                            │
    └────────────────────────────────────────────────────────────┘

             │ generates
             │
             └──────────────────────────┐
                                        │
                                        ▼
                              ┌─────────────────┐
                              │  New Commands   │ ─────┐
                              └─────────────────┘      │
                                        │              │
                                        └──────────────┘
                                        CYCLE REPEATS
```

## 1. Command Hierarchy

### 1.1 ICommand Interface
**Location:** `/lib/domain/model/commands/interfaces/i_command.dart`

The foundational command interface defining the Command pattern:

```dart
abstract class ICommand {
  String get name;
  String get category;
  String get description;
  Event get successEvent;
  Event get failureEvent;
  bool get done;
  bool get undone;
  bool get redone;

  bool doIt();
  bool undo();
  bool redo();

  List<Event> getEvents();
}
```

**Key Characteristics:**
- Supports undo/redo operations
- Tracks command state (started, done, undone, redone)
- Returns success/failure events
- Maintains event history

### 1.2 IBasicCommand Implementation
**Location:** `/lib/domain/model/commands/interfaces/i_basic_command.dart`

Base implementation providing common command functionality:

```dart
abstract class IBasicCommand implements ICommand {
  final String name;
  late String category;
  String state = 'started';
  String description;
  final DomainSession session;
  bool partOfTransaction = false;
  List<Event> events = [];

  IBasicCommand(this.name, this.session, {this.description = 'Basic command'});

  void addEvent(Event event);
  display({String title = 'BasicCommand'});
}
```

**Key Features:**
- Session context for domain operations
- Transaction support
- Event collection
- State management

### 1.3 ICommandBusCommand Interface
**Location:** `/lib/domain/application/command_bus/i_command_bus_command.dart`

Modern command interface for the Command Bus infrastructure:

```dart
abstract class ICommandBusCommand {
  String get id;  // Unique identifier for tracing
  Map<String, dynamic> toJson();  // Serialization support
}
```

**Key Features:**
- Unique ID for correlation and tracing
- JSON serialization for persistence and messaging
- Type-safe handler registration
- Simplified interface for modern CQRS

### 1.4 Command Handlers

**Interface:** `/lib/domain/application/command_bus/i_command_handler.dart`

```dart
abstract class ICommandHandler<TCommand extends ICommandBusCommand> {
  Future<CommandResult> handle(TCommand command);
  bool canHandle(dynamic command);
}
```

**Responsibilities:**
- Execute business logic for specific command types
- Validate command and domain state
- Coordinate with repositories and domain services
- Generate domain events as results
- Return typed CommandResult

**Example Implementation:**

```dart
class CreateOrderHandler implements ICommandHandler<CreateOrderCommand> {
  final OrderRepository _orderRepository;
  final CustomerRepository _customerRepository;

  @override
  Future<CommandResult> handle(CreateOrderCommand command) async {
    // 1. Validate
    final customer = await _customerRepository.findById(command.customerId);
    if (customer == null) {
      return CommandResult.failure('Customer not found');
    }

    // 2. Execute domain logic
    final order = Order.create(command.customerId, command.items);

    // 3. Persist
    await _orderRepository.save(order);

    // 4. Return result
    return CommandResult.success(data: order.id);
  }

  @override
  bool canHandle(dynamic command) => command is CreateOrderCommand;
}
```

### 1.5 Command Bus Infrastructure
**Location:** `/lib/domain/application/command_bus/command_bus.dart`

The central command execution engine providing:

**Core Capabilities:**
- **Handler Management:** Multiple handlers per command type
- **Validation Pipeline:** Pre-execution command validation
- **Middleware Support:** Pre/post-execution hooks
- **Event Integration:** Automatic lifecycle event publishing
- **Error Handling:** Graceful exception handling
- **Tracing:** Detailed observability for debugging

**Key Methods:**

```dart
class CommandBus {
  // Registration
  void registerHandler<TCommand>(ICommandHandler<TCommand> handler);
  void registerValidator<TCommand>(dynamic Function(TCommand) validator);

  // Middleware
  void addPreExecutionMiddleware(Future<void> Function(ICommandBusCommand) middleware);
  void addPostExecutionMiddleware(Future<void> Function(ICommandBusCommand, CommandResult) middleware);

  // Execution
  Future<CommandResult> execute(ICommandBusCommand command);
  Future<List<CommandResult>> executeAll(ICommandBusCommand command);

  // Integration
  void setEventPublisher(dynamic eventPublisher);
}
```

**Execution Flow:**

```
1. Receive Command
2. Validate Command (if validator registered)
3. Execute Pre-Execution Middleware
4. Find Matching Handler
5. Execute Handler
6. Execute Post-Execution Middleware
7. Publish Lifecycle Events (CommandExecuted/CommandFailed)
8. Return CommandResult
```

## 2. Event Hierarchy

### 2.1 Event Base Class
**Location:** `/lib/domain/model/event/event.dart`

Legacy event implementation for backward compatibility:

```dart
class Event implements IDomainEvent {
  final String name;
  final String description;
  final List<String> handlers;
  final Entity? entity;
  final Map<String, dynamic> data;
  final String id;
  final DateTime timestamp;
  String aggregateId;
  String aggregateType;
  int aggregateVersion;

  Map<String, dynamic> get eventData => data;
  Map<String, dynamic> toJson();
  Event toBaseEvent();
  void trigger(DomainSession session);
}
```

**Constructors:**
- `Event(name, description, handlers, entity, [data])` - Standard event
- `Event.SuccessEvent(...)` - For successful operations
- `Event.FailureEvent(...)` - For failed operations

### 2.2 IDomainEvent Interface
**Location:** `/lib/domain/model/event/domain_event.dart`

Modern interface for domain events:

```dart
abstract class IDomainEvent {
  String get id;
  String get name;
  DateTime get timestamp;
  String get aggregateId;
  String get aggregateType;
  int get aggregateVersion;
  Entity? get entity;
  Map<String, dynamic> get eventData;

  Map<String, dynamic> toJson();
  Event toBaseEvent();
}
```

**Key Properties:**
- **Aggregate Metadata:** Type, ID, and version for event sourcing
- **Temporal Information:** Timestamp for ordering and auditing
- **Entity Reference:** Associated domain entity
- **Event Data:** Structured payload for event processing
- **Serialization:** JSON support for persistence and messaging

### 2.3 DomainEvent Abstract Class
**Location:** `/lib/domain/application/domain_event.dart`

Base class for creating domain events:

```dart
abstract class DomainEvent {
  String get aggregateId;
  int get version;
  DateTime get timestamp;

  Map<String, dynamic> toMap();
}
```

### 2.4 Event Handlers

**Interface:** `/lib/domain/application/event_bus/i_event_handler.dart`

```dart
abstract class IEventHandler<TEvent extends IDomainEvent> {
  Future<void> handle(TEvent event);
  bool canHandle(IDomainEvent event);
  String get handlerName;
}
```

**Use Cases:**
- Read model updates (CQRS projections)
- External system integrations
- Notification services
- Audit logging
- Analytics and reporting

**Example Implementation:**

```dart
class OrderConfirmationHandler implements IEventHandler<OrderCreatedEvent> {
  final EmailService _emailService;

  @override
  Future<void> handle(OrderCreatedEvent event) async {
    await _emailService.sendOrderConfirmation(
      event.customerId,
      event.orderId,
    );
  }

  @override
  bool canHandle(IDomainEvent event) => event is OrderCreatedEvent;

  @override
  String get handlerName => 'OrderConfirmationHandler';
}
```

### 2.5 Event Bus Infrastructure
**Location:** `/lib/domain/application/event_bus/event_bus.dart`

The central event distribution engine with comprehensive capabilities:

**Core Features:**
- **Handler Management:** Register/unregister event handlers
- **Policy Integration:** Automatic policy triggering
- **Command Generation:** Policy-driven command creation
- **Event Persistence:** EventStore integration
- **Middleware Pipeline:** Pre/post-publishing hooks
- **Saga Support:** Process manager orchestration
- **Error Resilience:** Graceful failure handling

**Key Methods:**

```dart
class EventBus {
  // Handler Management
  void registerHandler<TEvent>(IEventHandler<TEvent> handler);
  void unregisterHandler<TEvent>(IEventHandler<TEvent> handler);

  // Policy Integration
  void registerPolicy(IEventTriggeredPolicy policy);
  void unregisterPolicy(IEventTriggeredPolicy policy);

  // Publishing
  Future<void> publish(IDomainEvent event);
  Future<void> publishAll(List<IDomainEvent> events);

  // Middleware
  void addPrePublishingMiddleware(Future<void> Function(IDomainEvent) middleware);
  void addPostPublishingMiddleware(Future<void> Function(IDomainEvent) middleware);

  // Integration
  void setCommandBus(CommandBus commandBus);
  void setEventStore(dynamic eventStore);

  // Saga Support
  void registerSaga<T extends ProcessManager>(T Function() sagaFactory);
  void unregisterSaga(String sagaType);
}
```

**Event Publishing Flow:**

```
1. Receive Event
2. Execute Pre-Publishing Middleware
3. Persist to Event Store (if configured)
4. Distribute to Matching Event Handlers
5. Trigger Applicable Policies
   5a. Evaluate Policy Conditions
   5b. Execute Policy Actions
   5c. Generate Commands from Policies
   5d. Dispatch Commands to Command Bus
6. Execute Post-Publishing Middleware
7. Complete Publication
```

### 2.6 Event Store Integration
**Location:** `/lib/domain/application/event_store.dart`

Persistent event storage for event sourcing:

```dart
class EventStore {
  final EDNetDatabase _db;
  final EventPublisher _publisher;

  // Persistence
  Future<void> store(IDomainEvent event);
  Future<void> storeAll(List<IDomainEvent> events);

  // Retrieval
  Future<List<IDomainEvent>> getEventsForAggregate(String aggregateType, String aggregateId);
  Future<List<IDomainEvent>> getEventsByType(String eventType, {DateTime? since});

  // Schema Management
  Future<void> ensureEventSourcingTables();
}
```

**Features:**
- Transaction-based storage
- Aggregate reconstitution
- Event replay capabilities
- Temporal querying
- Sequence number management

## 3. Policy Hierarchy

### 3.1 IPolicy Interface
**Location:** `/lib/domain/model/policy/i_policy.dart`

Base interface for domain policies:

```dart
abstract class IPolicy {
  String get name;
  String get description;
  PolicyScope? get scope;

  bool evaluate(Entity entity);
  PolicyEvaluationResult evaluateWithDetails(Entity entity);
}
```

**Implementations:**

**Policy (Functional):**
```dart
class Policy implements IPolicy {
  final String name;
  final String description;
  final bool Function(Entity) _evaluationFunction;
  PolicyScope? scope;

  Policy(this.name, this.description, this._evaluationFunction, {this.scope});
}
```

**PolicyWithDependencies (Expression-based):**
```dart
class PolicyWithDependencies implements IPolicy {
  final String name;
  final String description;
  final String expression;
  final Set<String> dependencies;
  PolicyScope? scope;

  // Evaluates expressions like "price > 0" against entity attributes
}
```

### 3.2 Specialized Policy Types

#### 3.2.1 AttributePolicy
**Location:** `/lib/domain/model/policy/attribute_policy.dart`

Validates specific entity attributes:

```dart
class AttributePolicy extends Policy {
  final String attributeName;
  final bool Function(dynamic value) validator;

  AttributePolicy({
    required String name,
    required String description,
    required this.attributeName,
    required this.validator,
    PolicyScope? scope,
  });
}
```

**Built-in Validators (AttributeValidators):**
- **Null Checks:** `isNotNull`
- **Numeric:** `isPositive`, `isNegative`, `isGreaterThan(n)`, `isLessThan(n)`, `isBetween(min, max)`
- **String:** `hasMinLength(n)`, `hasMaxLength(n)`, `matchesRegex(pattern)`
- **Format:** `isEmail`, `isUrl`, `isPhoneNumber`, `isDate`
- **Type:** `isType(Type)`, `isOneOf(values)`
- **Relationships:** `hasParentType(type)`, `hasChildType(type)`

#### 3.2.2 CompositePolicy
**Location:** `/lib/domain/model/policy/composite_policy.dart`

Combines multiple policies with logical operators:

```dart
class CompositePolicy implements IPolicy {
  final String name;
  final String description;
  final List<IPolicy> policies;
  final CompositePolicyType type;  // all, any, none, majority
  final PolicyScope? scope;
}
```

**Evaluation Strategies:**
- **all:** All policies must pass (AND)
- **any:** At least one policy must pass (OR)
- **none:** No policies should pass (NOT)
- **majority:** More than half must pass

### 3.3 IEventTriggeredPolicy Interface
**Location:** `/lib/domain/model/policy/i_event_triggered_policy.dart`

Reactive policies that respond to domain events:

```dart
abstract class IEventTriggeredPolicy {
  String get name;

  // Policy evaluation
  bool evaluate(dynamic entity);

  // Event triggering
  bool shouldTriggerOnEvent(dynamic event);

  // Policy actions
  void executeActions(dynamic entity, dynamic event);

  // Command generation (closes the CEP cycle)
  List<ICommandBusCommand> generateCommands(dynamic entity, dynamic event);
}
```

**CEP Cycle Integration:**
1. **Event Published** → EventBus receives domain event
2. **Policy Evaluation** → EventBus checks `shouldTriggerOnEvent(event)`
3. **Action Execution** → Policy executes business logic via `executeActions(entity, event)`
4. **Command Generation** → Policy creates commands via `generateCommands(entity, event)`
5. **Command Dispatch** → EventBus sends commands to CommandBus
6. **Cycle Continues** → Commands generate new events

**Example Implementation:**

```dart
class InventoryReservationPolicy implements IEventTriggeredPolicy {
  @override
  String get name => 'InventoryReservation';

  @override
  bool evaluate(dynamic entity) => entity is Order;

  @override
  bool shouldTriggerOnEvent(dynamic event) => event is OrderCreatedEvent;

  @override
  void executeActions(dynamic entity, dynamic event) {
    // Business logic: Log reservation request
    print('Reserving inventory for order ${event.orderId}');
  }

  @override
  List<ICommandBusCommand> generateCommands(dynamic entity, dynamic event) {
    final orderEvent = event as OrderCreatedEvent;
    return [
      ReserveInventoryCommand(
        orderId: orderEvent.orderId,
        items: orderEvent.items,
      ),
    ];
  }
}
```

### 3.4 Policy Engine
**Location:** `/lib/domain/model/policy/policy_engine.dart`

Manages policy execution and the CEP cycle:

```dart
class PolicyEngine implements IPolicyEngine {
  final List<Policy> _policies;
  final IDomainSession? _session;

  // Policy Management
  void addPolicy(IPolicy policy);
  bool removePolicy(IPolicy policy);
  List<IPolicy> get policies;

  // Policy Selection
  List<IPolicy> getApplicablePolicies(Entity entity);
  List<Policy> getTriggeredPolicies(Entity entity, Event event);

  // Policy Execution
  List<dynamic> executePolicies(Entity entity);
  List<dynamic> processEvent(Entity entity, Event event);

  // Command Execution (CEP Cycle)
  List<dynamic> executeGeneratedCommands(List<dynamic> commands, dynamic aggregateRoot);
}
```

**Policy Execution Flow:**

```
1. Receive Event and Entity
2. Find Policies:
   - Filter by evaluate(entity) == true
   - Filter by shouldTriggerOnEvent(event) == true
3. For Each Triggered Policy:
   a. Execute executeActions(entity, event)
   b. Collect commands from generateCommands(entity, event)
4. Execute Generated Commands:
   a. Call aggregateRoot.executeCommand(command)
   b. Collect new events from command execution
   c. Process new events (recursive)
5. Return Command Execution Results
```

**Recursive CEP Cycle:**

The PolicyEngine implements the complete reactive cycle:

```dart
List<dynamic> executeGeneratedCommands(List<dynamic> commands, dynamic aggregateRoot) {
  final results = [];

  for (var command in commands) {
    // Execute command
    final result = aggregateRoot.executeCommand(command);
    results.add(result);

    // If command succeeded, process generated events
    if (result.isSuccess && aggregateRoot.pendingEvents.isNotEmpty) {
      for (var event in aggregateRoot.pendingEvents) {
        // Process event through policies (recursive)
        final newCommands = processEvent(aggregateRoot, event);

        // Execute those commands (recursive)
        if (newCommands.isNotEmpty) {
          executeGeneratedCommands(newCommands, aggregateRoot);
        }
      }

      aggregateRoot.markEventsAsProcessed();
    }
  }

  return results;
}
```

### 3.5 Policy Evaluator
**Location:** `/lib/domain/model/policy/policy_evaluator.dart`

Evaluates policies with detailed tracing:

```dart
class PolicyEvaluator {
  final PolicyRegistry _policyRegistry;
  final PolicyEvaluationTracer _tracer;

  // Evaluation
  PolicyEvaluationResult evaluate(Entity entity, {String? policyKey});

  // Tracing
  String getEvaluationTrace();
}
```

**PolicyEvaluationResult:**
```dart
class PolicyEvaluationResult {
  final bool success;
  final List<PolicyViolation> violations;
}
```

## 4. CEP Cycle Flow

### 4.1 Complete Cycle Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                        CEP CYCLE FLOW                               │
└─────────────────────────────────────────────────────────────────────┘

USER/SYSTEM
    │
    │ 1. Issues Command
    ▼
┌────────────────────┐
│   COMMAND BUS      │
│                    │
│ - Validate Command │
│ - Execute Handler  │
│ - Return Result    │
└────────┬───────────┘
         │
         │ 2. Command Handler Generates Events
         ▼
┌────────────────────┐
│   DOMAIN EVENT     │
│                    │
│ - OrderCreated     │
│ - PaymentReceived  │
│ - ItemShipped      │
└────────┬───────────┘
         │
         │ 3. Event Published
         ▼
┌────────────────────┐
│    EVENT BUS       │
│                    │
│ - Store Event      │
│ - Notify Handlers  │
│ - Trigger Policies │
└────────┬───────────┘
         │
         ├──────────────────────┬──────────────────────┐
         │                      │                      │
         │ 4a. Event Handlers   │ 4b. Event Store     │ 4c. Policies
         ▼                      ▼                      ▼
┌──────────────────┐   ┌──────────────────┐   ┌──────────────────┐
│  IEventHandler   │   │   EVENT STORE    │   │ IEventTriggered  │
│                  │   │                  │   │     Policy       │
│ - Update Reads   │   │ - Persist Event  │   │                  │
│ - Send Notif.    │   │ - Enable Replay  │   │ - Evaluate       │
│ - Log/Audit      │   │ - Audit Trail    │   │ - Execute Action │
└──────────────────┘   └──────────────────┘   │ - Gen. Commands  │
                                              └────────┬─────────┘
                                                       │
                                                       │ 5. Commands Generated
                                                       ▼
                                              ┌──────────────────┐
                                              │  POLICY ENGINE   │
                                              │                  │
                                              │ - Collect Cmds   │
                                              │ - Dispatch to    │
                                              │   Command Bus    │
                                              └────────┬─────────┘
                                                       │
                                                       │ 6. New Commands
                                                       ▼
                                              ┌──────────────────┐
                                              │   COMMAND BUS    │
                                              │                  │
                                              │ CYCLE REPEATS    │
                                              └──────────────────┘
```

### 4.2 Detailed Execution Flow

#### Step 1: Command Execution

```dart
// User creates and submits command
final command = CreateOrderCommand(
  customerId: 'CUST-123',
  items: [
    OrderItem(productId: 'PROD-456', quantity: 2),
    OrderItem(productId: 'PROD-789', quantity: 1),
  ],
);

// Command Bus processes
final result = await commandBus.execute(command);
// └─→ Validates command
// └─→ Executes pre-middleware
// └─→ Finds CreateOrderHandler
// └─→ Calls handler.handle(command)
// └─→ Executes post-middleware
// └─→ Publishes CommandExecuted event
// └─→ Returns CommandResult
```

#### Step 2: Event Generation

```dart
// Inside CreateOrderHandler
class CreateOrderHandler implements ICommandHandler<CreateOrderCommand> {
  Future<CommandResult> handle(CreateOrderCommand command) async {
    // Create aggregate
    final order = Order.create(command.customerId, command.items);

    // Aggregate generates domain event
    final event = OrderCreatedEvent(
      orderId: order.id,
      customerId: command.customerId,
      items: command.items,
      timestamp: DateTime.now(),
    );

    // Persist order
    await orderRepository.save(order);

    // Publish event
    await eventBus.publish(event);

    return CommandResult.success(data: order.id);
  }
}
```

#### Step 3: Event Distribution

```dart
// EventBus.publish() flow
Future<void> publish(IDomainEvent event) async {
  // 3.1 Pre-publishing middleware
  await _executePrePublishingMiddleware(event);

  // 3.2 Persist to event store
  await _eventStore?.store(event);

  // 3.3 Distribute to event handlers
  await _distributeToHandlers(event);
  // └─→ OrderConfirmationHandler sends email
  // └─→ InventoryUpdateHandler updates read model
  // └─→ AuditLogHandler logs event

  // 3.4 Trigger policies
  await _triggerPolicies(event);
  // └─→ Find policies where shouldTriggerOnEvent(event) == true
  // └─→ For each policy: executeActions(entity, event)
  // └─→ For each policy: generateCommands(entity, event)
  // └─→ Collect all generated commands

  // 3.5 Dispatch generated commands
  await _dispatchGeneratedCommands(commands);
  // └─→ For each command: commandBus.execute(command)

  // 3.6 Post-publishing middleware
  await _executePostPublishingMiddleware(event);
}
```

#### Step 4: Policy Triggering

```dart
// Policy evaluation and command generation
class InventoryReservationPolicy implements IEventTriggeredPolicy {
  @override
  bool shouldTriggerOnEvent(dynamic event) {
    return event is OrderCreatedEvent;
  }

  @override
  void executeActions(dynamic entity, dynamic event) {
    // Side effect: Log reservation request
    logger.info('Reserving inventory for order ${event.orderId}');

    // Could also: Update metrics, send notifications, etc.
  }

  @override
  List<ICommandBusCommand> generateCommands(dynamic entity, dynamic event) {
    final orderEvent = event as OrderCreatedEvent;

    // Generate multiple commands based on business rules
    return [
      // Reserve inventory
      ReserveInventoryCommand(
        orderId: orderEvent.orderId,
        items: orderEvent.items,
      ),

      // Initiate payment
      ProcessPaymentCommand(
        orderId: orderEvent.orderId,
        customerId: orderEvent.customerId,
        amount: calculateTotal(orderEvent.items),
      ),

      // Notify warehouse
      NotifyWarehouseCommand(
        orderId: orderEvent.orderId,
        items: orderEvent.items,
      ),
    ];
  }
}
```

#### Step 5: Command Dispatch and Cycle Continuation

```dart
// EventBus dispatches policy-generated commands
Future<void> _dispatchGeneratedCommands(List<ICommandBusCommand> commands) async {
  if (_commandBus == null) return;

  for (final command in commands) {
    try {
      // Execute command through Command Bus
      final result = await _commandBus.execute(command);

      // If successful, command will:
      // 1. Execute business logic
      // 2. Generate new events
      // 3. Publish those events
      // 4. Trigger more policies
      // 5. Generate more commands
      // ... CYCLE CONTINUES

    } catch (error) {
      // Log but continue with other commands
      observabilityError('policyCommandFailed', error: error);
    }
  }
}
```

### 4.3 Cycle Termination

The CEP cycle naturally terminates when:

1. **No More Commands Generated:** Policies return empty command lists
2. **No Policies Triggered:** No policies have `shouldTriggerOnEvent() == true`
3. **Command Execution Fails:** Error handling prevents infinite loops
4. **Business Logic Completion:** Domain rules determine workflow end

**Example Termination:**

```dart
// After several iterations, final event is published
class OrderFulfilledEvent implements IDomainEvent {
  // ... event properties
}

// Confirmation policy executes but generates no new commands
class OrderConfirmationPolicy implements IEventTriggeredPolicy {
  @override
  List<ICommandBusCommand> generateCommands(entity, event) {
    // Send confirmation email (side effect in executeActions)
    // But return NO commands - cycle terminates
    return [];
  }
}
```

## 5. Mathematical Validation (Category Theory)

### 5.1 Category Theory Foundation
**Location:** `/lib/mathematical_foundations/category_theory_foundation.dart`

The CEP cycle is validated using Category Theory to ensure mathematical soundness:

```dart
class CategoryTheoryFoundationImpl implements ICategoryTheoryFoundation {
  // Morphism composition
  DomainMorphism compose(DomainMorphism f, DomainMorphism g);

  // Identity morphisms
  DomainMorphism identityMorphism(DomainConcept concept);

  // CEP cycle as morphisms
  DomainMorphism commandToMorphism(BusinessCommand command);
  DomainMorphism eventToMorphism(MathematicalDomainEvent event);
  DomainMorphism policyToMorphism(BusinessPolicy policy);

  // Validation
  MathematicalValidationResult validateCategoryLaws();
}
```

### 5.2 Morphism Types

```dart
enum MorphismType {
  command,      // State transformation via command
  event,        // Immutable state transition record
  policy,       // Conditional transformation
  composition,  // Composed morphisms
  identity,     // Identity transformation
}
```

### 5.3 Category Laws Validation

#### Law 1: Identity
For any morphism `f: A → B`:
- `f ∘ id_A = f` (left identity)
- `id_B ∘ f = f` (right identity)

**Validation:**
```dart
// Test identity laws
for (final concept in _objects.values) {
  final identity = identityMorphism(concept);

  for (final morphism in _morphisms.values) {
    if (morphism.source.name == concept.name) {
      final rightIdentity = compose(morphism, identity);
      assert(rightIdentity.equals(morphism));  // morphism ∘ id = morphism
    }

    if (morphism.target.name == concept.name) {
      final leftIdentity = compose(identity, morphism);
      assert(leftIdentity.equals(morphism));  // id ∘ morphism = morphism
    }
  }
}
```

#### Law 2: Associativity
For morphisms `f: A → B`, `g: B → C`, `h: C → D`:
- `(h ∘ g) ∘ f = h ∘ (g ∘ f)`

**Validation:**
```dart
// Test associativity
for (final h in _morphisms.values) {
  for (final g in _morphisms.values) {
    for (final f in _morphisms.values) {
      if (isValidComposition(f, g) && isValidComposition(g, h)) {
        final leftAssoc = compose(compose(h, g), f);   // (h ∘ g) ∘ f
        final rightAssoc = compose(h, compose(g, f));  // h ∘ (g ∘ f)

        assert(leftAssoc.equals(rightAssoc));  // Must be equal
      }
    }
  }
}
```

### 5.4 CEP Cycle as Category

The CEP cycle forms a category where:

**Objects:** Domain states (aggregate states, entity states)

**Morphisms:**
- **Commands:** `Command: State_Before → State_After`
- **Events:** `Event: State_Before → State_After` (immutable)
- **Policies:** `Policy: State → State'` (conditional)

**Composition:**
```
Command → Event → Policy → Command'
     └──────── CEP Cycle ──────────┘
```

**Mathematical Properties:**

1. **Closure:** Commands, events, and policies compose to create new morphisms
2. **Identity:** Each state has an identity morphism (no-op)
3. **Associativity:** Order of composition grouping doesn't matter
4. **Immutability:** Events are immutable morphisms (pure functions)

**Example:**

```dart
// Command as morphism
final createOrderMorphism = commandToMorphism(
  CreateOrderCommand(customerId: 'C1', items: [item1])
);
// Type: Morphism(OrderState_Empty → OrderState_Created)

// Event as morphism
final orderCreatedMorphism = eventToMorphism(
  OrderCreatedEvent(orderId: 'O1', customerId: 'C1')
);
// Type: Morphism(OrderState_Created → OrderState_Created_Recorded)

// Policy as morphism
final inventoryPolicyMorphism = policyToMorphism(
  InventoryReservationPolicy()
);
// Type: Morphism(OrderState_Created_Recorded → OrderState_Inventory_Reserved)

// Composition: CEP cycle
final cepCycle = compose(
  inventoryPolicyMorphism,
  compose(orderCreatedMorphism, createOrderMorphism)
);
// Type: Morphism(OrderState_Empty → OrderState_Inventory_Reserved)
```

### 5.5 Functor Mapping

Bounded contexts can be mapped using functors:

```dart
NaturalTransformation naturalTransformation(
  BoundedContext source,
  BoundedContext target
) {
  return NaturalTransformationImpl(source, target);
}
```

This enables:
- **Context Mapping:** Transform concepts between bounded contexts
- **Anti-Corruption Layers:** Protect domain integrity
- **Event Translation:** Map events across contexts

### 5.6 Monadic Workflows

Workflows compose monadically:

```dart
MonadicWorkflow composeMonadically(
  BusinessWorkflow w1,
  BusinessWorkflow w2
) {
  // Validate workflows can be composed
  if (w1.output['type'] != w2.input['type']) {
    throw MathematicalException('Type mismatch');
  }

  return MonadicWorkflowImpl(
    name: '${w1.name}_then_${w2.name}',
    input: w1.input,
    output: w2.output,
    composedWorkflows: [w1, w2],
  );
}
```

## 6. Integration Patterns

### 6.1 Application Service Integration

```dart
class OrderApplicationService {
  final CommandBus _commandBus;
  final EventBus _eventBus;
  final OrderRepository _orderRepository;

  Future<OrderResult> createOrder(CreateOrderRequest request) async {
    // 1. Create command
    final command = CreateOrderCommand(
      customerId: request.customerId,
      items: request.items,
    );

    // 2. Execute via Command Bus
    final result = await _commandBus.execute(command);

    // 3. Return result
    if (result.isSuccess) {
      return OrderResult.success(orderId: result.data);
    } else {
      return OrderResult.failure(error: result.errorMessage);
    }

    // Event publishing and policy triggering happen automatically
  }
}
```

### 6.2 Aggregate Root Integration

```dart
class Order extends AggregateRoot {
  String customerId;
  List<OrderItem> items;
  OrderStatus status;

  // Command execution
  CommandResult processPayment(ProcessPaymentCommand command) {
    // Validate
    if (status != OrderStatus.created) {
      return CommandResult.failure('Order already processed');
    }

    // Execute business logic
    status = OrderStatus.paid;

    // Generate event
    final event = PaymentProcessedEvent(
      orderId: id,
      amount: command.amount,
      timestamp: DateTime.now(),
    );

    // Add to pending events
    raiseEvent(event);

    return CommandResult.success();
  }

  // Aggregate root automatically publishes events via EventBus
}
```

### 6.3 Saga/Process Manager Integration

```dart
class OrderFulfillmentSaga extends ProcessManager {
  @override
  String get sagaType => 'OrderFulfillment';

  @override
  void configureSteps() {
    // Step 1: Order Created
    step('OrderCreated')
      .startsOn<OrderCreatedEvent>()
      .compensateWith((event) => CancelOrderCommand(orderId: event.orderId));

    // Step 2: Payment Processed
    step('PaymentProcessed')
      .triggeredBy<PaymentProcessedEvent>()
      .thenExecute((event) => [
        ReserveInventoryCommand(orderId: event.orderId),
      ])
      .compensateWith((event) => RefundPaymentCommand(orderId: event.orderId));

    // Step 3: Inventory Reserved
    step('InventoryReserved')
      .triggeredBy<InventoryReservedEvent>()
      .thenExecute((event) => [
        ShipOrderCommand(orderId: event.orderId),
      ])
      .compensateWith((event) => ReleaseInventoryCommand(orderId: event.orderId));

    // Step 4: Order Shipped (completes saga)
    step('OrderShipped')
      .triggeredBy<OrderShippedEvent>()
      .completes();
  }
}

// Register saga with EventBus
eventBus.registerSaga<OrderFulfillmentSaga>(() => OrderFulfillmentSaga());
```

### 6.4 CQRS Integration

The CEP cycle naturally supports CQRS:

**Command Side:**
```dart
// Commands modify state
commandBus.execute(CreateOrderCommand(...));
commandBus.execute(ProcessPaymentCommand(...));
```

**Query Side:**
```dart
// Event handlers update read models
class OrderReadModelUpdater implements IEventHandler<OrderCreatedEvent> {
  final ReadModelRepository _readModel;

  @override
  Future<void> handle(OrderCreatedEvent event) async {
    await _readModel.insert({
      'orderId': event.orderId,
      'customerId': event.customerId,
      'status': 'created',
      'createdAt': event.timestamp,
    });
  }
}

class PaymentReadModelUpdater implements IEventHandler<PaymentProcessedEvent> {
  final ReadModelRepository _readModel;

  @override
  Future<void> handle(PaymentProcessedEvent event) async {
    await _readModel.update(
      {'orderId': event.orderId},
      {'status': 'paid', 'paidAt': event.timestamp},
    );
  }
}
```

## 7. Testing the CEP Cycle

### 7.1 Unit Testing

**Command Handler Test:**
```dart
test('CreateOrderHandler should create order and publish event', () async {
  // Arrange
  final mockRepo = MockOrderRepository();
  final mockEventBus = MockEventBus();
  final handler = CreateOrderHandler(mockRepo, mockEventBus);
  final command = CreateOrderCommand(customerId: 'C1', items: [item1]);

  // Act
  final result = await handler.handle(command);

  // Assert
  expect(result.isSuccess, isTrue);
  verify(mockRepo.save(any)).called(1);
  verify(mockEventBus.publish(any)).called(1);
});
```

**Policy Test:**
```dart
test('InventoryReservationPolicy should trigger on OrderCreated', () {
  // Arrange
  final policy = InventoryReservationPolicy();
  final event = OrderCreatedEvent(orderId: 'O1', items: [item1]);

  // Act
  final shouldTrigger = policy.shouldTriggerOnEvent(event);
  final commands = policy.generateCommands(null, event);

  // Assert
  expect(shouldTrigger, isTrue);
  expect(commands, hasLength(1));
  expect(commands.first, isA<ReserveInventoryCommand>());
});
```

### 7.2 Integration Testing

**Full CEP Cycle Test:**
```dart
test('Complete CEP cycle: Command → Event → Policy → Command', () async {
  // Arrange
  final commandBus = CommandBus();
  final eventBus = EventBus();
  final policyEngine = PolicyEngine(null);

  eventBus.setCommandBus(commandBus);

  final policy = InventoryReservationPolicy();
  eventBus.registerPolicy(policy);

  final executedCommands = <ICommandBusCommand>[];
  commandBus.registerHandler<ReserveInventoryCommand>(
    MockHandler((cmd) {
      executedCommands.add(cmd);
      return CommandResult.success();
    }),
  );

  // Act
  final event = OrderCreatedEvent(orderId: 'O1', items: [item1]);
  await eventBus.publish(event);

  // Assert
  await Future.delayed(Duration(milliseconds: 100));  // Allow async processing
  expect(executedCommands, hasLength(1));
  expect(executedCommands.first, isA<ReserveInventoryCommand>());
});
```

**See:** `/test/integration/event_storming_complete_cycle_test.dart` for comprehensive examples

## 8. Best Practices

### 8.1 Command Design
- **Single Responsibility:** One command = one business operation
- **Immutable:** Commands should be immutable value objects
- **Self-Describing:** Include all necessary data for execution
- **Unique Identification:** Use unique IDs for tracing
- **Validation:** Validate at the boundary, not in handlers

### 8.2 Event Design
- **Past Tense:** Name events in past tense (OrderCreated, not CreateOrder)
- **Immutable:** Events are facts that cannot change
- **Complete Data:** Include all data needed by handlers
- **Aggregate Info:** Always include aggregate ID and version
- **Fine-Grained:** Prefer multiple small events over large ones

### 8.3 Policy Design
- **Clear Triggers:** Explicitly define which events trigger policies
- **Idempotent:** Policies should handle duplicate events gracefully
- **Stateless:** Policies should be stateless (use aggregate state instead)
- **Atomic Actions:** Keep `executeActions()` simple and atomic
- **Command Generation:** Generate commands, don't execute directly

### 8.4 Cycle Management
- **Termination:** Ensure cycles can terminate naturally
- **Error Handling:** Don't let one failure cascade
- **Monitoring:** Log cycle depth and duration
- **Circuit Breakers:** Implement safeguards against infinite loops
- **Compensation:** Design compensating actions for failures

## 9. Observability and Debugging

### 9.1 Tracing Support

Both CommandBus and EventBus include comprehensive tracing:

```dart
// Command tracing
observabilityTrace('commandExecutionStarted', {
  'commandType': commandType.toString(),
  'commandId': commandId,
  'commandData': command.toJson(),
});

// Event tracing
observabilityTrace('eventPublishing', {
  'eventName': event.name,
  'eventId': event.id,
  'handlerCount': handlers.length,
  'policyCount': policies.length,
});
```

### 9.2 Debugging Techniques

**Command Execution Failures:**
```dart
// Add debug middleware
commandBus.addPreExecutionMiddleware((command) async {
  print('EXECUTING: ${command.runtimeType} with ID ${command.id}');
});

commandBus.addPostExecutionMiddleware((command, result) async {
  print('RESULT: ${result.isSuccess ? 'SUCCESS' : 'FAILED'} - ${result.errorMessage ?? ''}');
});
```

**Event Flow Visualization:**
```dart
// Track event flow
eventBus.addPrePublishingMiddleware((event) async {
  print('EVENT PUBLISHED: ${event.name} at ${event.timestamp}');
});

eventBus.addPostPublishingMiddleware((event) async {
  print('EVENT PROCESSED: ${event.name}');
});
```

**Policy Triggering:**
```dart
// Log policy evaluations
class LoggingPolicyDecorator implements IEventTriggeredPolicy {
  final IEventTriggeredPolicy _inner;

  @override
  bool shouldTriggerOnEvent(dynamic event) {
    final result = _inner.shouldTriggerOnEvent(event);
    print('Policy ${_inner.name} trigger: $result for event ${event.name}');
    return result;
  }

  @override
  List<ICommandBusCommand> generateCommands(entity, event) {
    final commands = _inner.generateCommands(entity, event);
    print('Policy ${_inner.name} generated ${commands.length} commands');
    return commands;
  }
}
```

## 10. File Locations Reference

### Commands
- Interface: `/lib/domain/model/commands/interfaces/i_command.dart`
- Base: `/lib/domain/model/commands/interfaces/i_basic_command.dart`
- Bus Command: `/lib/domain/application/command_bus/i_command_bus_command.dart`
- Handler Interface: `/lib/domain/application/command_bus/i_command_handler.dart`
- Command Bus: `/lib/domain/application/command_bus/command_bus.dart`
- Command Result: `/lib/domain/application/command_result.dart`

### Events
- Event Base: `/lib/domain/model/event/event.dart`
- Domain Event Interface: `/lib/domain/model/event/domain_event.dart`
- Domain Event Application: `/lib/domain/application/domain_event.dart`
- Event Handler: `/lib/domain/application/event_bus/i_event_handler.dart`
- Event Bus: `/lib/domain/application/event_bus/event_bus.dart`
- Event Store: `/lib/domain/application/event_store.dart`
- Event Publisher: `/lib/domain/application/event_publisher.dart`
- Event Registry: `/lib/domain/application/event_type_registry.dart`

### Policies
- Base Interface: `/lib/domain/model/policy/i_policy.dart`
- Event-Triggered: `/lib/domain/model/policy/i_event_triggered_policy.dart`
- Policy Engine: `/lib/domain/model/policy/policy_engine.dart`
- Policy Evaluator: `/lib/domain/model/policy/policy_evaluator.dart`
- Attribute Policy: `/lib/domain/model/policy/attribute_policy.dart`
- Composite Policy: `/lib/domain/model/policy/composite_policy.dart`
- Policy Registry: `/lib/domain/model/policy/policy_registry.dart`
- Policy Scope: `/lib/domain/model/policy/policy_scope.dart`
- Policy Tracer: `/lib/domain/model/policy/policy_evaluation_tracer.dart`
- Policy Violation: `/lib/domain/model/policy/policy_violation_exception.dart`

### Mathematical Foundations
- Category Theory: `/lib/mathematical_foundations/category_theory_foundation.dart`
- Mathematical Types: `/lib/mathematical_foundations/mathematical_types.dart`
- Business Primitives: `/lib/mathematical_foundations/business_primitives.dart`

### Integration Components
- Aggregate Root: `/lib/domain/model/aggregate_root/aggregate_root.dart`
- Enhanced Aggregate: `/lib/domain/model/aggregate_root/enhanced_aggregate_root.dart`
- Application Service: `/lib/domain/application/application_service/enhanced_application_service.dart`
- Process Manager: `/lib/domain/application/process_manager/process_manager.dart`

### Tests
- Complete Cycle: `/test/integration/event_storming_complete_cycle_test.dart`
- Event Sourcing: `/test/integration/event_sourcing_integration_test.dart`
- Command Bus: `/test/command_bus/command_bus_test.dart`
- Event Bus: `/test/event_bus/event_bus_test.dart`
- Policy Engine: `/test/policy/engine/policy_engine_test.dart`
- Process Manager: `/test/process_manager/process_manager_test.dart`

## Conclusion

The Command-Event-Policy cycle in EDNet Core provides a mathematically sound, fully reactive architecture for domain-driven design. By separating commands (intent), events (facts), and policies (reactions), the system achieves:

- **High Decoupling:** Components interact through well-defined interfaces
- **Extensibility:** New behaviors added via handlers and policies
- **Testability:** Each component tested in isolation
- **Auditability:** Complete event history in event store
- **Reactivity:** Automatic propagation of domain changes
- **Mathematical Correctness:** Category theory validation ensures soundness

The architecture supports complex workflows, sagas, compensating transactions, and distributed systems while maintaining domain integrity and business rule enforcement.
