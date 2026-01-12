part of ednet_core;

/// Random data generation functions - now using service-based approach
/// All hardcoded data has been moved to random_data_legacy.dart for backward compatibility

bool randomBool() => Random().nextBool();

double randomDouble(num max) => Random().nextDouble() * max;

int randomInt(int max) => Random().nextInt(max);

num randomNum(int max) {
  var logic = randomBool();
  var sign = randomSign();
  if (logic) {
    return sign * randomInt(max);
  } else {
    return sign * randomDouble(max);
  }
}

randomSign() {
  int result = 1;
  var random = randomInt(10);
  if (random == 0 || random == 5 || random == 10) {
    result = -1;
  }
  return result;
}

String randomWord() => _globalRandomDataService.randomWord();

String randomUri() => _globalRandomDataService.randomUri();

String randomEmail() => _globalRandomDataService.randomEmail();

String randomQuote() => _globalRandomDataService.randomQuote();

randomListElement(List list) => list[randomInt(list.length - 1)];
