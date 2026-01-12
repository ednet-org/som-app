import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

/// Test entity class that satisfies the self-referential type constraint
class TestMember extends Entity<TestMember> {
  TestMember(Concept concept) {
    this.concept = concept;
  }

  TestMember.withConcept(Concept concept) {
    this.concept = concept;
  }

  /// Override to return correct concrete type
  @override
  TestMember createInstance() {
    return TestMember(concept!);
  }
}

/// Test entities collection
class TestMembers extends Entities<TestMember> {
  TestMembers(Concept concept) {
    this.concept = concept;
  }
}

/// Tests for Entity.copy() method.
///
/// These tests verify that:
/// 1. Entity.copy() returns the correct concrete type, not base Entity<E>
/// 2. Copy maintains all attribute values
/// 3. Copy maintains parent references
/// 4. Entities.copy() preserves entity types
void main() {
  late Domain domain;
  late Model model;
  late Concept memberConcept;
  late TestMembers members;

  setUp(() {
    // Create a domain with member concept
    domain = Domain('Test');
    model = Model(domain, 'TestModel');
    domain.models.add(model);

    // Create a concept with various attributes
    memberConcept = Concept(model, 'Member');
    memberConcept.entry = true;
    memberConcept.updateOid = true;

    // Add a String identifier
    final nameAttr = Attribute(memberConcept, 'name');
    nameAttr.identifier = true;
    nameAttr.type = domain.getType('String');

    // Add other attributes
    final emailAttr = Attribute(memberConcept, 'email');
    emailAttr.type = domain.getType('String');

    final ageAttr = Attribute(memberConcept, 'age');
    ageAttr.type = domain.getType('int');

    final joinDateAttr = Attribute(memberConcept, 'joinDate');
    joinDateAttr.type = domain.getType('DateTime');

    final activeAttr = Attribute(memberConcept, 'active');
    activeAttr.type = domain.getType('bool');

    model.concepts.add(memberConcept);

    // Create entities collection
    members = TestMembers(memberConcept);
  });

  group('Entity.copy() Type Casting', () {
    test('copy() returns correct concrete type, not base Entity<E>', () {
      final original = TestMember(memberConcept);
      original.setAttribute('name', 'John Doe');
      original.setAttribute('email', 'john@example.com');
      original.setAttribute('age', 30);
      original.setAttribute('active', true);

      // This should NOT throw a type cast error
      final copy = original.copy();

      // Verify the copy is the correct concrete type
      expect(
        copy,
        isA<TestMember>(),
        reason: 'copy() should return TestMember, not Entity<TestMember>',
      );

      // Verify it's actually a different instance
      expect(
        identical(copy, original),
        isFalse,
        reason: 'copy() should create a new instance',
      );
    });

    test('copy() maintains all attribute values', () {
      final original = TestMember(memberConcept);
      original.setAttribute('name', 'Jane Smith');
      original.setAttribute('email', 'jane@example.com');
      original.setAttribute('age', 25);
      original.setAttribute('active', false);

      final joinDate = DateTime(2024, 1, 15);
      original.setAttribute('joinDate', joinDate);

      final copy = original.copy();

      // Verify all attributes are copied
      expect(copy.getAttribute('name'), equals('Jane Smith'));
      expect(copy.getAttribute('email'), equals('jane@example.com'));
      expect(copy.getAttribute('age'), equals(25));
      expect(copy.getAttribute('active'), equals(false));
      expect(copy.getAttribute('joinDate'), equals(joinDate));
    });

    test('copy() creates independent instance', () {
      final original = TestMember(memberConcept);
      original.setAttribute('name', 'Original Name');
      original.setAttribute('email', 'original@example.com');
      original.setAttribute('age', 30);

      final copy = original.copy();

      // Modify copy (use non-identifier attributes)
      copy.setAttribute('email', 'modified@example.com');
      copy.setAttribute('age', 35);

      // Original should be unchanged
      expect(original.getAttribute('email'), equals('original@example.com'));
      expect(original.getAttribute('age'), equals(30));

      // Copy should have new values
      expect(copy.getAttribute('email'), equals('modified@example.com'));
      expect(copy.getAttribute('age'), equals(35));
    });

    test('copy() preserves OID (shallow copy)', () {
      final original = TestMember(memberConcept);
      original.setAttribute('name', 'Test User');

      final copy = original.copy();

      // Copy preserves the OID (this is by design - it's a shallow copy)
      expect(
        copy.oid,
        equals(original.oid),
        reason: 'Copy preserves OID as per Entity.copy() design',
      );
    });

    test('copy() preserves concept reference', () {
      final original = TestMember(memberConcept);
      original.setAttribute('name', 'Test');

      final copy = original.copy();

      expect(copy.concept, equals(original.concept));
      expect(copy.concept, equals(memberConcept));
    });
  });

  group('Entities.copy() Type Preservation', () {
    test('Entities.copy() returns collection of correct concrete types', () {
      // Add multiple entities
      for (var i = 0; i < 3; i++) {
        final member = TestMember(memberConcept);
        member.setAttribute('name', 'Member $i');
        member.setAttribute('email', 'member$i@example.com');
        member.setAttribute('age', 20 + i);
        members.add(member);
      }

      // Copy the entire collection (returns Entities<TestMember>)
      final copiedMembers = members.copy();

      expect(copiedMembers.length, equals(3));

      // Verify each copied entity is correct type
      for (final copiedMember in copiedMembers) {
        expect(
          copiedMember,
          isA<TestMember>(),
          reason: 'Each copied entity should be TestMember type',
        );
      }
    });

    test('Entities.copy() maintains attribute values for all entities', () {
      // Add entities with specific data
      final member1 = TestMember(memberConcept);
      member1.setAttribute('name', 'Alice');
      member1.setAttribute('age', 30);
      members.add(member1);

      final member2 = TestMember(memberConcept);
      member2.setAttribute('name', 'Bob');
      member2.setAttribute('age', 25);
      members.add(member2);

      // Copy collection
      final copiedMembers = members.copy();

      // Find copied members by name
      final copiedAlice = copiedMembers.firstWhereAttribute('name', 'Alice');
      final copiedBob = copiedMembers.firstWhereAttribute('name', 'Bob');

      expect(copiedAlice, isNotNull);
      expect(copiedBob, isNotNull);
      expect(copiedAlice!.getAttribute('age'), equals(30));
      expect(copiedBob!.getAttribute('age'), equals(25));
    });
  });

  group('Entity.newEntity() Factory', () {
    test('createInstance() returns correct type for concrete subclass', () {
      final member = TestMember(memberConcept);
      member.setAttribute('name', 'Test');

      // createInstance() should return TestMember, not Entity<TestMember>
      final newInstance = member.createInstance();

      expect(
        newInstance,
        isA<TestMember>(),
        reason: 'createInstance() should return concrete type',
      );
    });
  });
}
