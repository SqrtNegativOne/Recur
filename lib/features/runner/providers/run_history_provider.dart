import 'package:recur/features/runner/data/models/run_record.dart';
import 'package:recur/features/runner/data/repositories/run_history_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'run_history_provider.g.dart';

@Riverpod(keepAlive: true)
RunHistoryRepository runHistoryRepository(Ref ref) => RunHistoryRepository();

/// Provides the full list of run records (newest first).
@Riverpod(keepAlive: true)
class RunHistory extends _$RunHistory {
  @override
  Future<List<RunRecord>> build() async {
    final repo = ref.read(runHistoryRepositoryProvider);
    return repo.loadAll();
  }

  /// Saves a new record and refreshes the list.
  Future<void> addRecord(RunRecord record) async {
    final repo = ref.read(runHistoryRepositoryProvider);
    await repo.save(record);
    state = AsyncData(await repo.loadAll());
  }
}

/// Provides run records filtered by checklist ID.
@Riverpod(keepAlive: true)
Future<List<RunRecord>> checklistHistory(Ref ref, String checklistId) async {
  final repo = ref.read(runHistoryRepositoryProvider);
  return repo.loadForChecklist(checklistId);
}
