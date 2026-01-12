import 'package:ednet_core/ednet_core.dart';
import 'package:test/test.dart';

void main() {
  group('ValueComparator Infrastructure', () {
    group('NullHandlingComparator', () {
      test('null < any_value (nullsFirst)', () {
        const comparator = StringComparator();
        expect(comparator.compare(null, 'hello'), lessThan(0));
        expect(comparator.compare('hello', null), greaterThan(0));
      });

      test('null == null', () {
        const comparator = StringComparator();
        expect(comparator.compare(null, null), equals(0));
      });
    });

    group('StringComparator', () {
      const comparator = StringComparator();

      test('compares strings lexicographically', () {
        expect(comparator.compare('apple', 'banana'), lessThan(0));
        expect(comparator.compare('banana', 'apple'), greaterThan(0));
        expect(comparator.compare('hello', 'hello'), equals(0));
      });

      test('handles empty strings', () {
        expect(comparator.compare('', 'a'), lessThan(0));
        expect(comparator.compare('a', ''), greaterThan(0));
        expect(comparator.compare('', ''), equals(0));
      });

      test('is case-sensitive by default', () {
        expect(
          comparator.compare('Apple', 'apple'),
          lessThan(0),
        ); // 'A' < 'a' in ASCII
      });

      test('canCompare validates type', () {
        expect(comparator.canCompare('hello'), isTrue);
        expect(comparator.canCompare(null), isTrue);
        expect(comparator.canCompare(123), isFalse);
      });
    });

    group('NumericComparator', () {
      const comparator = NumericComparator();

      test('compares integers', () {
        expect(comparator.compare(1, 2), lessThan(0));
        expect(comparator.compare(2, 1), greaterThan(0));
        expect(comparator.compare(5, 5), equals(0));
      });

      test('compares doubles', () {
        expect(comparator.compare(1.5, 2.5), lessThan(0));
        expect(comparator.compare(3.14159, 3.14159), equals(0));
      });

      test('compares mixed int and double', () {
        expect(comparator.compare(1, 1.0), equals(0));
        expect(comparator.compare(1, 1.5), lessThan(0));
      });

      test('handles negative numbers', () {
        expect(comparator.compare(-5, 5), lessThan(0));
        expect(comparator.compare(-1, -2), greaterThan(0));
      });
    });

    group('BoolComparator', () {
      const comparator = BoolComparator();

      test('false < true convention', () {
        expect(comparator.compare(false, true), lessThan(0));
        expect(comparator.compare(true, false), greaterThan(0));
      });

      test('equal booleans', () {
        expect(comparator.compare(true, true), equals(0));
        expect(comparator.compare(false, false), equals(0));
      });

      test('null handling', () {
        expect(comparator.compare(null, true), lessThan(0));
        expect(comparator.compare(null, false), lessThan(0));
        expect(comparator.compare(true, null), greaterThan(0));
      });
    });

    group('DateTimeComparator', () {
      const comparator = DateTimeComparator();

      test('compares dates chronologically', () {
        final earlier = DateTime(2020, 1, 1);
        final later = DateTime(2020, 12, 31);

        expect(comparator.compare(earlier, later), lessThan(0));
        expect(comparator.compare(later, earlier), greaterThan(0));
        expect(comparator.compare(earlier, earlier), equals(0));
      });

      test('handles precision to microseconds', () {
        final dt1 = DateTime(2020, 1, 1, 12, 30, 45, 100, 200);
        final dt2 = DateTime(2020, 1, 1, 12, 30, 45, 100, 201);

        expect(comparator.compare(dt1, dt2), lessThan(0));
      });
    });

    group('DurationComparator', () {
      const comparator = DurationComparator();

      test('compares durations by total microseconds', () {
        final shorter = const Duration(hours: 1);
        final longer = const Duration(hours: 2);

        expect(comparator.compare(shorter, longer), lessThan(0));
        expect(comparator.compare(longer, shorter), greaterThan(0));
      });

      test('equivalent durations in different units', () {
        final minutes60 = const Duration(minutes: 60);
        final hour1 = const Duration(hours: 1);

        expect(comparator.compare(minutes60, hour1), equals(0));
      });
    });

    group('UriComparator', () {
      const comparator = UriComparator();

      test('compares URIs lexicographically', () {
        final uri1 = Uri.parse('http://example.com/a');
        final uri2 = Uri.parse('http://example.com/b');

        expect(comparator.compare(uri1, uri2), lessThan(0));
      });
    });

    group('DynamicComparator', () {
      const comparator = DynamicComparator();

      test('compares Comparable objects', () {
        expect(comparator.compare(1, 2), lessThan(0));
        expect(comparator.compare('a', 'b'), lessThan(0));
      });

      test('falls back to toString for non-Comparable', () {
        // Objects become their toString representations
        final obj1 = _TestObject('apple');
        final obj2 = _TestObject('banana');

        expect(comparator.compare(obj1, obj2), lessThan(0));
      });
    });

    group('FallbackComparator', () {
      const comparator = FallbackComparator();

      test('handles any types without throwing', () {
        expect(() => comparator.compare(Object(), Object()), returnsNormally);
        expect(() => comparator.compare(123, 'hello'), returnsNormally);
      });
    });
  });

  group('Collection Comparators', () {
    group('ListComparator', () {
      // Use default element comparator (DynamicComparator)
      const comparator = ListComparator<int>();

      test('lexicographic element-by-element comparison', () {
        expect(comparator.compare([1, 2, 3], [1, 2, 4]), lessThan(0));
        expect(comparator.compare([1, 2, 4], [1, 2, 3]), greaterThan(0));
        expect(comparator.compare([1, 2, 3], [1, 2, 3]), equals(0));
      });

      test('shorter list < longer list (when prefix matches)', () {
        expect(comparator.compare([1, 2], [1, 2, 3]), lessThan(0));
        expect(comparator.compare([1, 2, 3], [1, 2]), greaterThan(0));
      });

      test('empty list < non-empty list', () {
        expect(comparator.compare([], [1]), lessThan(0));
        expect(comparator.compare([1], []), greaterThan(0));
        expect(comparator.compare(<int>[], <int>[]), equals(0));
      });

      test('null list handling', () {
        expect(comparator.compare(null, [1, 2]), lessThan(0));
        expect(comparator.compare([1, 2], null), greaterThan(0));
        expect(comparator.compare(null, null), equals(0));
      });
    });

    group('SetComparator', () {
      // Use default element comparator (DynamicComparator)
      const comparator = SetComparator<int>();

      test('converts to sorted list for comparison', () {
        // {3, 1, 2} sorted becomes [1, 2, 3]
        expect(comparator.compare({3, 1, 2}, {1, 2, 3}), equals(0));
        expect(comparator.compare({1, 2}, {1, 2, 3}), lessThan(0));
      });

      test('different elements produce different results', () {
        expect(comparator.compare({1, 2, 3}, {1, 2, 4}), lessThan(0));
      });
    });

    group('MapComparator', () {
      // Use default comparators (DynamicComparator for both)
      const comparator = MapComparator<String, int>();

      test('compares by sorted keys first', () {
        expect(
          comparator.compare({'a': 1, 'b': 2}, {'b': 2, 'a': 1}),
          equals(0),
        );
        expect(comparator.compare({'a': 1}, {'b': 1}), lessThan(0));
      });

      test('same keys, different values', () {
        expect(comparator.compare({'a': 1}, {'a': 2}), lessThan(0));
      });

      test('fewer entries < more entries (same prefix keys)', () {
        expect(comparator.compare({'a': 1}, {'a': 1, 'b': 2}), lessThan(0));
      });
    });
  });

  group('ComparatorRegistry', () {
    test('singleton instance', () {
      expect(ComparatorRegistry.instance, same(ComparatorRegistry.instance));
    });

    test('has default comparators registered', () {
      expect(ComparatorRegistry.instance.hasComparator('String'), isTrue);
      expect(ComparatorRegistry.instance.hasComparator('int'), isTrue);
      expect(ComparatorRegistry.instance.hasComparator('double'), isTrue);
      expect(ComparatorRegistry.instance.hasComparator('bool'), isTrue);
      expect(ComparatorRegistry.instance.hasComparator('DateTime'), isTrue);
      expect(ComparatorRegistry.instance.hasComparator('Duration'), isTrue);
      expect(ComparatorRegistry.instance.hasComparator('Uri'), isTrue);
    });

    test('createFor returns registered comparator', () {
      final comparator = ComparatorRegistry.instance.createFor('String');
      expect(comparator, isA<StringComparator>());
    });

    test('createFor handles generic List<T>', () {
      final comparator = ComparatorRegistry.instance.createFor('List<String>');
      expect(comparator, isA<ListComparator>());
    });

    test('createFor handles generic Set<T>', () {
      final comparator = ComparatorRegistry.instance.createFor('Set<int>');
      expect(comparator, isA<SetComparator>());
    });

    test('createFor handles generic Map<K,V>', () {
      final comparator = ComparatorRegistry.instance.createFor(
        'Map<String, int>',
      );
      expect(comparator, isA<MapComparator>());
    });

    test('createFor handles nested generics', () {
      final comparator = ComparatorRegistry.instance.createFor(
        'List<List<String>>',
      );
      expect(comparator, isA<ListComparator>());
    });

    test('createFor returns fallback for unknown types', () {
      final comparator = ComparatorRegistry.instance.createFor('UnknownType');
      expect(comparator, isA<FallbackComparator>());
    });

    test('compare convenience method works', () {
      final result = ComparatorRegistry.instance.compare(
        'apple',
        'banana',
        'String',
      );
      expect(result, lessThan(0));
    });

    test('compare respects disabled metadata', () {
      final metadata = ComparisonMetadata(enabled: false);
      final result = ComparatorRegistry.instance.compare(
        'apple',
        'banana',
        'String',
        metadata,
      );
      expect(result, equals(0)); // Disabled comparison always returns 0
    });

    test('register custom comparator', () {
      // Register a custom comparator
      ComparatorRegistry.instance.register(
        'CustomType',
        const _CustomComparator(),
      );

      expect(ComparatorRegistry.instance.hasComparator('CustomType'), isTrue);

      final result = ComparatorRegistry.instance.compare(
        'anything',
        'anything',
        'CustomType',
      );
      expect(result, equals(42)); // Our custom comparator always returns 42

      // Clean up
      ComparatorRegistry.instance.unregister('CustomType');
    });
  });

  group('ComparisonMetadata', () {
    test('default values', () {
      const metadata = ComparisonMetadata();
      expect(metadata.enabled, isTrue);
      expect(metadata.strategy, equals(ComparisonStrategy.defaultStrategy));
      expect(metadata.caseSensitive, isTrue);
      expect(metadata.nullOrdering, equals(NullOrdering.nullsFirst));
    });

    test('fromYaml parses strategy', () {
      final metadata = ComparisonMetadata.fromYaml({
        'strategy': 'lexicographic',
        'caseSensitive': false,
      });

      expect(metadata.strategy, equals(ComparisonStrategy.lexicographic));
      expect(metadata.caseSensitive, isFalse);
    });

    test('fromYaml parses entity mode', () {
      final metadata = ComparisonMetadata.fromYaml({'strategy': 'by_oid'});

      expect(metadata.mode, equals(ComparisonMode.byOid));
    });

    test('fromYaml parses null ordering', () {
      final metadata = ComparisonMetadata.fromYaml({
        'nullOrdering': 'nullsLast',
      });

      expect(metadata.nullOrdering, equals(NullOrdering.nullsLast));
    });

    test('fromYaml parses attribute key', () {
      final metadata = ComparisonMetadata.fromYaml({
        'strategy': 'by_attribute',
        'attribute': 'lastName',
      });

      expect(metadata.strategy, equals(ComparisonStrategy.byAttribute));
      expect(metadata.attributeKey, equals('lastName'));
    });

    test('toMap serializes correctly', () {
      const metadata = ComparisonMetadata(
        enabled: true,
        strategy: ComparisonStrategy.lexicographic,
        caseSensitive: false,
      );

      final map = metadata.toMap();
      expect(map['enabled'], isTrue);
      expect(map['strategy'], equals('lexicographic'));
      expect(map['caseSensitive'], isFalse);
    });
  });

  group('Edge Cases and Robustness', () {
    test('comparing very large numbers', () {
      const comparator = NumericComparator();
      final bigInt1 = 9223372036854775807; // Max int64
      final bigInt2 = 9223372036854775806;

      expect(comparator.compare(bigInt1, bigInt2), greaterThan(0));
    });

    test('comparing special double values', () {
      const comparator = NumericComparator();

      expect(comparator.compare(double.nan, double.nan), equals(0));
      expect(
        comparator.compare(double.infinity, double.negativeInfinity),
        greaterThan(0),
      );
      expect(
        comparator.compare(double.negativeInfinity, double.infinity),
        lessThan(0),
      );
    });

    test('comparing Unicode strings', () {
      const comparator = StringComparator();

      expect(
        comparator.compare('日本', '中国'),
        isNot(equals(0)),
      ); // Different Unicode strings
      expect(comparator.compare('日本', '日本'), equals(0));
    });

    test('deeply nested collections', () {
      final comparator = ComparatorRegistry.instance.createFor(
        'List<List<List<int>>>',
      );

      final list1 = [
        [
          [1, 2],
        ],
        [
          [3, 4],
        ],
      ];
      final list2 = [
        [
          [1, 2],
        ],
        [
          [3, 5],
        ],
      ];

      expect(comparator.compare(list1, list2), lessThan(0));
    });
  });
}

/// Test helper class for DynamicComparator tests
class _TestObject {
  final String value;
  _TestObject(this.value);

  @override
  String toString() => value;
}

/// Custom comparator for testing registration
class _CustomComparator implements ValueComparator<dynamic> {
  const _CustomComparator();

  @override
  int compare(dynamic value1, dynamic value2) => 42;

  @override
  bool canCompare(dynamic value) => true;

  @override
  NullOrdering get nullOrdering => NullOrdering.nullsFirst;
}
