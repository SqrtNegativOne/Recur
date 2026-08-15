import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import 'package:recur/app.dart';
// Importing this file registers the @pragma('vm:entry-point') overlayMain()
// function so the Android overlay service can launch it as a separate isolate.
import 'package:recur/core/overlay/overlay_main.dart'
    show overlayMain; // ignore: unused_import
import 'package:recur/core/utils/logger.dart';

class AppWindowListener extends WindowListener {
  @override
  void onWindowClose() async {
    // Explicitly destroy the window and exit the process.
    // This bypasses any buggy plugin teardown logic that causes "restarts".
    await windowManager.destroy();
    exit(0);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();
    
    // Intercept the default close behavior
    await windowManager.setPreventClose(true);
    windowManager.addListener(AppWindowListener());
    
    WindowOptions windowOptions = const WindowOptions(
      size: Size(1280, 720),
      center: true,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  // Log Flutter framework errors
  FlutterError.onError = (details) {
    logger.e(
      'FlutterError caught by global error handler',
      error: details.exception,
      stackTrace: details.stack,
    );
  };

  // Log all other Dart/async errors
  PlatformDispatcher.instance.onError = (error, stack) {
    logger.e(
      'PlatformDispatcherError caught by global error handler',
      error: error,
      stackTrace: stack,
    );
    return true; // Prevent hard crashes
  };

  runApp(const ProviderScope(child: RecurApp()));
}
