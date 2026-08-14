import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Resolves the storage directory for checklist JSON files.
/// Uses custom path from settings if set, otherwise falls back
/// to Documents/Recur/checklists/.
Future<Directory> resolveStorageDirectory(String customPath) async {
  if (customPath.isNotEmpty) {
    final dir = Directory(customPath);
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  // Default: platform documents directory / Recur / checklists
  final docsDir = await _getDocumentsDirectory();
  final defaultDir = Directory('${docsDir.path}/Recur/checklists');
  if (!defaultDir.existsSync()) {
    await defaultDir.create(recursive: true);
  }
  return defaultDir;
}

Future<Directory> _getDocumentsDirectory() async {
  // On Windows, getApplicationDocumentsDirectory() returns the user's
  // Documents folder, which is the right place for user-visible files.
  return getApplicationDocumentsDirectory();
}
