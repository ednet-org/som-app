import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

void main() {
  group('Bloom Filter Algorithm', () {
    late BloomFilterAlgorithm bloomFilter;

    setUp(() {
      bloomFilter = BloomFilterAlgorithm();
    });

    test('should have correct algorithm properties', () {
      expect(bloomFilter.code, equals('bloom_filter'));
      expect(bloomFilter.name, equals('Bloom Filter'));
      expect(
        bloomFilter.providedBehaviors,
        contains('fast-membership-testing'),
      );
      expect(bloomFilter.providedBehaviors, contains('probabilistic-search'));
      expect(
        bloomFilter.providedBehaviors,
        contains('memory-efficient-lookup'),
      );
    });

    test('should create bloom filter and test membership', () {
      final items = ['Customer', 'Order', 'Product', 'Invoice'];

      final input = BloomFilterInput(
        items: items,
        expectedElements: 10,
        falsePositiveRate: 0.01,
      );

      final result = bloomFilter.execute(input);

      expect(result.filter, isNotNull);
      expect(result.size, greaterThan(0));
      expect(result.hashFunctions, greaterThan(0));

      // All added items should test positive (true positives)
      for (final item in items) {
        expect(
          result.contains(item),
          isTrue,
          reason: '$item should be in filter',
        );
      }

      // Non-added items might test positive (false positives) or negative
      // but should not always test positive
      final nonItems = ['NonExistent1', 'NonExistent2', 'NotThere'];
      var allPositive = true;
      for (final item in nonItems) {
        if (!result.contains(item)) {
          allPositive = false;
          break;
        }
      }
      expect(
        allPositive,
        isFalse,
        reason: 'Not all non-items should test positive',
      );
    });

    test('should respect false positive rate approximately', () {
      final items = List.generate(100, (i) => 'Item$i');

      final input = BloomFilterInput(
        items: items,
        expectedElements: 100,
        falsePositiveRate: 0.1, // 10% false positive rate
      );

      final result = bloomFilter.execute(input);

      // Test with items definitely not in the set
      final testItems = List.generate(1000, (i) => 'TestItem$i');
      var falsePositives = 0;

      for (final item in testItems) {
        if (result.contains(item)) {
          falsePositives++;
        }
      }

      final actualRate = falsePositives / testItems.length;

      // Should be roughly within the expected false positive rate
      // Allow some tolerance due to probabilistic nature
      expect(
        actualRate,
        lessThanOrEqualTo(0.15),
        reason: 'False positive rate too high: $actualRate',
      );
    });

    test('should work with concept names for semantic search', () {
      // Simulate concept knowledge base
      final conceptNames = [
        'Customer',
        'Order',
        'Product',
        'Invoice',
        'Payment',
        'Shipping',
        'Inventory',
        'Supplier',
        'Category',
        'Review',
        'User',
        'Account',
        'Transaction',
        'Report',
        'Analytics',
      ];

      final input = BloomFilterInput(
        items: conceptNames,
        expectedElements: 20,
        falsePositiveRate: 0.05,
      );

      final result = bloomFilter.execute(input);

      // Fast concept existence checking
      expect(result.contains('Customer'), isTrue);
      expect(result.contains('Order'), isTrue);
      expect(result.contains('Product'), isTrue);

      // Semantic variations might trigger false positives
      final variations = ['customer', 'CUSTOMER', 'Customer1'];
      for (final variation in variations) {
        if (result.contains(variation)) {
          break;
        }
      }
      // Some variations might be false positives, which is expected
    });

    test('should demonstrate memory efficiency', () {
      // Large number of items
      final largeItemSet = List.generate(10000, (i) => 'Entity$i');

      final input = BloomFilterInput(
        items: largeItemSet,
        expectedElements: 10000,
        falsePositiveRate: 0.01,
      );

      final result = bloomFilter.execute(input);

      // Bloom filter should be reasonably sized based on mathematical formula
      // For 10000 elements and 1% false positive rate, optimal size is ~95851 bits
      const expectedMinSize =
          90000; // Reasonable minimum based on bloom filter math
      const expectedMaxSize = 100000; // Reasonable maximum
      expect(
        result.size,
        greaterThan(expectedMinSize),
        reason: 'Bloom filter should be large enough for the required capacity',
      );
      expect(
        result.size,
        lessThan(expectedMaxSize),
        reason: 'Bloom filter should not be excessively large',
      );

      // Should still find all items
      var foundCount = 0;
      for (final item in largeItemSet.take(100)) {
        // Test sample
        if (result.contains(item)) {
          foundCount++;
        }
      }
      expect(foundCount, equals(100), reason: 'Should find all added items');
    });

    test('should support adding items after creation', () {
      final initialItems = ['A', 'B', 'C'];

      final input = BloomFilterInput(
        items: initialItems,
        expectedElements: 10,
        falsePositiveRate: 0.01,
      );

      final result = bloomFilter.execute(input);

      // Add new items
      result.add('D');
      result.add('E');

      // Should find both old and new items
      expect(result.contains('A'), isTrue);
      expect(result.contains('D'), isTrue);
      expect(result.contains('E'), isTrue);
    });

    test('should work with entity codes for fast lookup', () {
      final domain = Domain('TestDomain');
      final model = Model(domain, 'TestModel');
      final concept = Concept(model, 'Entity');

      final entities = Entities<DynamicEntity>();
      entities.concept = concept;

      // Create many entities
      final entityCodes = <String>[];
      for (int i = 0; i < 1000; i++) {
        final entity = DynamicEntity.withConcept(concept);
        entity.code = 'Entity$i';
        entities.add(entity);
        entityCodes.add(entity.code);
      }

      // Create bloom filter for fast code lookup
      final input = BloomFilterInput(
        items: entityCodes,
        expectedElements: 1000,
        falsePositiveRate: 0.01,
      );

      final result = bloomFilter.execute(input);

      // Fast existence checking
      expect(result.contains('Entity0'), isTrue);
      expect(result.contains('Entity500'), isTrue);
      expect(result.contains('Entity999'), isTrue);

      // Non-existent entities
      expect(result.contains('Entity1000'), isFalse);
      expect(result.contains('NonExistent'), isFalse);
    });

    test('should provide filter statistics', () {
      final items = List.generate(50, (i) => 'Item$i');

      final input = BloomFilterInput(
        items: items,
        expectedElements: 50,
        falsePositiveRate: 0.05,
      );

      final result = bloomFilter.execute(input);

      final stats = result.getStatistics();

      expect(stats['size'], isNotNull);
      expect(stats['hashFunctions'], isNotNull);
      expect(stats['expectedElements'], equals(50));
      expect(stats['falsePositiveRate'], closeTo(0.05, 0.01));
      expect(stats['bitsPerElement'], greaterThan(0));
    });

    test('should demonstrate dbpedia-style concept filtering', () {
      // Simulate large knowledge base concepts
      final dbpediaConcepts = [
        'Person',
        'Place',
        'Organization',
        'Event',
        'Species',
        'Book',
        'Film',
        'Album',
        'Song',
        'Artwork',
        'Building',
        'Monument',
        'Stadium',
        'University',
        'Hospital',
        'Country',
        'City',
        'River',
        'Mountain',
        'Lake',
        'Company',
        'Government',
        'PoliticalParty',
        'Military',
        'Scientist',
        'Artist',
        'Athlete',
        'Politician',
        'Writer',
      ];

      final input = BloomFilterInput(
        items: dbpediaConcepts,
        expectedElements: 100, // Expecting more concepts
        falsePositiveRate: 0.02,
      );

      final result = bloomFilter.execute(input);

      // Fast semantic concept checking
      expect(result.contains('Person'), isTrue);
      expect(result.contains('Organization'), isTrue);
      expect(result.contains('Country'), isTrue);

      // Unknown concepts should mostly be negative
      final unknownConcepts = [
        'XyzUnknown',
        'RandomConcept123',
        'NotInDbpedia',
      ];

      var falsePositiveCount = 0;
      for (final concept in unknownConcepts) {
        if (result.contains(concept)) {
          falsePositiveCount++;
        }
      }

      // Most should be negative (but some false positives are expected)
      expect(falsePositiveCount, lessThan(unknownConcepts.length));
    });

    test('should handle empty filter', () {
      final input = BloomFilterInput(
        items: <String>[],
        expectedElements: 10,
        falsePositiveRate: 0.01,
      );

      final result = bloomFilter.execute(input);

      // Empty filter should mostly return false
      expect(result.contains('Anything'), isFalse);
      expect(result.contains('Something'), isFalse);
    });

    test('should track performance metrics', () {
      final items = List.generate(100, (i) => 'Item$i');

      final input = BloomFilterInput(
        items: items,
        expectedElements: 100,
        falsePositiveRate: 0.01,
      );

      // Execute multiple times
      bloomFilter.execute(input);
      bloomFilter.execute(input);

      final metrics = bloomFilter.getMetrics();
      expect(metrics['executionCount'], equals(2));
      expect(metrics['totalExecutionTime'], greaterThan(0));
    });
  });
}
