import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/mock_api.dart';


class ApplyProvider extends ChangeNotifier {
  static const _key = 'applied_ids';

  final MockApi _api;
  ApplyProvider(this._api);

  final Set<String> _applied = {};

  bool isApplied(String id) => _applied.contains(id);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _applied.addAll(prefs.getStringList(_key) ?? []);
    notifyListeners();
  }

  Future<bool> apply(String id) async {
    if (_applied.contains(id)) return true;

    _applied.add(id);
    notifyListeners();

    try {
      await _api.applyToJob(id);
      await _save();
      return true;
    } on ApiException {
      _applied.remove(id);
      notifyListeners();
      return false;
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, _applied.toList());
  }
}
