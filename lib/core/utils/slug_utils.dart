/// Converts a name to a URL-friendly slug.
/// "Morning Routine!" → "morning-routine"
String toSlug(String name) {
  return name
      .toLowerCase()
      .trim()
      .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
      .replaceAll(RegExp(r'[\s]+'), '-')
      .replaceAll(RegExp(r'-+'), '-')
      .replaceAll(RegExp(r'^-|-$'), '');
}

/// Builds a filename from a slug and a short ID segment.
/// e.g. "morning-routine_a1b2c3d4.json"
String buildFileName(String name, String id) {
  final slug = toSlug(name);
  final shortId = id.length >= 8 ? id.substring(0, 8) : id;
  return '${slug}_$shortId.json';
}
