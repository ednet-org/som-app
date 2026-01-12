part of ednet_core;

/// Semantic data provider for BDD test generation
///
/// Provides ontologically organized, semantically coherent random data
/// for generating purposeful tests. Integrates all domain-specific data
/// and core DDD patterns to support realistic BDD scenarios.
class SemanticDataProvider implements RandomDataConfigProvider {
  final String? preferredDomain;
  final Random _random = Random();

  SemanticDataProvider({this.preferredDomain});

  /// Factory constructors for domain-specific providers
  factory SemanticDataProvider.ecommerce() =>
      SemanticDataProvider(preferredDomain: 'ecommerce');

  factory SemanticDataProvider.healthcare() =>
      SemanticDataProvider(preferredDomain: 'healthcare');

  factory SemanticDataProvider.finance() =>
      SemanticDataProvider(preferredDomain: 'finance');

  factory SemanticDataProvider.education() =>
      SemanticDataProvider(preferredDomain: 'education');

  factory SemanticDataProvider.logistics() =>
      SemanticDataProvider(preferredDomain: 'logistics');

  @override
  RandomDataConfig get config => RandomDataConfig(
    words: _collectWords(),
    uris: _collectUris(),
    emails: _collectEmails(),
    quotes: _collectQuotes(),
  );

  /// Generate entity name based on domain and archetype
  String generateEntityName({String? domain, String? archetype}) {
    final selectedDomain = domain ?? preferredDomain ?? _randomDomain();
    final selectedArchetype = archetype ?? _randomArchetype();

    return _generateDomainEntityName(selectedDomain, selectedArchetype);
  }

  /// Generate attribute name for entity
  String generateAttributeName(String entityType) {
    final archetype = DomainOntology.entityArchetypes[entityType];
    if (archetype != null && archetype.attributes.isNotEmpty) {
      return archetype.attributes[_random.nextInt(archetype.attributes.length)];
    }

    // Fallback to common attributes
    final commonAttributes = [
      'id',
      'name',
      'description',
      'createdDate',
      'updatedDate',
      'status',
    ];
    return commonAttributes[_random.nextInt(commonAttributes.length)];
  }

  /// Generate domain event name
  String generateEventName({String? domain, String? pattern}) {
    final selectedDomain = domain ?? preferredDomain ?? _randomDomain();
    final selectedPattern = pattern ?? _randomEventPattern();

    return _generateDomainEventName(selectedDomain, selectedPattern);
  }

  /// Generate command name
  String generateCommandName({String? domain, String? pattern}) {
    final selectedDomain = domain ?? preferredDomain ?? _randomDomain();
    final selectedPattern = pattern ?? _randomCommandPattern();

    return _generateDomainCommandName(selectedDomain, selectedPattern);
  }

  /// Generate policy name
  String generatePolicyName({String? domain, String? pattern}) {
    final selectedDomain = domain ?? preferredDomain ?? _randomDomain();
    final selectedPattern = pattern ?? _randomPolicyPattern();

    return '${_domainPrefix(selectedDomain)}${selectedPattern}Policy';
  }

  /// Generate BDD scenario
  BDDScenario generateBDDScenario({String? domain}) {
    final selectedDomain = domain ?? preferredDomain ?? _randomDomain();
    return _getScenarioForDomain(selectedDomain);
  }

  /// Generate realistic test value for attribute
  dynamic generateTestValue(String attributeName, String type) {
    // Map to value object patterns if applicable
    for (final pattern in DomainOntology.valueObjectPatterns.values) {
      if (attributeName.toLowerCase().contains(pattern.name.toLowerCase())) {
        if (pattern.examples.isNotEmpty) {
          return pattern.examples[_random.nextInt(pattern.examples.length)];
        }
      }
    }

    // Type-based generation
    switch (type.toLowerCase()) {
      case 'string':
        return _generateStringValue(attributeName);
      case 'int':
        return _random.nextInt(1000);
      case 'double':
        return _random.nextDouble() * 1000;
      case 'bool':
        return _random.nextBool();
      case 'datetime':
        return DateTime.now().toIso8601String();
      default:
        return 'TestValue';
    }
  }

  /// Get all available domains
  List<String> get availableDomains => [
    'ecommerce',
    'healthcare',
    'finance',
    'education',
    'logistics',
  ];

