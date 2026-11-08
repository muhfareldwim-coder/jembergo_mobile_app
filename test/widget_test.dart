import 'package:flutter_test/flutter_test.dart';

import 'package:jembergo_mobile_app/main.dart';

void main() {
  testWidgets('welcome screen opens the login screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const JemberGoApp());

    expect(
      find.text('Discover the Ultimate\nWisata Jember Experience'),
      findsOneWidget,
    );
    expect(find.text('Mulai Sekarang'), findsOneWidget);

    await tester.tap(find.text('Mulai Sekarang'));
    await tester.pumpAndSettle();

    expect(find.text('Masuk ke Akun'), findsOneWidget);
    expect(find.text('Alamat Email'), findsOneWidget);
  });

  testWidgets('existing-account link opens the login screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const JemberGoApp());

    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();

    expect(find.text('Masuk ke Akun'), findsOneWidget);
  });
}
