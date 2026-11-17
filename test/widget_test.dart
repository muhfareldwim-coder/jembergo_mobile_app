import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jembergo_mobile_app/app.dart';
import 'package:jembergo_mobile_app/features/home/presentation/home_screen.dart';

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

  testWidgets('featured destinations can auto-rotate and be swiped', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    String featuredName() {
      return tester
          .widget<Text>(find.byKey(const ValueKey('featured-destination-name')))
          .data!;
    }

    expect(featuredName(), 'Pantai Tanjung Papuma');

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    expect(featuredName(), 'Air Terjun Tancak');

    final carousel = find.byKey(
      const ValueKey('featured-destination-carousel'),
    );
    await tester.ensureVisible(carousel);
    await tester.pumpAndSettle();
    await tester.fling(carousel, const Offset(-500, 0), 1000);
    await tester.pumpAndSettle();
    expect(featuredName(), 'Teluk Love');
  });

  testWidgets('home article opens its detail and linked destination', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    final articleCardTitle = find.textContaining(
      'Panduan Lengkap Eksplorasi Tanjung Papuma',
    );
    await tester.scrollUntilVisible(
      articleCardTitle,
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(articleCardTitle);
    await tester.pumpAndSettle();

    expect(find.text('Lihat Destinasi'), findsOneWidget);
    final articleSection = find.text('Berburu foto saat pagi');
    await tester.scrollUntilVisible(
      articleSection,
      300,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.pumpAndSettle();
    expect(articleSection, findsOneWidget);

    await tester.tap(find.text('Lihat Destinasi'));
    await tester.pumpAndSettle();
    expect(find.text('Pantai Tanjung Papuma'), findsOneWidget);
  });
}
