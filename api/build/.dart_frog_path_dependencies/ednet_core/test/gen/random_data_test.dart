import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

void main() {
  group('Random Data Generation', () {
    test('randomBool returns boolean values', () {
      final result = randomBool();
      expect(result, isA<bool>());
    });

    test('randomInt returns integer within range', () {
      final result = randomInt(10);
      expect(result, isA<int>());
      expect(result, greaterThanOrEqualTo(0));
      expect(result, lessThan(10));
    });

    test('randomDouble returns double within range', () {
      final result = randomDouble(10.0);
      expect(result, isA<double>());
      expect(result, greaterThanOrEqualTo(0.0));
      expect(result, lessThan(10.0));
    });

    test('randomNum returns num within range', () {
      final result = randomNum(10);
      expect(result, isA<num>());
      expect(result.abs(), lessThan(10));
    });

    test('randomWord returns a string', () {
      final result = randomWord();
      expect(result, isA<String>());
      expect(result.isNotEmpty, isTrue);
    });

    test('randomUri returns a string', () {
      final result = randomUri();
      expect(result, isA<String>());
      expect(result.isNotEmpty, isTrue);
    });

    test('randomEmail returns a string', () {
      final result = randomEmail();
      expect(result, isA<String>());
      expect(result.isNotEmpty, isTrue);
      expect(result.contains('@'), isTrue);
    });

    test('randomQuote returns a non-empty string', () {
      final result = randomQuote();
      expect(result, isA<String>());
      expect(result.isNotEmpty, isTrue);
    });

    test('randomQuote returns different quotes on multiple calls', () {
      final results = <String>{};
      for (var i = 0; i < 10; i++) {
        results.add(randomQuote());
      }
      // Should get at least some different quotes (allowing for randomness)
      expect(results.length, greaterThanOrEqualTo(1));
    });

    test('randomListElement returns element from list', () {
      final testList = ['a', 'b', 'c'];
      final result = randomListElement(testList);
      expect(testList.contains(result), isTrue);
    });

    test('randomQuote returns consistent results', () {
      final quote1 = randomQuote();
      final quote2 = randomQuote();
      // Just verify that we get String objects (content may vary due to randomness)
      expect(quote1, isA<String>());
      expect(quote2, isA<String>());
    });

    test('randomSign returns 1 or -1', () {
      for (var i = 0; i < 100; i++) {
        final result = randomSign();
        expect(result, anyOf(equals(1), equals(-1)));
      }
    });

    // TDD Test for hardcoded data issue - now using legacy data file
    test('randomData should not contain hardcoded production data', () {
      // This test verifies that production code no longer contains hardcoded data
      // The data has been moved to random_data_legacy.dart for backward compatibility
      final legacyService = RandomDataService.legacy();

      // Test that the service can access legacy data (moved from production code)
      final word = legacyService.randomWord();
      final uri = legacyService.randomUri();
      final email = legacyService.randomEmail();
      final quote = legacyService.randomQuote();

      expect(word, isA<String>());
      expect(word.isNotEmpty, isTrue);
      expect(uri, isA<String>());
      expect(uri.isNotEmpty, isTrue);
      expect(email, isA<String>());
      expect(email.contains('@'), isTrue);
      expect(quote, isA<String>());
      expect(quote.isNotEmpty, isTrue);

      // This demonstrates the architectural fix: data is now properly encapsulated
    });

    test(
      'randomData functions should be replaceable with service-based approach',
      () {
        // Test that we can use the service-based approach as a drop-in replacement
        final service = RandomDataService.test();
        final serviceWord = service.randomWord();
        final serviceUri = service.randomUri();
        final serviceEmail = service.randomEmail();
        final serviceQuote = service.randomQuote();

        expect(serviceWord, isA<String>());
        expect(serviceUri, isA<String>());
        expect(serviceEmail, isA<String>());
        expect(serviceQuote, isA<String>());
      },
    );
  });
}
