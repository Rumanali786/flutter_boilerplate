import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageDb {
  static late SharedPreferences _sharedPreferences;

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<void> setString(String key, String value) async {
    await _sharedPreferences.setString(key, value);
  }

  static String getString(String key) {
    return _sharedPreferences.getString(key) ?? '';
  }

  static Future<void> setBool(String key, bool value) async {
    await _sharedPreferences.setBool(key, value);
  }

  static bool getBool(String key) {
    return _sharedPreferences.getBool(key) ?? false;
  }

  static bool? getNullBool(String key) {
    return _sharedPreferences.getBool(key);
  }

  static Future<void> setInt(String key, int value) async {
    await _sharedPreferences.setInt(key, value);
  }

  static int getInt(String key) {
    return _sharedPreferences.getInt(key) ?? 0;
  }

  static int? getNullInt(String key) {
    return _sharedPreferences.getInt(key);
  }


  static Future<void> setStringList(String key, List<String> value) async {
    await _sharedPreferences.setStringList(key, value);
  }

  static List<String> getStringList(String key) {
    return _sharedPreferences.getStringList(key) ?? [];
  }

  static Future<void> removeValue({required String key}) async {
    await _sharedPreferences.remove(key);
  }

  static Future<void> deletedAllSecureData() async {
    await _sharedPreferences.clear();
  }
}
