import 'package:flutter/material.dart';
import 'package:recur/core/utils/duration_formatter.dart';
import 'package:recur/features/checklist/data/models/checklist_model.dart';

class ChecklistCard extends StatelessWidget {
  final ChecklistModel checklist;
  final VoidCallback onTap;

  const ChecklistCard({
    super.key,
    required this.checklist,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = _parseColor(checklist.color);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: cardColor.withValues(alpha: 0.15),
                    child: Icon(Icons.checklist, color: cardColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      checklist.name,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (checklist.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  checklist.description,
                  style: theme.textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const Spacer(),
              Row(
                children: [
                  Icon(Icons.task_alt,
                      size: 16, color: theme.colorScheme.outline),
                  const SizedBox(width: 4),
                  Text(
                    '${checklist.tasks.length} tasks',
                    style: theme.textTheme.labelSmall,
                  ),
                  const Spacer(),
                  Icon(Icons.timer_outlined,
                      size: 16, color: theme.colorScheme.outline),
                  const SizedBox(width: 4),
                  Text(
                    formatDurationHuman(checklist.totalDuration),
                    style: theme.textTheme.labelSmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return const Color(0xFF6750A4);
    }
  }
}
