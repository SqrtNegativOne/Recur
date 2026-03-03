import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recur/features/checklist/data/models/checklist_model.dart';
import 'package:recur/features/runner/data/models/run_state.dart';

/// The run session provider manages the timer state machine for running
/// a checklist. It handles start, pause, resume, skip, stop, and
/// auto-advance between tasks.
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
    );
    _startTimer();
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
    if (current.phase != RunPhase.running && current.phase != RunPhase.paused) {
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
      // Timer expired — check auto-advance
      if (current.checklist.settings.autoAdvance) {
        _timer?.cancel();
        state = current.copyWith(
          elapsedSeconds: newElapsed,
          phase: RunPhase.transitioning,
        );
        // Auto-advance after delay
        _transitionTimer = Timer(
          Duration(seconds: current.checklist.settings.autoAdvanceDelaySeconds),
          () => _advanceToNextTask(),
        );
      } else {
        // No auto-advance: keep counting (overtime)
        state = current.copyWith(elapsedSeconds: newElapsed);
      }
    } else {
      state = current.copyWith(elapsedSeconds: newElapsed);
    }
  }

  void _advanceToNextTask() {
    final current = state;
    if (current == null) return;

    final nextIndex = current.currentTaskIndex + 1;
    if (nextIndex >= current.checklist.tasks.length) {
      // All tasks complete
      _timer?.cancel();
      state = current.copyWith(phase: RunPhase.allComplete);
    } else {
      state = current.copyWith(
        currentTaskIndex: nextIndex,
        elapsedSeconds: 0,
        phase: RunPhase.running,
      );
      _startTimer();
    }
  }
}
