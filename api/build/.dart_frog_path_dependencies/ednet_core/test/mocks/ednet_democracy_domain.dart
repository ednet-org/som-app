/// EDNet Democracy Domain Mock for Testing
///
/// This mock domain provides a democracy/voting system for testing core EDNet
/// functionality including entities, relationships, commands, and events.
library;

import 'package:ednet_core/ednet_core.dart';

/// Democracy domain mock for testing entity relationships and workflows
class EDNetDemocracyDomain extends Domain {
  late Domain _domain;
  late Model _model;
  late Concept _citizenConcept;
  late Concept _delegateConcept;
  late Concept _referendumConcept;
  late Concept _voteConcept;

  late Entities<Citizen> _citizens;
  late Entities<Delegate> _delegates;
  late Entities<Referendum> _referendums;
  late Entities<Vote> _votes;

  late DomainModels _domainModels;

  EDNetDemocracyDomain() {
    _initializeDomain();
  }

  void _initializeDomain() {
    // Create domain and model
    _domain = Domain('Democracy');
    _model = Model(_domain, 'Governance');

    // Initialize domain models
    _domainModels = DomainModels(_domain);

    // Create concepts
    _citizenConcept = Concept(_model, 'Citizen');
    _citizenConcept.description = 'A citizen in the democratic system';
    _citizenConcept.entry = true; // Mark as entry concept

    _referendumConcept = Concept(_model, 'Referendum');
    _referendumConcept.description = 'A democratic referendum for voting';
    _referendumConcept.entry = true; // Mark as entry concept

    _voteConcept = Concept(_model, 'Vote');
    _voteConcept.description = 'A vote cast by a citizen in a referendum';

    // Add attributes to Citizen
    _citizenConcept.attributes.add(
      Attribute(_citizenConcept, 'name')
        ..type = _domain.getType('String')
        ..init = null
        ..required = true,
    );

    _citizenConcept.attributes.add(
      Attribute(_citizenConcept, 'email')
        ..type = _domain.getType('String')
        ..init = null
        ..required = true,
    );

    _citizenConcept.attributes.add(
      Attribute(_citizenConcept, 'idNumber')
        ..type = _domain.getType('String')
        ..init = null
        ..required = true,
    );

    _citizenConcept.attributes.add(
      Attribute(_citizenConcept, 'verified')
        ..type = _domain.getType('bool')
        ..init = 'false'
        ..required = false,
    );

    _citizenConcept.attributes.add(
      Attribute(_citizenConcept, 'registerDate')
        ..type = _domain.getType('DateTime')
        ..init = null
        ..required = false,
    );

    // Additional attributes for delegate functionality
    _citizenConcept.attributes.add(
      Attribute(_citizenConcept, 'specialty')
        ..type = _domain.getType('String')
        ..init = ''
        ..required = false,
    );

    _citizenConcept.attributes.add(
      Attribute(_citizenConcept, 'delegatorCount')
        ..type = _domain.getType('int')
        ..init = '0'
        ..required = false,
    );

    // Create delegate concept that inherits from citizen
    _delegateConcept = Concept(_model, 'Delegate');
    _delegateConcept.description = 'A delegate who represents citizens';

    // Set up inheritance relationship: Delegate inherits from Citizen
    Parent(_delegateConcept, _citizenConcept, 'citizen');

    // Add delegate-specific attributes
    _delegateConcept.attributes.add(
      Attribute(_delegateConcept, 'specialty')
        ..type = _domain.getType('String')
        ..init = null
        ..required = true,
    );

    _delegateConcept.attributes.add(
      Attribute(_delegateConcept, 'delegatorCount')
        ..type = _domain.getType('int')
        ..init = '0'
        ..required = false,
    );

    // Add attributes to Referendum
    _referendumConcept.attributes.add(
      Attribute(_referendumConcept, 'title')
        ..type = _domain.getType('String')
        ..init = null
        ..required = true,
    );

    _referendumConcept.attributes.add(
      Attribute(_referendumConcept, 'description')
        ..type = _domain.getType('String')
        ..init = null
        ..required = true,
    );

    _referendumConcept.attributes.add(
      Attribute(_referendumConcept, 'startDate')
        ..type = _domain.getType('DateTime')
        ..init = null
        ..required = true,
    );

    _referendumConcept.attributes.add(
      Attribute(_referendumConcept, 'endDate')
        ..type = _domain.getType('DateTime')
        ..init = null
        ..required = true,
    );

    _referendumConcept.attributes.add(
      Attribute(_referendumConcept, 'active')
        ..type = _domain.getType('bool')
        ..init = 'true'
        ..required = false,
    );

    // Add attributes to Vote
    _voteConcept.attributes.add(
      Attribute(_voteConcept, 'choice')
        ..type = _domain.getType('String')
        ..init = null
        ..required = true,
    );

    _voteConcept.attributes.add(
      Attribute(_voteConcept, 'timestamp')
        ..type = _domain.getType('DateTime')
        ..init = null
        ..required = false,
    );

    _voteConcept.attributes.add(
      Attribute(_voteConcept, 'verified')
        ..type = _domain.getType('bool')
        ..init = 'false'
        ..required = false,
    );

    // Create relationships
    Child(_citizenConcept, _voteConcept, 'votes');

    Parent(_voteConcept, _citizenConcept, 'citizen');

    Child(_referendumConcept, _voteConcept, 'votes');

    Parent(_voteConcept, _referendumConcept, 'referendum');

    // Initialize entity collections with concepts for validation
    _citizens = Entities<Citizen>();
    _citizens.concept = _citizenConcept;
    _citizens.pre = true; // Enable validation

    _delegates = Entities<Delegate>();
    _delegates.concept = _delegateConcept;
    _delegates.pre = true; // Enable validation

    _referendums = Entities<Referendum>();
    _referendums.concept = _referendumConcept;
    _referendums.pre = true; // Enable validation

    _votes = Entities<Vote>();
    _votes.concept = _voteConcept;
    _votes.pre = true; // Enable validation
  }

