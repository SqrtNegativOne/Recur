import 'package:flutter/material.dart';

class RunControls extends StatelessWidget {
  const RunControls({
    required this.isPaused,
    required this.onPauseResume,
    required this.onSkip,
    super.key,
  });
  final bool isPaused;
  final VoidCallback onPauseResume;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
