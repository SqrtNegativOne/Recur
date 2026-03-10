import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recur/features/runner/data/models/run_record.dart';
import 'package:recur/features/runner/data/repositories/run_history_repository.dart';

final runHistoryRepositoryProvider =
    Provider<RunHistoryRepository>((ref) => RunHistoryRepository());

/// Provides the full list of run records (newest first).
final runHistoryProvider =
    AsyncNotifierProvider<RunHistoryNotifier, List<RunRecord>>(
        RunHistoryNotifier.new);

class RunHistoryNotifier extends AsyncNotifier<List<RunRecord>> {
  @override
  Future<List<RunRecord>> build() async {
    final repo = ref.read(runHistoryRepositoryProvider);
    return await repo.loadAll();
  }

  /// Saves a new record and refreshes the list.
  Future<void> addRecord(RunRecord record) async {
    final repo = ref.read(runHistoryRepositoryProvider);
    await repo.save(record);
    state = AsyncData(await repo.loadAll());
  }
}

/// Provides run records filtered by checklist ID.
final checklistHistoryProvider =
    FutureProvider.family<List<RunRecord>, String>((ref, checklistId) async {
  final repo = ref.read(runHistoryRepositoryProvider);
  return await repo.loadForChecklist(checklistId);
});
