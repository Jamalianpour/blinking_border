import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:blinking_border/blinking_border.dart';

void main() {
  group('BlinkingBorder Widget Tests', () {
    testWidgets('BlinkingBorder renders child widget', (
      WidgetTester tester,
    ) async {
      const testKey = Key('test-child');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlinkingBorder(
              child: Container(key: testKey, width: 100, height: 100),
            ),
          ),
        ),
      );

      expect(find.byKey(testKey), findsOneWidget);
    });

    testWidgets('BlinkingBorder applies custom color', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlinkingBorder(
              color: Colors.red,
              child: Container(width: 100, height: 100),
            ),
          ),
        ),
      );

      final blinkingBorder = tester.widget<BlinkingBorder>(
        find.byType(BlinkingBorder),
      );

      expect(blinkingBorder.color, Colors.red);
    });

    testWidgets('BlinkingBorder respects autoStart property', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlinkingBorder(
              autoStart: false,
              child: Container(width: 100, height: 100),
            ),
          ),
        ),
      );

      final blinkingBorder = tester.widget<BlinkingBorder>(
        find.byType(BlinkingBorder),
      );

      expect(blinkingBorder.autoStart, false);
    });

    testWidgets('BlinkingBorder applies border radius', (
      WidgetTester tester,
    ) async {
      const testRadius = BorderRadius.all(Radius.circular(10));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlinkingBorder(
              borderRadius: testRadius,
              child: Container(width: 100, height: 100),
            ),
          ),
        ),
      );

      final blinkingBorder = tester.widget<BlinkingBorder>(
        find.byType(BlinkingBorder),
      );

      expect(blinkingBorder.borderRadius, testRadius);
    });

    testWidgets('BlinkingBorder changes blink style', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlinkingBorder(
              blinkStyle: BlinkStyle.cornerSweep,
              child: Container(width: 100, height: 100),
            ),
          ),
        ),
      );

      final blinkingBorder = tester.widget<BlinkingBorder>(
        find.byType(BlinkingBorder),
      );

      expect(blinkingBorder.blinkStyle, BlinkStyle.cornerSweep);
    });

    testWidgets('BlinkingBorder supports rainbow style', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlinkingBorder(
              blinkStyle: BlinkStyle.rainbow,
              child: Container(width: 100, height: 100),
            ),
          ),
        ),
      );

      final blinkingBorder = tester.widget<BlinkingBorder>(
        find.byType(BlinkingBorder),
      );

      expect(blinkingBorder.blinkStyle, BlinkStyle.rainbow);
    });

    testWidgets('BlinkingBorder supports pulsing style', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlinkingBorder(
              blinkStyle: BlinkStyle.pulsing,
              pulseScale: 0.1,
              child: Container(width: 100, height: 100),
            ),
          ),
        ),
      );

      final blinkingBorder = tester.widget<BlinkingBorder>(
        find.byType(BlinkingBorder),
      );

      expect(blinkingBorder.blinkStyle, BlinkStyle.pulsing);
      expect(blinkingBorder.pulseScale, 0.1);
    });

    testWidgets('BlinkingBorder supports glowing style', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlinkingBorder(
              blinkStyle: BlinkStyle.glowing,
              child: Container(width: 100, height: 100),
            ),
          ),
        ),
      );

      final blinkingBorder = tester.widget<BlinkingBorder>(
        find.byType(BlinkingBorder),
      );

      expect(blinkingBorder.blinkStyle, BlinkStyle.glowing);
    });

    testWidgets('BlinkingBorder changes stroke style', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlinkingBorder(
              strokeStyle: StrokeStyle.dashed,
              child: Container(width: 100, height: 100),
            ),
          ),
        ),
      );

      final blinkingBorder = tester.widget<BlinkingBorder>(
        find.byType(BlinkingBorder),
      );

      expect(blinkingBorder.strokeStyle, StrokeStyle.dashed);
    });
  });
}
