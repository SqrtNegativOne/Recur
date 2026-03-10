import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recur/core/utils/duration_formatter.dart';
import 'package:recur/features/runner/providers/run_session_provider.dart';

class RunCompleteScreen extends ConsumerWidget {
  final String checklistId;

  const RunCompleteScreen({super.key, required this.checklistId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final runState = ref.watch(runSessionProvider);
    final checklistName = runState?.checklist.name ?? 'Routine';

    // Calculate run stats from the completed state
    final taskTimes = runState?.taskElapsedTimes ?? [];
    final totalActual = taskTimes.fold<int>(0, (sum, s) => sum + s);
    final totalPlanned = runState?.checklist.totalDuration ?? 0;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.celebration,
                  size: 80,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'Done!',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '$checklistName complete',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
                if (runState != null) ...[
                  const SizedBox(height: 24),
                  // Stats summary
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _StatColumn(
                                label: 'Tasks',
                                value: '${runState.totalTaskCount}',
                                icon: Icons.task_alt,
                              ),
                              _StatColumn(
                                label: 'Time',
                                value: formatDurationHuman(totalActual),
                                icon: Icons.timer,
                              ),
                              _StatColumn(
                                label: 'Planned',
                                value: formatDurationHuman(totalPlanned),
                                icon: Icons.schedule,
                              ),
                            ],
                          ),
                          if (totalPlanned > 0) ...[
                            const SizedBox(height: 12),
                            _PaceIndicator(
                              actualSeconds: totalActual,
                              plannedSeconds: totalPlanned,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  // Per-task breakdown
                  if (taskTimes.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    ...List.generate(
                      taskTimes.length,
                      (i) {
                        final task = i < runState.checklist.tasks.length
                            ? runState.checklist.tasks[i]
                            : null;
                        final actual = taskTimes[i];
                        final planned = task?.durationSeconds ?? 0;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              Icon(
                                actual <= planned
                                    ? Icons.check_circle_outline
                                    : Icons.timer_off_outlined,
                                size: 16,
                                color: actual <= planned
                                    ? Colors.green
                                    : theme.colorScheme.error,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                  child: Text(
                                      task?.name ?? 'Task ${i + 1}',
                                      style: theme.textTheme.bodyMedium)),
                              Text(
                                '${formatDurationHuman(actual)} / ${formatDurationHuman(planned)}',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ],
                const SizedBox(height: 48),
                FilledButton.icon(
                  onPressed: () {
                    ref.read(runSessionProvider.notifier).stop();
                    context.go('/checklist/$checklistId');
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Finish'),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    // Re-run the same checklist
                    final checklist = runState?.checklist;
                    ref.read(runSessionProvider.notifier).stop();
                    if (checklist != null) {
                      ref.read(runSessionProvider.notifier).start(checklist);
                      context.go('/checklist/$checklistId/run');
                    } else {
                      context.go('/checklist/$checklistId');
                    }
                  },
                  icon: const Icon(Icons.replay),
                  label: const Text('Run Again'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatColumn({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(height: 4),
        Text(value,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        Text(label, style: theme.textTheme.labelSmall),
      ],
    );
  }
}

/// Shows whether the user finished faster or slower than planned.
class _PaceIndicator extends StatelessWidget {
  final int actualSeconds;
  final int plannedSeconds;

  const _PaceIndicator({
    required this.actualSeconds,
    required this.plannedSeconds,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final diff = actualSeconds - plannedSeconds;
    final absDiff = diff.abs();
    final faster = diff <= 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          faster ? Icons.trending_down : Icons.trending_up,
          color: faster ? Colors.green : theme.colorScheme.error,
          size: 20,
        ),
        const SizedBox(width: 4),
        Text(
          faster
              ? '${formatDurationHuman(absDiff)} faster than planned'
              : '${formatDurationHuman(absDiff)} over planned',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: faster ? Colors.green : theme.colorScheme.error,
          ),
        ),
      ],
    );
  }
}
