import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _sanctuaryKey = 'favorite_sanctuary_ids';
  static const String _animalKey = 'favorite_animal_ids';

  static Future<Set<String>> getSanctuaryFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_sanctuaryKey) ?? <String>[]).toSet();
  }

  static Future<Set<String>> getAnimalFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_animalKey) ?? <String>[]).toSet();
  }

  static Future<void> toggleSanctuaryFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = (prefs.getStringList(_sanctuaryKey) ?? <String>[]).toSet();

    if (!ids.add(id)) {
      ids.remove(id);
    }

    await prefs.setStringList(_sanctuaryKey, ids.toList());
  }

  static Future<void> toggleAnimalFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = (prefs.getStringList(_animalKey) ?? <String>[]).toSet();

    if (!ids.add(id)) {
      ids.remove(id);
    }

    await prefs.setStringList(_animalKey, ids.toList());
  }
}