  // Getters for domain and model
  Domain get domain => _domain;
  Model get model => _model;

  // Getters for concepts
  Concept get citizenConcept => _citizenConcept;
  Concept get delegateConcept => _delegateConcept;
  Concept get referendumConcept => _referendumConcept;
  Concept get voteConcept => _voteConcept;

  // Getters for entity collections
  Entities<Citizen> get citizens => _citizens;
  Entities<Delegate> get delegates => _delegates;
  Entities<Referendum> get referendums => _referendums;
  Entities<Vote> get votes => _votes;

  // Getter for domain session
  DomainSession get session => _domainModels.newSession();

  // Factory methods for creating entities
  Citizen createCitizen({
    required String name,
    required String email,
    required String idNumber,
    bool verified = false,
    DateTime? registerDate,
  }) {
    final citizen = Citizen.withConcept(_citizenConcept);
    citizen.setAttribute('name', name);
    citizen.setAttribute('email', email);
    citizen.setAttribute('idNumber', idNumber);
    citizen.setAttribute('verified', verified);
    citizen.setAttribute('registerDate', registerDate ?? DateTime.now());
    _citizens.add(citizen);
    return citizen;
  }

  Referendum createReferendum({
    required String title,
    required String description,
    DateTime? startDate,
    DateTime? endDate,
    bool active = true,
  }) {
    final referendum = Referendum.withConcept(_referendumConcept);
    referendum.setAttribute('title', title);
    referendum.setAttribute('description', description);
    referendum.setAttribute('startDate', startDate ?? DateTime.now());
    referendum.setAttribute(
      'endDate',
      endDate ?? DateTime.now().add(const Duration(days: 30)),
    );
    referendum.setAttribute('active', active);
    _referendums.add(referendum);
    return referendum;
  }

  Vote createVote({
    required String choice,
    Citizen? citizen,
    Referendum? referendum,
    DateTime? timestamp,
    bool verified = false,
  }) {
    final vote = Vote.withConcept(_voteConcept);
    vote.setAttribute('choice', choice);
    vote.setAttribute('timestamp', timestamp ?? DateTime.now());
    vote.setAttribute('verified', verified);

    // Set parent relationships if provided
    if (citizen != null) {
      vote.setParent('citizen', citizen);
    }
    if (referendum != null) {
      vote.setParent('referendum', referendum);
    }

    _votes.add(vote);
    return vote;
  }

