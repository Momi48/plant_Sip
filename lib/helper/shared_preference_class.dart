// Source - https://stackoverflow.com/a/69056214
// Posted by Hassan Sammour
// Retrieved 2026-03-15, License - CC BY-SA 4.0

import 'package:shared_preferences/shared_preferences.dart';

class SPHelper {
  SPHelper._();
  static SPHelper sp = SPHelper._();
  SharedPreferences? prefs;
  Future<void> initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> save(String name, String value) async {
    await prefs!.setString(name, value);
  }

  String? get(String key) {
    return prefs!.getString(key);
  }

  Future<bool> delete(String key) async {
    return await prefs!.remove(key);
  }
}
