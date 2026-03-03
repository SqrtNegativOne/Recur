import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:recur/features/checklist/data/models/checklist_model.dart';
import 'package:recur/features/checklist/data/models/task_model.dart';

part 'run_state.freezed.dart';

enum RunPhase { idle, running, paused, transitioning, allComplete }

@freezed
class RunState with _$RunState {
  const RunState._();

  const factory RunState({
    required ChecklistModel checklist,
    @Default(0) int currentTaskIndex,
    @Default(0) int elapsedSeconds,
    @Default(RunPhase.idle) RunPhase phase,
  }) = _RunState;

  /// The currently active task, or null if index is out of range.
  TaskModel? get currentTask {
    if (currentTaskIndex < checklist.tasks.length) {
      return checklist.tasks[currentTaskIndex];
    }
    return null;
  }

  /// Seconds remaining for the current task (can go negative for overtime).
  int get remainingSeconds {
    final task = currentTask;
    if (task == null) return 0;
    return task.durationSeconds - elapsedSeconds;
  }

  /// Progress fraction (0.0 to 1.0) for the current task's timer.
  double get progress {
    final task = currentTask;
    if (task == null || task.durationSeconds == 0) return 1.0;
    return (elapsedSeconds / task.durationSeconds).clamp(0.0, 1.0);
  }

  /// Whether the timer has exceeded the allocated duration.
  bool get isOvertime => remainingSeconds < 0;

  /// Number of tasks completed so far.
  int get completedTaskCount => currentTaskIndex;

  /// Total number of tasks.
  int get totalTaskCount => checklist.tasks.length;
}
