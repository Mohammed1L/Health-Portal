import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_project/theme/theme_provider.dart';

void main() {
  group('ThemeProvider', () {
    test('initial theme mode should be light', () {
      final provider = ThemeProvider();
      expect(provider.themeMode, ThemeMode.light);
    });

    test('isDarkMode should return false for light mode', () {
      final provider = ThemeProvider();
      expect(provider.isDarkMode, false);
    });

    test('setThemeMode should update theme mode', () {
      final provider = ThemeProvider();
      provider.setThemeMode(ThemeMode.dark);
      expect(provider.themeMode, ThemeMode.dark);
      expect(provider.isDarkMode, true);
    });

    test('setThemeMode should notify listeners', () {
      final provider = ThemeProvider();
      var notified = false;
      provider.addListener(() {
        notified = true;
      });

      provider.setThemeMode(ThemeMode.dark);
      expect(notified, true);
    });

    test('setThemeMode should not notify if mode is the same', () {
      final provider = ThemeProvider();
      var notificationCount = 0;
      provider.addListener(() {
        notificationCount++;
      });

      provider.setThemeMode(ThemeMode.light);
      expect(notificationCount, 0);
    });

    test('toggleTheme should switch from light to dark', () {
      final provider = ThemeProvider();
      provider.toggleTheme();
      expect(provider.themeMode, ThemeMode.dark);
    });

    test('toggleTheme should switch from dark to light', () {
      final provider = ThemeProvider();
      provider.setThemeMode(ThemeMode.dark);
      provider.toggleTheme();
      expect(provider.themeMode, ThemeMode.light);
    });

    test('toggleTheme should switch from system to light', () {
      final provider = ThemeProvider();
      provider.setThemeMode(ThemeMode.system);
      provider.toggleTheme();
      expect(provider.themeMode, ThemeMode.light);
    });
  });
}

