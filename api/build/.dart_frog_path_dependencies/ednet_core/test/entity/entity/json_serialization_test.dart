import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

/// Test entity class that satisfies the self-referential type constraint
class TestPerson extends Entity<TestPerson> {
  TestPerson(Concept concept) {
    this.concept = concept;
  }

  TestPerson.withConcept(Concept concept) {
    this.concept = concept;
  }
}

/// Test entities collection
class TestPersons extends Entities<TestPerson> {
  TestPersons(Concept concept) {
    this.concept = concept;
  }
}

/// Tests for JSON serialization of entities with DateTime attributes.
///
/// These tests verify that:
/// 1. DateTime attributes are converted to ISO 8601 strings during serialization
/// 2. ISO 8601 strings are parsed back to DateTime during deserialization
/// 3. JSON round-trip preserves DateTime values
void main() {
  late Domain domain;
  late Model model;
  late Concept personConcept;
  late TestPersons persons;

  setUp(() {
    // Create a domain with DateTime attributes
    domain = Domain('Test');
    model = Model(domain, 'TestModel');
    domain.models.add(model);

    // Create a concept with DateTime attributes
    personConcept = Concept(model, 'Person');
    personConcept.entry = true;
    personConcept.updateOid = true; // Allow oid updates for fromJsonMap tests

    // Add a String identifier
    final nameAttr = Attribute(personConcept, 'name');
    nameAttr.identifier = true;
    nameAttr.type = domain.getType('String');

    // Add DateTime attributes - this is the key test scenario
    final birthDateAttr = Attribute(personConcept, 'birthDate');
    birthDateAttr.type = domain.getType('DateTime');

    final createdAtAttr = Attribute(personConcept, 'createdAt');
    createdAtAttr.type = domain.getType('DateTime');

    model.concepts.add(personConcept);

    // Create entities collection
    persons = TestPersons(personConcept);
  });

  group('DateTime JSON Serialization', () {
    test(
      'Entity.toJsonMap() converts DateTime attributes to ISO 8601 strings',
      () {
        final person = TestPerson(personConcept);
        person.setAttribute('name', 'John Doe');

        // Set DateTime values
        final birthDate = DateTime(1990, 5, 15, 10, 30, 0);
        final createdAt = DateTime(2024, 11, 25, 14, 45, 30);
        person.setAttribute('birthDate', birthDate);
        person.setAttribute('createdAt', createdAt);

        // Serialize to JSON
        final json = person.toJsonMap();

        // Verify DateTime was converted to ISO 8601 string
        expect(json['attributes'], isNotNull);
        final attributes = json['attributes'] as Map<String, dynamic>;

        // Should be ISO 8601 strings, not DateTime objects
        expect(
          attributes['birthDate'],
          isA<String>(),
          reason: 'DateTime should be serialized as ISO 8601 string',
        );
        expect(
          attributes['createdAt'],
          isA<String>(),
          reason: 'DateTime should be serialized as ISO 8601 string',
        );

        // Verify the string format is ISO 8601
        expect(attributes['birthDate'], equals(birthDate.toIso8601String()));
        expect(attributes['createdAt'], equals(createdAt.toIso8601String()));
      },
    );

    test('Entity.fromJsonMap() parses ISO 8601 strings back to DateTime', () {
      final person = TestPerson(personConcept);

      // Create JSON with ISO 8601 DateTime strings
      final birthDate = DateTime(1990, 5, 15, 10, 30, 0);
      final createdAt = DateTime(2024, 11, 25, 14, 45, 30);

      final json = {
        'oid': Oid.ts(DateTime.now().millisecondsSinceEpoch).toString(),
        'concept': 'Person',
        'attributes': {
          'name': 'Jane Doe',
          'birthDate': birthDate.toIso8601String(),
          'createdAt': createdAt.toIso8601String(),
        },
      };

      // Deserialize from JSON
      person.fromJsonMap(json);

      // Verify DateTime was parsed correctly
      final loadedBirthDate = person.getAttribute('birthDate');
      final loadedCreatedAt = person.getAttribute('createdAt');

      expect(
        loadedBirthDate,
        isA<DateTime>(),
        reason: 'ISO 8601 string should be parsed to DateTime',
      );
      expect(
        loadedCreatedAt,
        isA<DateTime>(),
        reason: 'ISO 8601 string should be parsed to DateTime',
      );

      expect(loadedBirthDate, equals(birthDate));
      expect(loadedCreatedAt, equals(createdAt));
    });

    test('JSON round-trip preserves DateTime values', () {
      final original = TestPerson(personConcept);
      original.setAttribute('name', 'Alice Smith');

      // Set DateTime values with various precisions
      final birthDate = DateTime(1985, 12, 31, 23, 59, 59, 999);
      final createdAt = DateTime.now();
      original.setAttribute('birthDate', birthDate);
      original.setAttribute('createdAt', createdAt);

      // Serialize to JSON
      final json = original.toJsonMap();

      // Deserialize to new entity
      final restored = TestPerson(personConcept);
      restored.fromJsonMap(json);

      // Verify values match
      expect(restored.getAttribute('name'), equals('Alice Smith'));
      expect(restored.getAttribute('birthDate'), equals(birthDate));
      expect(restored.getAttribute('createdAt'), equals(createdAt));
    });

    test('Entity.toJson() can be encoded with jsonEncode()', () {
      final person = TestPerson(personConcept);
      person.setAttribute('name', 'Bob Johnson');
      person.setAttribute('birthDate', DateTime(2000, 1, 1));
      person.setAttribute('createdAt', DateTime.now());

      // This should NOT throw "Converting object to an encodable object failed"
      expect(
        () => person.toJson(),
        returnsNormally,
        reason: 'toJson() should handle DateTime attributes without throwing',
      );

      // Verify the result is valid JSON string
      final jsonString = person.toJson();
      expect(jsonString, isA<String>());
      expect(jsonString.isNotEmpty, isTrue);
    });

    test('Null DateTime attributes are handled correctly', () {
      final person = TestPerson(personConcept);
      person.setAttribute('name', 'Charlie Brown');
      // birthDate and createdAt are not set (null)

      // Serialize
      final json = person.toJsonMap();

      // Null attributes should not be in the JSON
      final attributes = json['attributes'] as Map<String, dynamic>?;
      if (attributes != null) {
        expect(attributes.containsKey('birthDate'), isFalse);
        expect(attributes.containsKey('createdAt'), isFalse);
      }

      // Deserialize to new entity
      final restored = TestPerson(personConcept);
      restored.fromJsonMap(json);

      // Null values should remain null
      expect(restored.getAttribute('birthDate'), isNull);
      expect(restored.getAttribute('createdAt'), isNull);
    });

    test('Mixed attribute types are serialized correctly', () {
      // Add more attribute types to the concept
      final ageAttr = Attribute(personConcept, 'age');
      ageAttr.type = domain.getType('int');

      final activeAttr = Attribute(personConcept, 'active');
      activeAttr.type = domain.getType('bool');

      final scoreAttr = Attribute(personConcept, 'score');
      scoreAttr.type = domain.getType('double');

      final person = TestPerson(personConcept);
      person.setAttribute('name', 'Mixed Types Test');
      person.setAttribute('birthDate', DateTime(1995, 6, 15));
      person.setAttribute('age', 29);
      person.setAttribute('active', true);
      person.setAttribute('score', 95.5);

      // Serialize
      final json = person.toJsonMap();

      // Verify all types are correct in JSON
      final attributes = json['attributes'] as Map<String, dynamic>;
      expect(attributes['name'], isA<String>());
      expect(
        attributes['birthDate'],
        isA<String>(),
        reason: 'DateTime should be converted to ISO 8601 string',
      );
      expect(attributes['age'], isA<int>());
      expect(attributes['active'], isA<bool>());
      expect(attributes['score'], isA<double>());

      // Verify round-trip
      final restored = TestPerson(personConcept);
      restored.fromJsonMap(json);

      expect(restored.getAttribute('name'), equals('Mixed Types Test'));
      expect(restored.getAttribute('birthDate'), equals(DateTime(1995, 6, 15)));
      expect(restored.getAttribute('age'), equals(29));
      expect(restored.getAttribute('active'), equals(true));
      expect(restored.getAttribute('score'), equals(95.5));
    });
  });

  group('Entities JSON Serialization', () {
    test('Entities.toJsonList() handles DateTime attributes', () {
      // Add entities with DateTime attributes
      for (var i = 0; i < 3; i++) {
        final person = TestPerson(personConcept);
        person.setAttribute('name', 'Person $i');
        person.setAttribute('birthDate', DateTime(1990 + i, i + 1, i + 10));
        persons.add(person);
      }

      // Serialize all entities
      final jsonList = persons.toJsonList();

      expect(jsonList, hasLength(3));

      // Verify each entity has DateTime as ISO 8601 string
      for (var i = 0; i < 3; i++) {
        final entityJson = jsonList[i] as Map<String, dynamic>;
        final attributes = entityJson['attributes'] as Map<String, dynamic>;
        expect(
          attributes['birthDate'],
          isA<String>(),
          reason: 'DateTime in list should be serialized as ISO 8601 string',
        );
      }
    });
  });
}