  // Private helper methods

  List<String> _collectWords() {
    final words = <String>[];

    // Add entity names from all domains
    words.addAll(DomainOntology.entityArchetypes.keys);

    // Add domain-specific vocabulary
    if (preferredDomain == null || preferredDomain == 'ecommerce') {
      words.addAll(['product', 'order', 'cart', 'payment', 'customer']);
    }
    if (preferredDomain == null || preferredDomain == 'healthcare') {
      words.addAll([
        'patient',
        'doctor',
        'appointment',
        'diagnosis',
        'treatment',
      ]);
    }
    if (preferredDomain == null || preferredDomain == 'finance') {
      words.addAll(['account', 'transaction', 'payment', 'loan', 'balance']);
    }
    if (preferredDomain == null || preferredDomain == 'education') {
      words.addAll(['student', 'course', 'grade', 'assignment', 'enrollment']);
    }
    if (preferredDomain == null || preferredDomain == 'logistics') {
      words.addAll([
        'shipment',
        'warehouse',
        'carrier',
        'inventory',
        'delivery',
      ]);
    }

    return words;
  }

  List<String> _collectUris() {
    return [
      'https://example.com/api',
      'https://test.ecommerce.com',
      'https://healthcare.example.org',
      'https://finance.test.com',
      'https://education.example.edu',
      'https://logistics.example.net',
    ];
  }

  List<String> _collectEmails() {
    final emails = <String>[];

    // E-commerce personas
    for (final persona in ECommerceDomain.customerPersonas) {
      emails.add(persona.email);
    }

    // Healthcare personas
    for (final persona in HealthcareDomain.patientPersonas) {
      emails.add(
        '${persona.firstName.toLowerCase()}.${persona.lastName.toLowerCase()}@healthcare.example.com',
      );
    }

    // Add generic test emails
    emails.addAll(['test@example.com', 'admin@test.com', 'user@demo.com']);

    return emails;
  }

  List<String> _collectQuotes() {
    return [
      'Quality code requires comprehensive testing',
      'BDD scenarios drive domain understanding',
      'Semantic coherence improves test reliability',
      'Domain-driven design guides architecture',
      'Events capture business semantics',
    ];
  }

  String _randomDomain() {
    final domains = availableDomains;
    return domains[_random.nextInt(domains.length)];
  }

  String _randomArchetype() {
    final archetypes = DomainOntology.entityArchetypes.keys.toList();
    return archetypes[_random.nextInt(archetypes.length)];
  }

  String _randomEventPattern() {
    final patterns = DomainOntology.eventPatterns.keys.toList();
    return patterns[_random.nextInt(patterns.length)];
  }

  String _randomCommandPattern() {
    final patterns = DomainOntology.commandPatterns.keys.toList();
    return patterns[_random.nextInt(patterns.length)];
  }

  String _randomPolicyPattern() {
    final patterns = DomainOntology.policyPatterns.keys.toList();
    return patterns[_random.nextInt(patterns.length)];
  }

  String _generateDomainEntityName(String domain, String archetype) {
    switch (domain) {
      case 'ecommerce':
        return _ecommerceEntityName(archetype);
      case 'healthcare':
        return _healthcareEntityName(archetype);
      case 'finance':
        return _financeEntityName(archetype);
      case 'education':
        return _educationEntityName(archetype);
      case 'logistics':
        return _logisticsEntityName(archetype);
      default:
        return archetype;
    }
  }

  String _ecommerceEntityName(String archetype) {
    final mapping = {
      'Person': 'Customer',
      'Product': 'Product',
      'Order': 'Order',
      'Payment': 'Payment',
      'Document': 'Invoice',
      'Address': 'ShippingAddress',
    };
    return mapping[archetype] ?? archetype;
  }

  String _healthcareEntityName(String archetype) {
    final mapping = {
      'Person': 'Patient',
      'Organization': 'HealthcareProvider',
      'Appointment': 'MedicalAppointment',
      'Document': 'MedicalRecord',
      'Payment': 'MedicalBilling',
    };
    return mapping[archetype] ?? archetype;
  }

