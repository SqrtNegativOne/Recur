import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recur/app.dart';

void main() {
  testWidgets('App launches smoke test', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: RecurApp()),
    );
    await tester.pumpAndSettle();
    expect(find.text('Recur'), findsOneWidget);
  });
}
