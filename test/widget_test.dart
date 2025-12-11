// Main widget test file
// Individual widget tests are in test/widget/ directory

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:my_project/main.dart';
import 'package:my_project/theme/theme_provider.dart';

void main() {
  testWidgets('App should start with LoginScreen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MyApp(),
      ),
    );

    // Verify that login screen is displayed
    expect(find.text('تسجيل الدخول'), findsOneWidget);
  });
}
