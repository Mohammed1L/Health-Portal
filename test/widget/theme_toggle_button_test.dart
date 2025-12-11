import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:my_project/widgets/app_bar/theme_toggle_button.dart';
import 'package:my_project/theme/theme_provider.dart';

void main() {
  group('ThemeToggleButton Widget Tests', () {
    testWidgets('should display light mode icon in light theme', (WidgetTester tester) async {
      final themeProvider = ThemeProvider();
      themeProvider.setThemeMode(ThemeMode.light);

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: themeProvider,
          child: MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                actions: const [ThemeToggleButton()],
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.dark_mode), findsOneWidget);
    });

    testWidgets('should display dark mode icon in dark theme', (WidgetTester tester) async {
      final themeProvider = ThemeProvider();
      themeProvider.setThemeMode(ThemeMode.dark);

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: themeProvider,
          child: MaterialApp(
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: ThemeMode.dark,
            home: Scaffold(
              appBar: AppBar(
                actions: const [ThemeToggleButton()],
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.light_mode), findsOneWidget);
    });

    testWidgets('should toggle theme when tapped', (WidgetTester tester) async {
      final themeProvider = ThemeProvider();
      themeProvider.setThemeMode(ThemeMode.light);

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: themeProvider,
          child: MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                actions: const [ThemeToggleButton()],
              ),
            ),
          ),
        ),
      );

      expect(themeProvider.themeMode, ThemeMode.light);

      await tester.tap(find.byType(ThemeToggleButton));
      await tester.pump();

      expect(themeProvider.themeMode, ThemeMode.dark);
    });
  });
}

