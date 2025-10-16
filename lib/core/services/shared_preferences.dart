import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  factory SharedPreferencesService() => _instance;
  SharedPreferencesService._internal();
  static final SharedPreferencesService _instance = SharedPreferencesService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> writeString(String key, String value) async {
    await init();
    await _prefs!.setString(key, value);
  }

  Future<String?> readString(String key) async {
    await init();
    return _prefs!.getString(key);
  }

  Future<void> writeBool(String key, bool value) async {
    await init();
    await _prefs!.setBool(key, value);
  }

  Future<bool?> readBool(String key) async {
    await init();
    return _prefs!.getBool(key);
  }

  Future<void> writeInt(String key, int value) async {
    await init();
    await _prefs!.setInt(key, value);
  }

  Future<int?> readInt(String key) async {
    await init();
    return _prefs!.getInt(key);
  }

  Future<void> writeDouble(String key, double value) async {
    await init();
    await _prefs!.setDouble(key, value);
  }

  Future<double?> readDouble(String key) async {
    await init();
    return _prefs!.getDouble(key);
  }

  Future<void> writeStringList(String key, List<String> value) async {
    await init();
    await _prefs!.setStringList(key, value);
  }

  Future<List<String>?> readStringList(String key) async {
    await init();
    return _prefs!.getStringList(key);
  }

  Future<void> delete(String key) async {
    await init();
    await _prefs!.remove(key);
  }

  Future<void> deleteAll() async {
    await init();
    await _prefs!.clear();
  }

  Future<bool> containsKey(String key) async {
    await init();
    return _prefs!.containsKey(key);
  }

  Future<Set<String>> getKeys() async {
    await init();
    return _prefs!.getKeys();
  }
}
