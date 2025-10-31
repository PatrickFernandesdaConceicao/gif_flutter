// lib/state/gif_notifier.dart
import 'package:flutter/foundation.dart';
import '../data/models/gif_model.dart';
import '../data/repositories/gif_repository.dart';
import '../data/repositories/mysql_repository.dart';
import 'dart:async';

class GifNotifier extends ChangeNotifier {
  final GifRepository remoteRepo;
  final MySQLRepository mysqlRepo;

  GifNotifier({
    required this.remoteRepo,
    required this.mysqlRepo,
  }) {
    _init();
  }

  GifModel? currentGif;
  bool loading = false;
  String? error;
  List<GifModel> favorites = [];
  List<String> searchHistory = [];

  Timer? _debounceTimer;
  static const _debounceDelay = Duration(milliseconds: 500);

  Future<void> _init() async {
    await loadFavorites();
    await _loadHistory();
  }

  // ==================== GIF ALEATÓRIO ====================

  Future<void> fetchRandom({String? tag, String rating = 'g'}) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      currentGif = await remoteRepo.getRandomGif(tag: tag, rating: rating);
      
      // Adiciona ao histórico se houver tag
      if (tag != null && tag.isNotEmpty) {
        await mysqlRepo.addToHistory(tag);
        await _loadHistory();
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

  // ==================== FAVORITOS ====================

  Future<void> loadFavorites() async {
    favorites = await mysqlRepo.getFavorites();
    notifyListeners();
  }

  Future<void> toggleFavorite(GifModel gif) async {
    final isFav = await mysqlRepo.isFavorite(gif.id);
    
    if (isFav) {
      await mysqlRepo.removeFavorite(gif.id);
    } else {
      await mysqlRepo.addFavorite(gif);
    }
    
    await loadFavorites();
  }

  Future<bool> isFavorite(GifModel gif) async {
    return await mysqlRepo.isFavorite(gif.id);
  }

  // ==================== HISTÓRICO ====================

  Future<void> _loadHistory() async {
    searchHistory = await mysqlRepo.getSearchHistory();
    notifyListeners();
  }

  Future<void> removeFromHistory(String tag) async {
    await mysqlRepo.removeFromHistory(tag);
    await _loadHistory();
  }

  Future<void> clearHistory() async {
    await mysqlRepo.clearHistory();
    await _loadHistory();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}