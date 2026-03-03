/// Formats a duration in seconds to "MM:SS" string.
String formatDuration(int totalSeconds) {
  final minutes = totalSeconds ~/ 60;
  final seconds = totalSeconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}

/// Formats a duration in seconds to a human-readable string like "2m 30s".
String formatDurationHuman(int totalSeconds) {
  if (totalSeconds <= 0) return '0s';
  final minutes = totalSeconds ~/ 60;
  final seconds = totalSeconds % 60;
  if (minutes == 0) return '${seconds}s';
  if (seconds == 0) return '${minutes}m';
  return '${minutes}m ${seconds}s';
}
