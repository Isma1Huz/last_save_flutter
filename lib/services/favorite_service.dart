import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const _key = 'favorite_contacts';

  Future<List<String>> _getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  Future<void> addFavorite(String contactId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await _getFavorites();
    if (!favorites.contains(contactId)) {
      favorites.add(contactId);
      await prefs.setStringList(_key, favorites);
    }
  }

  Future<void> removeFavorite(String contactId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await _getFavorites();
    favorites.remove(contactId);
    await prefs.setStringList(_key, favorites);
  }

  Future<bool> isFavorite(String contactId) async {
    final favorites = await _getFavorites();
    return favorites.contains(contactId);
  }

  Future<bool> toggleFavorite(String contactId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await _getFavorites();
    if (favorites.contains(contactId)) {
      favorites.remove(contactId);
      await prefs.setStringList(_key, favorites);
      return false;
    } else {
      favorites.add(contactId);
      await prefs.setStringList(_key, favorites);
      return true;
    }
  }
}
