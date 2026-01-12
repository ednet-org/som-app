part of ednet_core;

/// Configuration for random data generation
class RandomDataConfig {
  final List<String> words;
  final List<String> uris;
  final List<String> emails;
  final List<String> quotes;

  const RandomDataConfig({
    required this.words,
    required this.uris,
    required this.emails,
    required this.quotes,
  });

  /// Creates a minimal config with empty lists for testing
  factory RandomDataConfig.empty() =>
      const RandomDataConfig(words: [], uris: [], emails: [], quotes: []);

  /// Creates a config with default test data
  factory RandomDataConfig.withDefaults() => const RandomDataConfig(
    words: [
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
    ],
    uris: ['https://example.com', 'https://test.com', 'https://demo.com'],
    emails: ['test@example.com', 'demo@test.com', 'sample@mock.com'],
    quotes: [
      'This is a test quote.',
      'Another sample quote for testing.',
      'Mock quote for development purposes.',
    ],
  );
}

/// Provider for random data generation configuration
abstract class RandomDataConfigProvider {
  RandomDataConfig get config;
}

/// Default implementation that uses the legacy hardcoded data
/// Data has been moved to random_data_legacy.dart to remove hardcoded content from production library
class LegacyRandomDataConfigProvider implements RandomDataConfigProvider {
  @override
  RandomDataConfig get config => RandomDataConfig(
    words: wordList,
    uris: uriList,
    emails: emailList,
    quotes: quotes.map((q) => q.text).toList(),
  );
}

/// Test implementation that uses minimal data
class TestRandomDataConfigProvider implements RandomDataConfigProvider {
  @override
  RandomDataConfig get config => RandomDataConfig.withDefaults();
}
