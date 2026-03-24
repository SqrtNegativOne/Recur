import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Returns light theme from 06:00–18:00, dark otherwise.
ThemeMode themeForHour(int hour) =>
    (hour >= 6 && hour < 18) ? ThemeMode.light : ThemeMode.dark;

/// Returns a greeting string based on the current hour.
String greetingForHour(int hour) {
  if (hour >= 5 && hour < 12) return 'Good Morning!';
  if (hour >= 12 && hour < 17) return 'Good Afternoon!';
  if (hour >= 17 && hour < 21) return 'Good Evening!';
  return 'Good Night!';
}

/// Emits the time-based ThemeMode and updates every minute.
final timeBasedThemeModeProvider = StreamProvider<ThemeMode>((ref) async* {
  yield themeForHour(DateTime.now().hour);
  await for (final _ in Stream.periodic(const Duration(minutes: 1))) {
    yield themeForHour(DateTime.now().hour);
  }
});
