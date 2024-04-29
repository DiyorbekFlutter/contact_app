import 'package:shared_preferences/shared_preferences.dart';

sealed class SharedPreferencesService {
  static late final SharedPreferences prefs;
  static void storageString(SharedPreferencesStorageKey key, String data) => prefs.setString(key.name, data);
  static String? getString(SharedPreferencesStorageKey key) => prefs.getString(key.name);
  static void remove(SharedPreferencesStorageKey key) => prefs.remove(key.name);
}

enum SharedPreferencesStorageKey {
  registered,
  language
}
