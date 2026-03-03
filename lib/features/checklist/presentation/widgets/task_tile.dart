import 'package:flutter/material.dart';
import 'package:recur/core/utils/duration_formatter.dart';
import 'package:recur/features/checklist/data/models/task_model.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;
  final int index;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TaskTile({
    super.key,
    required this.task,
    required this.index,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      key: ValueKey(task.id),
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.primaryContainer,
        child: Text(
          '${index + 1}',
          style: TextStyle(color: theme.colorScheme.onPrimaryContainer),
        ),
      ),
      title: Text(task.name),
      subtitle: Text(formatDurationHuman(task.durationSeconds)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
              tooltip: 'Delete task',
            ),
          const Icon(Icons.drag_handle),
        ],
      ),
      onTap: onTap,
    );
  }
}
