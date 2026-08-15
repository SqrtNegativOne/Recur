import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recur/app.dart';
import 'package:recur/core/providers/time_theme_provider.dart';

void main() {
  testWidgets('App launches smoke test', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          timeBasedThemeModeProvider.overrideWith(
            (ref) => Stream.value(ThemeMode.light),
          ),
        ],
        child: const RecurApp(),
      ),
    );
    expect(find.text('Recur'), findsOneWidget);
  });
}
