import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/gif_model.dart';
import '../../data/adapters/gif_adapter.dart';

class HiveManager {
  static const String favoritesBox = 'favorites';
  static const String prefsBox = 'preferences';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(GifModelAdapter());
    await Hive.openBox<GifModel>(favoritesBox);
    await Hive.openBox(prefsBox);
  }
}
