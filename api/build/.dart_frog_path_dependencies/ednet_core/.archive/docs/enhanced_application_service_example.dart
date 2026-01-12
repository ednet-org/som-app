import 'package:ednet_core/ednet_core.dart';

/// Example demonstrating the Enhanced Application Service orchestrating
/// the complete Command-Event-Policy cycle in EDNet Core.
/// 
/// This example shows:
/// - Command execution with transaction management
/// - Event publishing and policy triggering
/// - Aggregate lifecycle management
/// - Workflow orchestration
/// - Error handling and recovery

void main() async {
  print('🚀 Enhanced Application Service Example');
  print('=========================================\n');

  // Setup the complete Command-Event-Policy infrastructure
  final infrastructure = await setupCommandEventPolicyInfrastructure();
  
  print('📋 Infrastructure Setup Complete\n');

  // Demonstrate various application service capabilities
  await demonstrateBasicCommandExecution(infrastructure);
  await demonstrateWorkflowOrchestration(infrastructure);
  await demonstrateErrorHandlingAndRecovery(infrastructure);
  await demonstratePerformanceMonitoring(infrastructure);
  
  print('\n✅ Enhanced Application Service Example Complete');
}

/// Infrastructure container for the Command-Event-Policy cycle
class CommandEventPolicyInfrastructure {
  final CommandBus commandBus;
  final EventBus eventBus;
  final EventStore eventStore;
  final EnhancedApplicationService applicationService;
  final OrderRepository orderRepository;
  final DomainSession session;

  CommandEventPolicyInfrastructure({
    required this.commandBus,
    required this.eventBus,
    required this.eventStore,
    required this.applicationService,
    required this.orderRepository,
    required this.session,
  });
}

/// Sets up the complete Command-Event-Policy infrastructure
Future<CommandEventPolicyInfrastructure> setupCommandEventPolicyInfrastructure() async {
  // Create core components
  final commandBus = CommandBus();
  final eventBus = EventBus();
  final session = DomainSession();
  final eventPublisher = EventPublisher();
  final database = InMemoryDatabase();
  final eventStore = EventStore(database, eventPublisher);
  
  // Create repositories
  final orderRepository = OrderRepository();
  
  // Wire components together
  eventBus.setCommandBus(commandBus);
  eventBus.setEventStore(eventStore);
  
  // Register command handlers
  final orderCommandHandler = OrderCommandHandler(orderRepository, eventBus);
  final inventoryCommandHandler = InventoryCommandHandler();
  commandBus.registerHandler<CreateOrderCommand>(orderCommandHandler);
  commandBus.registerHandler<ReserveInventoryCommand>(inventoryCommandHandler);
  
  // Register event handlers
  final orderConfirmationHandler = OrderConfirmationHandler();
  final inventoryNotificationHandler = InventoryNotificationHandler();
  eventBus.registerHandler<OrderCreatedEvent>(orderConfirmationHandler);
  eventBus.registerHandler<InventoryReservedEvent>(inventoryNotificationHandler);
  
  // Register event-triggered policies
  final inventoryReservationPolicy = InventoryReservationPolicy();
  eventBus.registerPolicy(inventoryReservationPolicy);
  
  // Create the enhanced application service
  final applicationService = EnhancedApplicationService(
    session: session,
    commandBus: commandBus,
    eventBus: eventBus,
  );
  
  return CommandEventPolicyInfrastructure(
    commandBus: commandBus,
    eventBus: eventBus,
    eventStore: eventStore,
    applicationService: applicationService,
    orderRepository: orderRepository,
    session: session,
  );
}

/// Demonstrates basic command execution with transaction management
Future<void> demonstrateBasicCommandExecution(CommandEventPolicyInfrastructure infra) async {
  print('🔥 Demonstrating Basic Command Execution');
  print('-----------------------------------------');
  
  // Create an order command
  final createOrderCommand = CreateOrderCommand(
    customerId: 'CUSTOMER-001',
    items: [
      OrderItem(productId: 'PRODUCT-A', quantity: 2, unitPrice: 29.99),
      OrderItem(productId: 'PRODUCT-B', quantity: 1, unitPrice: 15.99),
    ],
  );
  
  print('📤 Executing CreateOrderCommand...');
  
  // Execute command through the enhanced application service
  final result = await infra.applicationService.executeCommand(createOrderCommand);
  
  if (result.isSuccess) {
    print('✅ Order created successfully: ${result.data}');
    print('📋 Transaction committed automatically');
    print('🔄 Events published, policies triggered');
  } else {
    print('❌ Order creation failed: ${result.errorMessage}');
  }
  
  print('');
}

