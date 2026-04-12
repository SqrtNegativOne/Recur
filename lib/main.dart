import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recur/app.dart';
// Importing this file registers the @pragma('vm:entry-point') overlayMain()
// function so the Android overlay service can launch it as a separate isolate.
import 'package:recur/core/overlay/overlay_main.dart' show overlayMain; // ignore: unused_import

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: RecurApp()));
}
