import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/character_model.dart';

class PrefsService {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUsername = 'username';
  static const String _keyFavorites = 'favorite_characters';

  static Future<void> saveLoginSession(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUsername, username);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  static Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername) ?? 'Explorer';
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyUsername);
  }

  static Future<void> saveFavorites(List<Character> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> jsonList =
        favorites.map((char) => jsonEncode(char.toJson())).toList();
    await prefs.setStringList(_keyFavorites, jsonList);
  }

  static Future<List<Character>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonList = prefs.getStringList(_keyFavorites);
    if (jsonList == null) return [];
    return jsonList
        .map((item) => Character.fromJson(jsonDecode(item)))
        .toList();
  }
}