// lib/core/prefs/app_preferences.dart
import '../../data/repositories/mysql_repository.dart';

class AppPreferences {
  final MySQLRepository _mysqlRepo;

  AppPreferences(this._mysqlRepo);

  // ==================== TEMA ====================

  Future<String> getTheme() async {
    final value = await _mysqlRepo.getPreference('theme');
    return value ?? 'system';
  }

  Future<void> setTheme(String theme) async {
    await _mysqlRepo.setPreference('theme', theme);
  }

  // ==================== RATING ====================

  Future<String> getRating() async {
    final value = await _mysqlRepo.getPreference('rating');
    return value ?? 'g';
  }

  Future<void> setRating(String rating) async {
    await _mysqlRepo.setPreference('rating', rating);
  }

  // ==================== AUTOPLAY ====================

  Future<bool> getAutoplay() async {
    final value = await _mysqlRepo.getPreference('autoplay');
    return value == 'true';
  }

  Future<void> setAutoplay(bool autoplay) async {
    await _mysqlRepo.setPreference('autoplay', autoplay.toString());
  }
}