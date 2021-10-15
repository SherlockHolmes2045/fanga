import 'package:flutter/material.dart';
import 'package:fanga/localization/language/language_en.dart';
import 'package:fanga/localization/language/language_fr.dart';

import 'language/languages.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<Languages> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['fr', 'en'].contains(locale.languageCode);

  @override
  Future<Languages> load(Locale locale) => _load(locale);

  static Future<Languages> _load(Locale locale) async {
    switch (locale.languageCode) {
      case 'en':
        return LanguageEn();
      case 'fr':
        return LanguageFr();
      default:
        return LanguageFr();
    }
  }

  @override
  bool shouldReload(LocalizationsDelegate<Languages> old) => false;
}
