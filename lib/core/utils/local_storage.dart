import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage(this.sharedPreference);
  final SharedPreferences sharedPreference;

  Future<void> saveData({required String key, required String value}) async {
    await sharedPreference.setString(key, value);
  }

  String? readData({required String key}) {
    final String? value = sharedPreference.getString(key);
    return value;
  }
}
