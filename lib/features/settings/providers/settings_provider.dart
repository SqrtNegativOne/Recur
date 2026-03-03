import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recur/features/settings/data/models/app_settings.dart';
import 'package:recur/features/settings/data/repositories/settings_repository.dart';

final settingsRepositoryProvider = Provider((ref) => SettingsRepository());

final settingsProvider =
    AsyncNotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);

class SettingsNotifier extends AsyncNotifier<AppSettings> {
  @override
  Future<AppSettings> build() async {
    final repo = ref.read(settingsRepositoryProvider);
    return await repo.load();
  }

  Future<void> setStoragePath(String path) async {
    final repo = ref.read(settingsRepositoryProvider);
    final current = state.valueOrNull ?? const AppSettings();
    final updated = current.copyWith(storageFolderPath: path);
    await repo.save(updated);
    state = AsyncData(updated);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final repo = ref.read(settingsRepositoryProvider);
    final current = state.valueOrNull ?? const AppSettings();
    final updated = current.copyWith(themeMode: mode);
    await repo.save(updated);
    state = AsyncData(updated);
  }
}
