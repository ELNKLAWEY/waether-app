import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _favoritesKey = 'favorites';
  static const String _isMetricKey = 'isMetric';

  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  Future<void> addFavorite(String city) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];
    if (!favorites.contains(city)) {
      favorites.add(city);
      await prefs.setStringList(_favoritesKey, favorites);
    }
  }

  Future<void> removeFavorite(String city) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];
    favorites.remove(city);
    await prefs.setStringList(_favoritesKey, favorites);
  }

  Future<bool> isMetric() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isMetricKey) ?? true;
  }

  Future<void> setMetric(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isMetricKey, value);
  }
}
