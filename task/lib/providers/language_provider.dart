import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const _key = 'app_language';

  String _lang = 'en'; // 'en' or 'hi'

  bool get isHindi => _lang == 'hi';
  Locale get locale => Locale(_lang);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _lang = prefs.getString(_key) ?? 'en';
    notifyListeners();
  }

  Future<void> toggle() async {
    _lang = isHindi ? 'en' : 'hi';
    notifyListeners(); // UI changes right away, saving happens after

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, _lang);
  }
}
