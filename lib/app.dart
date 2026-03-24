import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recur/core/providers/time_theme_provider.dart';
import 'package:recur/core/router/app_router.dart';
import 'package:recur/core/theme/app_theme.dart';
import 'package:recur/features/settings/providers/settings_provider.dart';

class RecurApp extends ConsumerWidget {
  const RecurApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final timeTheme = ref.watch(timeBasedThemeModeProvider);

    final resolvedTimeTheme =
        timeTheme.valueOrNull ?? themeForHour(DateTime.now().hour);

    final themeMode = settings.whenOrNull(
          data: (s) => s.themeMode == ThemeMode.system
              ? resolvedTimeTheme
              : s.themeMode,
        ) ??
        resolvedTimeTheme;

    return MaterialApp.router(
      title: 'Recur',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
