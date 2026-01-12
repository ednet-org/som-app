import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

void main() {
  group('RandomDataService', () {
    late RandomDataService testService;

    setUp(() {
      testService = RandomDataService.test();
    });

    test('test service uses minimal data sets', () {
      final word = testService.randomWord();
      expect(word, isA<String>());
      expect(
        [
          'test',
          'data',
          'sample',
          'example',
          'mock',
          'demo',
          'prototype',
          'placeholder',
          'default',
          'value',
        ].contains(word),
        isTrue,
      );
    });

    test('test service generates valid URIs', () {
      final uri = testService.randomUri();
      expect(uri, isA<String>());
      expect(uri.startsWith('https://'), isTrue);
    });

    test('test service generates valid emails', () {
      final email = testService.randomEmail();
      expect(email, isA<String>());
      expect(email.contains('@'), isTrue);
    });

    test('test service generates quotes', () {
      final quote = testService.randomQuote();
      expect(quote, isA<String>());
      expect(quote.isNotEmpty, isTrue);
    });

    test('legacy service uses full data sets', () {
      final legacyService = RandomDataService.legacy();
      final word = legacyService.randomWord();
      expect(word, isA<String>());
      expect(word.isNotEmpty, isTrue);
    });

    test('backward compatibility functions work', () {
      final word = randomWordFromService();
      final uri = randomUriFromService();
      final email = randomEmailFromService();
      final quote = randomQuoteFromService();

      expect(word, isA<String>());
      expect(uri, isA<String>());
      expect(email, isA<String>());
      expect(quote, isA<String>());
    });

    test('empty config returns empty strings', () {
      // Override with empty config
      final emptyConfigService = RandomDataService(_EmptyConfigProvider());

      expect(emptyConfigService.randomWord(), equals(''));
      expect(emptyConfigService.randomUri(), equals(''));
      expect(emptyConfigService.randomEmail(), equals(''));
      expect(emptyConfigService.randomQuote(), equals(''));
    });
  });
}

/// Test helper for empty config
class _EmptyConfigProvider implements RandomDataConfigProvider {
  @override
  RandomDataConfig get config => RandomDataConfig.empty();
}
