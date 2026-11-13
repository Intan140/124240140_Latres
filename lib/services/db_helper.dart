import 'package:hive_flutter/hive_flutter.dart';
import '../models/character_model.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  DBHelper._init();

  static const String usersBoxName = 'users_box';
  static const String favoritesBoxName = 'favorites_box';

  static Future<void> initHive() async {
    await Hive.initFlutter();
    await Hive.openBox(usersBoxName);
    await Hive.openBox(favoritesBoxName);
  }

  Box get _usersBox => Hive.box(usersBoxName);
  Box get _favoritesBox => Hive.box(favoritesBoxName);

  // ================= AUTH (REGISTER & LOGIN) =================

  Future<bool> registerUser(String username, String password) async {
    if (_usersBox.containsKey(username)) {
      return false;
    }
    await _usersBox.put(username, password);
    return true;
  }

  Future<bool> loginUser(String username, String password) async {
    if (!_usersBox.containsKey(username)) {
      return false;
    }
    return _usersBox.get(username) == password;
  }

  // ================= FAVORITES CRUD =================

  Future<void> insertFavorite(Character character) async {
    await _favoritesBox.put(character.id.toString(), character.toMap());
  }

  Future<void> deleteFavorite(int id) async {
    await _favoritesBox.delete(id.toString());
  }

  Future<List<Character>> getAllFavorites() async {
    final List<Character> list = [];
    for (final value in _favoritesBox.values) {
      if (value is Map) {
        list.add(Character.fromMap(Map<String, dynamic>.from(value)));
      }
    }
    return list;
  }
}