import 'package:hive_flutter/hive_flutter.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  DBHelper._init();

  static const String usersBoxName = 'users_box';

  static Future<void> initHive() async {
    await Hive.initFlutter();
    await Hive.openBox(usersBoxName);
  }

  Box get _usersBox => Hive.box(usersBoxName);

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
}