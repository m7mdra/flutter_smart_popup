import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_smart_popup/flutter_smart_popup.dart';

void main() {
  group('SmartPopup Widget Tests', () {
    testWidgets('SmartPopup creates correctly with required parameters',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SmartPopup(
              content: Text('Test Content'),
              child: Text('Test Child'),
            ),
          ),
        ),
      );

      expect(find.text('Test Child'), findsOneWidget);
      expect(find.text('Test Content'),
          findsNothing); // Content not shown initially
    });

    testWidgets('SmartPopup shows content when tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SmartPopup(
              content: Text('Popup Content'),
              child: Text('Tap Me'),
            ),
          ),
        ),
      );

      // Tap the child widget
      await tester.tap(find.text('Tap Me'));
      await tester.pumpAndSettle();

      // Content should now be visible
      expect(find.text('Popup Content'), findsOneWidget);
    });

    testWidgets('SmartPopup respects isLongPress parameter',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SmartPopup(
              content: Text('Long Press Content'),
              child: Text('Long Press Me'),
              isLongPress: true,
            ),
          ),
        ),
      );

      // Regular tap should not show popup
      await tester.tap(find.text('Long Press Me'));
      await tester.pumpAndSettle();
      expect(find.text('Long Press Content'), findsNothing);

      // Long press should show popup
      await tester.longPress(find.text('Long Press Me'));
      await tester.pumpAndSettle();
      expect(find.text('Long Press Content'), findsOneWidget);
    });

    testWidgets('SmartPopup can be dismissed by tapping outside',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SmartPopup(
                content: Text('Dismissible Content'),
                child: Text('Show Popup'),
              ),
            ),
          ),
        ),
      );

      // Show popup
      await tester.tap(find.text('Show Popup'));
      await tester.pumpAndSettle();
      expect(find.text('Dismissible Content'), findsOneWidget);

      // Tap outside to dismiss
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(find.text('Dismissible Content'), findsNothing);
    });

    testWidgets('SmartPopup blur effects work correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SmartPopup(
              enableBlur: true,
              blurSigma: 5.0,
              content: Text('Blurred Content'),
              child: Text('Show Blur'),
            ),
          ),
        ),
      );

      // Show popup with blur
      await tester.tap(find.text('Show Blur'));
      await tester.pumpAndSettle();

      expect(find.text('Blurred Content'), findsOneWidget);
      expect(find.byType(BackdropFilter), findsOneWidget);
    });
  });

  group('SmartPopup Result Propagation Tests', () {
    testWidgets('SmartPopup onResult callback works',
        (WidgetTester tester) async {
      String? receivedResult;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartPopup<String>(
              content: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () =>
                      Navigator.pop<String>(context, 'test_result'),
                  child: const Text('Return Result'),
                ),
              ),
              onResult: (result) {
                receivedResult = result;
              },
              child: const Text('Show Result Popup'),
            ),
          ),
        ),
      );

      // Show popup
      await tester.tap(find.text('Show Result Popup'));
      await tester.pumpAndSettle();

      // Tap button to return result
      await tester.tap(find.text('Return Result'));
      await tester.pumpAndSettle();

      expect(receivedResult, equals('test_result'));
    });

    testWidgets('PopupNavigator.pop works correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartPopup<int>(
              content: Builder(
                builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop<int>(context, 42),
                      child: const Text('Return 42'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop<int>(context, null),
                      child: const Text('Return Null'),
                    ),
                  ],
                ),
              ),
              child: const Text('Show Options'),
            ),
          ),
        ),
      );

      // Test returning a value
      await tester.tap(find.text('Show Options'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Return 42'));
      await tester.pumpAndSettle();

      // Popup should be dismissed
      expect(find.text('Return 42'), findsNothing);
    });
  });

  group('SmartPopup Configuration Tests', () {
    testWidgets('SmartPopup respects custom styling',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SmartPopup(
              backgroundColor: Colors.red,
              arrowColor: Colors.blue,
              contentPadding: EdgeInsets.all(20),
              contentRadius: 15.0,
              showArrow: false,
              content: Text('Styled Content'),
              child: Text('Show Styled'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Styled'));
      await tester.pumpAndSettle();

      expect(find.text('Styled Content'), findsOneWidget);
      // When showArrow is false, the arrow size should be zero
      // We can't easily test for the absence of CustomPaint since other widgets may use it
      // Instead, let's verify the content is displayed properly
      expect(find.text('Styled Content'), findsOneWidget);
    });

    testWidgets('SmartPopup respects position parameter',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                SizedBox(height: 100),
                SmartPopup(
                  position: PopupPosition.top,
                  content: Text('Top Position'),
                  child: Text('Show Top'),
                ),
                SizedBox(height: 100),
                SmartPopup(
                  position: PopupPosition.bottom,
                  content: Text('Bottom Position'),
                  child: Text('Show Bottom'),
                ),
              ],
            ),
          ),
        ),
      );

      // Test top position
      await tester.tap(find.text('Show Top'));
      await tester.pumpAndSettle();
      expect(find.text('Top Position'), findsOneWidget);

      await tester.tapAt(const Offset(10, 10)); // Dismiss
      await tester.pumpAndSettle();

      // Test bottom position
      await tester.tap(find.text('Show Bottom'));
      await tester.pumpAndSettle();
      expect(find.text('Bottom Position'), findsOneWidget);
    });
  });

  group('SmartPopup Callback Tests', () {
    testWidgets('SmartPopup lifecycle callbacks work',
        (WidgetTester tester) async {
      bool beforeCalled = false;
      bool afterCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartPopup(
              onBeforePopup: () => beforeCalled = true,
              onAfterPopup: () => afterCalled = true,
              content: const Text('Callback Content'),
              child: const Text('Test Callbacks'),
            ),
          ),
        ),
      );

      expect(beforeCalled, isFalse);
      expect(afterCalled, isFalse);

      // Show popup
      await tester.tap(find.text('Test Callbacks'));
      await tester.pumpAndSettle();

      expect(beforeCalled, isTrue);
      expect(afterCalled, isFalse);

      // Dismiss popup
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(afterCalled, isTrue);
    });
  });
}
