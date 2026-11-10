import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:jembergo_mobile_app/models/app_data.dart';
import 'package:jembergo_mobile_app/screens/destination_detail_screen.dart';
import 'package:jembergo_mobile_app/screens/profile_screen.dart';
import 'package:jembergo_mobile_app/screens/tickets_screen.dart';

void _usePhoneViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
}

Finder _verticalScrollable() {
  return find.byWidgetPredicate(
    (widget) =>
        widget is Scrollable && widget.axisDirection == AxisDirection.down,
  );
}

void main() {
  setUp(() {
    AppData.profile.value = const UserProfile(
      name: 'Budi Santoso',
      email: 'budi.santoso@email.com',
      phone: '+62 812-3456-7890',
    );
    AppData.tickets.value = [
      TicketOrder(
        bookingCode: 'JGO-20261028-8921',
        destination: DestinationInfo.destinations[0],
        visitDate: DateTime(2026, 11, 12),
        people: 3,
        status: TicketStatus.active,
      ),
      TicketOrder(
        bookingCode: 'JGO-20261029-3372',
        destination: DestinationInfo.destinations[3],
        visitDate: DateTime(2026, 11, 14),
        people: 1,
        status: TicketStatus.pending,
      ),
      TicketOrder(
        bookingCode: 'JGO-20260914-1102',
        destination: DestinationInfo.destinations[1],
        visitDate: DateTime(2026, 9, 14),
        people: 2,
        status: TicketStatus.completed,
      ),
    ];
  });

  testWidgets('destination booking creates an order visible on tickets page', (
    WidgetTester tester,
  ) async {
    _usePhoneViewport(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: DestinationDetailScreen(
          destination: DestinationInfo.destinations.first,
        ),
      ),
    );

    await tester.tap(find.text('Pesan Tiket Sekarang'));
    await tester.pumpAndSettle();
    expect(find.text('Pesan Tiket Wisata'), findsOneWidget);

    await tester.tap(find.text('Lanjutkan ke Tiket'));
    await tester.pumpAndSettle();

    expect(find.text('Tiket Saya'), findsOneWidget);
    expect(
      AppData.tickets.value.first.destination.name,
      'Pantai Tanjung Papuma',
    );
    expect(AppData.tickets.value.first.status, TicketStatus.pending);
  });

  testWidgets('active ticket opens a scannable QR ticket detail', (
    WidgetTester tester,
  ) async {
    _usePhoneViewport(tester);
    await tester.pumpWidget(const MaterialApp(home: TicketsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Tiket Saya'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Buka E-Ticket & QR'),
      240,
      scrollable: _verticalScrollable(),
    );
    await tester.tap(find.text('Buka E-Ticket & QR'));
    await tester.pumpAndSettle();

    expect(find.text('E-Ticket & QR Detail'), findsOneWidget);
    expect(find.byType(QrImageView), findsOneWidget);
    expect(find.text('JGO-20261028-8921'), findsOneWidget);
  });

  testWidgets('profile form validates and saves updated account details', (
    WidgetTester tester,
  ) async {
    _usePhoneViewport(tester);
    await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byType(TextFormField).first,
      240,
      scrollable: _verticalScrollable(),
    );
    await tester.enterText(find.byType(TextFormField).at(0), 'Dewi Wisata');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'dewi@example.com',
    );
    await tester.enterText(
      find.byType(TextFormField).at(2),
      '+62 812-9988-7766',
    );
    await tester.ensureVisible(find.text('Simpan Perubahan Profil'));
    await tester.tap(find.text('Simpan Perubahan Profil'));
    await tester.pump();

    expect(AppData.profile.value.name, 'Dewi Wisata');
    expect(AppData.profile.value.email, 'dewi@example.com');
    expect(AppData.profile.value.phone, '+62 812-9988-7766');
  });
}
