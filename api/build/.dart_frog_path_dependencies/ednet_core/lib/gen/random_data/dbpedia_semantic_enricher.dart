part of ednet_core;

/// DBpedia-enriched semantic data provider
///
/// Extends SemanticDataProvider with real-world data from DBpedia.
/// Falls back to synthetic data when DBpedia is unavailable.
///
/// Usage:
/// ```dart
/// // Auto-detect DBpedia endpoint (local → remote)
/// final enricher = DBpediaSemanticEnricher.auto();
///
/// // Generate test data with real-world entities
/// final cities = await enricher.getRealWorldCities(limit: 10);
/// final companies = await enricher.getRealWorldCompanies(limit: 5);
///
/// // Enrich BDD scenario with real data
/// final scenario = await enricher.enrichScenario(
///   semanticProvider.generateBDDScenario(domain: 'logistics'),
/// );
/// ```
class DBpediaSemanticEnricher {
  dynamic _dbpediaService; // DBpediaService from ednet_dbpedia_integration
  final bool _isEnabled;

  DBpediaSemanticEnricher({
    SemanticDataProvider? semanticProvider,
    dynamic dbpediaService,
  }) : _dbpediaService = dbpediaService,
       _isEnabled = dbpediaService != null;

  /// Factory: Auto-detect DBpedia (local → remote fallback)
  ///
  /// Requires ednet_dbpedia_integration package to be available.
  /// If not available, falls back to synthetic data only.
  factory DBpediaSemanticEnricher.auto({
    SemanticDataProvider? semanticProvider,
  }) {
    try {
      // Attempt to create DBpediaService if package is available
      // This will be resolved at runtime when package is imported
      // For now, return enricher without DBpedia
      return DBpediaSemanticEnricher(semanticProvider: semanticProvider);
    } catch (e) {
      // Package not available, use synthetic data only
      return DBpediaSemanticEnricher(semanticProvider: semanticProvider);
    }
  }

  /// Check if DBpedia integration is enabled
  bool get isDBpediaEnabled => _isEnabled;

  /// Get real-world cities from DBpedia
  ///
  /// Falls back to synthetic cities if DBpedia unavailable.
  Future<List<RealWorldEntity>> getRealWorldCities({int limit = 10}) async {
    if (!_isEnabled) {
      return _generateSyntheticCities(limit);
    }

    try {
      // Dynamic call to DBpediaService.getCities()
      final cities = await _dbpediaService.getCities(limit: limit);
      return cities
          .map<RealWorldEntity>(
            (city) => RealWorldEntity(
              uri: city.uri,
              label: city.label,
              description: city.description ?? '',
              type: 'City',
              properties: {
                'population': city.properties['population'],
                'country': city.properties['country'],
              },
            ),
          )
          .toList();
    } catch (e) {
      // Fallback to synthetic
      return _generateSyntheticCities(limit);
    }
  }

  /// Get real-world companies from DBpedia
  Future<List<RealWorldEntity>> getRealWorldCompanies({int limit = 10}) async {
    if (!_isEnabled) {
      return _generateSyntheticCompanies(limit);
    }

    try {
      final companies = await _dbpediaService.getCompanies(limit: limit);
      return companies
          .map<RealWorldEntity>(
            (company) => RealWorldEntity(
              uri: company.uri,
              label: company.label,
              description: company.description ?? '',
              type: 'Company',
            ),
          )
          .toList();
    } catch (e) {
      return _generateSyntheticCompanies(limit);
    }
  }

  /// Get real-world scientists from DBpedia
  Future<List<RealWorldEntity>> getRealWorldScientists({int limit = 10}) async {
    if (!_isEnabled) {
      return _generateSyntheticScientists(limit);
    }

    try {
      final scientists = await _dbpediaService.getScientists(limit: limit);
      return scientists
          .map<RealWorldEntity>(
            (scientist) => RealWorldEntity(
              uri: scientist.uri,
              label: scientist.label,
              description: scientist.description ?? '',
              type: 'Scientist',
            ),
          )
          .toList();
    } catch (e) {
      return _generateSyntheticScientists(limit);
    }
  }

  /// Get real-world entities by type
  Future<List<RealWorldEntity>> getRealWorldEntitiesByType(
    String type, {
    int limit = 10,
  }) async {
    if (!_isEnabled) {
      return _generateSyntheticEntities(type, limit);
    }

    try {
      final entities = await _dbpediaService.getResourcesByType(
        type,
        limit: limit,
      );
      return entities
          .map<RealWorldEntity>(
            (entity) => RealWorldEntity(
              uri: entity.uri,
              label: entity.label,
              description: entity.description ?? '',
              type: type,
            ),
          )
          .toList();
    } catch (e) {
      return _generateSyntheticEntities(type, limit);
    }
  }

