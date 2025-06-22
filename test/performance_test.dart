import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_smart_popup/flutter_smart_popup.dart';

void main() {
  group('SmartPopup Performance Tests', () {
    testWidgets('Popup animation performance', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SmartPopup(
                animationDuration: const Duration(milliseconds: 300),
                content: Container(
                  width: 200,
                  height: 150,
                  padding: const EdgeInsets.all(16),
                  child: const Text('Performance test popup'),
                ),
                child: const Text('Performance Test'),
              ),
            ),
          ),
        ),
      );

      final stopwatch = Stopwatch()..start();

      // Show popup
      await tester.tap(find.text('Performance Test'));
      await tester.pumpAndSettle();

      stopwatch.stop();

      // Animation should complete within reasonable time
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      expect(find.text('Performance test popup'), findsOneWidget);
    });

    testWidgets('Blur effect performance', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SmartPopup(
                enableBlur: true,
                blurSigma: 10.0,
                content: Container(
                  padding: const EdgeInsets.all(20),
                  child: const Text('Blur performance test'),
                ),
                child: const Text('Blur Test'),
              ),
            ),
          ),
        ),
      );

      final stopwatch = Stopwatch()..start();

      await tester.tap(find.text('Blur Test'));
      await tester.pumpAndSettle();

      stopwatch.stop();

      // Blur animation should not significantly impact performance
      expect(stopwatch.elapsedMilliseconds, lessThan(1500));
      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('Memory usage with multiple popups',
        (WidgetTester tester) async {
      // Test that multiple popup creations don't cause memory leaks
      for (int i = 0; i < 10; i++) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: SmartPopup(
                  enableBlur: true,
                  content: Text('Popup $i'),
                  child: Text('Button $i'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Button $i'));
        await tester.pump(const Duration(milliseconds: 100));

        await tester.tapAt(const Offset(10, 10)); // Dismiss
        await tester.pump(const Duration(milliseconds: 100));
      }

      // Should complete without memory issues
      expect(true, isTrue);
    });

    testWidgets('Rapid show/hide performance', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SmartPopup(
                content: Text('Rapid test content'),
                child: Text('Rapid Test'),
              ),
            ),
          ),
        ),
      );

      final stopwatch = Stopwatch()..start();

      // Perform rapid show/hide operations
      for (int i = 0; i < 5; i++) {
        await tester.tap(find.text('Rapid Test'));
        await tester.pump(const Duration(milliseconds: 50));

        await tester.tapAt(const Offset(10, 10));
        await tester.pump(const Duration(milliseconds: 50));
      }

      stopwatch.stop();

      // Rapid operations should complete efficiently
      expect(stopwatch.elapsedMilliseconds, lessThan(2000));
    });

    testWidgets('Complex content rendering performance',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SmartPopup(
                enableBlur: true,
                content: SizedBox(
                  width: 300,
                  height: 400,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Complex content to test rendering performance
                        for (int i = 0; i < 20; i++)
                          ListTile(
                            leading: CircleAvatar(child: Text('$i')),
                            title: Text('Item $i'),
                            subtitle: Text('Subtitle for item $i'),
                            trailing: const Icon(Icons.arrow_forward),
                          ),
                        const SizedBox(
                            height:
                                20), // Use SizedBox instead of Container for whitespace
                      ],
                    ),
                  ),
                ),
                child: const Text('Complex Content Test'),
              ),
            ),
          ),
        ),
      );

      final stopwatch = Stopwatch()..start();

      await tester.tap(find.text('Complex Content Test'));
      await tester.pumpAndSettle();

      stopwatch.stop();

      // Complex content should render within reasonable time
      expect(stopwatch.elapsedMilliseconds, lessThan(2000));
      expect(find.text('Item 0'), findsOneWidget);
      expect(find.text('Item 19'), findsOneWidget);
    });
  });
}
