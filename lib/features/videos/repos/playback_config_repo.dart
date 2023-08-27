import 'package:shared_preferences/shared_preferences.dart';

class PlaybackConfigRepository {
  PlaybackConfigRepository(this.preferences);
  static const String _autoplay = 'autoplay';
  static const String _muted = 'muted';
  final SharedPreferences preferences;

  Future<void> setMuted(bool value) async {
    preferences.setBool(_muted, value);
  }

  Future<void> setAutoplay(bool value) async {
    preferences.setBool(_autoplay, value);
  }

  bool getMuted() {
    return preferences.getBool(_muted) ?? false;
  }

  bool getAutoplay() {
    return preferences.getBool(_autoplay) ?? false;
  }
}
