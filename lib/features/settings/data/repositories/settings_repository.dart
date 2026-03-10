import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recur/features/settings/data/models/app_settings.dart';

class SettingsRepository {
  static const _storagePathKey = 'storage_folder_path';
  static const _themeModeKey = 'theme_mode';
  static const _soundEnabledKey = 'sound_enabled';
  static const _ttsEnabledKey = 'tts_enabled';

  Future<AppSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    return AppSettings(
      storageFolderPath: prefs.getString(_storagePathKey) ?? '',
      themeMode: _parseThemeMode(prefs.getString(_themeModeKey)),
      soundEnabled: prefs.getBool(_soundEnabledKey) ?? true,
      ttsEnabled: prefs.getBool(_ttsEnabledKey) ?? false,
    );
  }

  Future<void> save(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storagePathKey, settings.storageFolderPath);
    await prefs.setString(_themeModeKey, settings.themeMode.name);
    await prefs.setBool(_soundEnabledKey, settings.soundEnabled);
    await prefs.setBool(_ttsEnabledKey, settings.ttsEnabled);
  }

  ThemeMode _parseThemeMode(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
