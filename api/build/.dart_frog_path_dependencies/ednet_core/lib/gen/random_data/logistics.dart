part of ednet_core;

/// Logistics and Supply Chain domain semantic data
///
/// Provides semantically coherent test data for logistics domains including
/// shipments, warehouses, inventory, carriers, and supply chain workflows.
class LogisticsDomain {
  /// Shipment statuses
  static const shipmentStatuses = [
    'Created',
    'PickedUp',
    'InTransit',
    'AtHub',
    'OutForDelivery',
    'Delivered',
    'Failed',
    'Returned',
    'Cancelled',
  ];

  /// Carrier types
  static const carrierTypes = ['Ground', 'Air', 'Sea', 'Rail', 'Intermodal'];

  /// Carrier companies
  static const carriers = <Carrier>[
    Carrier(
      id: 'CARR-001',
      name: 'FastShip Logistics',
      type: 'Ground',
      serviceAreas: ['US', 'CA', 'MX'],
      deliverySpeed: 'Standard',
      trackingCapability: true,
    ),
    Carrier(
      id: 'CARR-002',
      name: 'AirExpress Global',
      type: 'Air',
      serviceAreas: ['Worldwide'],
      deliverySpeed: 'Express',
      trackingCapability: true,
    ),
    Carrier(
      id: 'CARR-003',
      name: 'Ocean Freight Co',
      type: 'Sea',
      serviceAreas: ['International'],
      deliverySpeed: 'Economy',
      trackingCapability: true,
    ),
  ];

  /// Warehouse locations
  static const warehouses = <Warehouse>[
    Warehouse(
      id: 'WH-001',
      name: 'North Distribution Center',
      location: 'Chicago, IL',
      capacity: 50000,
      currentUtilization: 42000,
      type: 'Distribution',
    ),
    Warehouse(
      id: 'WH-002',
      name: 'West Coast Hub',
      location: 'Los Angeles, CA',
      capacity: 75000,
      currentUtilization: 68000,
      type: 'Fulfillment',
    ),
    Warehouse(
      id: 'WH-003',
      name: 'East Regional Depot',
      location: 'Newark, NJ',
      capacity: 40000,
      currentUtilization: 35000,
      type: 'Distribution',
    ),
  ];

  /// Package types
  static const packageTypes = [
    'Envelope',
    'SmallParcel',
    'MediumBox',
    'LargeBox',
    'Pallet',
    'Container',
    'Fragile',
    'Perishable',
    'HazardousMaterial',
  ];

  /// Inventory operations
  static const inventoryOperations = [
    'StockReceived',
    'StockAllocated',
    'StockPicked',
    'StockPacked',
    'StockShipped',
    'StockReturned',
    'StockDamaged',
    'StockCycleCount',
    'StockAdjustment',
  ];

  /// Shipment scenarios
  static const shipmentScenarios = <ShipmentScenario>[
    ShipmentScenario(
      trackingNumber: 'TRK-1001-ABC',
      origin: 'Chicago, IL',
      destination: 'New York, NY',
      weight: 5.2,
      dimensions: '12x10x8',
      carrier: 'FastShip Logistics',
      service: 'Ground',
      estimatedDays: 3,
      insured: true,
      insuranceValue: 250.00,
    ),
    ShipmentScenario(
      trackingNumber: 'TRK-1002-XYZ',
      origin: 'Los Angeles, CA',
      destination: 'Tokyo, Japan',
      weight: 25.8,
      dimensions: '24x20x16',
      carrier: 'AirExpress Global',
      service: 'Express',
      estimatedDays: 2,
      insured: true,
      insuranceValue: 5000.00,
    ),
  ];

  /// Route optimization factors
  static const routeOptimizationFactors = [
    'Distance',
    'Time',
    'Cost',
    'FuelEfficiency',
    'TrafficConditions',
    'WeatherConditions',
    'DeliveryWindows',
    'VehicleCapacity',
  ];

