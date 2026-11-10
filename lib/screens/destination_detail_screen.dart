import 'package:flutter/material.dart';

import '../models/app_data.dart';
import 'map_screen.dart';
import 'tickets_screen.dart';

class DestinationDetailScreen extends StatelessWidget {
  const DestinationDetailScreen({required this.destination, super.key});

  final DestinationInfo destination;

  static const _navy = Color(0xFF0C192C);
  static const _blue = Color(0xFF006194);
  static const _muted = Color(0xFF64748B);

  Future<void> _openBooking(BuildContext context) async {
    final today = DateTime.now();
    var visitDate = DateTime(today.year, today.month, today.day + 1);
    var people = 1;
    final order = await showModalBottomSheet<TicketOrder>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => SafeArea(
          child: Container(
            padding: EdgeInsets.fromLTRB(
              20,
              14,
              20,
              20 + MediaQuery.viewInsetsOf(context).bottom,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                const SizedBox(height: 18),
                const Text(
                  'Pesan Tiket Wisata',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: _navy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  destination.name,
                  style: const TextStyle(color: _muted, fontSize: 13),
                ),
                const SizedBox(height: 18),
                OutlinedButton.icon(
                  onPressed: () async {
                    final selected = await showDatePicker(
                      context: context,
                      initialDate: visitDate,
                      firstDate: DateTime(today.year, today.month, today.day),
                      lastDate: today.add(const Duration(days: 365)),
                    );
                    if (selected != null) {
                      setSheetState(() => visitDate = selected);
                    }
                  },
                  icon: const Icon(Icons.calendar_month_rounded),
                  label: Text(
                    '${visitDate.day.toString().padLeft(2, '0')}/'
                    '${visitDate.month.toString().padLeft(2, '0')}/'
                    '${visitDate.year}',
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _navy,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Jumlah wisatawan',
                        style: TextStyle(
                          color: _navy,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: people > 1
                          ? () => setSheetState(() => people--)
                          : null,
                      icon: const Icon(Icons.remove_circle_outline_rounded),
                    ),
                    Text(
                      '$people',
                      style: const TextStyle(
                        color: _navy,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      onPressed: people < 20
                          ? () => setSheetState(() => people++)
                          : null,
                      icon: const Icon(Icons.add_circle_outline_rounded),
                    ),
                  ],
                ),
                const Divider(height: 20),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Total pembayaran',
                        style: TextStyle(color: _muted, fontSize: 13),
                      ),
                    ),
                    Text(
                      'Rp ${(destination.price * people).toString()}',
                      style: const TextStyle(
                        color: _navy,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {
                    final created = AppData.createOrder(
                      destination: destination,
                      visitDate: visitDate,
                      people: people,
                    );
                    Navigator.of(context).pop(created);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: _navy,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('Lanjutkan ke Tiket'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (order != null && context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => TicketsScreen(focusBookingCode: order.bookingCode),
        ),
      );
    }
  }

  void _openMap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MapScreen(
          userName: AppData.profile.value.name,
          initialDestinationId: destination.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHero(context)),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 124),
                sliver: SliverList.list(
                  children: [
                    _buildTitleAndPrice(),
                    const SizedBox(height: 13),
                    _buildDistanceCard(),
                    const SizedBox(height: 13),
                    _buildRatingRow(),
                    const SizedBox(height: 18),
                    _buildRouteCard(context),
                    const SizedBox(height: 22),
                    _buildFacilities(),
                    const SizedBox(height: 22),
                    _buildDescription(),
                    const SizedBox(height: 22),
                    _buildGallery(),
                    const SizedBox(height: 22),
                    _buildReview(),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.96),
                  border: const Border(
                    top: BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x120C192C),
                      blurRadius: 16,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 52,
                  child: destination.price > 0
                      ? FilledButton(
                          onPressed: () => _openBooking(context),
                          style: FilledButton.styleFrom(
                            backgroundColor: _navy,
                            foregroundColor: Colors.white,
                            shape: const StadiumBorder(),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Pesan Tiket Sekarang'),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_rounded, size: 18),
                            ],
                          ),
                        )
                      : const OutlinedButton(
                          onPressed: null,
                          child: Text('Informasi tiket belum tersedia'),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    return SizedBox(
      height: 340,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(destination.image, fit: BoxFit.cover),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x77000000),
                  Colors.transparent,
                  Color(0x44000000),
                ],
                stops: [0, 0.45, 1],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).top + 8,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _heroAction(
                  icon: Icons.arrow_back_rounded,
                  label: 'Kembali',
                  onTap: () => Navigator.of(context).maybePop(),
                ),
                _heroAction(
                  icon: Icons.favorite_border_rounded,
                  label: 'Simpan ke favorit',
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ditambahkan ke favorit.')),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 18,
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.photo_library_outlined,
                    color: Colors.white,
                    size: 15,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Jelajahi keindahan Jember',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white.withValues(alpha: 0.9),
      shape: const CircleBorder(),
      child: IconButton(
        tooltip: label,
        onPressed: onTap,
        icon: Icon(icon, color: _navy, size: 21),
      ),
    );
  }

  Widget _buildTitleAndPrice() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                destination.name,
                style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 21,
                  height: 1.2,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    color: Color(0xFFE11D48),
                    size: 15,
                  ),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      destination.area,
                      style: const TextStyle(color: _muted, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'MULAI DARI',
              style: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.7,
              ),
            ),
            Text(
              destination.price > 0 ? destination.priceFormatted : 'Cek lokasi',
              style: const TextStyle(
                color: _navy,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Text(
              '/ orang',
              style: TextStyle(color: _muted, fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDistanceCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          const Icon(Icons.near_me_outlined, color: _blue, size: 17),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              '${destination.distanceKm.toStringAsFixed(0)} km dari Jember',
              style: const TextStyle(
                color: Color(0xFF334155),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Icon(
            Icons.schedule_rounded,
            color: Color(0xFF059669),
            size: 16,
          ),
          const SizedBox(width: 5),
          const Text(
            '~50 mnt berkendara',
            style: TextStyle(color: Color(0xFF475569), fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingRow() {
    return Row(
      children: [
        const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 19),
        const SizedBox(width: 4),
        Text(
          destination.rating.toStringAsFixed(1),
          style: const TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            '(${destination.reviews} ulasan)',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: _muted, fontSize: 11),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'Buka Ulasan',
          style: TextStyle(
            color: _blue,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Icon(Icons.chevron_right_rounded, color: _blue, size: 17),
      ],
    );
  }

  Widget _buildRouteCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE0F2FE), Color(0xFFF0F7FF)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFBAE6FD)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(Icons.map_outlined, color: _blue),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Navigasi Peta & Rute',
                  style: TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Lihat jalur menuju destinasi',
                  style: TextStyle(color: _muted, fontSize: 10),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () => _openMap(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: _blue,
              backgroundColor: Colors.white,
              side: const BorderSide(color: Color(0xFFBAE6FD)),
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
              minimumSize: Size.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
            ),
            child: const Text('Buka Peta', style: TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilities() {
    const facilities = [
      (Icons.deck_outlined, 'Gazebo & Rest Area'),
      (Icons.restaurant_outlined, 'Kuliner lokal'),
      (Icons.wb_sunny_outlined, 'Spot foto'),
      (Icons.mosque_outlined, 'Musholla & Toilet'),
      (Icons.local_parking_outlined, 'Area Parkir'),
      (Icons.landscape_outlined, 'Area wisata'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Fasilitas yang Tersedia'),
        const SizedBox(height: 11),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: facilities.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 42,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            final item = facilities[index];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Icon(item.$1, size: 16, color: _blue),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      item.$2,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF334155),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Deskripsi'),
        const SizedBox(height: 7),
        Text(
          destination.description,
          style: const TextStyle(
            color: Color(0xFF475569),
            fontSize: 12,
            height: 1.65,
          ),
        ),
      ],
    );
  }

  Widget _buildGallery() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Galeri Foto'),
        const SizedBox(height: 10),
        SizedBox(
          height: 95,
          child: Row(
            children: [
              for (var index = 0; index < 3; index++) ...[
                if (index > 0) const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(destination.image, fit: BoxFit.cover),
                        if (index == 2)
                          Container(
                            color: Colors.black.withValues(alpha: 0.42),
                            alignment: Alignment.center,
                            child: const Text(
                              '+12 Foto',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _sectionTitle('Ulasan Pengunjung'),
            const Spacer(),
            Text(
              '${destination.reviews} ulasan',
              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(17),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: _blue,
                    child: Text(
                      'RD',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rian Daniswara',
                          style: TextStyle(
                            color: Color(0xFF1E293B),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Wisatawan • 2 hari lalu',
                          style: TextStyle(color: _muted, fontSize: 9),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    '★★★★★',
                    style: TextStyle(color: Color(0xFFF59E0B), fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 9),
              Text(
                'Pemandangannya indah dan suasananya menyenangkan. '
                'Salah satu destinasi yang wajib dikunjungi di Jember!',
                style: const TextStyle(
                  color: Color(0xFF475569),
                  fontSize: 11,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF0F172A),
        fontSize: 14,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}
