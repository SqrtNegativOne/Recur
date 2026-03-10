import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:recur/features/runner/data/models/run_record.dart';

/// Stores run history as a JSON array in the app's support directory.
///
/// This is separate from the checklist storage folder so it:
/// 1. Doesn't pollute the user's checklists folder
/// 2. Won't be accidentally synced via Syncthing
/// 3. Won't be loaded as a checklist by ChecklistRepository
class RunHistoryRepository {
  /// Gets the path to the history JSON file.
  Future<File> get _file async {
    final dir = await getApplicationSupportDirectory();
    return File('${dir.path}/run_history.json');
  }

  /// Loads all run records, sorted newest first.
  Future<List<RunRecord>> loadAll() async {
    try {
      final file = await _file;
      if (!await file.exists()) return [];
      final content = await file.readAsString();
      final list = jsonDecode(content) as List;
      final records = list
          .map((e) => RunRecord.fromJson(e as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
      return records;
    } catch (_) {
      return [];
    }
  }

  /// Loads run records for a specific checklist.
  Future<List<RunRecord>> loadForChecklist(String checklistId) async {
    final all = await loadAll();
    return all.where((r) => r.checklistId == checklistId).toList();
  }

  /// Appends a new run record and saves.
  Future<void> save(RunRecord record) async {
    final records = await loadAll();
    records.insert(0, record);
    await _writeAll(records);
  }

  /// Writes all records to disk.
  Future<void> _writeAll(List<RunRecord> records) async {
    final file = await _file;
    final json = jsonEncode(records.map((r) => r.toJson()).toList());
    await file.writeAsString(json);
  }
}
