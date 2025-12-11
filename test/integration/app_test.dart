import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_project/main.dart' as app;
import 'package:provider/provider.dart';
import 'package:my_project/theme/theme_provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Health Portal Integration Tests', () {
    testWidgets('Complete login flow', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Verify login screen is displayed
      expect(find.text('تسجيل الدخول'), findsOneWidget);

      // Enter username - find TextField by type
      final textFields = find.byType(TextField);
      if (textFields.evaluate().isNotEmpty) {
        await tester.enterText(textFields.first, 'testuser');
        await tester.pumpAndSettle();

        // Enter password - use second TextField
        if (textFields.evaluate().length > 1) {
          await tester.enterText(textFields.at(1), 'password123');
          await tester.pumpAndSettle();
        }
      }

      // Tap login button
      final loginButton = find.text('تسجيل الدخول');
      await tester.tap(loginButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Note: Actual navigation depends on login logic
      // This is a template for the integration test
    });

    testWidgets('Navigation flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate through different screens
      // This is a template - adjust based on actual navigation structure
    });

    testWidgets('Theme toggle functionality', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Find theme toggle button
      // Tap it
      // Verify theme changes
      // This is a template - adjust based on actual implementation
    });
  });
}

