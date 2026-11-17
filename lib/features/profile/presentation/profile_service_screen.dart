import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum ProfileServiceType { help, terms, privacy, about }

class ProfileServiceScreen extends StatelessWidget {
  const ProfileServiceScreen({required this.type, super.key});

  final ProfileServiceType type;

  static const _navy = Color(0xFF0C192C);
  static const _muted = Color(0xFF64748B);

  String get _title => switch (type) {
    ProfileServiceType.help => 'Bantuan & Pusat Informasi',
    ProfileServiceType.terms => 'Syarat & Ketentuan',
    ProfileServiceType.privacy => 'Kebijakan Privasi',
    ProfileServiceType.about => 'Tentang JemberGo',
  };

  String get _subtitle => switch (type) {
    ProfileServiceType.help => 'Panduan menggunakan JemberGo',
    ProfileServiceType.terms => 'Ketentuan penggunaan layanan',
    ProfileServiceType.privacy => 'Informasi pengelolaan data',
    ProfileServiceType.about => 'Informasi aplikasi dan pengelola',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
                children: switch (type) {
                  ProfileServiceType.help => _buildHelpContent(context),
                  ProfileServiceType.terms => _buildLegalContent(_terms),
                  ProfileServiceType.privacy => _buildLegalContent(_privacy),
                  ProfileServiceType.about => _buildAboutContent(),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 18, 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Kembali',
            onPressed: () => Navigator.of(context).maybePop(),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFF1F5F9),
              foregroundColor: _navy,
            ),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _navy,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _subtitle,
                  style: const TextStyle(color: _muted, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildHelpContent(BuildContext context) => [
    _infoCard(
      icon: Icons.support_agent_rounded,
      iconColor: const Color(0xFF0284C7),
      title: 'Ada yang bisa kami bantu?',
      body: 'Temukan panduan singkat untuk menjelajahi destinasi, memesan tiket, dan melihat e-ticket.',
    ),
    const SizedBox(height: 16),
    const Text(
      'Pertanyaan yang sering diajukan',
      style: TextStyle(color: _navy, fontSize: 15, fontWeight: FontWeight.w800),
    ),
    const SizedBox(height: 8),
    for (final section in _helpQuestions)
      Card(
        margin: const EdgeInsets.only(bottom: 8),
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 15),
          childrenPadding: const EdgeInsets.fromLTRB(15, 0, 15, 16),
          title: Text(
            section.title,
            style: const TextStyle(
              color: _navy,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                section.body,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 12,
                  height: 1.55,
                ),
              ),
            ),
          ],
        ),
      ),
    const SizedBox(height: 10),
    Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFDBEAFE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.emergency_rounded, color: Color(0xFFDC2626), size: 20),
              SizedBox(width: 8),
              Text(
                'Bantuan darurat',
                style: TextStyle(
                  color: _navy,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Untuk keadaan darurat, hubungi layanan darurat setempat di 112.',
            style: TextStyle(color: _muted, fontSize: 11, height: 1.5),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => _callEmergency(context),
              icon: const Icon(Icons.call_rounded, size: 17),
              label: const Text('Hubungi 112'),
              style: FilledButton.styleFrom(
                backgroundColor: _navy,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  ];

  List<Widget> _buildLegalContent(List<_ServiceSection> sections) => [
    _infoCard(
      icon: type == ProfileServiceType.terms
          ? Icons.gavel_rounded
          : Icons.verified_user_outlined,
      iconColor: const Color(0xFF0284C7),
      title: type == ProfileServiceType.terms
          ? 'Penggunaan JemberGo'
          : 'Privasi pengguna',
      body: type == ProfileServiceType.terms
          ? 'Mohon baca panduan berikut sebelum menggunakan informasi dan fitur aplikasi.'
          : 'Berikut penjelasan ringkas tentang data yang digunakan oleh versi aplikasi saat ini.',
    ),
    const SizedBox(height: 16),
    for (var index = 0; index < sections.length; index++) ...[
      _sectionCard(index + 1, sections[index]),
      if (index != sections.length - 1) const SizedBox(height: 10),
    ],
    const SizedBox(height: 14),
    const Text(
      'Informasi ini menjelaskan perilaku aplikasi saat ini. Ketentuan resmi dari pengelola destinasi tetap berlaku.',
      style: TextStyle(color: _muted, fontSize: 10, height: 1.5),
    ),
  ];

  List<Widget> _buildAboutContent() => [
    Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Image.asset(
            'assets/logo jembergonobackgroud.png',
            width: 180,
            height: 150,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 8),
          const Text(
            'JemberGo',
            style: TextStyle(
              color: _navy,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Informasi & Layanan Pariwisata Kabupaten Jember',
            textAlign: TextAlign.center,
            style: TextStyle(color: _muted, fontSize: 12, height: 1.5),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Versi 1.2.0',
              style: TextStyle(
                color: _navy,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    ),
    const SizedBox(height: 16),
    _infoCard(
      icon: Icons.travel_explore_rounded,
      iconColor: const Color(0xFF059669),
      title: 'Jelajahi Jember',
      body: 'JemberGo membantu menemukan informasi destinasi, melihat panduan perjalanan, serta mencoba alur pemesanan tiket wisata.',
    ),
    const SizedBox(height: 12),
    const Text(
      'Dikembangkan sebagai aplikasi informasi dan layanan wisata Kabupaten Jember.',
      textAlign: TextAlign.center,
      style: TextStyle(color: _muted, fontSize: 11, height: 1.5),
    ),
  ];

  Widget _infoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String body,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _navy,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  body,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 11,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard(int index, _ServiceSection section) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$index. ${section.title}',
            style: const TextStyle(
              color: _navy,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            section.body,
            style: const TextStyle(color: _muted, fontSize: 12, height: 1.6),
          ),
        ],
      ),
    );
  }

  Future<void> _callEmergency(BuildContext context) async {
    final uri = Uri(scheme: 'tel', path: '112');
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        _showCallError(context);
      }
    } on Exception {
      if (context.mounted) _showCallError(context);
    }
  }

  void _showCallError(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Aplikasi telepon tidak dapat dibuka.')),
      );
  }
}

