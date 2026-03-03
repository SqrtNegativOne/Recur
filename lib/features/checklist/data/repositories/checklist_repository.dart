import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:recur/features/checklist/data/models/checklist_model.dart';

class ChecklistRepository {
  final Directory storageDir;

  ChecklistRepository(this.storageDir);

  /// Loads all checklists from JSON files in the storage directory.
  /// Skips Syncthing conflict files (.sync-conflict-*).
  Future<List<ChecklistModel>> loadAll() async {
    final checklists = <ChecklistModel>[];
    if (!await storageDir.exists()) return checklists;

    await for (final entity in storageDir.list()) {
      if (entity is File && _isValidChecklistFile(entity.path)) {
        try {
          final content = await entity.readAsString();
          final json = jsonDecode(content) as Map<String, dynamic>;
          checklists.add(ChecklistModel.fromJson(json));
        } catch (_) {
          // Skip malformed files silently
        }
      }
    }

    // Sort by updatedAt descending (newest first)
    checklists.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return checklists;
  }

  /// Loads a single checklist by its ID.
  Future<ChecklistModel?> loadById(String id) async {
    final all = await loadAll();
    try {
      return all.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Saves a checklist to its JSON file, updating the updatedAt timestamp.
  Future<void> save(ChecklistModel checklist) async {
    final updated = checklist.copyWith(updatedAt: DateTime.now());
    final file = File('${storageDir.path}/${updated.fileName}');
    final json = jsonEncode(updated.toJson());
    await file.writeAsString(json);

    // If the filename changed (due to name change), clean up old files
    // with the same ID but different name
    await _cleanupOldFiles(updated.id, updated.fileName);
  }

  /// Deletes a checklist file by ID.
  Future<void> delete(String id) async {
    await for (final entity in storageDir.list()) {
      if (entity is File && _isValidChecklistFile(entity.path)) {
        try {
          final content = await entity.readAsString();
          final json = jsonDecode(content) as Map<String, dynamic>;
          if (json['id'] == id) {
            await entity.delete();
            return;
          }
        } catch (_) {
          // Skip
        }
      }
    }
  }

  /// Watches the storage folder for file changes (new, modified, deleted).
  /// Useful for detecting Syncthing-synced files.
  Stream<FileSystemEvent> watchFolder() {
    if (!storageDir.existsSync()) return const Stream.empty();
    return storageDir.watch();
  }

  bool _isValidChecklistFile(String path) {
    final name = path.split(Platform.pathSeparator).last;
    return name.endsWith('.json') && !name.contains('.sync-conflict-');
  }

  Future<void> _cleanupOldFiles(String id, String currentFileName) async {
    await for (final entity in storageDir.list()) {
      if (entity is File && _isValidChecklistFile(entity.path)) {
        final name = entity.path.split(Platform.pathSeparator).last;
        if (name == currentFileName) continue;
        try {
          final content = await entity.readAsString();
          final json = jsonDecode(content) as Map<String, dynamic>;
          if (json['id'] == id) {
            await entity.delete();
          }
        } catch (_) {
          // Skip
        }
      }
    }
  }
}
