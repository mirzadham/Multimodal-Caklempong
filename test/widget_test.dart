import 'package:flutter_test/flutter_test.dart';

import 'package:pocket_caklempong/main.dart';

void main() {
  testWidgets('App renders without error', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PocketCaklempongApp());

    // Verify the app title is rendered
    expect(find.text('POCKET CAKLEMPONG'), findsOneWidget);
  });

  testWidgets('Gong buttons are displayed', (WidgetTester tester) async {
    await tester.pumpWidget(const PocketCaklempongApp());

    // Should have 8 gong labels
    expect(find.text('Do'), findsOneWidget);
    expect(find.text('Re'), findsOneWidget);
    expect(find.text('Mi'), findsOneWidget);
  });
}
