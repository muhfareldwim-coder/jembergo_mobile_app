import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:jembergo_mobile_app/screens/map_screen.dart';

void main() {
  testWidgets('MapScreen renders all core map elements and OSM attribution', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: MapScreen()));

    // Header greetings
    expect(find.text('Halo, '), findsOneWidget);
    expect(find.text('Budi Santoso'), findsOneWidget);
    expect(find.text('Peta Wisata Jember, Jawa Timur'), findsOneWidget);

    // Search bar & badges
    expect(find.text('Cari wisata di Jember...'), findsOneWidget);
    expect(find.byTooltip('Cari wisata'), findsOneWidget);
    expect(find.textContaining('GPS'), findsOneWidget);
    expect(find.text('OSRM Jalur Cepat'), findsOneWidget);
    expect(find.byType(FlutterMap), findsOneWidget);

    // OpenStreetMap attribution
    expect(find.text('© OpenStreetMap contributors'), findsOneWidget);

    // Map filters are removed; destination search remains available.
    expect(find.text('Semua'), findsNothing);
    expect(find.byTooltip('Urutkan'), findsNothing);

    // Selected destination card
    expect(find.text('TUJUAN TERPILIH'), findsOneWidget);
    expect(find.text('Pantai Tanjung Papuma'), findsWidgets);
    expect(find.text('Mulai Navigasi Rute'), findsOneWidget);
    expect(find.text('Detail'), findsOneWidget);

    // Bottom Navigation items
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Jelajahi'), findsOneWidget);
    expect(find.text('Peta'), findsOneWidget);
    expect(find.text('Tiket'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
  });

  testWidgets('searching destination filters map items', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: MapScreen()));

    await tester.enterText(find.byType(TextField), 'tancak');
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Air Terjun Tancak'), findsWidgets);
  });

  testWidgets('map destinations stay aligned with the explore list', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: MapScreen()));

    await tester.enterText(find.byType(TextField), 'botani');
    await tester.pump();

    expect(find.text('Taman'), findsNothing);
  });

  testWidgets(
    'navigation remains available when device location is unavailable',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MapScreen()));

      await tester.ensureVisible(find.text('Mulai Navigasi Rute'));
      await tester.tap(find.text('Mulai Navigasi Rute'));
      await tester.pump();

      expect(find.text('Mulai Navigasi Rute'), findsOneWidget);
      expect(find.text('TUJUAN TERPILIH'), findsOneWidget);
    },
  );

  testWidgets('detail button opens the full destination page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: MapScreen()));

    await tester.ensureVisible(find.text('Detail'));
    await tester.tap(find.text('Detail'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Fasilitas yang Tersedia'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Fasilitas yang Tersedia'), findsOneWidget);
    expect(find.text('Pesan Tiket Sekarang'), findsOneWidget);
  });
}
