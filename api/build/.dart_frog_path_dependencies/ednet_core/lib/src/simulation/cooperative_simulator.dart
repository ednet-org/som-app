/// Cooperative simulation support for EDNet Core domain models
///
/// This module provides simulation capabilities for domain-driven design patterns
/// including cooperative multi-agent simulations and domain model interactions.
part of ednet_core;

/// Simple domain model implementation for simulator compatibility
///
/// Used by the microservice shell to create compatible domain models
/// for DSL interpretation and simulation scenarios.
class DomainModel {
  /// The name of the domain model
  final String name;

  /// Optional description of the domain model
  final String description;

  /// Additional properties for the domain model
  final Map<String, dynamic> properties;

  /// Creates a new domain model instance
  ///
  /// [name] is the required name identifier
  /// [description] is an optional description
  /// [properties] are additional key-value properties
  const DomainModel({
    required this.name,
    this.description = '',
    this.properties = const {},
  });

  /// Creates a copy of this domain model with updated fields
  DomainModel copyWith({
    String? name,
    String? description,
    Map<String, dynamic>? properties,
  }) {
    return DomainModel(
      name: name ?? this.name,
      description: description ?? this.description,
      properties: properties ?? this.properties,
    );
  }

  /// Converts this domain model to a JSON map
  Map<String, dynamic> toJson() {
    return {'name': name, 'description': description, 'properties': properties};
  }

  /// Creates a domain model from a JSON map
  factory DomainModel.fromJson(Map<String, dynamic> json) {
    return DomainModel(
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      properties: Map<String, dynamic>.from(json['properties'] as Map? ?? {}),
    );
  }

  @override
  String toString() => 'DomainModel(name: $name, description: $description)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DomainModel &&
        other.name == name &&
        other.description == description &&
        _mapEquals(other.properties, properties);
  }

  @override
  int get hashCode => Object.hash(name, description, properties);

  /// Helper method to compare maps for equality
  bool _mapEquals(Map<String, dynamic> map1, Map<String, dynamic> map2) {
    if (map1.length != map2.length) return false;
    for (final key in map1.keys) {
      if (!map2.containsKey(key) || map1[key] != map2[key]) {
        return false;
      }
    }
    return true;
  }
}

/// Cooperative simulator for multi-agent domain scenarios
///
/// Provides simulation capabilities for testing domain model interactions
/// and cooperative behavior patterns in distributed systems.
class CooperativeSimulator {
  /// The domain models participating in the simulation
  final List<DomainModel> domainModels;

  /// Simulation configuration parameters
  final Map<String, dynamic> config;

  /// Current simulation state
  bool _isRunning = false;

  /// Creates a new cooperative simulator
  ///
  /// [domainModels] are the domain models to simulate
  /// [config] contains simulation parameters
  CooperativeSimulator({required this.domainModels, this.config = const {}});

  /// Whether the simulation is currently running
  bool get isRunning => _isRunning;

  /// Starts the cooperative simulation
  ///
  /// Returns true if simulation started successfully
  Future<bool> start() async {
    if (_isRunning) return false;

    _isRunning = true;

    // Initialize simulation state
    for (final model in domainModels) {
      _initializeModel(model);
    }

    return true;
  }

  /// Stops the cooperative simulation
  ///
  /// Returns true if simulation stopped successfully
  Future<bool> stop() async {
    if (!_isRunning) return false;

    _isRunning = false;

    // Cleanup simulation state
    _cleanup();

    return true;
  }

  /// Simulates one step of cooperative behavior
  ///
  /// Returns the simulation results for this step
  Future<Map<String, dynamic>> step() async {
    if (!_isRunning) {
      throw StateError('Simulation is not running');
    }

    // Simulate cooperative interactions between domain models
    final results = <String, dynamic>{};

    for (int i = 0; i < domainModels.length; i++) {
      final model = domainModels[i];
      results[model.name] = _simulateModelStep(model);
    }

    return results;
  }

  /// Runs the simulation for a specified number of steps
  ///
  /// [steps] is the number of simulation steps to execute
  /// Returns the cumulative simulation results
  Future<List<Map<String, dynamic>>> run({int steps = 10}) async {
    if (!_isRunning) {
      await start();
    }

    final results = <Map<String, dynamic>>[];

    for (int i = 0; i < steps; i++) {
      final stepResult = await step();
      results.add(stepResult);
    }

    return results;
  }

  /// Initializes a domain model for simulation
  void _initializeModel(DomainModel model) {
    // Initialize simulation state for the model
    // This could include setting up agents, resources, etc.
  }

  /// Simulates one step for a specific domain model
  Map<String, dynamic> _simulateModelStep(DomainModel model) {
    // Simulate behavior for this model
    return {
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'status': 'active',
      'interactions': <String>[],
    };
  }

  /// Cleans up simulation resources
  void _cleanup() {
    // Cleanup simulation state and resources
  }
}
