import 'package:flutter/material.dart';

class RunControls extends StatelessWidget {
  final bool isPaused;
  final VoidCallback onPauseResume;
  final VoidCallback onSkip;
  final VoidCallback onStop;

  const RunControls({
    super.key,
    required this.isPaused,
    required this.onPauseResume,
    required this.onSkip,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Stop
        IconButton.outlined(
          onPressed: onStop,
          icon: const Icon(Icons.stop),
          tooltip: 'Stop',
          iconSize: 32,
          style: IconButton.styleFrom(
            foregroundColor: theme.colorScheme.error,
            side: BorderSide(color: theme.colorScheme.error),
          ),
        ),
        const SizedBox(width: 24),
        // Pause / Resume
        FloatingActionButton.large(
          heroTag: 'pause_resume',
          onPressed: onPauseResume,
          child: Icon(isPaused ? Icons.play_arrow : Icons.pause, size: 40),
        ),
        const SizedBox(width: 24),
        // Skip
        IconButton.outlined(
          onPressed: onSkip,
          icon: const Icon(Icons.skip_next),
          tooltip: 'Skip',
          iconSize: 32,
        ),
      ],
    );
  }
}
