import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jembergo_mobile_app/widgets/app_bottom_navigation.dart';

void main() {
  testWidgets('all navigation items keep the same size when selected', (
    WidgetTester tester,
  ) async {
    for (var selectedIndex = 0; selectedIndex < 5; selectedIndex++) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: AppBottomNavigation(
              selectedIndex: selectedIndex,
              onSelected: (_) {},
            ),
          ),
        ),
      );

      final itemIcons = find.descendant(
        of: find.byType(AppBottomNavigation),
        matching: find.byType(AnimatedContainer),
      );
      expect(itemIcons, findsNWidgets(5));
      for (var index = 0; index < 5; index++) {
        expect(tester.getSize(itemIcons.at(index)), const Size(32, 32));
      }

      final icons = tester.widgetList<Icon>(
        find.descendant(
          of: find.byType(AppBottomNavigation),
          matching: find.byType(Icon),
        ),
      );
      expect(icons, hasLength(5));
      expect(icons.map((icon) => icon.size), everyElement(19));
    }
  });
}
