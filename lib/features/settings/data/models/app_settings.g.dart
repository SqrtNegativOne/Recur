// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppSettingsImpl _$$AppSettingsImplFromJson(Map<String, dynamic> json) =>
    _$AppSettingsImpl(
      storageFolderPath: json['storageFolderPath'] as String? ?? '',
      themeMode:
          json['themeMode'] == null
              ? ThemeMode.system
              : const ThemeModeConverter().fromJson(
                json['themeMode'] as String,
              ),
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      ttsEnabled: json['ttsEnabled'] as bool? ?? false,
    );

Map<String, dynamic> _$$AppSettingsImplToJson(_$AppSettingsImpl instance) =>
    <String, dynamic>{
      'storageFolderPath': instance.storageFolderPath,
      'themeMode': const ThemeModeConverter().toJson(instance.themeMode),
      'soundEnabled': instance.soundEnabled,
      'ttsEnabled': instance.ttsEnabled,
    };