  // Utility methods for creating test scenarios
  Map<String, dynamic> createSimpleVotingScenario() {
    final citizen1 = createCitizen(
      name: 'Alice Voter',
      email: 'alice@democracy.org',
      idNumber: 'C001',
      verified: true,
    );

    final citizen2 = createCitizen(
      name: 'Bob Representative',
      email: 'bob@democracy.org',
      idNumber: 'C002',
      verified: true,
    );

    final referendum = createReferendum(
      title: 'Infrastructure Investment',
      description: 'Should we invest in renewable energy infrastructure?',
    );

    final vote1 = createVote(choice: 'YES', verified: true);
    final vote2 = createVote(choice: 'NO', verified: true);

    return {
      'citizens': [citizen1, citizen2],
      'referendum': referendum,
      'votes': [vote1, vote2],
    };
  }

  Map<String, dynamic> createComplexVotingScenario() {
    final citizens = <Citizen>[];
    final votes = <Vote>[];

    // Create multiple citizens
    for (int i = 1; i <= 10; i++) {
      final citizen = createCitizen(
        name: 'Citizen $i',
        email: 'citizen$i@democracy.org',
        idNumber: 'C${i.toString().padLeft(3, '0')}',
        verified: i % 2 == 0, // Half verified
      );
      citizens.add(citizen);
    }

    // Create referendum
    final referendum = createReferendum(
      title: 'Education Reform',
      description: 'Should we implement comprehensive education reform?',
    );

    // Create votes
    for (int i = 0; i < citizens.length; i++) {
      final vote = createVote(
        choice: i % 3 == 0
            ? 'YES'
            : i % 3 == 1
            ? 'NO'
            : 'ABSTAIN',
        verified: citizens[i].getAttribute('verified') as bool,
      );
      votes.add(vote);
    }

    return {'citizens': citizens, 'referendum': referendum, 'votes': votes};
  }

  /// Create a delegate (which extends citizen)
  Delegate createDelegate({
    required String name,
    required String email,
    required String idNumber,
    required String specialty,
    bool verified = false,
    DateTime? registerDate,
  }) {
    // Create the citizen parent first
    final citizenParent = createCitizen(
      name: name,
      email: email,
      idNumber: idNumber,
      verified: verified,
      registerDate: registerDate,
    );

    // Create the delegate with proper concept
    final delegate = Delegate.withConcept(_delegateConcept);
    delegate.setAttribute('specialty', specialty);
    delegate.setAttribute('delegatorCount', 0);

    // Set up inheritance relationship
    delegate.setParent('citizen', citizenParent);

    _delegates.add(delegate);
    return delegate;
  }

  /// Create a voting scenario with specified parameters
  Map<String, dynamic> createVotingScenario({
    required int citizenCount,
    required String referendumTitle,
  }) {
    final citizens = <Citizen>[];
    final votes = <Vote>[];

    // Create citizens
    for (int i = 1; i <= citizenCount; i++) {
      final citizen = createCitizen(
        name: 'Test Citizen $i',
        email: 'citizen$i@test.org',
        idNumber: 'TC${i.toString().padLeft(3, '0')}',
        verified: true,
      );
      citizens.add(citizen);
    }

    // Create referendum
    final referendum = createReferendum(
      title: referendumTitle,
      description: 'Test referendum: $referendumTitle',
    );

    // Create votes for each citizen
    for (final citizen in citizens) {
      final vote = createVote(
        choice: 'Yes',
        citizen: citizen,
        referendum: referendum,
        verified: true,
      );
      votes.add(vote);
    }

    return {'citizens': citizens, 'referendum': referendum, 'votes': votes};
  }

  // Clean up for test isolation
  void reset() {
    _citizens.clear();
    _delegates.clear();
    _referendums.clear();
    _votes.clear();
  }
}

/// Citizen entity for democracy domain
class Citizen extends Entity<Citizen> {
  Citizen() : super();

  // Initialize with concept
  Citizen.withConcept(Concept concept) : super() {
    this.concept = concept;
  }
}

/// Referendum entity for democracy domain
class Referendum extends Entity<Referendum> {
  Referendum() : super();

  // Initialize with concept
  Referendum.withConcept(Concept concept) : super() {
    this.concept = concept;
  }
}

/// Vote entity for democracy domain
class Vote extends Entity<Vote> {
  Vote() : super();

  // Initialize with concept
  Vote.withConcept(Concept concept) : super() {
    this.concept = concept;
  }
}

/// Delegate entity for democracy domain
class Delegate extends Entity<Delegate> {
  Delegate() : super();

  // Initialize with concept
  Delegate.withConcept(Concept concept) : super() {
    this.concept = concept;
  }
}