/// Demonstrates multi-step workflow orchestration
Future<void> demonstrateWorkflowOrchestration(CommandEventPolicyInfrastructure infra) async {
  print('🔄 Demonstrating Workflow Orchestration');
  print('----------------------------------------');
  
  // Create a multi-step workflow
  final workflowCommands = [
    CreateOrderCommand(
      customerId: 'CUSTOMER-002',
      items: [OrderItem(productId: 'PRODUCT-C', quantity: 3, unitPrice: 45.99)],
    ),
    // The InventoryReservationPolicy will automatically generate ReserveInventoryCommand
    // Additional commands could be added here for a more complex workflow
  ];
  
  print('📋 Executing multi-step workflow...');
  
  // Execute workflow with atomic transaction
  final results = await infra.applicationService.executeWorkflow(workflowCommands);
  
  print('📊 Workflow Results:');
  for (int i = 0; i < results.length; i++) {
    final result = results[i];
    print('   Step ${i + 1}: ${result.isSuccess ? '✅ Success' : '❌ Failed'} - ${result.data ?? result.errorMessage}');
  }
  
  print('🔄 Complete workflow executed in single transaction');
  print('');
}

/// Demonstrates error handling and recovery mechanisms
Future<void> demonstrateErrorHandlingAndRecovery(CommandEventPolicyInfrastructure infra) async {
  print('🛡️ Demonstrating Error Handling & Recovery');
  print('--------------------------------------------');
  
  // Create a command that will fail
  final invalidOrderCommand = CreateOrderCommand(
    customerId: '', // Invalid - empty customer ID
    items: [],      // Invalid - no items
  );
  
  print('📤 Executing invalid command to test error handling...');
  
  // Execute command with validation
  final result = await infra.applicationService.executeCommandWithValidation(
    invalidOrderCommand,
    infra.orderRepository,
    validator: (command) {
      final cmd = command as CreateOrderCommand;
      if (cmd.customerId.isEmpty) {
        return ValidationResult.failure('Customer ID is required');
      }
      if (cmd.items.isEmpty) {
        return ValidationResult.failure('Order must have at least one item');
      }
      return ValidationResult.success();
    },
  );
  
  if (result.isFailure) {
    print('✅ Error handled correctly: ${result.errorMessage}');
    print('🔄 Transaction rolled back automatically');
    print('🚫 No events published due to validation failure');
  }
  
  print('');
}

/// Demonstrates performance monitoring capabilities
Future<void> demonstratePerformanceMonitoring(CommandEventPolicyInfrastructure infra) async {
  print('📊 Demonstrating Performance Monitoring');
  print('----------------------------------------');
  
  final monitoredCommand = CreateOrderCommand(
    customerId: 'CUSTOMER-003',
    items: [OrderItem(productId: 'PRODUCT-D', quantity: 1, unitPrice: 99.99)],
  );
  
  print('📤 Executing command with performance monitoring...');
  
  // Execute command with metrics collection
  final result = await infra.applicationService.executeCommandWithMetrics(monitoredCommand);
  
  if (result.isSuccess) {
    final metrics = result.data!['metrics'] as Map<String, dynamic>;
    print('✅ Command executed successfully');
    print('📊 Performance Metrics:');
    print('   - Execution Time: ${metrics['executionTimeMs']}ms');
    print('   - Command Type: ${metrics['commandType']}');
    print('   - Command ID: ${metrics['commandId']}');
    print('   - Start Time: ${metrics['startTime']}');
    print('   - Success: ${metrics['success']}');
  }
  
  print('');
}

// Domain Model Classes

/// Order aggregate root
class Order extends AggregateRoot<Order> {
  String? customerId;
  List<OrderItem> items = [];
  String status = 'created';
  double total = 0.0;

  Order() {
    concept = OrderConcept();
  }

  CommandResult processCreateOrder(CreateOrderCommand command) {
    if (command.customerId.isEmpty) {
      return CommandResult.failure('Customer ID is required');
    }
    
    if (command.items.isEmpty) {
      return CommandResult.failure('Order must have at least one item');
    }

    customerId = command.customerId;
    items = command.items;
    total = items.fold(0.0, (sum, item) => sum + (item.quantity * item.unitPrice));
    status = 'placed';

    // Record domain event
    recordEvent(
      'OrderCreated',
      'Order was successfully created',
      ['OrderConfirmationHandler', 'InventoryReservationPolicy'],
      data: {
        'orderId': oid.toString(),
        'customerId': customerId,
        'items': items.map((item) => item.toJson()).toList(),
        'total': total,
      },
    );

    return CommandResult.success(data: {'orderId': oid.toString(), 'total': total});
  }

