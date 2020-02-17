import 'package:big/localization/all_translations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale locale;
  LanguageProvider(locale){
this.locale=locale;
  }
  
  setLang(language) async {
    if (language == 'عربي') {
      await allTranslations.setNewLanguage("ar");
    } else if (language == 'Française') {
      await allTranslations.setNewLanguage("fr");
    } else if (language == 'русский') {
      await allTranslations.setNewLanguage("ru");
    } else if (language == 'Türk') {
      await allTranslations.setNewLanguage("tr");
    } else if (language == 'italiana') {
      await allTranslations.setNewLanguage("it");
    } else if (language == 'Deutsch') {
      await allTranslations.setNewLanguage("de");
    } else if (language == '中文') {
      await allTranslations.setNewLanguage("zh");
    } else {
      await allTranslations.setNewLanguage("en");
    }
    locale=allTranslations.locale;
    notifyListeners();
  }
}
