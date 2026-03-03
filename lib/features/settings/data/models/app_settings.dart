import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

/// Converter so ThemeMode can be stored as a string in JSON / SharedPreferences.
class ThemeModeConverter implements JsonConverter<ThemeMode, String> {
  const ThemeModeConverter();

  @override
  ThemeMode fromJson(String json) {
    switch (json) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  @override
  String toJson(ThemeMode object) => object.name;
}

@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default('') String storageFolderPath,
    @ThemeModeConverter() @Default(ThemeMode.system) ThemeMode themeMode,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
}
