import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_smart_popup/flutter_smart_popup.dart';

void main() {
  group('SmartPopup Golden Tests', () {
    testWidgets('SmartPopup basic appearance', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SmartPopup(
                content: Container(
                  padding: const EdgeInsets.all(16),
                  child: const Text('Golden test content'),
                ),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  color: Colors.blue,
                  child: const Text('Golden Test Button'),
                ),
              ),
            ),
          ),
        ),
      );

      // Capture initial state
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('golden/smart_popup_initial.png'),
      );

      // Show popup and capture
      await tester.tap(find.text('Golden Test Button'));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('golden/smart_popup_shown.png'),
      );
    });

    testWidgets('SmartPopup with different styles',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.grey[100],
            body: Center(
              child: SmartPopup(
                backgroundColor: Colors.white,
                arrowColor: Colors.red,
                contentRadius: 12.0,
                contentPadding: const EdgeInsets.all(20),
                showArrow: true,
                content: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 32),
                    SizedBox(height: 8),
                    Text(
                      'Styled Popup',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text('Custom styling example'),
                  ],
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Styled Button',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Styled Button'));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('golden/smart_popup_styled.png'),
      );
    });

    testWidgets('SmartPopup positioning variants', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                const SizedBox(height: 50),
                SmartPopup(
                  position: PopupPosition.bottom,
                  content: const Text('Bottom positioned'),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.green,
                    child: const Text('Top Area'),
                  ),
                ),
                const Spacer(),
                SmartPopup(
                  position: PopupPosition.top,
                  content: const Text('Top positioned'),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.orange,
                    child: const Text('Bottom Area'),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      );

      // Test top area popup (shows below)
      await tester.tap(find.text('Top Area'));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('golden/smart_popup_bottom_position.png'),
      );

      await tester.tapAt(const Offset(10, 10)); // Dismiss
      await tester.pumpAndSettle();

      // Test bottom area popup (shows above)
      await tester.tap(find.text('Bottom Area'));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('golden/smart_popup_top_position.png'),
      );
    });
  });
}
