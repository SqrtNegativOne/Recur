import 'package:flutter/material.dart';

/// A row of dots showing position in a task sequence.
class TaskProgressBar extends StatelessWidget {
  final int totalTasks;
  final int currentTaskIndex;

  const TaskProgressBar({
    super.key,
    required this.totalTasks,
    required this.currentTaskIndex,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalTasks, (index) {
        final isComplete = index < currentTaskIndex;
        final isCurrent = index == currentTaskIndex;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isCurrent ? 24 : 10,
            height: 10,
            decoration: BoxDecoration(
              color: isComplete
                  ? theme.colorScheme.primary
                  : isCurrent
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        );
      }),
    );
  }
}
