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

  static Future<void> setInt(String key, int value) async {
    await _sharedPreferences.setInt(key, value);
  }

  static int getInt(String key) {
    return _sharedPreferences.getInt(key) ?? 0;
  }

  static Future<void> removeValue({required String key}) async {
    await _sharedPreferences.remove(key);
  }

  static Future<void> deletedAllData() async {
    await _sharedPreferences.clear();
  }
}