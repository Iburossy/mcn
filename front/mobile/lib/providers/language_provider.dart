import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class LanguageProvider with ChangeNotifier {
  String _currentLanguage = 'fr';

  String get currentLanguage => _currentLanguage;

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString(StorageKeys.language) ?? 'fr';
    notifyListeners();
  }

  Future<void> setLanguage(String language) async {
    if (language != _currentLanguage) {
      _currentLanguage = language;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(StorageKeys.language, language);
      notifyListeners();
    }
  }
}
