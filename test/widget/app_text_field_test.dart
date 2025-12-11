import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_project/widgets/inputs/app_text_field.dart';

void main() {
  group('AppTextField Widget Tests', () {
    testWidgets('should display hint text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(
              hintText: 'Enter text',
            ),
          ),
        ),
      );

      expect(find.text('Enter text'), findsOneWidget);
    });

    testWidgets('should display label text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(
              labelText: 'Label',
            ),
          ),
        ),
      );

      expect(find.text('Label'), findsOneWidget);
    });

    testWidgets('should display error text when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(
              errorText: 'Error message',
            ),
          ),
        ),
      );

      expect(find.text('Error message'), findsOneWidget);
    });

    testWidgets('should call onChanged when text changes', (WidgetTester tester) async {
      String? changedValue;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(AppTextField), 'test');
      await tester.pump();

      expect(changedValue, 'test');
    });

    testWidgets('should use controller when provided', (WidgetTester tester) async {
      final controller = TextEditingController(text: 'Initial text');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(
              controller: controller,
            ),
          ),
        ),
      );

      expect(find.text('Initial text'), findsOneWidget);
      expect(controller.text, 'Initial text');
    });

    testWidgets('should be disabled when enabled is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(
              enabled: false,
            ),
          ),
        ),
      );

      final textField = tester.widget<AppTextField>(find.byType(AppTextField));
      expect(textField.enabled, false);
    });

    testWidgets('should apply keyboard type', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(
              keyboardType: TextInputType.emailAddress,
            ),
          ),
        ),
      );

      final textField = tester.widget<AppTextField>(find.byType(AppTextField));
      expect(textField.keyboardType, TextInputType.emailAddress);
    });
  });
}

