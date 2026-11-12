import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String keyIsLoggedIn = 'IS_LOGGED_IN';
  static const String keyUsername = 'USERNAME';
  static const String keyRegisteredUser = 'REG_USER';
  static const String keyRegisteredPass = 'REG_PASS';

  static Future<bool> register(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyRegisteredUser, username);
    await prefs.setString(keyRegisteredPass, password);
    return true;
  }

  static Future<bool> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    String? regUser = prefs.getString(keyRegisteredUser) ?? 'admin';
    String? regPass = prefs.getString(keyRegisteredPass) ?? 'admin123';

    if (username == regUser && password == regPass) {
      await prefs.setBool(keyIsLoggedIn, true);
      await prefs.setString(keyUsername, username);
      return true;
    }
    return false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyIsLoggedIn, false);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyIsLoggedIn) ?? false;
  }
}