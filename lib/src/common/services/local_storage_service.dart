import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _keyIsFirstTime = 'is_first_time';

  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  static Future<LocalStorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService(prefs);
  }

  bool getIsFirstTime() {
    return _prefs.getBool(_keyIsFirstTime) ?? true;
  }

  Future<void> setFirstTime(bool value) async {
    await _prefs.setBool(_keyIsFirstTime, value);
  }
}
