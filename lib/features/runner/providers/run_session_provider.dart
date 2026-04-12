import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recur/core/services/audio_service.dart';
import 'package:recur/core/services/overlay_service.dart';
import 'package:recur/features/checklist/data/models/checklist_model.dart';
import 'package:recur/features/checklist/data/models/task_model.dart';
import 'package:recur/features/runner/data/models/run_record.dart';
import 'package:recur/features/runner/data/models/run_state.dart';
import 'package:recur/features/runner/providers/run_history_provider.dart';
import 'package:recur/features/settings/providers/settings_provider.dart';
import 'package:uuid/uuid.dart';

/// The run session provider manages the timer state machine for running
/// a checklist. It handles start, pause, resume, skip, stop, and
/// auto-advance between tasks.
///
/// It also integrates with AudioService for:
/// - Playing a notification chime when a task timer expires
/// - Speaking a TTS prompt ("Get X done in Y") when each task starts
///
/// When a run completes, it saves a RunRecord to the history provider.
final runSessionProvider =
    NotifierProvider<RunSessionNotifier, RunState?>(RunSessionNotifier.new);

class RunSessionNotifier extends Notifier<RunState?> {
  Timer? _timer;
  Timer? _transitionTimer;

  @override
  RunState? build() {
    ref.onDispose(() {
      _timer?.cancel();
      _transitionTimer?.cancel();
    });
    return null;
  }

  /// Start running a checklist from the beginning.
  void start(ChecklistModel checklist) {
    if (checklist.tasks.isEmpty) return;
    _timer?.cancel();
    _transitionTimer?.cancel();

    state = RunState(
      checklist: checklist,
      currentTaskIndex: 0,
      elapsedSeconds: 0,
      phase: RunPhase.running,
      startedAt: DateTime.now(),
    );
    _startTimer();

    // Speak the first task prompt
    _speakTask(checklist.tasks.first);
  }

  /// Pause the current timer.
  void pause() {
    final current = state;
    if (current == null || current.phase != RunPhase.running) return;
    _timer?.cancel();
    state = current.copyWith(phase: RunPhase.paused);
  }

  /// Resume from paused state.
  void resume() {
    final current = state;
    if (current == null || current.phase != RunPhase.paused) return;
    state = current.copyWith(phase: RunPhase.running);
    _startTimer();
  }

  /// Skip to the next task.
  void skip() {
    final current = state;
    if (current == null) return;
    if (current.phase != RunPhase.running &&
        current.phase != RunPhase.paused) {
      return;
    }
    _timer?.cancel();
    _advanceToNextTask();
  }

  /// Stop the run session entirely.
  void stop() {
    _timer?.cancel();
    _transitionTimer?.cancel();
    state = null;
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _tick();
    });
  }

  void _tick() {
    final current = state;
    if (current == null || current.phase != RunPhase.running) {
      _timer?.cancel();
      return;
    }

    final newElapsed = current.elapsedSeconds + 1;
    final task = current.currentTask;

    if (task != null && newElapsed >= task.durationSeconds) {
      // Timer expired — play notification sound
      if (newElapsed == task.durationSeconds) {
        _playSound();
      }

      // Check auto-advance
      if (current.checklist.settings.autoAdvance &&
          newElapsed == task.durationSeconds) {
        _timer?.cancel();
        state = current.copyWith(
          elapsedSeconds: newElapsed,
          phase: RunPhase.transitioning,
        );
        // Auto-advance after delay
        _transitionTimer = Timer(
          Duration(
              seconds: current.checklist.settings.autoAdvanceDelaySeconds),
          () => _advanceToNextTask(),
        );
      } else {
        // No auto-advance: keep counting (overtime)
        state = current.copyWith(elapsedSeconds: newElapsed);
      }
    } else {
      state = current.copyWith(elapsedSeconds: newElapsed);
    }
    _relayToOverlay();
  }

  void _advanceToNextTask() {
    final current = state;
    if (current == null) return;

    final nextIndex = current.currentTaskIndex + 1;
    // Record elapsed time for the just-finished task
    final updatedTimes = [
      ...current.taskElapsedTimes,
      current.elapsedSeconds,
    ];

    if (nextIndex >= current.checklist.tasks.length) {
      // All tasks complete
      _timer?.cancel();
      state = current.copyWith(
        phase: RunPhase.allComplete,
        taskElapsedTimes: updatedTimes,
      );
      // Close the overlay — the run is done
      ref.read(overlayServiceProvider).hideOverlay();
      // Save run record to history
      _saveRunRecord(current, updatedTimes);
      // Announce completion via TTS
      _speakComplete();
    } else {
      state = current.copyWith(
        currentTaskIndex: nextIndex,
        elapsedSeconds: 0,
        phase: RunPhase.running,
        taskElapsedTimes: updatedTimes,
      );
      _startTimer();
      // Speak the next task prompt
      _speakTask(current.checklist.tasks[nextIndex]);
    }
  }

  // --- Audio integration ---

  /// Plays the timer-expired chime if sound is enabled in settings.
  void _playSound() {
    final settings = ref.read(settingsProvider).valueOrNull;
    if (settings?.soundEnabled ?? true) {
      ref.read(audioServiceProvider).playTimerExpiredSound();
    }
  }

  /// Speaks a task prompt via TTS if enabled in settings.
  void _speakTask(TaskModel task) {
    final settings = ref.read(settingsProvider).valueOrNull;
    if (settings?.ttsEnabled ?? false) {
      ref
          .read(audioServiceProvider)
          .speakTaskPrompt(task.name, task.durationSeconds);
    }
  }

  /// Speaks a completion message via TTS if enabled.
  void _speakComplete() {
    final settings = ref.read(settingsProvider).valueOrNull;
    if (settings?.ttsEnabled ?? false) {
      ref.read(audioServiceProvider).speakComplete();
    }
  }

  // --- History integration ---

  /// Pushes the latest timer state to the floating overlay widget (Android only).
  void _relayToOverlay() {
    final s = state;
    if (s == null) return;
    final task = s.currentTask;
    if (task == null) return;
    ref.read(overlayServiceProvider).sendTimerData(
      taskName: task.name,
      remainingSeconds: s.remainingSeconds,
      isOvertime: s.isOvertime,
      taskIndex: s.currentTaskIndex + 1,
      totalTasks: s.totalTaskCount,
    );
  }

  /// Creates and saves a RunRecord when all tasks complete.
  void _saveRunRecord(RunState finalState, List<int> taskTimes) {
    final record = RunRecord(
      id: const Uuid().v4(),
      checklistId: finalState.checklist.id,
      checklistName: finalState.checklist.name,
      startedAt: finalState.startedAt ?? DateTime.now(),
      completedAt: DateTime.now(),
      taskCount: finalState.totalTaskCount,
      taskActualSeconds: taskTimes,
      taskPlannedSeconds:
          finalState.checklist.tasks.map((t) => t.durationSeconds).toList(),
      taskNames: finalState.checklist.tasks.map((t) => t.name).toList(),
    );
    ref.read(runHistoryProvider.notifier).addRecord(record);
  }
}
