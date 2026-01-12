part of ednet_core;

/// E-commerce domain semantic data
///
/// Provides semantically coherent test data for e-commerce domains including
/// products, orders, customers, inventory, and shopping workflows.
class ECommerceDomain {
  /// Product categories with hierarchical structure
  static const productCategories = <ProductCategory>[
    ProductCategory(
      id: 'electronics',
      name: 'Electronics',
      subcategories: [
        'Laptops',
        'Smartphones',
        'Tablets',
        'Accessories',
        'Wearables',
      ],
    ),
    ProductCategory(
      id: 'clothing',
      name: 'Clothing & Apparel',
      subcategories: [
        'Men\'s Wear',
        'Women\'s Wear',
        'Children\'s Wear',
        'Accessories',
        'Footwear',
      ],
    ),
    ProductCategory(
      id: 'home',
      name: 'Home & Garden',
      subcategories: [
        'Furniture',
        'Kitchen',
        'Decor',
        'Garden Tools',
        'Bedding',
      ],
    ),
    ProductCategory(
      id: 'books',
      name: 'Books & Media',
      subcategories: [
        'Fiction',
        'Non-Fiction',
        'Educational',
        'E-books',
        'Audiobooks',
      ],
    ),
  ];

  /// Sample product data with realistic attributes
  static const products = <ProductData>[
    ProductData(
      sku: 'LAPTOP-HP-001',
      name: 'HP Pavilion 15 Laptop',
      category: 'Electronics',
      subcategory: 'Laptops',
      price: 899.99,
      currency: 'USD',
      description: 'Intel i5, 8GB RAM, 512GB SSD',
      inStock: true,
      stockQuantity: 45,
      tags: ['laptops', 'hp', 'portable', 'work'],
    ),
    ProductData(
      sku: 'PHONE-SAMS-002',
      name: 'Samsung Galaxy S23',
      category: 'Electronics',
      subcategory: 'Smartphones',
      price: 799.99,
      currency: 'USD',
      description: '6.1" display, 128GB storage, 5G',
      inStock: true,
      stockQuantity: 120,
      tags: ['smartphone', 'samsung', '5g', 'android'],
    ),
    ProductData(
      sku: 'SHIRT-MEN-003',
      name: 'Classic Cotton Oxford Shirt',
      category: 'Clothing',
      subcategory: 'Men\'s Wear',
      price: 49.99,
      currency: 'USD',
      description: '100% cotton, button-down collar',
      inStock: true,
      stockQuantity: 200,
      tags: ['shirt', 'cotton', 'formal', 'mens'],
    ),
    ProductData(
      sku: 'BOOK-FIC-004',
      name: 'The Midnight Library',
      category: 'Books',
      subcategory: 'Fiction',
      price: 16.99,
      currency: 'USD',
      description: 'By Matt Haig - Bestseller',
      inStock: true,
      stockQuantity: 88,
      tags: ['fiction', 'bestseller', 'novel'],
    ),
  ];

  /// Customer persona templates for realistic test scenarios
  static const customerPersonas = <CustomerPersona>[
    CustomerPersona(
      type: 'FrequentShopper',
      firstName: 'Sarah',
      lastName: 'Johnson',
      email: 'sarah.johnson@example.com',
      loyaltyTier: 'Gold',
      averageOrderValue: 150.00,
      orderFrequency: 'Weekly',
      preferredCategories: ['Electronics', 'Books'],
    ),
    CustomerPersona(
      type: 'OccasionalBuyer',
      firstName: 'Michael',
      lastName: 'Chen',
      email: 'michael.chen@example.com',
      loyaltyTier: 'Silver',
      averageOrderValue: 85.00,
      orderFrequency: 'Monthly',
      preferredCategories: ['Clothing', 'Home'],
    ),
    CustomerPersona(
      type: 'NewCustomer',
      firstName: 'Emily',
      lastName: 'Davis',
      email: 'emily.davis@example.com',
      loyaltyTier: 'Bronze',
      averageOrderValue: 45.00,
      orderFrequency: 'First Purchase',
      preferredCategories: ['Books'],
    ),
  ];

  /// Order status workflow states
  static const orderStatuses = [
    'Pending',
    'PaymentReceived',
    'Processing',
    'Shipped',
    'InTransit',
    'OutForDelivery',
    'Delivered',
    'Cancelled',
    'Refunded',
  ];

  /// Payment methods
  static const paymentMethods = [
    'CreditCard',
    'DebitCard',
    'PayPal',
    'ApplePay',
    'GooglePay',
    'BankTransfer',
    'CashOnDelivery',
  ];

