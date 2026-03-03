import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recur/features/runner/providers/run_session_provider.dart';

class RunCompleteScreen extends ConsumerWidget {
  final String checklistId;

  const RunCompleteScreen({super.key, required this.checklistId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final runState = ref.watch(runSessionProvider);
    final checklistName = runState?.checklist.name ?? 'Routine';

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
                  Text(
                    '${runState.totalTaskCount} tasks completed',
                    style: theme.textTheme.bodyLarge,
                  ),
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
