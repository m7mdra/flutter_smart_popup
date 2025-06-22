import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_smart_popup/flutter_smart_popup.dart';

void main() {
  group('SmartPopup Integration Tests', () {
    testWidgets('Complete popup interaction flow', (WidgetTester tester) async {
      String? resultReceived;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('SmartPopup Integration Test')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SmartPopup<String>(
                    enableBlur: true,
                    blurSigma: 5.0,
                    backgroundColor: Colors.white,
                    arrowColor: Colors.blue,
                    onResult: (result) {
                      resultReceived = result;
                    },
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Choose an option:'),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => PopupNavigator.pop<String>(
                            tester.element(find.byType(ElevatedButton).first),
                            'Option A',
                          ),
                          child: const Text('Option A'),
                        ),
                        ElevatedButton(
                          onPressed: () => PopupNavigator.pop<String>(
                            tester.element(find.byType(ElevatedButton).last),
                            'Option B',
                          ),
                          child: const Text('Option B'),
                        ),
                      ],
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Show Options',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Last result: ${resultReceived ?? "None"}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify initial state
      expect(find.text('Show Options'), findsOneWidget);
      expect(find.text('Choose an option:'), findsNothing);
      expect(resultReceived, isNull);

      // Tap to show popup
      await tester.tap(find.text('Show Options'));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Verify popup is shown with blur
      expect(find.text('Choose an option:'), findsOneWidget);
      expect(find.text('Option A'), findsOneWidget);
      expect(find.text('Option B'), findsOneWidget);
      expect(find.byType(BackdropFilter), findsOneWidget);

      // Select Option A
      await tester.tap(find.text('Option A'));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Verify popup is dismissed and result is received
      expect(find.text('Choose an option:'), findsNothing);
      expect(resultReceived, equals('Option A'));

      // Test barrier dismissal
      await tester.tap(find.text('Show Options'));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      expect(find.text('Choose an option:'), findsOneWidget);

      // Tap outside to dismiss
      await tester.tapAt(const Offset(50, 50));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      expect(find.text('Choose an option:'), findsNothing);
    });

    testWidgets('Multiple popup positioning test', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                const SizedBox(height: 50),
                SmartPopup(
                  position: PopupPosition.bottom,
                  content: const Text('Top area popup'),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.red,
                    child: const Text('Top Button'),
                  ),
                ),
                const Spacer(),
                SmartPopup(
                  position: PopupPosition.top,
                  content: const Text('Bottom area popup'),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.green,
                    child: const Text('Bottom Button'),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      );

      // Test top button (should show popup below)
      await tester.tap(find.text('Top Button'));
      await tester.pumpAndSettle();
      expect(find.text('Top area popup'), findsOneWidget);

      await tester.tapAt(const Offset(10, 10)); // Dismiss
      await tester.pumpAndSettle();

      // Test bottom button (should show popup above)
      await tester.tap(find.text('Bottom Button'));
      await tester.pumpAndSettle();
      expect(find.text('Bottom area popup'), findsOneWidget);
    });

    testWidgets('Long press vs tap interaction test',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SmartPopup(
                    isLongPress: false,
                    content: const Text('Tap popup content'),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.blue,
                      child: const Text('Tap Me'),
                    ),
                  ),
                  const SizedBox(height: 50),
                  SmartPopup(
                    isLongPress: true,
                    content: const Text('Long press popup content'),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.orange,
                      child: const Text('Long Press Me'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Test tap interaction
      await tester.tap(find.text('Tap Me'));
      await tester.pumpAndSettle();
      expect(find.text('Tap popup content'), findsOneWidget);

      await tester.tapAt(const Offset(10, 10)); // Dismiss
      await tester.pumpAndSettle();

      // Test that tap doesn't trigger long press popup
      await tester.tap(find.text('Long Press Me'));
      await tester.pumpAndSettle();
      expect(find.text('Long press popup content'), findsNothing);

      // Test long press interaction
      await tester.longPress(find.text('Long Press Me'));
      await tester.pumpAndSettle();
      expect(find.text('Long press popup content'), findsOneWidget);
    });

    testWidgets('Performance test with rapid interactions',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SmartPopup(
                enableBlur: true,
                content: Container(
                  padding: const EdgeInsets.all(20),
                  child: const Text('Performance test popup'),
                ),
                child: const Text('Rapid Test Button'),
              ),
            ),
          ),
        ),
      );

      // Perform rapid show/hide operations
      for (int i = 0; i < 5; i++) {
        await tester.tap(find.text('Rapid Test Button'));
        await tester.pump(const Duration(milliseconds: 100));

        await tester.tapAt(const Offset(10, 10)); // Dismiss
        await tester.pump(const Duration(milliseconds: 100));
      }

      // Final state should be clean
      expect(find.text('Performance test popup'), findsNothing);
      expect(find.text('Rapid Test Button'), findsOneWidget);
    });
  });
}
