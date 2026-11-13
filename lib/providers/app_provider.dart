import 'package:flutter/material.dart';
import '../models/character_model.dart';
import '../services/prefs_service.dart';

class AppProvider extends ChangeNotifier {
  List<Character> _favorites = [];
  List<Character> get favorites => _favorites;

  AppProvider() {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    _favorites = await PrefsService.getFavorites();
    notifyListeners();
  }

  bool isFavorite(int characterId) {
    return _favorites.any((c) => c.id == characterId);
  }

  Future<bool> toggleFavorite(Character character) async {
    final exists = isFavorite(character.id);
    if (exists) {
      _favorites.removeWhere((c) => c.id == character.id);
    } else {
      _favorites.add(character);
    }
    await PrefsService.saveFavorites(_favorites);
    notifyListeners();
    return !exists;
  }

  Future<void> removeFavorite(int characterId) async {
    _favorites.removeWhere((c) => c.id == characterId);
    await PrefsService.saveFavorites(_favorites);
    notifyListeners();
  }
}