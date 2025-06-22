import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_smart_popup/flutter_smart_popup.dart';

void main() {
  group('Screen Utility Tests', () {
    test('Screen properties return valid values', () {
      // Note: In test environment, these will return test values
      expect(Screen.width, greaterThan(0));
      expect(Screen.height, greaterThan(0));
      expect(Screen.scale, greaterThan(0));
      expect(Screen.statusBar, greaterThanOrEqualTo(0));
      expect(Screen.bottomBar, greaterThanOrEqualTo(0));
    });

    test('Screen mediaQuery is not null', () {
      expect(Screen.mediaQuery, isNotNull);
      expect(Screen.mediaQuery.size.width, greaterThan(0));
      expect(Screen.mediaQuery.size.height, greaterThan(0));
    });
  });
}
