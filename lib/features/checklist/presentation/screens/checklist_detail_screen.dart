import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recur/core/utils/duration_formatter.dart';
import 'package:recur/features/checklist/data/models/checklist_model.dart';
import 'package:recur/features/checklist/providers/checklist_detail_provider.dart';
import 'package:recur/features/checklist/providers/checklist_list_provider.dart';
import 'package:recur/features/checklist/presentation/widgets/task_tile.dart';

class ChecklistDetailScreen extends ConsumerWidget {
  final String checklistId;

  const ChecklistDetailScreen({super.key, required this.checklistId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(checklistDetailProvider(checklistId));

    return detailAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Error: $err')),
      ),
      data: (checklist) {
        if (checklist == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Checklist not found')),
          );
        }
        return _DetailContent(checklist: checklist);
      },
    );
  }
}

class _DetailContent extends ConsumerWidget {
  final ChecklistModel checklist;

  const _DetailContent({required this.checklist});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(checklist.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/checklist/${checklist.id}/edit'),
            tooltip: 'Edit checklist',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context, ref),
            tooltip: 'Delete checklist',
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: theme.colorScheme.surfaceContainerHighest,
            child: Row(
              children: [
                Icon(Icons.task_alt, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text('${checklist.tasks.length} tasks'),
                const SizedBox(width: 24),
                Icon(Icons.timer_outlined, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(formatDurationHuman(checklist.totalDuration)),
                if (checklist.settings.autoAdvance) ...[
                  const SizedBox(width: 24),
                  Icon(Icons.skip_next, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  const Text('Auto-advance'),
                ],
              ],
            ),
          ),
          // Task list
          Expanded(
            child: checklist.tasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_task,
                            size: 48, color: theme.colorScheme.outline),
                        const SizedBox(height: 16),
                        const Text('No tasks yet'),
                        const SizedBox(height: 8),
                        const Text('Add tasks to build your routine'),
                      ],
                    ),
                  )
                : ReorderableListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: checklist.tasks.length,
                    onReorder: (oldIndex, newIndex) =>
                        _reorderTasks(ref, oldIndex, newIndex),
                    itemBuilder: (context, index) {
                      final task = checklist.tasks[index];
                      return TaskTile(
                        key: ValueKey(task.id),
                        task: task,
                        index: index,
                        onTap: () => context.push(
                            '/checklist/${checklist.id}/task/${task.id}/edit'),
                        onDelete: () => _deleteTask(ref, index),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (checklist.tasks.isNotEmpty)
            FloatingActionButton.extended(
              heroTag: 'play',
              onPressed: () =>
                  context.push('/checklist/${checklist.id}/run'),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start'),
            ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'add',
            onPressed: () =>
                context.push('/checklist/${checklist.id}/task/new'),
            tooltip: 'Add task',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Future<void> _reorderTasks(WidgetRef ref, int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex--;
    final tasks = List.of(checklist.tasks);
    final item = tasks.removeAt(oldIndex);
    tasks.insert(newIndex, item);
    final updated = checklist.copyWith(tasks: tasks);
    final repo = await ref.read(checklistRepositoryProvider.future);
    await repo.save(updated);
    ref.invalidate(checklistListProvider);
    ref.invalidate(checklistDetailProvider(checklist.id));
  }

  Future<void> _deleteTask(WidgetRef ref, int index) async {
    final tasks = List.of(checklist.tasks);
    tasks.removeAt(index);
    final updated = checklist.copyWith(tasks: tasks);
    final repo = await ref.read(checklistRepositoryProvider.future);
    await repo.save(updated);
    ref.invalidate(checklistListProvider);
    ref.invalidate(checklistDetailProvider(checklist.id));
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Checklist'),
        content: Text('Are you sure you want to delete "${checklist.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await ref.read(checklistListProvider.notifier).deleteChecklist(checklist.id);
      if (context.mounted) context.go('/');
    }
  }
}
