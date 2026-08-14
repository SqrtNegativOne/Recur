import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recur/features/checklist/data/models/checklist_model.dart';
import 'package:recur/features/checklist/data/models/task_model.dart';
import 'package:recur/features/runner/data/models/run_state.dart';
import 'package:recur/features/runner/providers/run_session_provider.dart';

void main() {
  test('RunSessionNotifier starts correctly and sets initial state', () {
    // Create a container
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(runSessionProvider.notifier);
    
    final checklist = ChecklistModel(
      id: 'test_id',
      name: 'Test Checklist',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      tasks: [
        const TaskModel(id: 't1', name: 'Task 1', durationSeconds: 60),
      ],
    );
    
    notifier.start(checklist);
    
    final state = container.read(runSessionProvider);
    expect(state, isNotNull);
    expect(state!.phase, RunPhase.running);
    expect(state.currentTaskIndex, 0);
    expect(state.elapsedSeconds, 0);
    expect(state.checklist.id, 'test_id');
  });

  test('RunSessionNotifier pause and resume', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(runSessionProvider.notifier);
    final checklist = ChecklistModel(
      id: 'test_id',
      name: 'Test Checklist',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      tasks: [
        const TaskModel(id: 't1', name: 'Task 1', durationSeconds: 60),
      ],
    );
    
    notifier
      ..start(checklist)
      ..pause();
    
    final pausedState = container.read(runSessionProvider);
    expect(pausedState!.phase, RunPhase.paused);
    
    notifier.resume();
    final resumedState = container.read(runSessionProvider);
    expect(resumedState!.phase, RunPhase.running);
  });
}
