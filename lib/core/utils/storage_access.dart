import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

/// "All files access" (MANAGE_EXTERNAL_STORAGE) helper for Android 11+.
///
/// Apps targeting Android 11+ get a scoped view of shared storage:
/// a plain [Directory.list()] on e.g. `/storage/emulated/0/Documents`
/// returns only files the app itself created. JSON files synced by
/// Syncthing (or moved in by a file manager) are invisible until the
/// app is granted "All files access" — the same permission Syncthing
/// itself requires.
///
/// Folders inside the app's own storage (internal sandbox or
/// `Android/data/<package>`) are never scoped, so no permission is
/// needed there.
class StorageAccess {
  StorageAccess._();

  /// Whether [path] lives on shared external storage that is subject
  /// to scoped storage (and thus needs All files access).
  static bool needsAllFilesAccess(String path) {
    if (!Platform.isAndroid) return false;
    final normalized = path.replaceAll(Platform.pathSeparator, '/');
    return normalized.startsWith('/storage/') ||
        normalized.startsWith('/mnt/media/');
  }

  /// Current grant state. Always true off Android (not applicable).
  static Future<bool> isGranted() async {
    if (!Platform.isAndroid) return true;
    final status = await Permission.manageExternalStorage.status;
    return status.isGranted;
  }

  /// Opens the system "All files access" screen (Android 11+) and
  /// returns the resulting grant state.
  static Future<bool> request() async {
    if (!Platform.isAndroid) return true;
    await Permission.manageExternalStorage.request();
    final status = await Permission.manageExternalStorage.status;
    return status.isGranted;
  }
}
