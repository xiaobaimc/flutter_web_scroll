import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web_scroll/flutter_web_scroll.dart';

void main() {
  group('SmoothScrollConfig', () {
    test('default configuration uses Lenis scroll type', () {
      const config = SmoothScrollConfig();
      expect(config.scrollType, SmoothScrollType.lenis);
      expect(config.scrollSpeed, 1.2);
      expect(config.damping, 0.08);
    });

    test('Lenis factory creates correct configuration', () {
      final config = SmoothScrollConfig.lenis(
        scrollSpeed: 1.5,
        damping: 0.1,
      );
      expect(config.scrollType, SmoothScrollType.lenis);
      expect(config.scrollSpeed, 1.5);
      expect(config.damping, 0.1);
    });

    test('Linear factory creates correct configuration', () {
      final config = SmoothScrollConfig.linear(
        scrollSpeed: 1.0,
        duration: 400,
      );
      expect(config.scrollType, SmoothScrollType.linear);
      expect(config.scrollSpeed, 1.0);
      expect(config.linearDuration, 400);
    });

    test('Elastic factory creates correct configuration', () {
      final config = SmoothScrollConfig.elastic(
        springStiffness: 150.0,
        springDamping: 15.0,
      );
      expect(config.scrollType, SmoothScrollType.elastic);
      expect(config.springStiffness, 150.0);
      expect(config.springDamping, 15.0);
    });

    test('Custom factory creates correct configuration', () {
      final config = SmoothScrollConfig.custom(
        scrollSpeed: 2.0,
        damping: 0.05,
      );
      expect(config.scrollType, SmoothScrollType.custom);
      expect(config.scrollSpeed, 2.0);
      expect(config.damping, 0.05);
    });

    test('throws assertion error for invalid scrollSpeed', () {
      expect(
        () => SmoothScrollConfig(scrollSpeed: -1),
        throwsAssertionError,
      );
    });

    test('throws assertion error for invalid damping', () {
      expect(
        () => SmoothScrollConfig(damping: 1.5),
        throwsAssertionError,
      );
    });
  });

  group('SmoothScrollWeb Widget', () {
    testWidgets('creates widget with default config', (tester) async {
      final controller = ScrollController();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmoothScrollWeb(
              controller: controller,
              child: ListView(
                controller: controller,
                children: const [
                  SizedBox(height: 100, child: Text('Item 1')),
                  SizedBox(height: 100, child: Text('Item 2')),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(SmoothScrollWeb), findsOneWidget);
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
    });

    testWidgets('creates widget with custom config', (tester) async {
      final controller = ScrollController();
      final config = SmoothScrollConfig.elastic();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmoothScrollWeb(
              controller: controller,
              config: config,
              child: ListView(
                controller: controller,
                children: const [
                  SizedBox(height: 100, child: Text('Item 1')),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(SmoothScrollWeb), findsOneWidget);
    });
  });
}
