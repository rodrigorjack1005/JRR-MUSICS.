import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool get hasCompletedOnboarding =>
      _prefs.getBool('onboarding_done') ?? false;

  List<String> get favoriteGenres =>
      _prefs.getStringList('favorite_genres') ?? [];

  List<String> get favoriteArtists =>
      _prefs.getStringList('favorite_artists') ?? [];

  Future<void> saveOnboarding(
    List<String> genres,
    List<String> artists,
  ) async {
    await _prefs.setStringList('favorite_genres', genres);
    await _prefs.setStringList('favorite_artists', artists);
    await _prefs.setBool('onboarding_done', true);
  }
}
