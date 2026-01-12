import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

/// Test query for retrieving order summaries
class GetOrderSummariesQuery extends CqrsQuery<List<OrderSummaryReadModel>> {
  final String? status;
  final double? minAmount;
  final int? limit;

  GetOrderSummariesQuery({this.status, this.minAmount, this.limit});

  @override
  String get queryName => 'GetOrderSummaries';

  @override
  Map<String, dynamic> get parameters => {
    if (status != null) 'status': status,
    if (minAmount != null) 'minAmount': minAmount,
    if (limit != null) 'limit': limit,
  };
}

/// Test query for retrieving a specific order by ID
class GetOrderByIdQuery extends CqrsQuery<OrderSummaryReadModel?> {
  final String orderId;

  GetOrderByIdQuery(this.orderId);

  @override
  String get queryName => 'GetOrderById';

  @override
  Map<String, dynamic> get parameters => {'orderId': orderId};
}

/// Test query for customer profile retrieval
class GetCustomerProfileQuery extends CqrsQuery<CustomerProfileReadModel?> {
  final String customerId;

  GetCustomerProfileQuery(this.customerId);

  @override
  String get queryName => 'GetCustomerProfile';

  @override
  Map<String, dynamic> get parameters => {'customerId': customerId};
}

/// Test query for customer statistics
class GetCustomerStatisticsQuery extends CqrsQuery<Map<String, dynamic>> {
  final String? tier;
  final bool includeTotals;

  GetCustomerStatisticsQuery({this.tier, this.includeTotals = true});

  @override
  String get queryName => 'GetCustomerStatistics';

  @override
  Map<String, dynamic> get parameters => {
    if (tier != null) 'tier': tier,
    'includeTotals': includeTotals,
  };
}

/// Test query handler for order summary queries
class OrderSummaryQueryHandler
    implements
        IQueryHandler<GetOrderSummariesQuery, List<OrderSummaryReadModel>> {
  final IReadModelRepository<OrderSummaryReadModel> _repository;

  OrderSummaryQueryHandler(this._repository);

  @override
  String get handlerType => 'OrderSummaryQueryHandler';

  @override
  int get priority => 100;

  @override
  bool canHandle(CqrsQuery query) {
    return query is GetOrderSummariesQuery;
  }

  @override
  Future<List<OrderSummaryReadModel>> handle(
    GetOrderSummariesQuery query,
  ) async {
    // Build criteria based on query parameters
    final criteria = <String, dynamic>{};

    if (query.limit != null) {
      criteria['limit'] = query.limit;
    }

    var results = await _repository.query(criteria);

    // Apply filtering based on query parameters
    if (query.status != null) {
      results = results.where((order) => order.status == query.status).toList();
    }

    if (query.minAmount != null) {
      results = results
          .where((order) => order.totalAmount >= query.minAmount!)
          .toList();
    }

    return results;
  }
}

/// Test query handler for single order retrieval
class OrderByIdQueryHandler
    implements IQueryHandler<GetOrderByIdQuery, OrderSummaryReadModel?> {
  final IReadModelRepository<OrderSummaryReadModel> _repository;

  OrderByIdQueryHandler(this._repository);

  @override
  String get handlerType => 'OrderByIdQueryHandler';

  @override
  int get priority => 100;

  @override
  bool canHandle(CqrsQuery query) {
    return query is GetOrderByIdQuery;
  }

  @override
  Future<OrderSummaryReadModel?> handle(GetOrderByIdQuery query) async {
    return await _repository.getById(query.orderId);
  }
}

/// Test query handler for customer profile queries
class CustomerProfileQueryHandler
    implements
        IQueryHandler<GetCustomerProfileQuery, CustomerProfileReadModel?> {
  final IReadModelRepository<CustomerProfileReadModel> _repository;

  CustomerProfileQueryHandler(this._repository);

  @override
  String get handlerType => 'CustomerProfileQueryHandler';

  @override
  int get priority => 100;

  @override
  bool canHandle(CqrsQuery query) {
    return query is GetCustomerProfileQuery;
  }

  @override
  Future<CustomerProfileReadModel?> handle(
    GetCustomerProfileQuery query,
  ) async {
    return await _repository.getById(query.customerId);
  }
}