  @override
  void applyEvent(dynamic event) {
    if (event?.name == 'OrderCreated') {
      status = 'confirmed';
    }
  }
}

/// Order concept
class OrderConcept extends Concept {
  OrderConcept() : super() {
    entry = true; // Mark as aggregate root
  }
  
  @override
  String get name => 'Order';
}

/// Order item value object
class OrderItem {
  final String productId;
  final int quantity;
  final double unitPrice;

  OrderItem({
    required this.productId,
    required this.quantity,
    required this.unitPrice,
  });

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'quantity': quantity,
    'unitPrice': unitPrice,
  };
}

// Commands

/// Create order command
class CreateOrderCommand implements ICommandBusCommand {
  @override
  final String id = Oid().toString();
  final String customerId;
  final List<OrderItem> items;

  CreateOrderCommand({
    required this.customerId,
    required this.items,
  });

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'customerId': customerId,
    'items': items.map((item) => item.toJson()).toList(),
  };
}

/// Reserve inventory command
class ReserveInventoryCommand implements ICommandBusCommand {
  @override
  final String id = Oid().toString();
  final String orderId;
  final List<OrderItem> items;

  ReserveInventoryCommand({
    required this.orderId,
    required this.items,
  });

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'orderId': orderId,
    'items': items.map((item) => item.toJson()).toList(),
  };
}

// Events

/// Order created event
class OrderCreatedEvent implements IDomainEvent {
  @override
  final String id = Oid().toString();
  @override
  final DateTime timestamp = DateTime.now();
  @override
  final String name = 'OrderCreated';
  @override
  Entity? entity;
  @override
  String aggregateId;
  @override
  String aggregateType;
  @override
  int aggregateVersion;

  final String customerId;
  final List<OrderItem> items;
  final double total;

  OrderCreatedEvent({
    required this.customerId,
    required this.items,
    required this.total,
    this.aggregateId = '',
    this.aggregateType = 'Order',
    this.aggregateVersion = 0,
  });

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'name': name,
    'aggregateId': aggregateId,
    'aggregateType': aggregateType,
    'aggregateVersion': aggregateVersion,
    'customerId': customerId,
    'items': items.map((item) => item.toJson()).toList(),
    'total': total,
  };

  @override
  Event toBaseEvent() {
    return Event(name, 'Order created event', [], entity, toJson());
  }
}

/// Inventory reserved event
class InventoryReservedEvent implements IDomainEvent {
  @override
  final String id = Oid().toString();
  @override
  final DateTime timestamp = DateTime.now();
  @override
  final String name = 'InventoryReserved';
  @override
  Entity? entity;
  @override
  String aggregateId;
  @override
  String aggregateType;
  @override
  int aggregateVersion;

  final String orderId;
  final List<OrderItem> reservedItems;

  InventoryReservedEvent({
    required this.orderId,
    required this.reservedItems,
    this.aggregateId = '',
    this.aggregateType = 'Inventory',
    this.aggregateVersion = 0,
  });

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'name': name,
    'aggregateId': aggregateId,
    'aggregateType': aggregateType,
    'aggregateVersion': aggregateVersion,
    'orderId': orderId,
    'reservedItems': reservedItems.map((item) => item.toJson()).toList(),
  };

  @override
  Event toBaseEvent() {
    return Event(name, 'Inventory reserved event', [], entity, toJson());
  }
}

// Command Handlers

/// Order command handler
class OrderCommandHandler implements ICommandHandler<CreateOrderCommand> {
  final OrderRepository _repository;
  final EventBus _eventBus;

  OrderCommandHandler(this._repository, this._eventBus);

  @override
  Future<CommandResult> handle(CreateOrderCommand command) async {
    final order = Order();
    final result = order.processCreateOrder(command);
    
    if (result.isSuccess) {
      await _repository.save(order);
      
      // Publish domain event
      final event = OrderCreatedEvent(
        customerId: command.customerId,
        items: command.items,
        total: order.total,
        aggregateId: order.oid.toString(),
      );
      await _eventBus.publish(event);
    }
    
    return result;
  }

  @override
  bool canHandle(dynamic command) => command is CreateOrderCommand;
}

/// Inventory command handler
class InventoryCommandHandler implements ICommandHandler<ReserveInventoryCommand> {
  @override
  Future<CommandResult> handle(ReserveInventoryCommand command) async {
    // Simulate inventory reservation
    print('📦 Reserving inventory for order: ${command.orderId}');
    
    // In a real system, this would check stock levels and reserve items
    // For this example, we'll always succeed
    
    return CommandResult.success(data: {
      'orderId': command.orderId,
      'reservedItems': command.items.length,
    });
  }

