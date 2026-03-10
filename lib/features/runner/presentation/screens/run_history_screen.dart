import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recur/core/utils/duration_formatter.dart';
import 'package:recur/features/runner/data/models/run_record.dart';
import 'package:recur/features/runner/providers/run_history_provider.dart';

/// Shows run history and stats — either for all checklists or filtered
/// to a single checklist (when checklistId is provided).
class RunHistoryScreen extends ConsumerWidget {
  final String? checklistId;
  final String? checklistName;

  const RunHistoryScreen({super.key, this.checklistId, this.checklistName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Load either all history or checklist-specific history
    final historyAsync = checklistId != null
        ? ref.watch(checklistHistoryProvider(checklistId!))
        : ref.watch(runHistoryProvider);

    final title = checklistName != null ? '$checklistName History' : 'Run History';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (records) {
          if (records.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.history, size: 64,
                      color: Theme.of(context).colorScheme.outline),
                  const SizedBox(height: 16),
                  Text('No runs yet',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text('Complete a checklist run to see your stats',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _StatsCard(records: records),
              const SizedBox(height: 16),
              Text('Recent Runs',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ...records.map((record) => _RunRecordTile(record: record)),
            ],
          );
        },
      ),
    );
  }
}

/// Displays aggregate stats: total runs, total time, avg time, streak.
class _StatsCard extends StatelessWidget {
  final List<RunRecord> records;

  const _StatsCard({required this.records});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalRuns = records.length;
    final totalActual =
        records.fold<int>(0, (sum, r) => sum + r.totalActualSeconds);
    final avgActual = totalRuns > 0 ? totalActual ~/ totalRuns : 0;
    final streak = _calculateStreak(records);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Stats', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    icon: Icons.replay,
                    label: 'Total Runs',
                    value: '$totalRuns',
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    icon: Icons.timer_outlined,
                    label: 'Total Time',
                    value: formatDurationLong(totalActual),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    icon: Icons.speed,
                    label: 'Avg Run',
                    value: formatDurationLong(avgActual),
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    icon: Icons.local_fire_department,
                    label: 'Streak',
                    value: '$streak ${streak == 1 ? "day" : "days"}',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Calculates the current streak — consecutive days with at least one run.
  /// The streak must include today or yesterday to count.
  int _calculateStreak(List<RunRecord> records) {
    if (records.isEmpty) return 0;

    // Get unique dates (day granularity), sorted newest first
    final dates = records
        .map((r) => DateTime(
            r.completedAt.year, r.completedAt.month, r.completedAt.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    final today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final yesterday = today.subtract(const Duration(days: 1));

    // Streak must include today or yesterday
    if (dates.first != today && dates.first != yesterday) return 0;

    int streak = 1;
    for (int i = 1; i < dates.length; i++) {
      if (dates[i - 1].difference(dates[i]).inDays == 1) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textTheme.labelSmall),
            Text(value, style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            )),
          ],
        ),
      ],
    );
  }
}

/// Shows a single run record with date, time, and task count.
class _RunRecordTile extends StatelessWidget {
  final RunRecord record;

  const _RunRecordTile({required this.record});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actual = formatDurationHuman(record.totalActualSeconds);
    final planned = formatDurationHuman(record.totalPlannedSeconds);

    // Format date
    final date = record.completedAt;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final recordDay = DateTime(date.year, date.month, date.day);
    final diff = today.difference(recordDay).inDays;

    String dateLabel;
    if (diff == 0) {
      dateLabel = 'Today';
    } else if (diff == 1) {
      dateLabel = 'Yesterday';
    } else if (diff < 7) {
      dateLabel = '$diff days ago';
    } else {
      dateLabel =
          '${date.day}/${date.month}/${date.year}';
    }

    final timeLabel =
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

    // Color-code: green if faster than planned, red if slower
    final actualSecs = record.totalActualSeconds;
    final plannedSecs = record.totalPlannedSeconds;
    final paceColor = actualSecs <= plannedSecs
        ? Colors.green
        : theme.colorScheme.error;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(Icons.check_circle, color: paceColor),
        title: Text(record.checklistName),
        subtitle: Text(
          '$dateLabel at $timeLabel  ·  $actual / $planned  ·  ${record.taskCount} tasks',
        ),
        trailing: Icon(Icons.chevron_right,
            color: theme.colorScheme.outline),
        onTap: () => _showDetails(context),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(record.checklistName,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ...List.generate(record.taskCount, (i) {
              final name =
                  i < record.taskNames.length ? record.taskNames[i] : 'Task ${i + 1}';
              final actual = i < record.taskActualSeconds.length
                  ? formatDurationHuman(record.taskActualSeconds[i])
                  : '?';
              final planned = i < record.taskPlannedSeconds.length
                  ? formatDurationHuman(record.taskPlannedSeconds[i])
                  : '?';
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(child: Text(name)),
                    Text('$actual / $planned',
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
