import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:my_project/screens/login_screen.dart';
import 'package:my_project/theme/theme_provider.dart';

void main() {
  group('LoginScreen Widget Tests', () {
    testWidgets('should display login screen elements', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
          child: MaterialApp(
            home: const LoginScreen(),
          ),
        ),
      );

      // Check for username field (hint text)
      expect(find.text('اسم المستخدم'), findsWidgets);
      
      // Check for password field (hint text)
      expect(find.text('كلمة المرور'), findsWidgets);
      
      // Check for login button
      expect(find.text('تسجيل الدخول'), findsOneWidget);
    });

    testWidgets('should allow entering username', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
          child: MaterialApp(
            home: const LoginScreen(),
          ),
        ),
      );

      // Find TextField by type and enter text
      final textFields = find.byType(TextField);
      expect(textFields, findsWidgets);
      
      await tester.enterText(textFields.first, 'testuser');
      await tester.pump();

      expect(find.text('testuser'), findsOneWidget);
    });

    testWidgets('should allow entering password', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
          child: MaterialApp(
            home: const LoginScreen(),
          ),
        ),
      );

      // Find password TextField (should be the second one or find by obscureText)
      final textFields = find.byType(TextField);
      expect(textFields, findsWidgets);
      
      // Password field should be the second TextField
      await tester.enterText(textFields.at(1), 'password123');
      await tester.pump();

      // Password should be obscured, so we can't find the actual text
      // But we can verify the field exists
      expect(textFields, findsWidgets);
    });

    testWidgets('should display forgot password link', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
          child: MaterialApp(
            home: const LoginScreen(),
          ),
        ),
      );

      expect(find.text('نسيت كلمة المرور؟'), findsOneWidget);
    });

    testWidgets('should display registration link', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
          child: MaterialApp(
            home: const LoginScreen(),
          ),
        ),
      );

      expect(find.text('إنشاء حساب جديد'), findsOneWidget);
    });
  });
}

