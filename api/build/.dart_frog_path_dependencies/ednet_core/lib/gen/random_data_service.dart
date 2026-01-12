part of ednet_core;

/// Service for generating random data with configurable data sources
class RandomDataService {
  final RandomDataConfigProvider _configProvider;

  RandomDataService(this._configProvider);

  /// Factory constructor using legacy hardcoded data
  factory RandomDataService.legacy() =>
      RandomDataService(LegacyRandomDataConfigProvider());

  /// Factory constructor for testing with minimal data
  factory RandomDataService.test() =>
      RandomDataService(TestRandomDataConfigProvider());

  String randomWord() => _randomElement(_configProvider.config.words);

  String randomUri() => _randomElement(_configProvider.config.uris);

  String randomEmail() => _randomElement(_configProvider.config.emails);

  String randomQuote() => _randomElement(_configProvider.config.quotes);

  String _randomElement(List<String> list) {
    if (list.isEmpty) return '';
    return list[_randomInt(list.length - 1)];
  }

  int _randomInt(int max) => Random().nextInt(max);
}

/// Global instance for backward compatibility
final RandomDataService _globalRandomDataService = RandomDataService.legacy();

/// Backward-compatible functions that use the global service
String randomWordFromService() => _globalRandomDataService.randomWord();
String randomUriFromService() => _globalRandomDataService.randomUri();
String randomEmailFromService() => _globalRandomDataService.randomEmail();
String randomQuoteFromService() => _globalRandomDataService.randomQuote();