class _ServiceSection {
  const _ServiceSection({required this.title, required this.body});

  final String title;
  final String body;
}

const _helpQuestions = <_ServiceSection>[
  _ServiceSection(
    title: 'Bagaimana cara melihat detail destinasi?',
    body: 'Pilih kartu atau nama destinasi dari Beranda maupun Jelajahi untuk membuka informasi, lokasi, dan fasilitas yang tersedia.',
  ),
  _ServiceSection(
    title: 'Bagaimana cara memesan tiket?',
    body: 'Buka detail destinasi, pilih Pesan Tiket, lengkapi tanggal kunjungan dan jumlah pengunjung, lalu ikuti instruksi pada halaman pembayaran.',
  ),
  _ServiceSection(
    title: 'Di mana saya menemukan e-ticket?',
    body: 'Buka tab Tiket pada navigasi bawah. Pilih pesanan untuk melihat status dan detail tiket elektronik.',
  ),
  _ServiceSection(
    title: 'Bagaimana menggunakan peta?',
    body: 'Buka tab Peta dan izinkan akses lokasi jika ingin melihat posisi Anda. Anda juga dapat memilih destinasi untuk melihat rute.',
  ),
];

const _terms = <_ServiceSection>[
  _ServiceSection(
    title: 'Informasi destinasi',
    body: 'Informasi lokasi, fasilitas, harga, dan jam operasional dapat berubah. Periksa kembali informasi terbaru kepada pengelola destinasi sebelum berkunjung.',
  ),
  _ServiceSection(
    title: 'Pemesanan dan pembayaran',
    body: 'Pastikan data pengunjung dan tanggal kunjungan benar sebelum melanjutkan. Ikuti petunjuk pada aplikasi dan ketentuan resmi dari pengelola destinasi.',
  ),
  _ServiceSection(
    title: 'Penggunaan yang bertanggung jawab',
    body: 'Gunakan aplikasi secara wajar, patuhi aturan di lokasi wisata, jaga keselamatan, dan hormati lingkungan serta masyarakat setempat.',
  ),
  _ServiceSection(
    title: 'Ketersediaan layanan',
    body: 'Sebagian fitur pada versi ini masih berupa pratinjau. Status dan data yang ditampilkan pada alur simulasi belum tentu mewakili transaksi resmi.',
  ),
];

const _privacy = <_ServiceSection>[
  _ServiceSection(
    title: 'Data yang digunakan',
    body: 'Aplikasi dapat menggunakan nama, alamat email, nomor telepon, dan detail pesanan yang Anda masukkan untuk menampilkan profil serta alur pemesanan.',
  ),
  _ServiceSection(
    title: 'Lokasi perangkat',
    body: 'Akses lokasi hanya digunakan saat Anda memakai fitur peta atau rute. Anda dapat mengatur atau mencabut izin lokasi melalui pengaturan perangkat.',
  ),
  _ServiceSection(
    title: 'Penyimpanan pada versi ini',
    body: 'Data contoh profil dan tiket pada versi aplikasi ini dikelola di memori aplikasi dan dapat kembali ke nilai awal saat aplikasi dimulai ulang. Belum ada sinkronisasi akun ke server.',
  ),
  _ServiceSection(
    title: 'Kontrol pengguna',
    body: 'Jangan memasukkan informasi sensitif yang tidak diperlukan. Penghapusan data sementara dapat dilakukan dengan menutup atau mengatur ulang aplikasi.',
  ),
];
