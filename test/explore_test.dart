import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jembergo_mobile_app/screens/explore_screen.dart';

void main() {
  testWidgets('ExploreScreen renders all core elements', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ExploreScreen(),
      ),
    );

    // Header greetings
    expect(find.text('Halo, '), findsOneWidget);
    expect(find.text('Budi Santoso'), findsOneWidget);
    expect(find.text('Jember, Jawa Timur'), findsOneWidget);

    // Hero title & description
    expect(find.text('Jelajahi Wisata'), findsOneWidget);
    expect(
      find.text(
        'Temukan pesona laut selatan, air terjun lereng Argopuro & bukit asri Jember.',
      ),
      findsOneWidget,
    );

    // Search input
    expect(find.text('Cari pantai, air terjun, bukit...'), findsOneWidget);

    // Category chips
    expect(find.text('Semua'), findsOneWidget);
    expect(find.text('Wisata Alam'), findsOneWidget);
    expect(find.text('Wisata Bahari'), findsOneWidget);
    expect(find.text('Wisata Buatan'), findsOneWidget);

    // Sort trigger
    expect(find.text('Terpopuler'), findsOneWidget);

    // Initial destinations rendered
    expect(find.text('Pantai Tanjung Papuma'), findsOneWidget);
    expect(find.text('Air Terjun Tancak'), findsOneWidget);
    expect(find.text('Teluk Love'), findsOneWidget);
    expect(find.text('Puncak Rembangan'), findsOneWidget);

    // Tip box
    expect(find.text('TIPS WISATAWAN'), findsOneWidget);

    // Bottom Navigation items
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Jelajahi'), findsOneWidget);
    expect(find.text('Peta'), findsOneWidget);
    expect(find.text('Tiket'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
  });

  testWidgets('filtering by category updates destination list', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ExploreScreen(),
      ),
    );

    // Tap 'Wisata Alam' chip
    await tester.tap(find.text('Wisata Alam'));
    await tester.pumpAndSettle();

    expect(find.text('Air Terjun Tancak'), findsOneWidget);
    expect(find.text('Pantai Tanjung Papuma'), findsNothing);
    expect(find.text('Teluk Love'), findsNothing);
  });

  testWidgets('searching filters destinations and empty state works', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ExploreScreen(),
      ),
    );

    // Enter search query that matches Papuma
    await tester.enterText(find.byType(TextField), 'papuma');
    await tester.pumpAndSettle();

    expect(find.text('Pantai Tanjung Papuma'), findsOneWidget);
    expect(find.text('Air Terjun Tancak'), findsNothing);

    // Enter search query that matches nothing
    await tester.enterText(find.byType(TextField), 'xyz123random');
    await tester.pumpAndSettle();

    expect(find.text('Destinasi Tidak Ditemukan'), findsOneWidget);
    expect(find.text('Reset Pencarian'), findsOneWidget);

    // Tap reset button
    await tester.tap(find.text('Reset Pencarian'));
    await tester.pumpAndSettle();

    expect(find.text('Pantai Tanjung Papuma'), findsOneWidget);
  });
}
