import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_project/core/responsive.dart';

void main() {
  group('Responsive', () {
    testWidgets('isMobile should return true for small screens', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                expect(Responsive.isMobile(context), true);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('isTablet should return true for medium screens', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(800, 1200)),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                expect(Responsive.isTablet(context), true);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('isDesktop should return true for large screens', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1500, 1000));
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(1500, 1000)),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                expect(Responsive.isDesktop(context), true);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('getScreenWidth should return correct width', (tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 800));
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(500, 800)),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                expect(Responsive.getScreenWidth(context), 500);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('getScreenHeight should return correct height', (tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 800));
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(500, 800)),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                expect(Responsive.getScreenHeight(context), 800);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('getResponsiveValue should return mobile value for mobile', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                final value = Responsive.getResponsiveValue(
                  context,
                  mobile: 10.0,
                  tablet: 20.0,
                  desktop: 30.0,
                );
                expect(value, 10.0);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('getResponsiveValue should return tablet value for tablet', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(800, 1200)),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                final value = Responsive.getResponsiveValue(
                  context,
                  mobile: 10.0,
                  tablet: 20.0,
                  desktop: 30.0,
                );
                expect(value, 20.0);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('getResponsiveValue should return desktop value for desktop', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1500, 1000));
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(1500, 1000)),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                final value = Responsive.getResponsiveValue(
                  context,
                  mobile: 10.0,
                  tablet: 20.0,
                  desktop: 30.0,
                );
                expect(value, 30.0);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });
  });
}

