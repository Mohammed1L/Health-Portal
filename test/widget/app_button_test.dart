import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_project/widgets/buttons/app_button.dart';

void main() {
  group('AppButton Widget Tests', () {
    testWidgets('should display button text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              text: 'Test Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (WidgetTester tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              text: 'Test Button',
              onPressed: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Test Button'));
      await tester.pump();

      expect(tapped, true);
    });

    testWidgets('should not call onPressed when disabled', (WidgetTester tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              text: 'Test Button',
              onPressed: null,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Test Button'), warnIfMissed: false);
      await tester.pump();

      expect(tapped, false);
    });

    testWidgets('should display loading indicator when isLoading is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              text: 'Test Button',
              onPressed: () {},
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display icon when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              text: 'Test Button',
              onPressed: () {},
              icon: Icons.add,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('should apply correct size for small button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              text: 'Test Button',
              onPressed: () {},
              size: AppButtonSize.small,
            ),
          ),
        ),
      );

      final button = tester.widget<AppButton>(find.byType(AppButton));
      expect(button.size, AppButtonSize.small);
    });

    testWidgets('should apply correct size for medium button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              text: 'Test Button',
              onPressed: () {},
              size: AppButtonSize.medium,
            ),
          ),
        ),
      );

      final button = tester.widget<AppButton>(find.byType(AppButton));
      expect(button.size, AppButtonSize.medium);
    });

    testWidgets('should apply correct size for large button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              text: 'Test Button',
              onPressed: () {},
              size: AppButtonSize.large,
            ),
          ),
        ),
      );

      final button = tester.widget<AppButton>(find.byType(AppButton));
      expect(button.size, AppButtonSize.large);
    });

    testWidgets('should apply primary button type', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              text: 'Test Button',
              onPressed: () {},
              type: AppButtonType.primary,
            ),
          ),
        ),
      );

      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should apply outline button type', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              text: 'Test Button',
              onPressed: () {},
              type: AppButtonType.outline,
            ),
          ),
        ),
      );

      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('should apply text button type', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              text: 'Test Button',
              onPressed: () {},
              type: AppButtonType.text,
            ),
          ),
        ),
      );

      expect(find.byType(TextButton), findsOneWidget);
    });
  });
}