/// Test query handler for customer statistics
class CustomerStatisticsQueryHandler
    implements IQueryHandler<GetCustomerStatisticsQuery, Map<String, dynamic>> {
  final IReadModelRepository<CustomerProfileReadModel> _repository;

  CustomerStatisticsQueryHandler(this._repository);

  @override
  String get handlerType => 'CustomerStatisticsQueryHandler';

  @override
  int get priority => 100;

  @override
  bool canHandle(CqrsQuery query) {
    return query is GetCustomerStatisticsQuery;
  }

  @override
  Future<Map<String, dynamic>> handle(GetCustomerStatisticsQuery query) async {
    final allCustomers = await _repository.getAll();

    var customers = allCustomers;
    if (query.tier != null) {
      customers = customers.where((c) => c.customerTier == query.tier).toList();
    }

    final stats = <String, dynamic>{
      'totalCustomers': customers.length,
      'averageOrders': customers.isEmpty
          ? 0.0
          : customers.map((c) => c.totalOrders).reduce((a, b) => a + b) /
                customers.length,
      'averageSpent': customers.isEmpty
          ? 0.0
          : customers.map((c) => c.totalSpent).reduce((a, b) => a + b) /
                customers.length,
    };

    if (query.includeTotals) {
      stats['totalOrders'] = customers
          .map((c) => c.totalOrders)
          .fold(0, (a, b) => a + b);
      stats['totalRevenue'] = customers
          .map((c) => c.totalSpent)
          .fold(0.0, (a, b) => a + b);
    }

    return stats;
  }
}

/// Test read models (simplified versions for testing)
class OrderSummaryReadModel extends ReadModel {
  final String orderId;
  final String customerName;
  final double totalAmount;
  final String status;
  final DateTime orderDate;

  OrderSummaryReadModel({
    required this.orderId,
    required this.customerName,
    required this.totalAmount,
    required this.status,
    required this.orderDate,
    DateTime? lastUpdated,
  }) : super(id: orderId, lastUpdated: lastUpdated ?? DateTime.now());

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'orderId': orderId,
    'customerName': customerName,
    'totalAmount': totalAmount,
    'status': status,
    'orderDate': orderDate.toIso8601String(),
    'lastUpdated': lastUpdated.toIso8601String(),
  };
}

class CustomerProfileReadModel extends ReadModel {
  final String customerId;
  final String name;
  final String email;
  final int totalOrders;
  final double totalSpent;
  final String customerTier;

  CustomerProfileReadModel({
    required this.customerId,
    required this.name,
    required this.email,
    required this.totalOrders,
    required this.totalSpent,
    required this.customerTier,
    DateTime? lastUpdated,
  }) : super(id: customerId, lastUpdated: lastUpdated ?? DateTime.now());

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'customerId': customerId,
    'name': name,
    'email': email,
    'totalOrders': totalOrders,
    'totalSpent': totalSpent,
    'customerTier': customerTier,
    'lastUpdated': lastUpdated.toIso8601String(),
  };
}