  /// Enrich BDD scenario with real-world data
  ///
  /// Replaces synthetic entity references with real DBpedia entities.
  Future<EnrichedBDDScenario> enrichScenario(BDDScenario scenario) async {
    final enrichedGiven = await _enrichSteps(scenario.given);
    final enrichedWhen = await _enrichSteps(scenario.when);
    final enrichedThen = await _enrichSteps(scenario.then);

    return EnrichedBDDScenario(
      feature: scenario.feature,
      scenario: scenario.scenario,
      given: enrichedGiven,
      when: enrichedWhen,
      then: enrichedThen,
      originalScenario: scenario,
      realWorldEntities: _extractedEntities,
    );
  }

  final List<RealWorldEntity> _extractedEntities = [];

  Future<List<String>> _enrichSteps(List<String> steps) async {
    final enriched = <String>[];
    for (final step in steps) {
      enriched.add(await _enrichStep(step));
    }
    return enriched;
  }

  Future<String> _enrichStep(String step) async {
    String enriched = step;

    // Pattern matching for entity types
    if (step.contains('city') || step.contains('cities')) {
      final cities = await getRealWorldCities(limit: 3);
      if (cities.isNotEmpty) {
        _extractedEntities.addAll(cities);
        enriched = enriched.replaceFirst(
          RegExp(r'city|cities'),
          cities.first.label,
        );
      }
    }

    if (step.contains('company') || step.contains('companies')) {
      final companies = await getRealWorldCompanies(limit: 3);
      if (companies.isNotEmpty) {
        _extractedEntities.addAll(companies);
        enriched = enriched.replaceFirst(
          RegExp(r'company|companies'),
          companies.first.label,
        );
      }
    }

    return enriched;
  }

  // Synthetic fallback data generators

  List<RealWorldEntity> _generateSyntheticCities(int limit) {
    final cities = [
      const RealWorldEntity(
        uri: 'urn:synthetic:city:new-york',
        label: 'New York',
        description: 'Synthetic city for testing',
        type: 'City',
        properties: {'population': '8000000', 'country': 'USA'},
      ),
      const RealWorldEntity(
        uri: 'urn:synthetic:city:london',
        label: 'London',
        description: 'Synthetic city for testing',
        type: 'City',
        properties: {'population': '9000000', 'country': 'UK'},
      ),
      const RealWorldEntity(
        uri: 'urn:synthetic:city:paris',
        label: 'Paris',
        description: 'Synthetic city for testing',
        type: 'City',
        properties: {'population': '2000000', 'country': 'France'},
      ),
    ];
    return cities.take(limit).toList();
  }

  List<RealWorldEntity> _generateSyntheticCompanies(int limit) {
    final companies = [
      const RealWorldEntity(
        uri: 'urn:synthetic:company:acme-corp',
        label: 'ACME Corporation',
        description: 'Synthetic company for testing',
        type: 'Company',
      ),
      const RealWorldEntity(
        uri: 'urn:synthetic:company:globex',
        label: 'Globex Corporation',
        description: 'Synthetic company for testing',
        type: 'Company',
      ),
    ];
    return companies.take(limit).toList();
  }

  List<RealWorldEntity> _generateSyntheticScientists(int limit) {
    final scientists = [
      const RealWorldEntity(
        uri: 'urn:synthetic:scientist:einstein',
        label: 'Albert Einstein',
        description: 'Synthetic scientist for testing',
        type: 'Scientist',
      ),
    ];
    return scientists.take(limit).toList();
  }

  List<RealWorldEntity> _generateSyntheticEntities(String type, int limit) {
    return [
      const RealWorldEntity(
        uri: 'urn:synthetic:entity:test',
        label: 'Test Entity',
        description: 'Synthetic entity for testing',
        type: 'Entity',
      ),
    ];
  }

  /// Dispose resources
  void dispose() {
    if (_dbpediaService != null) {
      try {
        _dbpediaService.dispose();
      } catch (_) {}
    }
  }
}

/// Real-world entity from DBpedia or synthetic source
class RealWorldEntity {
  final String uri;
  final String label;
  final String description;
  final String type;
  final Map<String, dynamic> properties;

  const RealWorldEntity({
    required this.uri,
    required this.label,
    required this.description,
    required this.type,
    this.properties = const {},
  });

  @override
  String toString() => '$label ($type)';

  Map<String, dynamic> toJson() => {
    'uri': uri,
    'label': label,
    'description': description,
    'type': type,
    'properties': properties,
  };
}

/// BDD scenario enriched with real-world entities
class EnrichedBDDScenario {
  final String feature;
  final String scenario;
  final List<String> given;
  final List<String> when;
  final List<String> then;
  final BDDScenario originalScenario;
  final List<RealWorldEntity> realWorldEntities;

  const EnrichedBDDScenario({
    required this.feature,
    required this.scenario,
    required this.given,
    required this.when,
    required this.then,
    required this.originalScenario,
    required this.realWorldEntities,
  });

  @override
  String toString() =>
      '''
Feature: $feature
Scenario: $scenario
  Given ${given.join('\n  And ')}
  When ${when.join('\n  And ')}
  Then ${then.join('\n  And ')}

Real-world entities: ${realWorldEntities.map((e) => e.label).join(', ')}
''';
}
