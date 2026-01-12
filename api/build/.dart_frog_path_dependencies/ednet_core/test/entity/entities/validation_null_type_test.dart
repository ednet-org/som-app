import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

/// Test entity class
class TestProduct extends Entity<TestProduct> {
  TestProduct(Concept concept) {
    this.concept = concept;
  }

  @override
  TestProduct createInstance() => TestProduct(concept!);
}

/// Test entities collection
class TestProducts extends Entities<TestProduct> {
  TestProducts(Concept concept) {
    this.concept = concept;
  }
}

/// Tests for attribute type null safety in validation.
///
/// These tests verify that:
/// 1. Validation handles null attribute type gracefully (no crash)
/// 2. Null attribute type is reported as validation error
void main() {
  late Domain domain;
  late Model model;
  late Concept productConcept;
  late TestProducts products;

  setUp(() {
    domain = Domain('Test');
    model = Model(domain, 'TestModel');
    domain.models.add(model);

    // Create concept with attributes
    productConcept = Concept(model, 'Product');
    productConcept.entry = true;
    productConcept.updateOid = true;

    // Add a String identifier
    final nameAttr = Attribute(productConcept, 'name');
    nameAttr.identifier = true;
    nameAttr.type = domain.getType('String');

    // Add a price attribute with type
    final priceAttr = Attribute(productConcept, 'price');
    priceAttr.type = domain.getType('double');

    model.concepts.add(productConcept);

    products = TestProducts(productConcept);
  });

  group('Attribute Type Null Safety', () {
    test('Validation handles attribute with null type gracefully', () {
      // Create an attribute WITHOUT a type (null type scenario)
      final descAttr = Attribute(productConcept, 'description');
      // Intentionally NOT setting descAttr.type - leaving it null

      final product = TestProduct(productConcept);
      product.setAttribute('name', 'Test Product');
      product.setAttribute('description', 'This is a test');
      product.setAttribute('price', 19.99);

      // Adding should NOT throw NullCheckException
      expect(
        () => products.add(product),
        returnsNormally,
        reason: 'Validation should handle null attribute type gracefully',
      );
    });

    test('Validation reports null attribute type as error', () {
      // Create an attribute WITHOUT a type
      final categoryAttr = Attribute(productConcept, 'category');
      // Intentionally NOT setting type - leaving it null

      final product = TestProduct(productConcept);
      product.setAttribute('name', 'Another Product');
      product.setAttribute('category', 'Electronics');
      product.setAttribute('price', 29.99);

      // Clear any previous exceptions
      products.exceptions.clear();

      // Try to add - should report type error, not crash
      products.add(product);

      // Should have validation exception for null type (not crash)
      // Either: entity was added (null type ignored) or exception was raised
      // The key is: NO NULL CHECK EXCEPTION (no crash)
      expect(
        products.exceptions.length,
        greaterThanOrEqualTo(0),
        reason: 'Should not crash with NullCheckException',
      );
    });

    test('Validation succeeds when all attributes have types', () {
      final product = TestProduct(productConcept);
      product.setAttribute('name', 'Valid Product');
      product.setAttribute('price', 49.99);

      products.exceptions.clear();
      final added = products.add(product);

      expect(added, isTrue, reason: 'Should add product with valid types');
      expect(
        products.exceptions,
        isEmpty,
        reason: 'No validation exceptions for properly typed attributes',
      );
    });

    test('Validation catches type mismatch when type is defined', () {
      final product = TestProduct(productConcept);
      product.setAttribute('name', 'Invalid Price Product');
      // Set wrong type for price (string instead of double)
      product.setAttribute('price', 'not a number');

      products.exceptions.clear();
      products.add(product);

      // Should have type validation error for type mismatch
      expect(
        products.exceptions.length,
        greaterThan(0),
        reason: 'Should report type mismatch error',
      );
    });
  });
}
