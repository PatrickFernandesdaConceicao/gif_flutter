import '../../data/repositories/local_repository.dart';

class AppPreferences {
  final LocalRepository _repo;

  AppPreferences(this._repo);

  static const themeKey = 'theme';
  static const ratingKey = 'rating';
  static const languageKey = 'language';
  static const autoplayKey = 'autoplay';

  Future<void> setTheme(String theme) => _repo.setPreference(themeKey, theme);
  String getTheme() => _repo.getPreference(themeKey, 'system');

  Future<void> setRating(String rating) => _repo.setPreference(ratingKey, rating);
  String getRating() => _repo.getPreference(ratingKey, 'g');

  Future<void> setLanguage(String lang) => _repo.setPreference(languageKey, lang);
  String getLanguage() => _repo.getPreference(languageKey, 'en');

  Future<void> setAutoplay(bool value) => _repo.setPreference(autoplayKey, value);
  bool getAutoplay() => _repo.getPreference(autoplayKey, true);
}
