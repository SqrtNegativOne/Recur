import 'package:freezed_annotation/freezed_annotation.dart';

part 'run_record.freezed.dart';
part 'run_record.g.dart';

/// A record of a single completed checklist run.
///
/// Saved to app-local storage (not the checklist folder) so it doesn't
/// interfere with Syncthing sync. Each record captures both the actual
/// time spent per task and the planned duration, enabling stats like
/// "you ran 20% faster than planned".
@freezed
class RunRecord with _$RunRecord {
  const RunRecord._();

  const factory RunRecord({
    required String id,
    required String checklistId,
    required String checklistName,
    required DateTime startedAt,
    required DateTime completedAt,
    required int taskCount,
    @Default([]) List<int> taskActualSeconds,
    @Default([]) List<int> taskPlannedSeconds,
    @Default([]) List<String> taskNames,
  }) = _RunRecord;

  factory RunRecord.fromJson(Map<String, dynamic> json) =>
      _$RunRecordFromJson(json);

  /// Total actual seconds across all tasks.
  int get totalActualSeconds =>
      taskActualSeconds.fold(0, (sum, s) => sum + s);

  /// Total planned seconds across all tasks.
  int get totalPlannedSeconds =>
      taskPlannedSeconds.fold(0, (sum, s) => sum + s);

  /// Wall-clock duration of the entire run.
  Duration get wallClockDuration => completedAt.difference(startedAt);
}
