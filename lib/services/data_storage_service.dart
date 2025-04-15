import 'package:ice_cream/misc/data_storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataStorageService {
  SharedPreferences? _prefs;

  Future<SharedPreferences> get prefsGetter async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future setString(DataStorageKey dataStorageKey, String data) async {
    final prefs = await prefsGetter;
    prefs.setString(dataStorageKey.value, data); // Only use SharedPreferences
  }

  Future<String?> getString(DataStorageKey dataStorageKey) async {
    final prefs = await prefsGetter;
    return prefs.getString(dataStorageKey.value); // Only use SharedPreferences
  }

  Future<bool> getBool(DataStorageKey dataStorageKey) async {
    final prefs = await prefsGetter;
    return prefs.getBool(dataStorageKey.value) ?? false;
  }

  Future setBool(DataStorageKey dataStorageKey, bool value) async {
    final prefs = await prefsGetter;
    await prefs.setBool(dataStorageKey.value, value);
  }

  Future remove(DataStorageKey datastorageKey) async {
    final prefs = await prefsGetter;
    await prefs.remove(datastorageKey.value); // Remove from SharedPreferences
  }

  Future clear() async {
    final prefs = await prefsGetter;
    await prefs.clear(); // Clear all from SharedPreferences
  }
}
