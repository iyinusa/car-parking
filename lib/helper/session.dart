import 'package:shared_preferences/shared_preferences.dart';

class Session {
  /// set login status
  Future<void> setLog(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', status);
  }

  /// get login status
  Future<bool?> getLog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn');
  }

  /// set other data
  Future<void> setData(
    String type,
    String key,
    var value,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (type == 'string') prefs.setString(key, value);
    if (type == 'int') prefs.setInt(key, value);
    if (type == 'bool') prefs.setBool(key, value);
    if (type == 'double') prefs.setDouble(key, value);
  }

  getData(
    String type,
    String key,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (type == 'string') return prefs.getString(key);
    if (type == 'int') return prefs.getInt(key);
    if (type == 'bool') return prefs.getBool(key);
    if (type == 'double') return prefs.getDouble(key);
  }
}
