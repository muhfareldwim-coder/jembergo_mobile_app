import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../models/app_data.dart';
import 'tickets_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({required this.order, super.key});

  final TicketOrder order;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  static const _navy = Color(0xFF0C192C);
  static const _blue = Color(0xFF006194);
  static const _muted = Color(0xFF64748B);

  static const _totalSeconds = 15 * 60; // 15 minutes
  int _secondsLeft = _totalSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _timeLabel {
    final m = _secondsLeft ~/ 60;
    final s = _secondsLeft % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String _formatPrice(int value) {
    final digits = value.toString();
    final parts = <String>[];
    for (var end = digits.length; end > 0; end -= 3) {
      final start = end - 3 < 0 ? 0 : end - 3;
      parts.insert(0, digits.substring(start, end));
    }
    return parts.join('.');
  }

  String _formatDate(DateTime date) {
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

  void _copyText(String text) {
    Clipboard.setData(ClipboardData(text: text));
    _showMessage('Disalin ke clipboard.');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _confirmPayment() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Konfirmasi Pembayaran',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: Text(
          'Pastikan kamu sudah membayar melalui QRIS sebesar '
          'Rp ${_formatPrice(widget.order.total)} sebelum mengkonfirmasi.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Belum'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: _navy),
            child: const Text('Sudah Bayar'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      AppData.updateTicketStatus(widget.order.bookingCode, TicketStatus.active);
      _timer?.cancel();
      // Pop booking + payment screens and push TicketsScreen
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(
          builder: (_) =>
              TicketsScreen(focusBookingCode: widget.order.bookingCode),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildAppBar(),
          _buildStepper(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 120),
              children: [
                _buildCountdownBanner(),
                const SizedBox(height: 16),
                _buildBookingSummaryCard(),
                const SizedBox(height: 16),
                _buildBillSummary(),
                const SizedBox(height: 16),
                _buildPaymentMethodSection(),
                const SizedBox(height: 16),
                _buildInstructionNote(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // ── App Bar ───────────────────────────────────────────────────────────────

  Widget _buildAppBar() {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFFF1F5F9),
              ),
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: _navy,
                size: 22,
              ),
            ),
            const SizedBox(width: 6),
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Pembayaran Tiket',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Selesaikan pembayaran sebelum batas waktu',
                    style: TextStyle(color: _muted, fontSize: 9),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _secondsLeft < 60
                    ? const Color(0xFFFEF2F2)
                    : const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.timer_outlined,
                    size: 14,
                    color: _secondsLeft < 60 ? const Color(0xFFDC2626) : _blue,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _timeLabel,
                    style: TextStyle(
                      color: _secondsLeft < 60
                          ? const Color(0xFFDC2626)
                          : _blue,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Stepper ───────────────────────────────────────────────────────────────

  Widget _buildStepper() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          _stepItem(1, 'Data Pemesanan', state: _StepState.done),
          _stepConnector(active: true),
          _stepItem(2, 'Pembayaran', state: _StepState.active),
          _stepConnector(active: false),
          _stepItem(3, 'E-Tiket', state: _StepState.pending),
        ],
      ),
    );
  }

  Widget _stepItem(int number, String label, {required _StepState state}) {
    final isDone = state == _StepState.done;
    final isActive = state == _StepState.active;
    Color bg = isActive
        ? _navy
        : isDone
        ? const Color(0xFF059669)
        : const Color(0xFFE2E8F0);
    Color textColor = (isActive || isDone)
        ? Colors.white
        : const Color(0xFF94A3B8);

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: isDone
                ? const Icon(Icons.check_rounded, size: 15, color: Colors.white)
                : Text(
                    '$number',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? _navy : const Color(0xFF94A3B8),
              fontSize: 9,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepConnector({required bool active}) {
    return Container(
      width: 32,
      height: 2,
      color: active ? _navy : const Color(0xFFE2E8F0),
      margin: const EdgeInsets.only(bottom: 16),
    );
  }

  // ── Countdown Banner ──────────────────────────────────────────────────────

  Widget _buildCountdownBanner() {
    final isUrgent = _secondsLeft < 120;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isUrgent ? const Color(0xFFFFF1F2) : const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUrgent ? const Color(0xFFFECACA) : const Color(0xFFBFDBFE),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.hourglass_top_rounded,
            color: isUrgent ? const Color(0xFFDC2626) : _blue,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isUrgent
                      ? 'Segera selesaikan pembayaran!'
                      : 'Selesaikan pembayaran dalam',
                  style: TextStyle(
                    color: isUrgent
                        ? const Color(0xFF9F1239)
                        : const Color(0xFF1E40AF),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Pesanan kadaluarsa jika melewati batas waktu.',
                  style: TextStyle(
                    color: isUrgent
                        ? const Color(0xFFBE123C)
                        : const Color(0xFF3B82F6),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            _timeLabel,
            style: TextStyle(
              color: isUrgent ? const Color(0xFFDC2626) : _navy,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  // ── Booking Summary Card ──────────────────────────────────────────────────

  Widget _buildBookingSummaryCard() {
    final order = widget.order;
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'KODE BOOKING',
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                      ),
                    ),
                    SizedBox(height: 2),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFFED7AA)),
                ),
                child: const Text(
                  'Menunggu Pembayaran',
                  style: TextStyle(
                    color: Color(0xFFC2410C),
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                child: Text(
                  order.bookingCode,
                  style: const TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _copyText(order.bookingCode),
                tooltip: 'Salin kode booking',
                icon: const Icon(Icons.copy_rounded, size: 16, color: _blue),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const Divider(color: Color(0xFFE2E8F0), height: 20),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  order.destination.image,
                  width: 68,
                  height: 68,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.destination.category.toUpperCase(),
                      style: const TextStyle(
                        color: _blue,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      order.destination.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _navy,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _infoChip(
                      icon: Icons.calendar_month_rounded,
                      label: _formatDate(order.visitDate),
                    ),
                    const SizedBox(height: 4),
                    _infoChip(
                      icon: Icons.people_outline_rounded,
                      label: '${order.people} orang',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoChip({required IconData icon, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: _blue),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: _muted, fontSize: 10)),
      ],
    );
  }

  // ── Bill Summary ──────────────────────────────────────────────────────────

  Widget _buildBillSummary() {
    final order = widget.order;
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: _blue,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Rincian Tagihan',
                style: TextStyle(
                  color: _navy,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (order.childCount != null) ...[
            _billRow(
              label:
                  '${order.adults}× Tiket Dewasa '
                  '(@Rp ${_formatPrice(order.destination.price)})',
              amount:
                  'Rp ${_formatPrice(order.destination.price * order.adults)}',
            ),
            if (order.children > 0) ...[
              const SizedBox(height: 8),
              _billRow(
                label:
                    '${order.children}× Tiket Anak '
                    '(@Rp ${_formatPrice(order.destination.price * 3 ~/ 5)})',
                amount:
                    'Rp ${_formatPrice(order.destination.price * 3 ~/ 5 * order.children)}',
              ),
            ],
          ] else
            _billRow(
              label:
                  '${order.people} Tiket × Rp ${_formatPrice(order.destination.price)}',
              amount: 'Rp ${_formatPrice(order.total)}',
            ),
          const SizedBox(height: 8),
          _billRow(
            label: 'Biaya layanan',
            amount: 'Gratis',
            amountColor: const Color(0xFF059669),
          ),
          const SizedBox(height: 10),
          const Divider(color: Color(0xFFE2E8F0)),
          const SizedBox(height: 10),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Total Pembayaran',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                'Rp ${_formatPrice(order.total)}',
                style: const TextStyle(
                  color: _navy,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _billRow({
    required String label,
    required String amount,
    Color? amountColor,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: _muted, fontSize: 11),
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            color: amountColor ?? _navy,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // ── Payment Method ────────────────────────────────────────────────────────

  Widget _buildPaymentMethodSection() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Color(0xFF059669),
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Metode Pembayaran',
                      style: TextStyle(
                        color: _navy,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 1),
                    Text(
                      'Bayar dengan scan QRIS',
                      style: TextStyle(color: _muted, fontSize: 9),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const SizedBox(height: 16),
          _buildQrisSection(),
        ],
      ),
    );
  }

  Widget _buildQrisSection() {
    return Column(
      children: [
        const Text(
          'Scan QR menggunakan aplikasi dompet digital atau m-banking',
          textAlign: TextAlign.center,
          style: TextStyle(color: _muted, fontSize: 11),
        ),
        const SizedBox(height: 16),
        Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A0C192C),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      color: const Color(0xFFE11D48),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'QRIS',
                      style: TextStyle(
                        color: _navy,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                QrImageView(
                  data: widget.order.bookingCode,
                  version: QrVersions.auto,
                  size: 200,
                  backgroundColor: Colors.white,
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: Color(0xFF0C192C),
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: Color(0xFF0C192C),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.order.bookingCode,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Cara Pembayaran QRIS:',
                style: TextStyle(
                  color: _navy,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 6),
              _Step(number: '1', text: 'Buka aplikasi e-wallet atau m-banking'),
              _Step(number: '2', text: 'Pilih menu Scan QR / QRIS'),
              _Step(number: '3', text: 'Scan kode QR di atas'),
              _Step(
                number: '4',
                text: 'Masukkan nominal & konfirmasi pembayaran',
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Instruction Note ──────────────────────────────────────────────────────

  Widget _buildInstructionNote() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: Color(0xFF059669), size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Setelah pembayaran berhasil, klik "Konfirmasi Pembayaran Telah Dibuat" '
              'di bawah untuk mengaktifkan e-ticket kamu.',
              style: TextStyle(
                color: Color(0xFF047857),
                fontSize: 10,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom Bar ────────────────────────────────────────────────────────────

  Widget _buildBottomBar() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.97),
          border: const Border(top: BorderSide(color: Color(0xFFE2E8F0))),
          boxShadow: const [
            BoxShadow(
              color: Color(0x120C192C),
              blurRadius: 16,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text(
                  'Total Tagihan:',
                  style: TextStyle(color: _muted, fontSize: 11),
                ),
                const SizedBox(width: 8),
                Text(
                  'Rp ${_formatPrice(widget.order.total)}',
                  style: const TextStyle(
                    color: _navy,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: _confirmPayment,
                icon: const Icon(Icons.check_circle_rounded, size: 18),
                label: const Text('Konfirmasi Pembayaran Telah Dibuat'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF059669),
                  foregroundColor: Colors.white,
                  shape: const StadiumBorder(),
                  textStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helper ────────────────────────────────────────────────────────────────

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8EDF3)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x070C192C),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

enum _StepState { done, active, pending }

class _Step extends StatelessWidget {
  const _Step({required this.number, required this.text});

  final String number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: const Color(0xFF006194),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Color(0xFF475569), fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}