  /// Shipping methods with typical delivery times
  static const shippingMethods = <ShippingMethod>[
    ShippingMethod(
      id: 'standard',
      name: 'Standard Shipping',
      cost: 5.99,
      deliveryDays: '5-7',
      trackingAvailable: true,
    ),
    ShippingMethod(
      id: 'express',
      name: 'Express Shipping',
      cost: 15.99,
      deliveryDays: '2-3',
      trackingAvailable: true,
    ),
    ShippingMethod(
      id: 'overnight',
      name: 'Overnight Delivery',
      cost: 29.99,
      deliveryDays: '1',
      trackingAvailable: true,
    ),
    ShippingMethod(
      id: 'free',
      name: 'Free Shipping (over \$50)',
      cost: 0.00,
      deliveryDays: '7-10',
      trackingAvailable: false,
    ),
  ];

  /// Typical e-commerce domain events
  static const domainEvents = [
    'ProductCreated',
    'ProductUpdated',
    'ProductOutOfStock',
    'ProductRestocked',
    'OrderPlaced',
    'OrderConfirmed',
    'PaymentProcessed',
    'PaymentFailed',
    'OrderShipped',
    'OrderDelivered',
    'OrderCancelled',
    'RefundRequested',
    'RefundProcessed',
    'CustomerRegistered',
    'CartAbandoned',
    'WishlistItemAdded',
  ];

  /// BDD scenario templates for e-commerce
  static const bddScenarios = <BDDScenario>[
    BDDScenario(
      feature: 'Product Purchase',
      scenario: 'Customer completes successful purchase',
      given: [
        'Customer is logged in',
        'Product is in stock',
        'Customer has valid payment method',
      ],
      when: [
        'Customer adds product to cart',
        'Customer proceeds to checkout',
        'Customer confirms payment',
      ],
      then: [
        'Order is created with status Pending',
        'Payment is processed',
        'Order status changes to PaymentReceived',
        'Customer receives order confirmation email',
      ],
    ),
    BDDScenario(
      feature: 'Inventory Management',
      scenario: 'Product goes out of stock',
      given: [
        'Product has low stock quantity',
        'Multiple customers are viewing product',
      ],
      when: [
        'Customer purchases last available item',
        'Stock quantity reaches zero',
      ],
      then: [
        'ProductOutOfStock event is published',
        'Product is marked as unavailable',
        'Restocking notification is sent to warehouse',
        'Waiting list is created for interested customers',
      ],
    ),
    BDDScenario(
      feature: 'Order Cancellation',
      scenario: 'Customer cancels order before shipping',
      given: [
        'Customer has placed order',
        'Order status is Processing',
        'Order has not been shipped',
      ],
      when: ['Customer requests cancellation', 'Cancellation is confirmed'],
      then: [
        'Order status changes to Cancelled',
        'Payment refund is initiated',
        'Inventory is restored',
        'OrderCancelled event is published',
      ],
    ),
  ];
}

/// Product category structure
class ProductCategory {
  final String id;
  final String name;
  final List<String> subcategories;

  const ProductCategory({
    required this.id,
    required this.name,
    required this.subcategories,
  });
}

/// Product data model
class ProductData {
  final String sku;
  final String name;
  final String category;
  final String subcategory;
  final double price;
  final String currency;
  final String description;
  final bool inStock;
  final int stockQuantity;
  final List<String> tags;

  const ProductData({
    required this.sku,
    required this.name,
    required this.category,
    required this.subcategory,
    required this.price,
    required this.currency,
    required this.description,
    required this.inStock,
    required this.stockQuantity,
    required this.tags,
  });
}

/// Customer persona for test scenarios
class CustomerPersona {
  final String type;
  final String firstName;
  final String lastName;
  final String email;
  final String loyaltyTier;
  final double averageOrderValue;
  final String orderFrequency;
  final List<String> preferredCategories;

  const CustomerPersona({
    required this.type,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.loyaltyTier,
    required this.averageOrderValue,
    required this.orderFrequency,
    required this.preferredCategories,
  });
}

/// Shipping method details
class ShippingMethod {
  final String id;
  final String name;
  final double cost;
  final String deliveryDays;
  final bool trackingAvailable;

  const ShippingMethod({
    required this.id,
    required this.name,
    required this.cost,
    required this.deliveryDays,
    required this.trackingAvailable,
  });
}

/// BDD scenario template
class BDDScenario {
  final String feature;
  final String scenario;
  final List<String> given;
  final List<String> when;
  final List<String> then;

  const BDDScenario({
    required this.feature,
    required this.scenario,
    required this.given,
    required this.when,
    required this.then,
  });
}
