import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SomLocalizations {
  final Locale locale;

  static const LocalizationsDelegate<SomLocalizations> delegate =
      _SomLocalizationsDelegate();

  SomLocalizations(this.locale);

  static SomLocalizations? of(BuildContext context) {
    return Localizations.of<SomLocalizations>(context, SomLocalizations);
  }

  late Map<String, String> _localizedStrings;

  Future<bool> load() async {
    // Load the language JSON file from the "lang" folder
    String jsonString =
        await rootBundle.loadString('lang/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  // This method will be called from every widget which needs a localized text
  String? translate(String key) {
    return _localizedStrings[key];
  }
}

class _SomLocalizationsDelegate
    extends LocalizationsDelegate<SomLocalizations> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  const _SomLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Include all of your supported language codes here
    return ['en', 'de', 'sr'].contains(locale.languageCode);
  }

  @override
  Future<SomLocalizations> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    SomLocalizations localizations = new SomLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_SomLocalizationsDelegate old) => true;
}

String? keyString(BuildContext context, String key) {
  return SomLocalizations.of(context)!.translate(key);
}
