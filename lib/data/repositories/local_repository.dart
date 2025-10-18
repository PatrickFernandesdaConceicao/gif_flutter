import 'package:hive/hive.dart';
import '../models/gif_model.dart';
import '../../core/db/hive_manager.dart';

class LocalRepository {
  Box<GifModel> get _favBox => Hive.box<GifModel>(HiveManager.favoritesBox);
  Box get _prefsBox => Hive.box(HiveManager.prefsBox);

  // Favoritos
  List<GifModel> getFavorites() => _favBox.values.toList();

  Future<void> toggleFavorite(GifModel gif) async {
    if (_favBox.containsKey(gif.id)) {
      await _favBox.delete(gif.id);
    } else {
      await _favBox.put(gif.id, gif);
    }
  }

  bool isFavorite(String id) => _favBox.containsKey(id);

  // Preferências
  Future<void> setPreference(String key, dynamic value) async {
    await _prefsBox.put(key, value);
  }

  dynamic getPreference(String key, [dynamic defaultValue]) {
    return _prefsBox.get(key, defaultValue: defaultValue);
  }
}
