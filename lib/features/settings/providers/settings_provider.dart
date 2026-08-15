import 'package:flutter/material.dart';
import 'package:recur/features/settings/data/models/app_settings.dart';
import 'package:recur/features/settings/data/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) => SettingsRepository();

@Riverpod(keepAlive: true)
class Settings extends _$Settings {
  @override
  Future<AppSettings> build() async {
    final repo = ref.read(settingsRepositoryProvider);
    return repo.load();
  }

  Future<void> setStoragePath(String path) async {
    final repo = ref.read(settingsRepositoryProvider);
    final current = state.value ?? const AppSettings();
    final updated = current.copyWith(storageFolderPath: path);
    await repo.save(updated);
    state = AsyncData(updated);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final repo = ref.read(settingsRepositoryProvider);
    final current = state.value ?? const AppSettings();
    final updated = current.copyWith(themeMode: mode);
    await repo.save(updated);
    state = AsyncData(updated);
  }

  Future<void> setSoundEnabled({required bool enabled}) async {
    final repo = ref.read(settingsRepositoryProvider);
    final current = state.value ?? const AppSettings();
    final updated = current.copyWith(soundEnabled: enabled);
    await repo.save(updated);
    state = AsyncData(updated);
  }

  Future<void> setTtsEnabled({required bool enabled}) async {
    final repo = ref.read(settingsRepositoryProvider);
    final current = state.value ?? const AppSettings();
    final updated = current.copyWith(ttsEnabled: enabled);
    await repo.save(updated);
    state = AsyncData(updated);
  }
}
