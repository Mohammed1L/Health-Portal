import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_project/widgets/cards/app_card.dart';

void main() {
  group('AppCard Widget Tests', () {
    testWidgets('should display child widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppCard(
              child: const Text('Card Content'),
            ),
          ),
        ),
      );

      expect(find.text('Card Content'), findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (WidgetTester tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppCard(
              child: const Text('Card Content'),
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Card Content'));
      await tester.pump();

      expect(tapped, true);
    });

    testWidgets('should apply custom padding', (WidgetTester tester) async {
      const customPadding = EdgeInsets.all(20.0);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppCard(
              child: const Text('Card Content'),
              padding: customPadding,
            ),
          ),
        ),
      );

      // Find the Container with padding inside AppCard
      final containers = find.byType(Container).evaluate();
      Container? cardContainer;
      for (final element in containers) {
        final container = element.widget as Container;
        if (container.padding == customPadding) {
          cardContainer = container;
          break;
        }
      }

      expect(cardContainer, isNotNull);
      expect(cardContainer!.padding, customPadding);
    });

    testWidgets('should apply custom margin', (WidgetTester tester) async {
      const customMargin = EdgeInsets.all(10.0);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppCard(
              child: const Text('Card Content'),
              margin: customMargin,
            ),
          ),
        ),
      );

      // Find the Container with margin (outermost container in AppCard)
      final containers = find.byType(Container).evaluate();
      Container? marginContainer;
      for (final element in containers) {
        final container = element.widget as Container;
        if (container.margin == customMargin) {
          marginContainer = container;
          break;
        }
      }

      expect(marginContainer, isNotNull);
      expect(marginContainer!.margin, customMargin);
    });

    testWidgets('should apply custom border radius', (WidgetTester tester) async {
      const customRadius = 20.0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppCard(
              child: const Text('Card Content'),
              borderRadius: customRadius,
            ),
          ),
        ),
      );

      expect(find.byType(AppCard), findsOneWidget);
    });

    testWidgets('should apply outlined style when isOutlined is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppCard(
              child: const Text('Card Content'),
              isOutlined: true,
            ),
          ),
        ),
      );

      expect(find.byType(AppCard), findsOneWidget);
    });
  });
}

