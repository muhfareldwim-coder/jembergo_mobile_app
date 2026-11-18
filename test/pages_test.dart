import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:jembergo_mobile_app/models/app_data.dart';
import 'package:jembergo_mobile_app/features/destination/presentation/destination_detail_screen.dart';
import 'package:jembergo_mobile_app/features/payment/presentation/payment_screen.dart';
import 'package:jembergo_mobile_app/features/profile/presentation/profile_screen.dart';
import 'package:jembergo_mobile_app/features/ticket/presentation/tickets_screen.dart';

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
    AppData.language.value = 'ID';
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

  testWidgets('payment screen only offers QRIS', (WidgetTester tester) async {
    _usePhoneViewport(tester);
    await tester.pumpWidget(
      MaterialApp(home: PaymentScreen(order: AppData.tickets.value[1])),
    );

    expect(find.text('QRIS'), findsWidgets);
    expect(find.text('Virtual Account'), findsNothing);
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
    expect(find.text('Pemesanan Tiket'), findsWidgets);

    await tester.scrollUntilVisible(
      find.text('Anggota Rombongan'),
      400,
      scrollable: _verticalScrollable().first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Anggota Rombongan'), findsOneWidget);
    expect(find.text('Siti Rahmawati'), findsOneWidget);
    expect(find.text('Dimas Pratama'), findsOneWidget);

    await tester.ensureVisible(find.text('Lanjut Bayar'));
    await tester.tap(find.text('Lanjut Bayar'));
    await tester.pumpAndSettle();

    expect(find.text('Pembayaran Tiket'), findsWidgets);
    expect(
      AppData.tickets.value.first.destination.name,
      'Pantai Tanjung Papuma',
    );
    expect(AppData.tickets.value.first.adults, 2);
    expect(AppData.tickets.value.first.children, 1);
    expect(AppData.tickets.value.first.total, 65000);
    expect(AppData.tickets.value.first.status, TicketStatus.pending);
    expect(find.textContaining('Tiket Anak'), findsOneWidget);
  });

  testWidgets('active ticket opens a scannable QR ticket detail', (
    WidgetTester tester,
  ) async {
    _usePhoneViewport(tester);
    await tester.pumpWidget(const MaterialApp(home: TicketsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Tiket Saya'), findsOneWidget);
    expect(find.text('Buka E-Ticket & QR'), findsOneWidget);
    await tester.tap(find.text('Buka E-Ticket & QR'));
    await tester.pumpAndSettle();

    expect(find.text('E-Ticket & QR Detail'), findsOneWidget);
    expect(find.byType(QrImageView), findsOneWidget);
    expect(find.text('JGO-20261028-8921'), findsOneWidget);
  });

  testWidgets('ticket header hides logo and keeps status in top-right corner', (
    WidgetTester tester,
  ) async {
    _usePhoneViewport(tester);
    await tester.pumpWidget(const MaterialApp(home: TicketsScreen()));
    await tester.pumpAndSettle();

    expect(
      find.image(const AssetImage('assets/logo jembergonobackgroud.png')),
      findsNothing,
    );

    final bookingCode = tester.getTopLeft(find.text('JGO-20261028-8921'));
    final status = tester.getRect(find.text('Lunas • Siap Dipakai'));
    final price = tester.getRect(find.text('Rp 75.000'));
    expect(status.left, greaterThan(bookingCode.dx));
    expect(status.top, lessThan(bookingCode.dy));
    expect(status.right, greaterThan(tester.view.physicalSize.width - 50));
    expect(price.right, greaterThan(tester.view.physicalSize.width - 50));
  });

  testWidgets('profile form validates and saves updated account details', (
    WidgetTester tester,
  ) async {
    _usePhoneViewport(tester);
    await tester.pumpWidget(
      const MaterialApp(home: ProfileScreen(isGuest: false)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Profil Saya'), findsOneWidget);
    expect(find.text('Edit Informasi Pribadi'), findsOneWidget);
    await tester.tap(find.text('Edit Informasi Pribadi'));
    await tester.pumpAndSettle();

    expect(find.text('Edit & Detail Profil'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(0), 'Dewi Wisata');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'dewi@example.com',
    );
    await tester.enterText(
      find.byType(TextFormField).at(2),
      '+62 812-9988-7766',
    );
    final saveButton = find.text('Simpan Perubahan Profil');
    await tester.scrollUntilVisible(
      saveButton,
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(AppData.profile.value.name, 'Dewi Wisata');
    expect(AppData.profile.value.email, 'dewi@example.com');
    expect(AppData.profile.value.phone, '+62 812-9988-7766');
  });

  testWidgets('guest profile offers account entry points and no account form', (
    WidgetTester tester,
  ) async {
    _usePhoneViewport(tester);
    await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Pengunjung Tamu'), findsOneWidget);
    expect(find.text('Keuntungan Memiliki Akun'), findsOneWidget);
    expect(find.text('Belum Ada Favorit Tersimpan'), findsOneWidget);
    expect(find.text('Masuk Akun'), findsOneWidget);
    expect(find.text('Daftar Baru'), findsOneWidget);
    expect(find.text('Edit Informasi Pribadi'), findsNothing);
    expect(find.text('Logout / Keluar dari Akun'), findsNothing);

    await tester.tap(find.text('Masuk Akun'));
    await tester.pumpAndSettle();
    expect(find.text('Masuk ke Akun'), findsOneWidget);

    await tester.tap(find.byTooltip('Kembali'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Daftar Baru'));
    await tester.pumpAndSettle();
    expect(find.text('Buat Akun Baru'), findsOneWidget);
  });

  testWidgets('guest settings open language, help, legal, and about pages', (
    WidgetTester tester,
  ) async {
    _usePhoneViewport(tester);
    await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Pilihan Bahasa'),
      300,
      scrollable: _verticalScrollable().first,
    );
    await tester.ensureVisible(find.text('Pilihan Bahasa'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pilihan Bahasa'));
    await tester.pumpAndSettle();
    expect(find.text('Pilih Bahasa / Choose language'), findsOneWidget);
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    expect(AppData.language.value, 'EN');

    await tester.ensureVisible(find.text('Bantuan & Pusat Informasi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bantuan & Pusat Informasi'));
    await tester.pumpAndSettle();
    expect(find.text('Pertanyaan yang sering diajukan'), findsOneWidget);
    expect(find.text('Hubungi 112'), findsOneWidget);
    await tester.tap(find.text('Bagaimana cara memesan tiket?'));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Buka detail destinasi, pilih Pesan Tiket'),
      findsOneWidget,
    );

    await tester.tap(find.byTooltip('Kembali'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Syarat & Ketentuan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Syarat & Ketentuan'));
    await tester.pumpAndSettle();
    expect(find.text('Ketentuan penggunaan layanan'), findsOneWidget);

    await tester.tap(find.byTooltip('Kembali'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Kebijakan Privasi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kebijakan Privasi'));
    await tester.pumpAndSettle();
    expect(find.text('Informasi pengelolaan data'), findsOneWidget);

    await tester.tap(find.byTooltip('Kembali'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Tentang JemberGo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tentang JemberGo'));
    await tester.pumpAndSettle();
    expect(find.text('Versi 1.2.0'), findsOneWidget);
  });
}
