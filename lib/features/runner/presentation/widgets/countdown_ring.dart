import 'dart:math';
import 'package:flutter/material.dart';
import 'package:recur/core/utils/duration_formatter.dart';

class CountdownRing extends StatelessWidget {
  final int remainingSeconds;
  final double progress; // 0.0 to 1.0
  final bool isOvertime;
  final bool isPaused;

  const CountdownRing({
    super.key,
    required this.remainingSeconds,
    required this.progress,
    this.isOvertime = false,
    this.isPaused = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ringColor = isOvertime
        ? theme.colorScheme.error
        : isPaused
            ? theme.colorScheme.outline
            : theme.colorScheme.primary;

    return SizedBox(
      width: 240,
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(240, 240),
            painter: _RingPainter(
              progress: progress,
              color: ringColor,
              backgroundColor:
                  theme.colorScheme.surfaceContainerHighest,
              strokeWidth: 12,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isOvertime ? '+' : '',
                style: TextStyle(
                  color: theme.colorScheme.error,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                formatDuration(remainingSeconds.abs()),
                style: theme.textTheme.displayMedium?.copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                  color: isOvertime ? theme.colorScheme.error : null,
                ),
              ),
              if (isPaused)
                Text(
                  'PAUSED',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  _RingPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Start from top
      2 * pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
