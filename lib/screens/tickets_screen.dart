import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../models/app_data.dart';
import '../widgets/app_bottom_navigation.dart';
import 'explore_screen.dart';
import 'home_screen.dart';
import 'map_screen.dart';
import 'payment_screen.dart';
import 'profile_screen.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({this.focusBookingCode, super.key});

  final String? focusBookingCode;

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

Widget _bookingNotice() {
  return Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: const Color(0xFFE0F2FE),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFBAE6FD)),
    ),
    child: const Row(
      children: [
        Icon(
          Icons.check_circle_outline_rounded,
          color: Color(0xFF006194),
          size: 20,
        ),
        SizedBox(width: 9),
        Expanded(
          child: Text(
            'Pesanan dibuat. Selesaikan pembayaran untuk mengaktifkan e-ticket.',
            style: TextStyle(
              color: Color(0xFF0C4A6E),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

class _TicketsScreenState extends State<TicketsScreen> {
  static const _navy = Color(0xFF0C192C);
  static const _blue = Color(0xFF006194);
  static const _muted = Color(0xFF64748B);
  String _selectedFilter = 'Semua';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: ValueListenableBuilder<List<TicketOrder>>(
                    valueListenable: AppData.tickets,
                    builder: (context, tickets, _) {
                      final visible = tickets.where(_matchesFilter).toList();
                      return ListView(
                        padding: const EdgeInsets.fromLTRB(18, 12, 18, 116),
                        children: [
                          _buildIntro(tickets),
                          const SizedBox(height: 17),
                          _buildFilters(tickets),
                          const SizedBox(height: 16),
                          if (widget.focusBookingCode != null) ...[
                            _bookingNotice(),
                            const SizedBox(height: 13),
                          ],
                          if (visible.isEmpty)
                            _buildEmptyState()
                          else
                            for (final ticket in visible) ...[
                              _buildTicketCard(ticket),
                              const SizedBox(height: 14),
                            ],
                          if (tickets.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                'Menampilkan ${visible.length} dari ${tickets.length} pesanan',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 11,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return AppBottomNavigationDock(
      selectedIndex: 3,
      onSelected: _navigateToTab,
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/onboarding/jembergo_logo.png',
            width: 42,
            height: 36,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 8),
          const SizedBox(
            height: 28,
            child: VerticalDivider(width: 1, color: Color(0xFFE2E8F0)),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Tiket Saya',
              style: TextStyle(
                color: _navy,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          _headerButton(
            icon: Icons.notifications_none_rounded,
            label: 'Pemberitahuan',
            onTap: () => _showMessage('Tidak ada pemberitahuan baru.'),
          ),
          const SizedBox(width: 7),
          _headerButton(
            icon: Icons.person_outline_rounded,
            label: 'Profil Akun',
            onTap: () => _navigateToTab(4),
          ),
        ],
      ),
    );
  }

  Widget _headerButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return IconButton(
      tooltip: label,
      onPressed: onTap,
      style: IconButton.styleFrom(
        backgroundColor: const Color(0xFFF8FAFC),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
        fixedSize: const Size(38, 38),
      ),
      icon: Icon(icon, size: 19, color: const Color(0xFF475569)),
    );
  }

  Widget _buildIntro(List<TicketOrder> tickets) {
    final activeCount = tickets
        .where((ticket) => ticket.status == TicketStatus.active)
        .length;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'DOMPET WISATA',
                style: TextStyle(
                  color: _blue,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.9,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Pesanan & Tiket',
                style: TextStyle(
                  color: _navy,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        _roundAction(
          icon: Icons.receipt_long_rounded,
          label: 'Riwayat pesanan',
          onTap: () {
            setState(() => _selectedFilter = 'Selesai');
          },
        ),
        const SizedBox(width: 7),
        _roundAction(
          icon: Icons.help_outline_rounded,
          label: 'Bantuan pemesanan',
          onTap: () => _showMessage('Hubungi Jember Tourism Center di 112.'),
        ),
        const SizedBox(width: 7),
        if (activeCount > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$activeCount aktif',
              style: const TextStyle(
                color: Color(0xFF047857),
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }

  Widget _roundAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: const Color(0xFFEAF0FF),
      shape: const CircleBorder(),
      child: IconButton(
        tooltip: label,
        onPressed: onTap,
        icon: Icon(icon, size: 18, color: const Color(0xFF475569)),
      ),
    );
  }

  Widget _buildFilters(List<TicketOrder> tickets) {
    final activeCount = tickets
        .where((ticket) => ticket.status != TicketStatus.completed)
        .length;
    final completedCount = tickets
        .where((ticket) => ticket.status == TicketStatus.completed)
        .length;
    final filters = [
      ('Semua Tiket', 'Semua', tickets.length),
      ('Tiket Aktif', 'Aktif', activeCount),
      ('Selesai', 'Selesai', completedCount),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var index = 0; index < filters.length; index++) ...[
            if (index > 0) const SizedBox(width: 8),
            ChoiceChip(
              label: Text(
                filters[index].$1 +
                    (filters[index].$2 == 'Selesai'
                        ? ' (${filters[index].$3})'
                        : ''),
              ),
              selected: _selectedFilter == filters[index].$2,
              onSelected: (_) =>
                  setState(() => _selectedFilter = filters[index].$2),
              showCheckmark: false,
              backgroundColor: Colors.white,
              selectedColor: _navy,
              side: BorderSide(
                color: _selectedFilter == filters[index].$2
                    ? _navy
                    : const Color(0xFFE2E8F0),
              ),
              labelStyle: TextStyle(
                color: _selectedFilter == filters[index].$2
                    ? Colors.white
                    : const Color(0xFF475569),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            ),
          ],
        ],
      ),
    );
  }

  bool _matchesFilter(TicketOrder ticket) {
    return switch (_selectedFilter) {
      'Aktif' => ticket.status != TicketStatus.completed,
      'Selesai' => ticket.status == TicketStatus.completed,
      _ => true,
    };
  }

  Widget _buildTicketCard(TicketOrder ticket) {
    final isPending = ticket.status == TicketStatus.pending;
    final isCompleted = ticket.status == TicketStatus.completed;
    final accent = isPending
        ? const Color(0xFFE11D48)
        : isCompleted
        ? const Color(0xFF94A3B8)
        : _navy;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x100F172A),
            blurRadius: 18,
            offset: Offset(0, 7),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(width: 5, color: accent),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 16, 14, 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ticketHeader(ticket, isPending, isCompleted),
                    const SizedBox(height: 14),
                    _ticketSummary(ticket),
                    const SizedBox(height: 14),
                    const Divider(
                      height: 1,
                      color: Color(0xFFE2E8F0),
                      thickness: 1,
                    ),
                    const SizedBox(height: 13),
                    if (ticket.status == TicketStatus.active) ...[
                      _gateNote(),
                      const SizedBox(height: 10),
                      FilledButton.icon(
                        onPressed: () => _openQr(ticket),
                        icon: const Icon(Icons.qr_code_2_rounded, size: 19),
                        label: const Text('Buka E-Ticket & QR'),
                        style: FilledButton.styleFrom(
                          backgroundColor: _navy,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(48),
                          shape: const StadiumBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: () => _openMap(ticket.destination),
                        icon: const Icon(Icons.navigation_rounded, size: 18),
                        label: const Text('Kelola Perjalanan / Navigasi Rute'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _navy,
                          backgroundColor: const Color(0xFFF1F5F9),
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                          minimumSize: const Size.fromHeight(44),
                          shape: const StadiumBorder(),
                        ),
                      ),
                    ] else if (isPending)
                      _pendingActions(ticket)
                    else
                      _completedActions(ticket),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ticketHeader(TicketOrder ticket, bool isPending, bool isCompleted) {
    final label = isPending
        ? 'MENUNGGU PEMBAYARAN'
        : isCompleted
        ? 'KODE TIKET'
        : 'KODE BOOKING';
    final status = isPending
        ? 'Menunggu Pembayaran'
        : isCompleted
        ? 'Telah Digunakan'
        : 'Lunas • Siap Dipakai';
    final statusColor = isPending
        ? const Color(0xFF9F1239)
        : isCompleted
        ? const Color(0xFF475569)
        : const Color(0xFF047857);
    final statusBg = isPending
        ? const Color(0xFFFFE4E6)
        : isCompleted
        ? const Color(0xFFF1F5F9)
        : const Color(0xFFDCFCE7);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.7,
                ),
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      ticket.bookingCode,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _navy,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Salin kode booking',
                    onPressed: () => _copyBookingCode(ticket.bookingCode),
                    icon: const Icon(
                      Icons.copy_rounded,
                      size: 15,
                      color: _blue,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
            decoration: BoxDecoration(
              color: statusBg,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              status,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: statusColor,
                fontSize: 9,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _ticketSummary(TicketOrder ticket) {
    final destination = ticket.destination;
    final date = _formatDate(ticket.visitDate);
    final isPending = ticket.status == TicketStatus.pending;
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(
            destination.image,
            width: 86,
            height: 92,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                destination.category.toUpperCase(),
                style: const TextStyle(
                  color: _blue,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                destination.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _navy,
                  fontSize: 14,
                  height: 1.15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_month_rounded,
                    color: _blue,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '$date • ${ticket.people} orang',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isPending ? 'Total tagihan' : 'Total',
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    'Rp ${_formatPrice(ticket.total)}',
                    style: TextStyle(
                      color: isPending ? const Color(0xFFE11D48) : _navy,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _gateNote() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF0FF),
        borderRadius: BorderRadius.circular(13),
      ),
      child: const Row(
        children: [
          Icon(Icons.qr_code_2_rounded, color: Color(0xFF059669), size: 18),
          SizedBox(width: 7),
          Expanded(
            child: Text(
              'Tunjukkan QR di loket pintu gerbang',
              style: TextStyle(
                color: Color(0xFF1E293B),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            'Gate 1',
            style: TextStyle(
              color: _blue,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _pendingActions(TicketOrder ticket) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                size: 16,
                color: _blue,
              ),
              SizedBox(width: 7),
              Expanded(
                child: Text(
                  'Metode: QRIS',
                  style: TextStyle(color: Color(0xFF475569), fontSize: 10),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 9),
        FilledButton.icon(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => PaymentScreen(order: ticket),
              ),
            );
          },
          icon: const Icon(Icons.payments_outlined, size: 18),
          label: const Text('Lanjutkan Pembayaran'),
          style: FilledButton.styleFrom(
            backgroundColor: _navy,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(47),
            shape: const StadiumBorder(),
          ),
        ),
      ],
    );
  }

  Widget _completedActions(TicketOrder ticket) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: const Color(0xFFDCFCE7).withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFF86EFAC).withValues(alpha: 0.6),
            ),
          ),
          child: const Row(
            children: [
              Icon(Icons.verified_rounded, color: Color(0xFF059669), size: 15),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Ulasan aktif: Tiket telah berhasil digunakan',
                  style: TextStyle(
                    color: Color(0xFF047857),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: () => _showReviewDialog(ticket),
                icon: const Icon(
                  Icons.star_rounded,
                  color: Color(0xFFFBBF24),
                  size: 18,
                ),
                label: const Text('Beri Ulasan'),
                style: FilledButton.styleFrom(
                  backgroundColor: _navy,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(44),
                  shape: const StadiumBorder(),
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _showMessage(
                  'E-voucher PDF berhasil diunduh ke perangkat.',
                ),
                icon: const Icon(Icons.download_rounded, size: 18),
                label: const Text('Unduh PDF'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF1E293B),
                  backgroundColor: const Color(0xFFF1F5F9),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                  minimumSize: const Size.fromHeight(44),
                  shape: const StadiumBorder(),
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showReviewDialog(TicketOrder ticket) {
    int rating = 5;
    final reviewController = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          final labels = [
            '1.0 - Sangat Kurang',
            '2.0 - Kurang Puas',
            '3.0 - Cukup Baik',
            '4.0 - Sangat Baik!',
            '5.0 - Sangat Memuaskan!',
          ];

          return Container(
            padding: EdgeInsets.fromLTRB(
              20,
              16,
              20,
              24 + MediaQuery.viewInsetsOf(ctx).bottom,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(
                                Icons.verified_rounded,
                                color: Color(0xFF059669),
                                size: 14,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'TIKET TERVERIFIKASI',
                                style: TextStyle(
                                  color: Color(0xFF059669),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Beri Ulasan Destinasi',
                            style: TextStyle(
                              color: _navy,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFFF1F5F9),
                        ),
                        icon: const Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: _navy,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            ticket.destination.image,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ticket.destination.name,
                                style: const TextStyle(
                                  color: _navy,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Kunjungan: ${_formatDate(ticket.visitDate)}',
                                style: const TextStyle(
                                  color: _muted,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          'Bagaimana pengalaman wisatamu?',
                          style: TextStyle(color: _muted, fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            final star = index + 1;
                            return IconButton(
                              onPressed: () =>
                                  setModalState(() => rating = star),
                              icon: Icon(
                                star <= rating
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                                color: const Color(0xFFF59E0B),
                                size: 36,
                              ),
                            );
                          }),
                        ),
                        Text(
                          labels[rating - 1],
                          style: const TextStyle(
                            color: Color(0xFFD97706),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Tulis Ulasan & Pengalaman',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: reviewController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Bagikan tips jalur trekking, kebersihan, atau suasana pemandangan...',
                      hintStyle: const TextStyle(
                        color: Color(0xFFCBD5E1),
                        fontSize: 12,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                    style: const TextStyle(fontSize: 13, color: _navy),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => _showMessage(
                          'Fitur unggah foto lokal siap digunakan.',
                        ),
                        icon: const Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 18,
                        ),
                        label: const Text('+ Foto Liburan'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _navy,
                          side: const BorderSide(color: Color(0xFFCBD5E1)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Membantu wisatawan lain melihat kondisi terkini.',
                          style: TextStyle(color: _muted, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _showMessage(
                        'Ulasan bintang $rating berhasil dikirim! Terima kasih atas partisipasimu.',
                      );
                    },
                    icon: const Icon(Icons.send_rounded, size: 18),
                    label: const Text('Kirim Ulasan'),
                    style: FilledButton.styleFrom(
                      backgroundColor: _navy,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                      shape: const StadiumBorder(),
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: const Column(
        children: [
          Icon(Icons.confirmation_number_outlined, size: 44, color: _blue),
          SizedBox(height: 12),
          Text(
            'Belum ada tiket di kategori ini',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Jelajahi wisata Jember dan pesan tiket pertamamu.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF64748B), fontSize: 11),
          ),
        ],
      ),
    );
  }

  void _openQr(TicketOrder ticket) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => TicketQrScreen(ticket: ticket)),
    );
  }

  void _openMap(DestinationInfo destination) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MapScreen(
          userName: AppData.profile.value.name,
          initialDestinationId: destination.id,
        ),
      ),
    );
  }

  void _copyBookingCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    _showMessage('Kode booking disalin.');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _navigateToTab(int index) {
    if (index == 3) return;
    final userName = AppData.profile.value.name;
    final Widget page = switch (index) {
      0 => HomeScreen(userName: userName),
      1 => ExploreScreen(userName: userName),
      2 => MapScreen(userName: userName),
      _ => ProfileScreen(),
    };
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (context, _, _) => page,
        transitionDuration: const Duration(milliseconds: 220),
        transitionsBuilder: (context, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  static String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  static String _formatPrice(int value) {
    final digits = value.toString();
    final parts = <String>[];
    for (var end = digits.length; end > 0; end -= 3) {
      final start = end - 3 < 0 ? 0 : end - 3;
      parts.insert(0, digits.substring(start, end));
    }
    return parts.join('.');
  }
}

class TicketQrScreen extends StatelessWidget {
  const TicketQrScreen({required this.ticket, super.key});

  final TicketOrder ticket;

  static const _navy = Color(0xFF0C192C);

  @override
  Widget build(BuildContext context) {
    final destination = ticket.destination;
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          'E-Ticket & QR Detail',
          style: TextStyle(
            color: _navy,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 30),
        children: [
          Container(
            height: 112,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              image: DecorationImage(
                image: AssetImage(destination.image),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xBB0C192C)],
                ),
              ),
              child: const Text(
                'JEMBER TOURISM • E-TICKET',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'KABUPATEN JEMBER OFFICIAL PASS',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.7,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            destination.name,
                            style: const TextStyle(
                              color: _navy,
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            destination.area,
                            style: const TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _statusBadge(),
                  ],
                ),
                const SizedBox(height: 16),
                _infoPanel(context),
                const SizedBox(height: 18),
                const Text(
                  'PINDAI KODE DI PINTU MASUK',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: QrImageView(
                    data: ticket.bookingCode,
                    version: QrVersions.auto,
                    size: 190,
                    backgroundColor: Colors.white,
                    eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: _navy,
                    ),
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: _navy,
                    ),
                  ),
                ),
                const SizedBox(height: 11),
                SelectableText(
                  ticket.bookingCode,
                  style: const TextStyle(
                    color: _navy,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tunjukkan QR ini kepada petugas loket sebelum memasuki area wisata.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 11,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 15),
                _infoPanel(context, showGroup: true),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, color: _blue, size: 19),
                SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'Pastikan layar cukup terang saat QR dipindai. QR hanya dapat digunakan sesuai tanggal kunjungan.',
                    style: TextStyle(
                      color: Color(0xFF475569),
                      fontSize: 11,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Text(
        'TIKET AKTIF',
        style: TextStyle(
          color: Color(0xFF047857),
          fontSize: 9,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _infoPanel(BuildContext context, {bool showGroup = false}) {
    final profile = AppData.profile.value;
    final visitDate = ticket.visitDate;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _metric(
                  'Tanggal Kunjungan',
                  '${visitDate.day}/${visitDate.month}/${visitDate.year}',
                  Icons.calendar_today_rounded,
                ),
              ),
              Expanded(
                child: _metric(
                  'Pintu Masuk / Gate',
                  'Loket Utama',
                  Icons.door_front_door_outlined,
                ),
              ),
            ],
          ),
          if (showGroup) ...[
            const Divider(height: 22),
            Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(0xFFE2E8F0),
                  child: Icon(Icons.person_rounded, size: 17, color: _navy),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ketua rombongan / pemesan',
                        style: TextStyle(color: Color(0xFF64748B), fontSize: 9),
                      ),
                      Text(
                        profile.name,
                        style: const TextStyle(
                          color: _navy,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${ticket.people} wisatawan',
                  style: const TextStyle(
                    color: Color(0xFF475569),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const Divider(height: 22),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Pembayaran • Lunas',
                    style: TextStyle(
                      color: Color(0xFF047857),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  'Rp ${_formatPrice(ticket.total)}',
                  style: const TextStyle(
                    color: _navy,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _metric(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: _blue, size: 14),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 9),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: _navy,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  static const _blue = Color(0xFF006194);

  static String _formatPrice(int value) {
    final digits = value.toString();
    final parts = <String>[];
    for (var end = digits.length; end > 0; end -= 3) {
      final start = end - 3 < 0 ? 0 : end - 3;
      parts.insert(0, digits.substring(start, end));
    }
    return parts.join('.');
  }
}
