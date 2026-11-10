import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jembergo_mobile_app/main.dart';
import 'package:jembergo_mobile_app/screens/home_screen.dart';

void main() {
  testWidgets('welcome screen start button opens the home screen', (
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

    expect(
      find.text('Explore Your Dream\nWisata Jember Today'),
      findsOneWidget,
    );
    expect(find.text('Pantai Tanjung Papuma'), findsOneWidget);
  });

  testWidgets('existing-account link opens the login screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const JemberGoApp());

    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();

    expect(find.text('Masuk ke Akun'), findsOneWidget);
  });

  testWidgets(
    'login screen opens registration and registration returns to login',
    (WidgetTester tester) async {
      await tester.pumpWidget(const JemberGoApp());
      await tester.tap(find.text('Masuk'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Daftar Sekarang'));
      await tester.tap(find.text('Daftar Sekarang'));
      await tester.pumpAndSettle();
      expect(find.text('Buat Akun Baru'), findsOneWidget);
      expect(find.text('Nomor Telepon / WhatsApp'), findsOneWidget);
      expect(find.text('Konfirmasi Kata Sandi'), findsOneWidget);

      await tester.ensureVisible(find.text('Masuk di sini'));
      await tester.tap(find.text('Masuk di sini'));
      await tester.pumpAndSettle();
      expect(find.text('Masuk ke Akun'), findsOneWidget);
    },
  );

  testWidgets('valid login form opens the home screen preview', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const JemberGoApp());
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'rama@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.ensureVisible(find.text('Masuk').last);
    await tester.tap(find.text('Masuk').last);
    await tester.pumpAndSettle();

    expect(
      find.text('Explore Your Dream\nWisata Jember Today'),
      findsOneWidget,
    );
    expect(find.text('Pantai Tanjung Papuma'), findsOneWidget);
  });

  testWidgets('home content fills the available viewport width', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(600, 800);
    tester.view.devicePixelRatio = 1;
    tester.view.viewPadding = const FakeViewPadding(left: 32, right: 32);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetViewPadding);

    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    expect(tester.getSize(find.byType(CustomScrollView)).width, 600);
  });

  testWidgets('home category selection changes the featured destination', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    String featuredName() {
      return tester
          .widget<Text>(find.byKey(const ValueKey('featured-destination-name')))
          .data!;
    }

    expect(featuredName(), 'Pantai Tanjung Papuma');

    await tester.tap(find.text('Wisata Alam'));
    await tester.pumpAndSettle();
    expect(featuredName(), 'Air Terjun Tancak');

    await tester.tap(find.text('Wisata Bahari'));
    await tester.pumpAndSettle();
    expect(featuredName(), 'Teluk Love');

    await tester.tap(find.text('Wisata Buatan'));
    await tester.pumpAndSettle();
    expect(featuredName(), 'Puncak Rembangan');

    await tester.tap(find.text('Semua'));
    await tester.pumpAndSettle();
    expect(featuredName(), 'Pantai Tanjung Papuma');
  });
}
