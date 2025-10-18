// lib/state/gif_notifier.dart
import 'package:flutter/foundation.dart';
import '../data/models/gif_model.dart';
import '../data/repositories/gif_repository.dart';
import '../data/repositories/local_repository.dart';
import 'dart:async';

class GifNotifier extends ChangeNotifier {
  final GifRepository remoteRepo;
  final LocalRepository localRepo;

  GifNotifier({
    required this.remoteRepo,
    required this.localRepo,
  }) {
    _loadHistory();
  }

  GifModel? currentGif;
  bool loading = false;
  String? error;
  List<GifModel> favorites = [];
  List<String> searchHistory = [];

  Timer? _debounceTimer;
  static const _debounceDelay = Duration(milliseconds: 500);

  Future<void> fetchRandom({String? tag, String rating = 'g'}) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      currentGif = await remoteRepo.getRandomGif(tag: tag, rating: rating);
      
      // Adiciona ao histórico se houver tag
      if (tag != null && tag.isNotEmpty && !searchHistory.contains(tag)) {
        searchHistory.insert(0, tag);
        if (searchHistory.length > 10) searchHistory.removeLast();
        _saveHistory();
      }
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // Busca com debounce
  void searchWithDebounce({String? tag, String rating = 'g'}) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDelay, () {
      fetchRandom(tag: tag, rating: rating);
    });
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

  // Histórico
  Future<void> _saveHistory() async {
    await localRepo.setPreference('searchHistory', searchHistory);
  }

  Future<void> _loadHistory() async {
    final history = localRepo.getPreference('searchHistory', <String>[]);
    searchHistory = List<String>.from(history);
    notifyListeners();
  }

  void removeFromHistory(String tag) {
    searchHistory.remove(tag);
    _saveHistory();
    notifyListeners();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}