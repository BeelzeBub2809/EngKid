import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static late SharedPreferences _sharedPreferences;

  SharedPreferencesManager() {
    SharedPreferences.getInstance().then((value) {
      _sharedPreferences = value;
    });
  }

  Set<String> getKeys() {
    return _sharedPreferences.getKeys();
  }

  Future<bool> putString({required String key, required String value}) =>
      _sharedPreferences.setString(key, value);

  Future<bool> putStringList(
          {required String key, required List<String> value}) =>
      _sharedPreferences.setStringList(key, value);
  String? getString(String key) => _sharedPreferences.getString(key);
  List<String>? getStringList(String key) =>
      _sharedPreferences.getStringList(key);

  Future<bool> putInt({required String key, required int value}) =>
      _sharedPreferences.setInt(key, value);
  int? getInt(String key) => _sharedPreferences.getInt(key);

  Future<bool> putBool({required String key, required bool value}) =>
      _sharedPreferences.setBool(key, value);
  bool? getBool(String key) => _sharedPreferences.getBool(key);

  Future<bool> putDouble({required String key, required double value}) =>
      _sharedPreferences.setDouble(key, value);
  double? getDouble(String key) => _sharedPreferences.getDouble(key);

  Future remove(String key) => _sharedPreferences.remove(key);

  Future clear() => _sharedPreferences.clear();
}
