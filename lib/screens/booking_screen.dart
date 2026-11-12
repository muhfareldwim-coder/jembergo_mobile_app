import 'package:flutter/material.dart';

import '../models/app_data.dart';
import 'payment_screen.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({required this.destination, super.key});

  final DestinationInfo destination;

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  static const _navy = Color(0xFF0C192C);
  static const _blue = Color(0xFF006194);
  static const _muted = Color(0xFF64748B);

  late DateTime _selectedDate;
  late DateTime _calendarMonth; // first day of displayed month
  final List<_BookingMember> _members = [];

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _selectedDate = DateTime(today.year, today.month, today.day + 1);
    _calendarMonth = DateTime(today.year, today.month);
    final profile = AppData.profile.value;
    _nameController.text = profile.name;
    _emailController.text = profile.email;
    _phoneController.text = profile.phone;
    _members
      ..add(_BookingMember(name: 'Siti Rahmawati'))
      ..add(_BookingMember(name: 'Dimas Pratama', isChild: true));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    for (final member in _members) {
      member.dispose();
    }
    super.dispose();
  }

  int get _adultCount => 1 + _members.where((member) => !member.isChild).length;
  int get _childCount => _members.where((member) => member.isChild).length;
  int get _totalPeople => 1 + _members.length;
  int get _childTicketPrice => widget.destination.price * 3 ~/ 5;

  int get _total =>
      (widget.destination.price * _adultCount) +
      (_childTicketPrice * _childCount);

  String _formatPrice(int value) {
    final digits = value.toString();
    final parts = <String>[];
    for (var end = digits.length; end > 0; end -= 3) {
      final start = end - 3 < 0 ? 0 : end - 3;
      parts.insert(0, digits.substring(start, end));
    }
    return parts.join('.');
  }

  String _weekdayName(int weekday) {
    const weekdays = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    return weekdays[weekday - 1];
  }

  String _shortMonth(int month) {
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
    return months[month - 1];
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _proceed() {
    if (_nameController.text.trim().isEmpty) {
      _showMessage('Nama lengkap tidak boleh kosong.');
      return;
    }
    if (_emailController.text.trim().isEmpty) {
      _showMessage('Email tidak boleh kosong.');
      return;
    }
    if (!_emailController.text.trim().contains('@')) {
      _showMessage('Masukkan alamat email yang valid.');
      return;
    }
    if (_phoneController.text.trim().isEmpty) {
      _showMessage('Nomor WhatsApp tidak boleh kosong.');
      return;
    }
    if (_members.any((member) => member.controller.text.trim().isEmpty)) {
      _showMessage('Nama seluruh anggota rombongan harus diisi.');
      return;
    }
    final order = AppData.createOrder(
      destination: widget.destination,
      visitDate: _selectedDate,
      people: _totalPeople,
      adultCount: _adultCount,
      childCount: _childCount,
    );
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => PaymentScreen(order: order)),
    );
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
                _buildDestinationCard(),
                const SizedBox(height: 20),
                _buildDatePicker(),
                const SizedBox(height: 20),
                _buildLeaderForm(),
                const SizedBox(height: 20),
                _buildGroupCounter(),
                const SizedBox(height: 20),
                _buildCompletenessChecklist(),
                const SizedBox(height: 20),
                _buildPriceSummary(),
                const SizedBox(height: 20),
                _buildSecurityNote(),
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
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFF1F5F9),
                  fixedSize: const Size(40, 40),
                ),
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: _navy,
                  size: 22,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 58),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Pemesanan Tiket',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    widget.destination.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 10,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () => _showMessage(
                  'Butuh bantuan? Hubungi Jember Tourism Center.',
                ),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFF1F5F9),
                  fixedSize: const Size(40, 40),
                ),
                icon: const Icon(
                  Icons.help_outline_rounded,
                  color: _navy,
                  size: 20,
                ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _stepItem(1, 'Data Pemesanan', active: true),
          _stepConnector(),
          _stepItem(2, 'Pembayaran', active: false),
          _stepConnector(),
          _stepItem(3, 'E-Tiket', active: false),
        ],
      ),
    );
  }

  Widget _stepItem(int number, String label, {required bool active}) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: active ? _navy : const Color(0xFFF1F5F9),
              border: active
                  ? null
                  : Border.all(color: const Color(0xFFE2E8F0)),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$number',
              style: TextStyle(
                color: active ? Colors.white : const Color(0xFF94A3B8),
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              maxLines: 2,
              style: TextStyle(
                color: active ? _navy : const Color(0xFF94A3B8),
                fontSize: 10,
                height: 1.15,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepConnector() {
    return Container(
      width: 12,
      height: 2,
      color: const Color(0xFFE2E8F0),
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }

  // ── Destination Card ──────────────────────────────────────────────────────

  Widget _buildDestinationCard() {
    return _card(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              widget.destination.image,
              width: 78,
              height: 78,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6CF8BB),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Tiket Resmi ${widget.destination.category}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF00714D),
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.destination.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      color: _blue,
                      size: 13,
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        widget.destination.area,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: _muted, fontSize: 10),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      widget.destination.priceFormatted,
                      style: const TextStyle(
                        color: _blue,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Text(
                      ' /org',
                      style: TextStyle(color: _muted, fontSize: 9),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F3FF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Tersedia 450 kuota',
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF006C49),
                              fontSize: 8,
                              height: 1.15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Date Picker (Calendar) ────────────────────────────────────────────────

  Widget _buildDatePicker() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFFCCE5FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: _blue,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tanggal Kunjungan',
                      style: TextStyle(
                        color: _navy,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 1),
                    Text(
                      'Pilih jadwal rekreasi Anda',
                      style: TextStyle(color: _muted, fontSize: 10),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E7FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Wajib',
                  style: TextStyle(
                    color: _blue,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildCalendar(),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    // Navigation row
    final monthNames = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    final firstDayOfMonth = DateTime(_calendarMonth.year, _calendarMonth.month);
    final daysInMonth = DateTime(
      _calendarMonth.year,
      _calendarMonth.month + 1,
      0,
    ).day;

    // weekday of first day: Monday=1 ... Sunday=7
    // Grid offset: how many leading empty cells
    int firstWeekday = firstDayOfMonth.weekday; // 1=Mon, 7=Sun
    final leadingBlanks = firstWeekday - 1;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          // Month navigator
          Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _calendarMonth = DateTime(
                      _calendarMonth.year,
                      _calendarMonth.month - 1,
                    );
                  });
                },
                icon: const Icon(
                  Icons.chevron_left_rounded,
                  color: Color(0xFF94A3B8),
                ),
                visualDensity: VisualDensity.compact,
                constraints: const BoxConstraints.tightFor(
                  width: 32,
                  height: 32,
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        '${monthNames[_calendarMonth.month - 1]} ${_calendarMonth.year}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _navy,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (_calendarMonth.year == today.year &&
                        _calendarMonth.month == today.month)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6CF8BB),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Bulan Ini',
                          style: TextStyle(
                            color: Color(0xFF00714D),
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _calendarMonth = DateTime(
                      _calendarMonth.year,
                      _calendarMonth.month + 1,
                    );
                  });
                },
                icon: const Icon(Icons.chevron_right_rounded, color: _navy),
                visualDensity: VisualDensity.compact,
                constraints: const BoxConstraints.tightFor(
                  width: 32,
                  height: 32,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Day-of-week headers
          Row(
            children: const ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min']
                .map((d) {
                  return Expanded(
                    child: Text(
                      d,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                })
                .toList(),
          ),
          const SizedBox(height: 6),
          // Calendar grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisExtent: 36,
            ),
            itemCount: leadingBlanks + daysInMonth,
            itemBuilder: (context, index) {
              if (index < leadingBlanks) return const SizedBox.shrink();
              final day = index - leadingBlanks + 1;
              final date = DateTime(
                _calendarMonth.year,
                _calendarMonth.month,
                day,
              );
              final isPast =
                  date.isBefore(todayDate) || date.isAtSameMomentAs(todayDate);
              final isSelected =
                  date.year == _selectedDate.year &&
                  date.month == _selectedDate.month &&
                  date.day == _selectedDate.day;

              Color bgColor = Colors.transparent;
              Color textColor = _navy;
              if (isSelected) {
                bgColor = _navy;
                textColor = Colors.white;
              } else if (isPast) {
                textColor = const Color(0xFFCBD5E1);
              }

              return GestureDetector(
                onTap: isPast
                    ? null
                    : () => setState(() => _selectedDate = date),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(10),
                    border: !isPast && !isSelected
                        ? Border.all(color: const Color(0xFFE2E8F0))
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$day',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 11,
                      fontWeight: isSelected
                          ? FontWeight.w800
                          : FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F3FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF006C49),
                  size: 16,
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    '${_weekdayName(_selectedDate.weekday)}, '
                    '${_selectedDate.day} ${_shortMonth(_selectedDate.month)} '
                    '${_selectedDate.year} • Kuota Tersedia (Real-time aman)',
                    style: const TextStyle(
                      color: _navy,
                      fontSize: 10,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
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

  // ── Leader Form ───────────────────────────────────────────────────────────

  Widget _buildLeaderForm() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFFE2E7FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.badge_outlined, color: _blue, size: 18),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Data Ketua Rombongan',
                      style: TextStyle(
                        color: _navy,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 1),
                    Text(
                      'Penanggung jawab pemesanan tiket',
                      style: TextStyle(color: _muted, fontSize: 10),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E7FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Wajib',
                  style: TextStyle(
                    color: _blue,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _inputField(
            label: 'Nama Lengkap Sesuai KTP',
            controller: _nameController,
            icon: Icons.person_outline_rounded,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 12),
          _inputField(
            label: 'Alamat Email Aktif',
            controller: _emailController,
            icon: Icons.alternate_email_rounded,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          _inputField(
            label: 'Nomor WhatsApp',
            controller: _phoneController,
            icon: Icons.chat_bubble_outline_rounded,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.verified_user_outlined, color: _navy, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'E-voucher tiket dan QR code akan dikirimkan otomatis ke WhatsApp & Email ini untuk proses tapping gerbang masuk Papuma.',
                    style: TextStyle(
                      color: Color(0xFF475569),
                      fontSize: 10,
                      height: 1.45,
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

  Widget _inputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _navy,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 18, color: const Color(0xFF94A3B8)),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: _blue, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  // ── Group Counter ─────────────────────────────────────────────────────────

  Widget _buildGroupCounter() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Anggota Rombongan',
                      style: TextStyle(
                        color: _navy,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Maksimal 10 peserta per transaksi',
                      style: TextStyle(color: _muted, fontSize: 10),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF6CF8BB),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$_totalPeople / 10 Peserta',
                  style: const TextStyle(
                    color: Color(0xFF00714D),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildLeaderMemberCard(),
          for (var index = 0; index < _members.length; index++) ...[
            const SizedBox(height: 10),
            _buildMemberCard(_members[index], index),
          ],
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: OutlinedButton.icon(
              onPressed: _totalPeople >= 10 ? null : _addMember,
              icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
              label: const Text('Tambah Anggota Rombongan'),
              style: OutlinedButton.styleFrom(
                foregroundColor: _navy,
                backgroundColor: const Color(0xFFF1F5F9),
                side: const BorderSide(color: Color(0xFFE2E8F0)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderMemberCard() {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _memberNumber(1, isLeader: true),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Peserta 1 (Ketua Rombongan)',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Text(
                  'Penanggung Jawab',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              const Icon(
                Icons.account_circle_outlined,
                size: 17,
                color: _muted,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  _nameController.text.isEmpty
                      ? 'Nama Ketua Rombongan'
                      : _nameController.text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _navy,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _ticketTypeChip(
                label:
                    'Dewasa Reguler (Rp ${_formatPrice(widget.destination.price)})',
                selected: true,
                onTap: null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMemberCard(_BookingMember member, int index) {
    final number = index + 2;
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _memberNumber(number),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Peserta $number',
                  style: const TextStyle(
                    color: _navy,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Hapus Peserta $number',
                onPressed: () => _removeMember(member),
                constraints: const BoxConstraints.tightFor(
                  width: 28,
                  height: 28,
                ),
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: _muted,
                  size: 17,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          TextField(
            controller: member.controller,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: 'Nama Peserta $number',
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text(
                'Jenis Tiket:',
                style: TextStyle(color: _muted, fontSize: 10),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: _ticketTypeChip(
                        label:
                            'Dewasa (${_shortTicketPrice(widget.destination.price)})',
                        selected: !member.isChild,
                        onTap: () => setState(() => member.isChild = false),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: _ticketTypeChip(
                        label: 'Anak (${_shortTicketPrice(_childTicketPrice)})',
                        selected: member.isChild,
                        onTap: () => setState(() => member.isChild = true),
                      ),
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

  String _shortTicketPrice(int price) =>
      price % 1000 == 0 ? '${price ~/ 1000}k' : _formatPrice(price);

  Widget _memberNumber(int number, {bool isLeader = false}) {
    return Container(
      width: 21,
      height: 21,
      decoration: BoxDecoration(
        color: isLeader ? _navy : const Color(0xFFE2E8F0),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        '$number',
        style: TextStyle(
          color: isLeader ? Colors.white : const Color(0xFF475569),
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _ticketTypeChip({
    required String label,
    required bool selected,
    required VoidCallback? onTap,
  }) {
    return Material(
      color: selected ? _navy : const Color(0xFFF1F5F9),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : _muted,
              fontSize: 8,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  void _addMember() {
    if (_totalPeople >= 10) return;
    setState(() => _members.add(_BookingMember()));
  }

  void _removeMember(_BookingMember member) {
    setState(() => _members.remove(member));
    member.dispose();
  }

  Widget _buildCompletenessChecklist() {
    return _card(
      child: const Column(
        children: [
          _ChecklistItem(label: 'Semua data peserta terisi lengkap'),
          SizedBox(height: 8),
          _ChecklistItem(label: 'Kuota kunjungan terkonfirmasi & teralokasi'),
        ],
      ),
    );
  }

  // ── Price Summary ─────────────────────────────────────────────────────────

  Widget _buildPriceSummary() {
    final adultPrice = widget.destination.price * _adultCount;
    final childPrice = _childTicketPrice * _childCount;

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Text(
                      'Rincian Pembayaran',
                      style: TextStyle(
                        color: _navy,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Text(
                        '$_totalPeople Tiket',
                        style: const TextStyle(
                          color: _muted,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: _muted,
                  size: 17,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _priceRow(
            label:
                '$_adultCount× Tiket Dewasa (@Rp ${_formatPrice(widget.destination.price)})',
            amount: 'Rp ${_formatPrice(adultPrice)}',
          ),
          if (_childCount > 0) ...[
            const SizedBox(height: 8),
            _priceRow(
              label:
                  '$_childCount× Tiket Anak (@Rp ${_formatPrice(_childTicketPrice)})',
              amount: 'Rp ${_formatPrice(childPrice)}',
            ),
          ],
          const SizedBox(height: 12),
          const Divider(color: Color(0xFFE2E8F0)),
          const SizedBox(height: 9),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Tagihan',
                      style: TextStyle(
                        color: _navy,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Harga Tiket Bersih (Tanpa Biaya Tambahan)',
                      style: TextStyle(
                        color: Color(0xFF006C49),
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Rp ${_formatPrice(_total)}',
                style: const TextStyle(
                  color: _navy,
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceRow({required String label, required String amount}) {
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
          style: const TextStyle(
            color: _navy,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // ── Security Note ─────────────────────────────────────────────────────────

  Widget _buildSecurityNote() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3FF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          Icon(Icons.shield_rounded, color: _blue, size: 19),
          SizedBox(width: 9),
          Expanded(
            child: Text(
              'Jaminan Tiket Masuk Resmi 100%\nDikelola langsung oleh Disparbud Kabupaten Jember',
              style: TextStyle(
                color: Color(0xFF475569),
                fontSize: 10,
                fontWeight: FontWeight.w500,
                height: 1.4,
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
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC).withValues(alpha: 0.97),
          boxShadow: const [
            BoxShadow(
              color: Color(0x140F172A),
              blurRadius: 22,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'TOTAL BAYAR ($_totalPeople PESERTA)',
                  style: TextStyle(
                    color: _muted,
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                  ),
                ),
                Text(
                  'Rp ${_formatPrice(_total)}',
                  style: const TextStyle(
                    color: _navy,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 48,
                child: FilledButton.icon(
                  onPressed: _proceed,
                  icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                  label: const Text('Lanjut Bayar'),
                  style: FilledButton.styleFrom(
                    backgroundColor: _navy,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F0F172A),
            blurRadius: 20,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _BookingMember {
  _BookingMember({String name = '', this.isChild = false}) {
    controller.text = name;
  }

  final TextEditingController controller = TextEditingController();
  bool isChild;

  void dispose() => controller.dispose();
}

class _ChecklistItem extends StatelessWidget {
  const _ChecklistItem({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: Color(0xFF6CF8BB),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_rounded,
            color: Color(0xFF00714D),
            size: 15,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF131B2E),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
