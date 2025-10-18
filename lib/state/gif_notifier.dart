import 'package:flutter/foundation.dart';
import '../data/models/gif_model.dart';
import '../data/repositories/gif_repository.dart';
import '../data/repositories/local_repository.dart';

class GifNotifier extends ChangeNotifier {
  final GifRepository remoteRepo;
  final LocalRepository localRepo;

  GifNotifier({
    required this.remoteRepo,
    required this.localRepo,
  });

  GifModel? currentGif;
  bool loading = false;
  String? error;
  List<GifModel> favorites = [];

  Future<void> fetchRandom({String? tag, String rating = 'g'}) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      currentGif = await remoteRepo.getRandomGif(tag: tag, rating: rating);
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void loadFavorites() {
    favorites = localRepo.getFavorites();
    notifyListeners();
  }

  Future<void> toggleFavorite(GifModel gif) async {
    await localRepo.toggleFavorite(gif);
    loadFavorites();
  }

  bool isFavorite(GifModel gif) => localRepo.isFavorite(gif.id);
}