  @override
  bool canHandle(dynamic command) => command is ReserveInventoryCommand;
}

// Event Handlers

/// Order confirmation handler
class OrderConfirmationHandler implements IEventHandler<OrderCreatedEvent> {
  @override
  Future<void> handle(OrderCreatedEvent event) async {
    print('📧 Sending order confirmation to customer: ${event.customerId}');
    print('   Order Total: \$${event.total.toStringAsFixed(2)}');
  }

  @override
  bool canHandle(IDomainEvent event) => event is OrderCreatedEvent;

  @override
  String get handlerName => 'OrderConfirmationHandler';
}

/// Inventory notification handler
class InventoryNotificationHandler implements IEventHandler<InventoryReservedEvent> {
  @override
  Future<void> handle(InventoryReservedEvent event) async {
    print('📊 Inventory reserved for order: ${event.orderId}');
    print('   Reserved items: ${event.reservedItems.length}');
  }

  @override
  bool canHandle(IDomainEvent event) => event is InventoryReservedEvent;

  @override
  String get handlerName => 'InventoryNotificationHandler';
}

// Policies

/// Inventory reservation policy
class InventoryReservationPolicy implements IEventTriggeredPolicy {
  @override
  String get name => 'InventoryReservationPolicy';

  @override
  String get description => 'Automatically reserves inventory when orders are created';

  @override
  PolicyScope? get scope => PolicyScope.entity;

  @override
  bool evaluate(Entity entity) => true;

  @override
  PolicyEvaluationResult evaluateWithDetails(Entity entity) {
    return PolicyEvaluationResult(success: true, violations: []);
  }

  @override
  bool shouldTriggerOnEvent(dynamic event) {
    return event is OrderCreatedEvent;
  }

  @override
  void executeActions(Entity entity, dynamic event) {
    print('🔄 Inventory reservation policy triggered for order: ${event.aggregateId}');
  }

  @override
  List<ICommandBusCommand> generateCommands(Entity entity, dynamic event) {
    if (event is OrderCreatedEvent) {
      return [
        ReserveInventoryCommand(
          orderId: event.aggregateId,
          items: event.items,
        )
      ];
    }
    return [];
  }
}

// Repositories and Infrastructure

/// Order repository
class OrderRepository {
  final Map<String, Order> _orders = {};

  Future<Order?> findById(String id) async {
    return _orders[id];
  }

  Future<void> save(Order order) async {
    _orders[order.oid.toString()] = order;
    print('💾 Order saved: ${order.oid}');
  }

  Order createNew() => Order();
}

/// Simple domain session
class DomainSession {
  final List<dynamic> transactions = [];
  final List<IDomainEvent> publishedEvents = [];

  dynamic beginTransaction(String name) {
    final transaction = MockTransaction(name);
    transactions.add(transaction);
    return transaction;
  }

  void publishEvent(IDomainEvent event) {
    publishedEvents.add(event);
  }
}

/// Mock transaction
class MockTransaction {
  final String name;
  bool isCommitted = false;
  bool isRolledBack = false;

  MockTransaction(this.name);

  void commit() {
    isCommitted = true;
    print('✅ Transaction committed: $name');
  }

  void rollback() {
    isRolledBack = true;
    print('🔄 Transaction rolled back: $name');
  }
}

/// In-memory database for event store
class InMemoryDatabase {
  final Map<String, dynamic> _data = {};

  Future<void> transaction(Future<void> Function() operation) async {
    await operation();
  }

  Future<void> customInsert(String sql, {List<dynamic>? variables}) async {
    // Mock implementation for event storage
  }

  Future<QueryResult> customSelect(String sql, {List<dynamic>? variables}) async {
    // Mock implementation for event retrieval
    return QueryResult([]);
  }

  Future<void> customStatement(String sql) async {
    // Mock implementation for DDL
  }
}

/// Mock query result
class QueryResult {
  final List<QueryRow> _rows;

  QueryResult(this._rows);

  Future<List<QueryRow>> get() async => _rows;
  Future<QueryRow?> getSingleOrNull() async => _rows.isEmpty ? null : _rows.first;
}

/// Mock query row
class QueryRow {
  final Map<String, dynamic> _data;

  QueryRow(this._data);

  T read<T>(String column) => _data[column] as T;
}

/// Mock variable for SQL parameters
class Variable {
  final dynamic value;
  Variable(this.value);
}

/// Validation result for command validation
class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  ValidationResult._(this.isValid, this.errorMessage);

  factory ValidationResult.success() => ValidationResult._(true, null);
  factory ValidationResult.failure(String message) => ValidationResult._(false, message);
}