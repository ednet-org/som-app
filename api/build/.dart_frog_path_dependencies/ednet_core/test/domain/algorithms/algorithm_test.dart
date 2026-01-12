import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

// Test implementation of Algorithm
class TestAlgorithm extends Algorithm<int, int> {
  TestAlgorithm({
    required String code,
    required String name,
    String description = 'Test algorithm',
    List<String> applicableToConcepts = const [],
    List<String> providedBehaviors = const [],
  }) : super(
         code: code,
         name: name,
         description: description,
         applicableToConcepts: applicableToConcepts,
         providedBehaviors: providedBehaviors,
       );

  @override
  int performExecution(int input) {
    // Simple test implementation - doubles the input
    // Add a tiny delay to ensure measurable execution time
    for (int i = 0; i < 1000; i++) {
      // Small computation to ensure measurable time
    }
    return input * 2;
  }
}

// Test algorithm that throws an exception
class FailingAlgorithm extends Algorithm<int, int> {
  FailingAlgorithm()
    : super(
        code: 'failing',
        name: 'Failing Algorithm',
        description: 'Always fails',
      );

  @override
  int performExecution(int input) {
    throw Exception('Intentional failure');
  }
}

void main() {
  group('Algorithm Base Class', () {
    late TestAlgorithm algorithm;
    late Domain domain;
    late Model model;
    late Concept concept;

    setUp(() {
      algorithm = TestAlgorithm(
        code: 'test_algo',
        name: 'Test Algorithm',
        description: 'A test algorithm that doubles input',
        applicableToConcepts: ['Order', 'Customer'],
        providedBehaviors: ['optimization', 'calculation'],
      );
      domain = Domain('TestDomain');
      model = Model(domain, 'TestModel');
      concept = Concept(model, 'Order');
    });

    test('should initialize with correct properties', () {
      expect(algorithm.code, equals('test_algo'));
      expect(algorithm.name, equals('Test Algorithm'));
      expect(
        algorithm.description,
        equals('A test algorithm that doubles input'),
      );
      expect(algorithm.applicableToConcepts, contains('Order'));
      expect(algorithm.applicableToConcepts, contains('Customer'));
      expect(algorithm.providedBehaviors, contains('optimization'));
      expect(algorithm.providedBehaviors, contains('calculation'));
    });

    test('should execute algorithm successfully', () {
      final result = algorithm.execute(5);
      expect(result, equals(10));
    });

    test('should track execution metrics', () {
      // Initial metrics
      var metrics = algorithm.getMetrics();
      expect(metrics['executionCount'], equals(0));
      expect(metrics['totalExecutionTime'], equals(0));
      expect(metrics['averageExecutionTime'], equals(0));
      expect(metrics['lastExecutionTime'], equals(0));

      // Execute algorithm
      algorithm.execute(5);
      algorithm.execute(10);

      // Check updated metrics
      metrics = algorithm.getMetrics();
      expect(metrics['executionCount'], equals(2));
      expect(metrics['totalExecutionTime'], greaterThan(0));
      expect(metrics['averageExecutionTime'], greaterThan(0));
      expect(metrics['lastExecutionTime'], greaterThan(0));
    });

    test('should reset metrics', () {
      // Execute and verify metrics exist
      algorithm.execute(5);
      var metrics = algorithm.getMetrics();
      expect(metrics['executionCount'], equals(1));

      // Reset and verify
      algorithm.resetMetrics();
      metrics = algorithm.getMetrics();
      expect(metrics['executionCount'], equals(0));
      expect(metrics['totalExecutionTime'], equals(0));
      expect(metrics['averageExecutionTime'], equals(0));
      expect(metrics['lastExecutionTime'], equals(0));
    });

    test('should check applicability to concepts', () {
      // Applicable concept
      expect(algorithm.canApplyTo(concept), isTrue);

      // Non-applicable concept
      final productConcept = Concept(model, 'Product');
      expect(algorithm.canApplyTo(productConcept), isFalse);

      // Algorithm with no restrictions
      final universalAlgo = TestAlgorithm(
        code: 'universal',
        name: 'Universal Algorithm',
      );
      expect(universalAlgo.canApplyTo(concept), isTrue);
      expect(universalAlgo.canApplyTo(productConcept), isTrue);
    });

    test('should check applicability by category', () {
      // Create a concept with a code not in applicableToConcepts
      final testConcept = Concept(model, 'Product');

      testConcept.category = 'Order';
      expect(algorithm.canApplyTo(testConcept), isTrue);

      testConcept.category = 'Inventory';
      expect(algorithm.canApplyTo(testConcept), isFalse);
    });

    test('should throw AlgorithmException on failure', () {
      final failingAlgo = FailingAlgorithm();

      expect(() => failingAlgo.execute(5), throwsA(isA<AlgorithmException>()));

      try {
        failingAlgo.execute(5);
      } catch (e) {
        expect(e.toString(), contains('Algorithm failing failed'));
      }
    });

    test('should provide string representation', () {
      expect(algorithm.toString(), equals('Test Algorithm (test_algo)'));
    });
  });
}
