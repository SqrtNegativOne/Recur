import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recur/features/checklist/data/models/checklist_model.dart';
import 'package:recur/features/checklist/data/repositories/checklist_repository.dart';
import 'package:recur/features/settings/providers/settings_provider.dart';
import 'package:recur/features/settings/providers/storage_path_provider.dart';

final checklistRepositoryProvider = FutureProvider<ChecklistRepository>((ref) async {
  final settings = await ref.watch(settingsProvider.future);
  final dir = await resolveStorageDirectory(settings.storageFolderPath);
  return ChecklistRepository(dir);
});

final checklistListProvider =
    AsyncNotifierProvider<ChecklistListNotifier, List<ChecklistModel>>(
        ChecklistListNotifier.new);

class ChecklistListNotifier extends AsyncNotifier<List<ChecklistModel>> {
  StreamSubscription? _watchSub;

  @override
  Future<List<ChecklistModel>> build() async {
    final repo = await ref.watch(checklistRepositoryProvider.future);

    // Cancel any previous watcher
    _watchSub?.cancel();

    // Watch for filesystem changes (Syncthing, etc.)
    _watchSub = repo.watchFolder().listen((_) {
      // Debounce: just reload when anything changes
      _reload();
    });

    // Clean up watcher when provider is disposed
    ref.onDispose(() => _watchSub?.cancel());

    return await repo.loadAll();
  }

  Future<void> _reload() async {
    try {
      final repo = await ref.read(checklistRepositoryProvider.future);
      state = AsyncData(await repo.loadAll());
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    await _reload();
  }

  Future<void> deleteChecklist(String id) async {
    final repo = await ref.read(checklistRepositoryProvider.future);
    await repo.delete(id);
    await _reload();
  }

  /// Imports a checklist from an external JSON file path.
  /// Returns the imported checklist name on success, throws on failure.
  Future<String> importChecklist(String filePath) async {
    final repo = await ref.read(checklistRepositoryProvider.future);
    final checklist = await repo.importFromFile(filePath);
    await _reload();
    return checklist.name;
  }
}