void main() {
  group('CQRS Query Tests', () {
    group('Query Base Class', () {
      test('should create query with name and parameters', () {
        // Arrange & Act
        final query = GetOrderSummariesQuery(
          status: 'Completed',
          minAmount: 100.0,
          limit: 10,
        );

        // Assert
        expect(query.queryName, equals('GetOrderSummaries'));
        expect(query.parameters['status'], equals('Completed'));
        expect(query.parameters['minAmount'], equals(100.0));
        expect(query.parameters['limit'], equals(10));
      });

      test('should handle optional parameters correctly', () {
        // Arrange & Act
        final query = GetOrderSummariesQuery(); // No parameters

        // Assert
        expect(query.queryName, equals('GetOrderSummaries'));
        expect(query.parameters.isEmpty, isTrue);
      });

      test('should create single-parameter query', () {
        // Arrange & Act
        final query = GetOrderByIdQuery('order-123');

        // Assert
        expect(query.queryName, equals('GetOrderById'));
        expect(query.parameters['orderId'], equals('order-123'));
      });

      test('should handle boolean parameters', () {
        // Arrange & Act
        final query = GetCustomerStatisticsQuery(
          tier: 'Gold',
          includeTotals: false,
        );

        // Assert
        expect(query.queryName, equals('GetCustomerStatistics'));
        expect(query.parameters['tier'], equals('Gold'));
        expect(query.parameters['includeTotals'], equals(false));
      });
    });

    group('Query Handler Implementation', () {
      late InMemoryReadModelRepository<OrderSummaryReadModel> orderRepository;
      late InMemoryReadModelRepository<CustomerProfileReadModel>
      customerRepository;
      late OrderSummaryQueryHandler orderHandler;
      late OrderByIdQueryHandler orderByIdHandler;
      late CustomerProfileQueryHandler customerHandler;
      late CustomerStatisticsQueryHandler statsHandler;

      setUp(() {
        orderRepository = InMemoryReadModelRepository<OrderSummaryReadModel>();
        customerRepository =
            InMemoryReadModelRepository<CustomerProfileReadModel>();
        orderHandler = OrderSummaryQueryHandler(orderRepository);
        orderByIdHandler = OrderByIdQueryHandler(orderRepository);
        customerHandler = CustomerProfileQueryHandler(customerRepository);
        statsHandler = CustomerStatisticsQueryHandler(customerRepository);
      });

      test('should identify handleable queries correctly', () {
        // Arrange
        final orderSummariesQuery = GetOrderSummariesQuery();
        final orderByIdQuery = GetOrderByIdQuery('order-123');
        final customerQuery = GetCustomerProfileQuery('customer-456');
        final statsQuery = GetCustomerStatisticsQuery();

        // Act & Assert
        expect(orderHandler.canHandle(orderSummariesQuery), isTrue);
        expect(orderHandler.canHandle(orderByIdQuery), isFalse);
        expect(orderHandler.canHandle(customerQuery), isFalse);

        expect(orderByIdHandler.canHandle(orderByIdQuery), isTrue);
        expect(orderByIdHandler.canHandle(orderSummariesQuery), isFalse);

        expect(customerHandler.canHandle(customerQuery), isTrue);
        expect(customerHandler.canHandle(orderByIdQuery), isFalse);

        expect(statsHandler.canHandle(statsQuery), isTrue);
        expect(statsHandler.canHandle(customerQuery), isFalse);
      });

      test('should handle order summaries query with filters', () async {
        // Arrange - add test data
        final orders = [
          OrderSummaryReadModel(
            orderId: 'order-1',
            customerName: 'John Doe',
            totalAmount: 150.0,
            status: 'Completed',
            orderDate: DateTime.now(),
          ),
          OrderSummaryReadModel(
            orderId: 'order-2',
            customerName: 'Jane Smith',
            totalAmount: 75.0,
            status: 'Pending',
            orderDate: DateTime.now(),
          ),
          OrderSummaryReadModel(
            orderId: 'order-3',
            customerName: 'Bob Johnson',
            totalAmount: 200.0,
            status: 'Completed',
            orderDate: DateTime.now(),
          ),
        ];

        for (final order in orders) {
          await orderRepository.save(order);
        }

        final query = GetOrderSummariesQuery(
          status: 'Completed',
          minAmount: 100.0,
        );

        // Act
        final results = await orderHandler.handle(query);

        // Assert
        expect(results.length, equals(2));
        expect(results.any((o) => o.orderId == 'order-1'), isTrue);
        expect(results.any((o) => o.orderId == 'order-3'), isTrue);
        expect(
          results.any((o) => o.orderId == 'order-2'),
          isFalse,
        ); // Filtered out
      });

      test('should handle order by ID query', () async {
        // Arrange
        final order = OrderSummaryReadModel(
          orderId: 'order-123',
          customerName: 'John Doe',
          totalAmount: 150.0,
          status: 'Completed',
          orderDate: DateTime.now(),
        );
        await orderRepository.save(order);

        final query = GetOrderByIdQuery('order-123');

        // Act
        final result = await orderByIdHandler.handle(query);

        // Assert
        expect(result, isNotNull);
        expect(result!.orderId, equals('order-123'));
        expect(result.customerName, equals('John Doe'));
        expect(result.totalAmount, equals(150.0));
      });

      test('should return null for non-existent order', () async {
        // Arrange
        final query = GetOrderByIdQuery('non-existent-order');

        // Act
        final result = await orderByIdHandler.handle(query);

        // Assert
        expect(result, isNull);
      });

      test('should handle customer profile query', () async {
        // Arrange
        final customer = CustomerProfileReadModel(
          customerId: 'customer-123',
          name: 'Alice Johnson',
          email: 'alice@example.com',
          totalOrders: 5,
          totalSpent: 750.0,
          customerTier: 'Silver',
        );
        await customerRepository.save(customer);

        final query = GetCustomerProfileQuery('customer-123');

        // Act
        final result = await customerHandler.handle(query);

        // Assert
        expect(result, isNotNull);
        expect(result!.customerId, equals('customer-123'));
        expect(result.name, equals('Alice Johnson'));
        expect(result.customerTier, equals('Silver'));
      });

      test('should handle customer statistics query', () async {
        // Arrange
        final customers = [
          CustomerProfileReadModel(
            customerId: 'customer-1',
            name: 'Alice',
            email: 'alice@example.com',
            totalOrders: 5,
            totalSpent: 500.0,
            customerTier: 'Silver',
          ),
          CustomerProfileReadModel(
            customerId: 'customer-2',
            name: 'Bob',
            email: 'bob@example.com',
            totalOrders: 10,
            totalSpent: 1000.0,
            customerTier: 'Gold',
          ),
          CustomerProfileReadModel(
            customerId: 'customer-3',
            name: 'Charlie',
            email: 'charlie@example.com',
            totalOrders: 2,
            totalSpent: 200.0,
            customerTier: 'Bronze',
          ),
        ];

        for (final customer in customers) {
          await customerRepository.save(customer);
        }

        final query = GetCustomerStatisticsQuery(includeTotals: true);

        // Act
        final result = await statsHandler.handle(query);

        // Assert
        expect(result['totalCustomers'], equals(3));
        expect(result['averageOrders'], equals(17 / 3)); // (5+10+2)/3
        expect(result['averageSpent'], equals(1700.0 / 3)); // (500+1000+200)/3
        expect(result['totalOrders'], equals(17));
        expect(result['totalRevenue'], equals(1700.0));
      });

      test('should filter customer statistics by tier', () async {
        // Arrange
        final customers = [
          CustomerProfileReadModel(
            customerId: 'customer-1',
            name: 'Alice',
            email: 'alice@example.com',
            totalOrders: 5,
            totalSpent: 500.0,
            customerTier: 'Silver',
          ),
          CustomerProfileReadModel(
            customerId: 'customer-2',
            name: 'Bob',
            email: 'bob@example.com',
            totalOrders: 10,
            totalSpent: 1000.0,
            customerTier: 'Gold',
          ),
        ];

        for (final customer in customers) {
          await customerRepository.save(customer);
        }

        final query = GetCustomerStatisticsQuery(tier: 'Gold');

        // Act
        final result = await statsHandler.handle(query);

        // Assert
        expect(result['totalCustomers'], equals(1));
        expect(result['averageOrders'], equals(10.0));
        expect(result['averageSpent'], equals(1000.0));
      });
    });

    group('Query Bus', () {
      late QueryBus queryBus;
      late InMemoryReadModelRepository<OrderSummaryReadModel> orderRepository;
      late InMemoryReadModelRepository<CustomerProfileReadModel>
      customerRepository;

      setUp(() {
        queryBus = QueryBus();
        orderRepository = InMemoryReadModelRepository<OrderSummaryReadModel>();
        customerRepository =
            InMemoryReadModelRepository<CustomerProfileReadModel>();

        // Register handlers
        queryBus.registerHandler(OrderSummaryQueryHandler(orderRepository));
        queryBus.registerHandler(OrderByIdQueryHandler(orderRepository));
        queryBus.registerHandler(
          CustomerProfileQueryHandler(customerRepository),
        );
        queryBus.registerHandler(
          CustomerStatisticsQueryHandler(customerRepository),
        );
      });

      test('should execute order summaries query through bus', () async {
        // Arrange
        final order = OrderSummaryReadModel(
          orderId: 'order-123',
          customerName: 'John Doe',
          totalAmount: 150.0,
          status: 'Completed',
          orderDate: DateTime.now(),
        );
        await orderRepository.save(order);

        final query = GetOrderSummariesQuery(status: 'Completed');

        // Act
        final results = await queryBus.execute(query);

        // Assert
        expect(results, isA<List<OrderSummaryReadModel>>());
        final orderResults = results;
        expect(orderResults.length, equals(1));
        expect(orderResults.first.orderId, equals('order-123'));
      });

      test('should execute order by ID query through bus', () async {
        // Arrange
        final order = OrderSummaryReadModel(
          orderId: 'order-456',
          customerName: 'Jane Smith',
          totalAmount: 200.0,
          status: 'Pending',
          orderDate: DateTime.now(),
        );
        await orderRepository.save(order);

        final query = GetOrderByIdQuery('order-456');

        // Act
        final result = await queryBus.execute(query);

        // Assert
        expect(result, isA<OrderSummaryReadModel>());
        final orderResult = result as OrderSummaryReadModel;
        expect(orderResult.orderId, equals('order-456'));
        expect(orderResult.customerName, equals('Jane Smith'));
      });

      test('should execute customer profile query through bus', () async {
        // Arrange
        final customer = CustomerProfileReadModel(
          customerId: 'customer-789',
          name: 'Bob Johnson',
          email: 'bob@example.com',
          totalOrders: 3,
          totalSpent: 300.0,
          customerTier: 'Bronze',
        );
        await customerRepository.save(customer);

        final query = GetCustomerProfileQuery('customer-789');

        // Act
        final result = await queryBus.execute(query);

        // Assert
        expect(result, isA<CustomerProfileReadModel>());
        final customerResult = result as CustomerProfileReadModel;
        expect(customerResult.customerId, equals('customer-789'));
        expect(customerResult.name, equals('Bob Johnson'));
      });

      test('should execute customer statistics query through bus', () async {
        // Arrange
        final customer = CustomerProfileReadModel(
          customerId: 'customer-1',
          name: 'Test Customer',
          email: 'test@example.com',
          totalOrders: 5,
          totalSpent: 500.0,
          customerTier: 'Silver',
        );
        await customerRepository.save(customer);

        final query = GetCustomerStatisticsQuery();

        // Act
        final result = await queryBus.execute(query);

        // Assert
        expect(result, isA<Map<String, dynamic>>());
        final statsResult = result;
        expect(statsResult['totalCustomers'], equals(1));
        expect(statsResult['averageOrders'], equals(5.0));
        expect(statsResult['averageSpent'], equals(500.0));
      });

      test('should throw exception for unhandled query', () async {
        // Arrange
        final emptyQueryBus = QueryBus(); // No handlers registered
        final query = GetOrderByIdQuery('order-123');

        // Act & Assert
        expect(() => emptyQueryBus.execute(query), throwsA(isA<StateError>()));
      });

      test('should provide query bus statistics', () {
        // Act
        final stats = queryBus.getStatistics();

        // Assert
        expect(stats['totalHandlers'], equals(4));
        expect(stats['totalQueriesExecuted'], equals(0));
        expect(stats.containsKey('handlers'), isTrue);

        final handlers = stats['handlers'] as Map<String, dynamic>;
        expect(handlers.length, equals(4));
      });

      test('should track query execution statistics', () async {
        // Arrange
        final order = OrderSummaryReadModel(
          orderId: 'order-123',
          customerName: 'John Doe',
          totalAmount: 150.0,
          status: 'Completed',
          orderDate: DateTime.now(),
        );
        await orderRepository.save(order);

        final query1 = GetOrderSummariesQuery();
        final query2 = GetOrderByIdQuery('order-123');

        // Act
        await queryBus.execute(query1);
        await queryBus.execute(query2);

        // Assert
        final stats = queryBus.getStatistics();
        expect(stats['totalQueriesExecuted'], equals(2));

        final handlers = stats['handlers'] as Map<String, dynamic>;
        final orderSummaryHandler = handlers.values.firstWhere(
          (h) =>
              h['handlerType'].toString().contains('OrderSummaryQueryHandler'),
        );
        final orderByIdHandler = handlers.values.firstWhere(
          (h) => h['handlerType'].toString().contains('OrderByIdQueryHandler'),
        );

        expect(orderSummaryHandler['queriesHandled'], equals(1));
        expect(orderByIdHandler['queriesHandled'], equals(1));
      });
    });
  });
}
