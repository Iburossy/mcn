import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class LanguageProvider with ChangeNotifier {
  Locale _currentLocale = const Locale('fr');

  Locale get currentLocale => _currentLocale;
  String get currentLanguage => _currentLocale.languageCode;

  // Langues supportées
  static const List<Locale> supportedLocales = [
    Locale('fr'), // Français
    Locale('en'), // Anglais
    Locale('wo'), // Wolof
  ];

  // Noms des langues pour l'affichage
  static const Map<String, String> languageNames = {
    'fr': 'Français',
    'en': 'English',
    'wo': 'Wolof',
  };

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(StorageKeys.language) ?? 'fr';
    _currentLocale = Locale(languageCode);
    notifyListeners();
  }

  Future<void> setLanguage(String languageCode) async {
    if (languageCode != _currentLocale.languageCode) {
      _currentLocale = Locale(languageCode);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(StorageKeys.language, languageCode);
      notifyListeners();
    }
  }

  String getLanguageName(String languageCode) {
    return languageNames[languageCode] ?? languageCode;
  }

  bool isLanguageSupported(String languageCode) {
    return supportedLocales.any((locale) => locale.languageCode == languageCode);
  }
}