  /// Logistics domain events
  static const domainEvents = [
    'ShipmentCreated',
    'ShipmentPickedUp',
    'ShipmentInTransit',
    'ShipmentAtHub',
    'ShipmentOutForDelivery',
    'ShipmentDelivered',
    'ShipmentDelayed',
    'ShipmentException',
    'InventoryReceived',
    'InventoryAllocated',
    'InventoryDepleted',
    'WarehouseCapacityReached',
    'RouteOptimized',
    'CarrierAssigned',
  ];

  /// BDD scenario templates for logistics
  static const bddScenarios = <BDDScenario>[
    BDDScenario(
      feature: 'Shipment Tracking',
      scenario: 'Customer tracks package delivery',
      given: [
        'Shipment has been created',
        'Carrier has picked up package',
        'Tracking number is active',
      ],
      when: [
        'Package moves through transit hubs',
        'Each location scan updates status',
        'Package reaches delivery facility',
      ],
      then: [
        'ShipmentInTransit events are published',
        'Tracking history is updated',
        'Customer receives status notifications',
        'Estimated delivery time is updated',
      ],
    ),
    BDDScenario(
      feature: 'Warehouse Fulfillment',
      scenario: 'Order is fulfilled from warehouse',
      given: [
        'Order requires items from warehouse',
        'Items are in stock',
        'Warehouse has capacity',
      ],
      when: [
        'Order is received by warehouse',
        'Items are picked from inventory',
        'Items are packed for shipment',
        'Shipment is created',
      ],
      then: [
        'InventoryAllocated event is published',
        'Stock levels are updated',
        'ShipmentCreated event is triggered',
        'Carrier is assigned',
        'Tracking information is generated',
      ],
    ),
    BDDScenario(
      feature: 'Route Optimization',
      scenario: 'System optimizes delivery route',
      given: [
        'Multiple deliveries are scheduled',
        'Vehicle capacity is known',
        'Delivery time windows are defined',
      ],
      when: [
        'Route optimization algorithm runs',
        'Factors like distance and traffic are analyzed',
        'Optimal route is calculated',
      ],
      then: [
        'RouteOptimized event is published',
        'Driver receives updated route',
        'Delivery sequence is optimized',
        'Estimated times are recalculated',
      ],
    ),
  ];

  /// Warehouse operations
  static const warehouseOperations = [
    'Receiving',
    'PutAway',
    'Picking',
    'Packing',
    'Shipping',
    'Returns',
    'QualityControl',
    'CycleCount',
  ];

  /// Temperature zones (for perishables)
  static const temperatureZones = [
    'Ambient',
    'Refrigerated',
    'Frozen',
    'DeepFrozen',
    'ClimateControlled',
  ];
}

/// Carrier model
class Carrier {
  final String id;
  final String name;
  final String type;
  final List<String> serviceAreas;
  final String deliverySpeed;
  final bool trackingCapability;

  const Carrier({
    required this.id,
    required this.name,
    required this.type,
    required this.serviceAreas,
    required this.deliverySpeed,
    required this.trackingCapability,
  });
}

/// Warehouse model
class Warehouse {
  final String id;
  final String name;
  final String location;
  final int capacity;
  final int currentUtilization;
  final String type;

  const Warehouse({
    required this.id,
    required this.name,
    required this.location,
    required this.capacity,
    required this.currentUtilization,
    required this.type,
  });
}

/// Shipment scenario model
class ShipmentScenario {
  final String trackingNumber;
  final String origin;
  final String destination;
  final double weight;
  final String dimensions;
  final String carrier;
  final String service;
  final int estimatedDays;
  final bool insured;
  final double insuranceValue;

  const ShipmentScenario({
    required this.trackingNumber,
    required this.origin,
    required this.destination,
    required this.weight,
    required this.dimensions,
    required this.carrier,
    required this.service,
    required this.estimatedDays,
    required this.insured,
    required this.insuranceValue,
  });
}