  String _financeEntityName(String archetype) {
    final mapping = {
      'Person': 'AccountHolder',
      'Order': 'Transaction',
      'Payment': 'Payment',
      'Document': 'Statement',
    };
    return mapping[archetype] ?? archetype;
  }

  String _educationEntityName(String archetype) {
    final mapping = {
      'Person': 'Student',
      'Organization': 'School',
      'Document': 'Transcript',
      'Payment': 'Tuition',
    };
    return mapping[archetype] ?? archetype;
  }

  String _logisticsEntityName(String archetype) {
    final mapping = {
      'Person': 'Driver',
      'Organization': 'Carrier',
      'Order': 'Shipment',
      'Product': 'Package',
      'Address': 'DeliveryAddress',
    };
    return mapping[archetype] ?? archetype;
  }

  String _generateDomainEventName(String domain, String pattern) {
    final entityName = _generateDomainEntityName(domain, _randomArchetype());
    return '$entityName$pattern';
  }

  String _generateDomainCommandName(String domain, String pattern) {
    final entityName = _generateDomainEntityName(domain, _randomArchetype());
    return '$pattern$entityName';
  }

  String _domainPrefix(String domain) {
    switch (domain) {
      case 'ecommerce':
        return 'Commerce';
      case 'healthcare':
        return 'Clinical';
      case 'finance':
        return 'Financial';
      case 'education':
        return 'Academic';
      case 'logistics':
        return 'Supply';
      default:
        return '';
    }
  }

  BDDScenario _getScenarioForDomain(String domain) {
    switch (domain) {
      case 'ecommerce':
        return ECommerceDomain.bddScenarios[_random.nextInt(
          ECommerceDomain.bddScenarios.length,
        )];
      case 'healthcare':
        return HealthcareDomain.bddScenarios[_random.nextInt(
          HealthcareDomain.bddScenarios.length,
        )];
      case 'finance':
        return FinanceDomain.bddScenarios[_random.nextInt(
          FinanceDomain.bddScenarios.length,
        )];
      case 'education':
        return EducationDomain.bddScenarios[_random.nextInt(
          EducationDomain.bddScenarios.length,
        )];
      case 'logistics':
        return LogisticsDomain.bddScenarios[_random.nextInt(
          LogisticsDomain.bddScenarios.length,
        )];
      default:
        return ECommerceDomain.bddScenarios[0];
    }
  }

  String _generateStringValue(String attributeName) {
    final lowerName = attributeName.toLowerCase();

    if (lowerName.contains('email')) {
      return _collectEmails()[_random.nextInt(_collectEmails().length)];
    }
    if (lowerName.contains('name')) {
      return 'Test${attributeName}';
    }
    if (lowerName.contains('description')) {
      return 'Sample description for $attributeName';
    }
    if (lowerName.contains('status')) {
      return 'Active';
    }
    if (lowerName.contains('code') || lowerName.contains('sku')) {
      return '${attributeName.toUpperCase()}-${_random.nextInt(1000)}';
    }

    return 'TestValue';
  }
}

/// Global semantic data provider for backward compatibility
final semanticDataProvider = SemanticDataProvider();

/// Enhanced random data service using semantic provider
class SemanticRandomDataService extends RandomDataService {
  final SemanticDataProvider semanticProvider;

  SemanticRandomDataService(this.semanticProvider) : super(semanticProvider);

  /// Generate entity name for domain
  String entityName({String? domain, String? archetype}) =>
      semanticProvider.generateEntityName(domain: domain, archetype: archetype);

  /// Generate attribute name
  String attributeName(String entityType) =>
      semanticProvider.generateAttributeName(entityType);

  /// Generate event name
  String eventName({String? domain, String? pattern}) =>
      semanticProvider.generateEventName(domain: domain, pattern: pattern);

  /// Generate command name
  String commandName({String? domain, String? pattern}) =>
      semanticProvider.generateCommandName(domain: domain, pattern: pattern);

  /// Generate policy name
  String policyName({String? domain, String? pattern}) =>
      semanticProvider.generatePolicyName(domain: domain, pattern: pattern);

  /// Generate BDD scenario
  BDDScenario bddScenario({String? domain}) =>
      semanticProvider.generateBDDScenario(domain: domain);

  /// Generate test value
  dynamic testValue(String attributeName, String type) =>
      semanticProvider.generateTestValue(attributeName, type);
}
