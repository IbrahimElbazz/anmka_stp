// This is a basic Flutter widget test.

import 'package:flutter_test/flutter_test.dart';
import 'package:educational_app/main.dart';

void main() {
  testWidgets('App starts correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const EducationalApp());

    // Verify app launches without errors
    await tester.pumpAndSettle();
  });
}
