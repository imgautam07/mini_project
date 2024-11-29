import 'package:shared_preferences/shared_preferences.dart';

class LocalDataManager {
  static const String _loginKey = "LOGIN_KEY";
  static const String _splashKey = "splash";
  static const String _themeKey = "THEME_KEY";

  static Future<bool> storeToken(String token) async {
    SharedPreferences share = await SharedPreferences.getInstance();
    return share.setString(_loginKey, token);
  }

  static Future<String?> getToken() async {
    SharedPreferences share = await SharedPreferences.getInstance();
    return share.getString(_loginKey);
  }

  static Future<bool> deleteToken() async {
    SharedPreferences share = await SharedPreferences.getInstance();
    return share.remove(_loginKey);
  }

  static Future<bool> appOpened() async {
    SharedPreferences pre = await SharedPreferences.getInstance();

    return pre.getBool(_splashKey) ?? false;
  }

  static Future<bool> setOpened(bool value) async {
    SharedPreferences pre = await SharedPreferences.getInstance();

    return await pre.setBool(_splashKey, value);
  }

  static Future<bool> isThemeDark() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    var r = pre.getBool(_themeKey);
    return r ?? false;
  }

  static Future<void> setThemeDark(bool value) async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    await pre.setBool(_themeKey, value);
  }
}