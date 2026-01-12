import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

/// Test read model for order summaries - implements the book Chapter 6 pattern
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

  static OrderSummaryReadModel fromJson(Map<String, dynamic> json) {
    return OrderSummaryReadModel(
      orderId: json['orderId'],
      customerName: json['customerName'],
      totalAmount: json['totalAmount'].toDouble(),
      status: json['status'],
      orderDate: DateTime.parse(json['orderDate']),
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }

  OrderSummaryReadModel copyWith({
    String? customerName,
    double? totalAmount,
    String? status,
    DateTime? orderDate,
  }) {
    return OrderSummaryReadModel(
      orderId: orderId,
      customerName: customerName ?? this.customerName,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      orderDate: orderDate ?? this.orderDate,
      lastUpdated: DateTime.now(),
    );
  }
}

/// Test read model for customer profiles
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

  static CustomerProfileReadModel fromJson(Map<String, dynamic> json) {
    return CustomerProfileReadModel(
      customerId: json['customerId'],
      name: json['name'],
      email: json['email'],
      totalOrders: json['totalOrders'],
      totalSpent: json['totalSpent'].toDouble(),
      customerTier: json['customerTier'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }
}

void main() {
  group('CQRS Read Model Tests', () {
    group('ReadModel Base Class', () {
      test('should create read model with required properties', () {
        // Arrange & Act
        final readModel = OrderSummaryReadModel(
          orderId: 'ORDER-123',
          customerName: 'John Doe',
          totalAmount: 150.99,
          status: 'Completed',
          orderDate: DateTime(2024, 12, 1),
        );

        // Assert
        expect(readModel.id, equals('ORDER-123'));
        expect(readModel.orderId, equals('ORDER-123'));
        expect(readModel.customerName, equals('John Doe'));
        expect(readModel.totalAmount, equals(150.99));
        expect(readModel.status, equals('Completed'));
        expect(readModel.lastUpdated, isA<DateTime>());
      });

      test('should serialize to JSON correctly', () {
        // Arrange
        final orderDate = DateTime(2024, 12, 1, 10, 30);
        final lastUpdated = DateTime(2024, 12, 1, 11, 0);
        final readModel = OrderSummaryReadModel(
          orderId: 'ORDER-123',
          customerName: 'John Doe',
          totalAmount: 150.99,
          status: 'Completed',
          orderDate: orderDate,
          lastUpdated: lastUpdated,
        );

        // Act
        final json = readModel.toJson();

        // Assert
        expect(json['id'], equals('ORDER-123'));
        expect(json['orderId'], equals('ORDER-123'));
        expect(json['customerName'], equals('John Doe'));
        expect(json['totalAmount'], equals(150.99));
        expect(json['status'], equals('Completed'));
        expect(json['orderDate'], equals(orderDate.toIso8601String()));
        expect(json['lastUpdated'], equals(lastUpdated.toIso8601String()));
      });

      test('should deserialize from JSON correctly', () {
        // Arrange
        final json = {
          'orderId': 'ORDER-123',
          'customerName': 'John Doe',
          'totalAmount': 150.99,
          'status': 'Completed',
          'orderDate': '2024-12-01T10:30:00.000',
          'lastUpdated': '2024-12-01T11:00:00.000',
        };

        // Act
        final readModel = OrderSummaryReadModel.fromJson(json);

        // Assert
        expect(readModel.id, equals('ORDER-123'));
        expect(readModel.orderId, equals('ORDER-123'));
        expect(readModel.customerName, equals('John Doe'));
        expect(readModel.totalAmount, equals(150.99));
        expect(readModel.status, equals('Completed'));
        expect(readModel.orderDate, equals(DateTime(2024, 12, 1, 10, 30)));
        expect(readModel.lastUpdated, equals(DateTime(2024, 12, 1, 11, 0)));
      });

      test('should support immutable updates with copyWith', () {
        // Arrange
        final original = OrderSummaryReadModel(
          orderId: 'ORDER-123',
          customerName: 'John Doe',
          totalAmount: 150.99,
          status: 'Pending',
          orderDate: DateTime(2024, 12, 1),
        );

        // Act
        final updated = original.copyWith(
          status: 'Completed',
          totalAmount: 175.50,
        );

        // Assert
        expect(updated.id, equals(original.id));
        expect(updated.orderId, equals(original.orderId));
        expect(updated.customerName, equals(original.customerName));
        expect(updated.orderDate, equals(original.orderDate));

        // Updated fields
        expect(updated.status, equals('Completed'));
        expect(updated.totalAmount, equals(175.50));
        expect(updated.lastUpdated.isAfter(original.lastUpdated), isTrue);

        // Original unchanged
        expect(original.status, equals('Pending'));
        expect(original.totalAmount, equals(150.99));
      });
    });

    group('Customer Profile Read Model', () {
      test('should create customer read model with all properties', () {
        // Arrange & Act
        final readModel = CustomerProfileReadModel(
          customerId: 'CUST-456',
          name: 'Jane Smith',
          email: 'jane@example.com',
          totalOrders: 5,
          totalSpent: 750.25,
          customerTier: 'Gold',
        );

        // Assert
        expect(readModel.id, equals('CUST-456'));
        expect(readModel.customerId, equals('CUST-456'));
        expect(readModel.name, equals('Jane Smith'));
        expect(readModel.email, equals('jane@example.com'));
        expect(readModel.totalOrders, equals(5));
        expect(readModel.totalSpent, equals(750.25));
        expect(readModel.customerTier, equals('Gold'));
        expect(readModel.lastUpdated, isA<DateTime>());
      });

      test('should serialize customer profile to JSON', () {
        // Arrange
        final lastUpdated = DateTime(2024, 12, 1, 12, 0);
        final readModel = CustomerProfileReadModel(
          customerId: 'CUST-456',
          name: 'Jane Smith',
          email: 'jane@example.com',
          totalOrders: 5,
          totalSpent: 750.25,
          customerTier: 'Gold',
          lastUpdated: lastUpdated,
        );

        // Act
        final json = readModel.toJson();

        // Assert
        expect(json['id'], equals('CUST-456'));
        expect(json['customerId'], equals('CUST-456'));
        expect(json['name'], equals('Jane Smith'));
        expect(json['email'], equals('jane@example.com'));
        expect(json['totalOrders'], equals(5));
        expect(json['totalSpent'], equals(750.25));
        expect(json['customerTier'], equals('Gold'));
        expect(json['lastUpdated'], equals(lastUpdated.toIso8601String()));
      });

      test('should deserialize customer profile from JSON', () {
        // Arrange
        final json = {
          'customerId': 'CUST-456',
          'name': 'Jane Smith',
          'email': 'jane@example.com',
          'totalOrders': 5,
          'totalSpent': 750.25,
          'customerTier': 'Gold',
          'lastUpdated': '2024-12-01T12:00:00.000',
        };

        // Act
        final readModel = CustomerProfileReadModel.fromJson(json);

        // Assert
        expect(readModel.id, equals('CUST-456'));
        expect(readModel.name, equals('Jane Smith'));
        expect(readModel.email, equals('jane@example.com'));
        expect(readModel.totalOrders, equals(5));
        expect(readModel.totalSpent, equals(750.25));
        expect(readModel.customerTier, equals('Gold'));
        expect(readModel.lastUpdated, equals(DateTime(2024, 12, 1, 12, 0)));
      });
    });

    group('Read Model Collection Management', () {
      test('should manage collection of read models', () {
        // Arrange
        final readModels = <String, OrderSummaryReadModel>{};

        final order1 = OrderSummaryReadModel(
          orderId: 'ORDER-001',
          customerName: 'John Doe',
          totalAmount: 100.0,
          status: 'Pending',
          orderDate: DateTime.now(),
        );

        final order2 = OrderSummaryReadModel(
          orderId: 'ORDER-002',
          customerName: 'Jane Smith',
          totalAmount: 200.0,
          status: 'Completed',
          orderDate: DateTime.now(),
        );

        // Act
        readModels[order1.id] = order1;
        readModels[order2.id] = order2;

        // Assert
        expect(readModels.length, equals(2));
        expect(readModels['ORDER-001'], equals(order1));
        expect(readModels['ORDER-002'], equals(order2));
      });

      test('should filter read models by criteria', () {
        // Arrange
        final orders = [
          OrderSummaryReadModel(
            orderId: 'ORDER-001',
            customerName: 'John Doe',
            totalAmount: 100.0,
            status: 'Pending',
            orderDate: DateTime.now(),
          ),
          OrderSummaryReadModel(
            orderId: 'ORDER-002',
            customerName: 'Jane Smith',
            totalAmount: 200.0,
            status: 'Completed',
            orderDate: DateTime.now(),
          ),
          OrderSummaryReadModel(
            orderId: 'ORDER-003',
            customerName: 'Bob Johnson',
            totalAmount: 150.0,
            status: 'Pending',
            orderDate: DateTime.now(),
          ),
        ];

        // Act
        final pendingOrders = orders
            .where((order) => order.status == 'Pending')
            .toList();
        final highValueOrders = orders
            .where((order) => order.totalAmount > 150.0)
            .toList();

        // Assert
        expect(pendingOrders.length, equals(2));
        expect(pendingOrders[0].orderId, equals('ORDER-001'));
        expect(pendingOrders[1].orderId, equals('ORDER-003'));

        expect(highValueOrders.length, equals(1));
        expect(highValueOrders[0].orderId, equals('ORDER-002'));
      });

      test('should sort read models by different criteria', () {
        // Arrange
        final date1 = DateTime(2024, 12, 1);
        final date2 = DateTime(2024, 12, 2);
        final date3 = DateTime(2024, 12, 3);

        final orders = [
          OrderSummaryReadModel(
            orderId: 'ORDER-002',
            customerName: 'Jane Smith',
            totalAmount: 200.0,
            status: 'Completed',
            orderDate: date2,
          ),
          OrderSummaryReadModel(
            orderId: 'ORDER-001',
            customerName: 'John Doe',
            totalAmount: 100.0,
            status: 'Pending',
            orderDate: date1,
          ),
          OrderSummaryReadModel(
            orderId: 'ORDER-003',
            customerName: 'Bob Johnson',
            totalAmount: 150.0,
            status: 'Pending',
            orderDate: date3,
          ),
        ];

        // Act
        final sortedByDate = List.from(orders)
          ..sort((a, b) => a.orderDate.compareTo(b.orderDate));

        // Assert - sorted by date (ascending)
        expect(sortedByDate[0].orderId, equals('ORDER-001'));
        expect(sortedByDate[1].orderId, equals('ORDER-002'));
        expect(sortedByDate[2].orderId, equals('ORDER-003'));

        // Sort by amount (descending)
        final sortedByAmount = List.from(orders)
          ..sort((a, b) => b.totalAmount.compareTo(a.totalAmount));
        expect(sortedByAmount[0].totalAmount, equals(200.0));
        expect(sortedByAmount[1].totalAmount, equals(150.0));
        expect(sortedByAmount[2].totalAmount, equals(100.0));
      });
    });
  });
}
