import 'package:flutter/material.dart';
import 'package:jembergo_mobile_app/models/app_data.dart';
import 'package:jembergo_mobile_app/features/auth/presentation/login_screen.dart';
import 'package:jembergo_mobile_app/features/auth/presentation/register_screen.dart';
import 'package:jembergo_mobile_app/features/destination/presentation/explore_screen.dart';
import 'package:jembergo_mobile_app/features/home/presentation/home_screen.dart';
import 'package:jembergo_mobile_app/features/map/presentation/map_screen.dart';
import 'package:jembergo_mobile_app/features/profile/presentation/profile_detail_screen.dart';
import 'package:jembergo_mobile_app/features/profile/presentation/profile_service_screen.dart';
import 'package:jembergo_mobile_app/features/ticket/presentation/tickets_screen.dart';
import 'package:jembergo_mobile_app/shared/widgets/app_bottom_navigation.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({this.isGuest = true, super.key});

  final bool isGuest;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const _navy = Color(0xFF0C192C);
  static const _blue = Color(0xFF006194);
  static const _muted = Color(0xFF64748B);

  // --- Password form ---
  final _oldPwdController = TextEditingController();
  final _newPwdController = TextEditingController();
  bool _pwdExpanded = false;
  bool _obscureOld = true;
  bool _obscureNew = true;

  final Set<String> _favoriteIds = {'papuma', 'rembangan'};

  @override
  void dispose() {
    _oldPwdController.dispose();
    _newPwdController.dispose();
    super.dispose();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

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
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(18, 14, 18, 120),
                    children: widget.isGuest
                        ? [
                            _buildGuestProfileCard(),
                            const SizedBox(height: 14),
                            _buildGuestFavorites(),
                            const SizedBox(height: 14),
                            _buildGuestSettings(),
                            const SizedBox(height: 20),
                            const Text(
                              'JemberGo App v1.2.0 • Dinas Pariwisata Jember\n'
                              'Mendukung Pariwisata Ramah & Terintegrasi',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 10,
                                height: 1.5,
                              ),
                            ),
                          ]
                        : [
                            _buildProfileCard(),
                            const SizedBox(height: 14),
                            _buildFavorites(),
                            const SizedBox(height: 14),
                            _buildSettings(),
                            const SizedBox(height: 20),
                            _buildLogoutButton(),
                            const SizedBox(height: 16),
                            const Text(
                              'Jember Tourism Center • Layanan Pengaduan 112',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 10,
                              ),
                            ),
                          ],
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
      selectedIndex: 4,
      onSelected: _navigateToTab,
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 10, 14, 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profil Saya',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  widget.isGuest
                      ? 'Jelajahi Jember sebagai pengunjung'
                      : 'Kelola informasi akun & preferensi',
                  style: TextStyle(color: _muted, fontSize: 10),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Pemberitahuan',
            onPressed: () => _showMessage('Tidak ada pemberitahuan baru.'),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFF1F5F9),
            ),
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: _navy,
              size: 21,
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            tooltip: 'Pengaturan',
            onPressed: () =>
                _showMessage('Halaman pengaturan akan segera tersedia.'),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFF1F5F9),
            ),
            icon: const Icon(Icons.tune_rounded, color: _navy, size: 21),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestProfileCard() {
    return _card(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F9FF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE0F2FE)),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: Color(0xFF0369A1),
                      size: 38,
                    ),
                  ),
                  Positioned(
                    right: -4,
                    bottom: -4,
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.lock_rounded,
                        color: _muted,
                        size: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Pengunjung Tamu',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: _navy,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        SizedBox(width: 6),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            child: Text(
                              'Tamu',
                              style: TextStyle(
                                color: _muted,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 7),
                    Text(
                      'Masuk atau buat akun untuk menikmati semua fitur JemberGo secara optimal.',
                      style: TextStyle(
                        color: _muted,
                        fontSize: 11,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _openLogin,
                  icon: const Icon(Icons.login_rounded, size: 16),
                  label: const Text('Masuk Akun'),
                  style: FilledButton.styleFrom(
                    backgroundColor: _navy,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _openRegister,
                  icon: const Icon(Icons.person_add_alt_1_rounded, size: 16),
                  label: const Text('Daftar Baru'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF334155),
                    backgroundColor: const Color(0xFFF8FAFC),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
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
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.stars_rounded, color: _blue, size: 17),
                    SizedBox(width: 6),
                    Text(
                      'Keuntungan Memiliki Akun',
                      style: TextStyle(
                        color: _navy,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  'Simpan tiket elektronik dan destinasi favorit, serta kelola preferensi wisata antar-perangkat.',
                  style: TextStyle(color: _muted, fontSize: 10, height: 1.45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestFavorites() {
    return _card(
      child: Column(
        children: [
          _sectionHeader(
            icon: Icons.favorite_rounded,
            iconColor: const Color(0xFFE11D48),
            iconBg: const Color(0xFFFFF1F2),
            title: 'Destinasi Favorit',
            subtitle: '0 tersimpan',
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF1F2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_border_rounded,
                    color: Color(0xFFE11D48),
                    size: 23,
                  ),
                ),
                const SizedBox(height: 9),
                const Text(
                  'Belum Ada Favorit Tersimpan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _navy,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Login untuk menyimpan dan menyinkronkan destinasi favorit Anda di Jember.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _muted, fontSize: 10, height: 1.4),
                ),
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: _openLogin,
                  icon: const Icon(Icons.login_rounded, size: 15),
                  label: const Text('Masuk'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: _navy,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 17,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
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

  Widget _buildGuestSettings() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            icon: Icons.tune_rounded,
            iconColor: _navy,
            iconBg: const Color(0xFFF1F5F9),
            title: 'Pengaturan & Layanan',
            subtitle: 'Preferensi dan informasi bantuan',
          ),
          const SizedBox(height: 8),
          _settingsTile(
            icon: Icons.language_rounded,
            title: 'Pilihan Bahasa',
            onTap: _showLanguagePicker,
            trailing: ValueListenableBuilder<String>(
              valueListenable: AppData.language,
              builder: (context, language, _) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  language,
                  style: const TextStyle(
                    color: _navy,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
          _settingsTile(
            icon: Icons.help_outline_rounded,
            title: 'Bantuan & Pusat Informasi',
            onTap: () => _openServicePage(ProfileServiceType.help),
          ),
          _settingsTile(
            icon: Icons.gavel_rounded,
            title: 'Syarat & Ketentuan',
            onTap: () => _openServicePage(ProfileServiceType.terms),
          ),
          _settingsTile(
            icon: Icons.verified_user_outlined,
            title: 'Kebijakan Privasi',
            onTap: () => _openServicePage(ProfileServiceType.privacy),
          ),
          _settingsTile(
            icon: Icons.info_outline_rounded,
            title: 'Tentang JemberGo',
            onTap: () => _openServicePage(ProfileServiceType.about),
          ),
        ],
      ),
    );
  }

  void _openLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const LoginScreen()));
  }

  void _openRegister() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const RegisterScreen()));
  }

  Future<void> _showLanguagePicker() async {
    final selectedLanguage = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(12, 4, 12, 8),
                child: Text(
                  'Pilih Bahasa / Choose language',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              RadioGroup<String>(
                groupValue: AppData.language.value,
                onChanged: (value) {
                  if (value != null) Navigator.of(context).pop(value);
                },
                child: Column(
                  children: [
                    for (final option in const [
                      (code: 'ID', label: 'Bahasa Indonesia'),
                      (code: 'EN', label: 'English'),
                    ])
                      RadioListTile<String>(
                        value: option.code,
                        title: Text(option.label),
                        activeColor: _navy,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (selectedLanguage == null || !mounted) return;
    AppData.language.value = selectedLanguage;
    _showMessage(
      selectedLanguage == 'ID'
          ? 'Bahasa tampilan dipilih: Bahasa Indonesia.'
          : 'Selected display language: English.',
    );
  }

  void _openServicePage(ProfileServiceType type) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => ProfileServiceScreen(type: type)),
    );
  }

  // ── Profile Card ──────────────────────────────────────────────────────────

  Widget _buildProfileCard() {
    return _card(
      child: Column(
        children: [
          // Avatar
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 4),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/home/profile_avatar.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                right: -2,
                bottom: 2,
                child: Material(
                  color: _navy,
                  shape: const CircleBorder(),
                  child: IconButton(
                    tooltip: 'Ganti Foto Profil',
                    onPressed: () => _showMessage(
                      'Pemilihan foto profil akan segera tersedia.',
                    ),
                    icon: const Icon(
                      Icons.photo_camera_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    constraints: const BoxConstraints.tightFor(
                      width: 32,
                      height: 32,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Name
          ValueListenableBuilder<UserProfile>(
            valueListenable: AppData.profile,
            builder: (context, profile, _) => Column(
              children: [
                Text(
                  profile.name,
                  style: const TextStyle(
                    color: _navy,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.mail_outline_rounded,
                      size: 13,
                      color: _muted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      profile.email,
                      style: const TextStyle(color: _muted, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.phone_iphone_rounded,
                      size: 13,
                      color: _muted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      profile.phone,
                      style: const TextStyle(color: _muted, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          // Edit button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _openProfileDetail,
              icon: const Icon(Icons.edit_outlined, size: 17),
              label: const Text('Edit Informasi Pribadi'),
              style: OutlinedButton.styleFrom(
                foregroundColor: _navy,
                side: const BorderSide(color: Color(0xFFE2E8F0)),
                padding: const EdgeInsets.symmetric(vertical: 11),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Favorites ─────────────────────────────────────────────────────────────

  Widget _buildFavorites() {
    final favorites = DestinationInfo.destinations
        .where((d) => _favoriteIds.contains(d.id))
        .toList();

    return _card(
      child: Column(
        children: [
          _sectionHeader(
            icon: Icons.favorite_rounded,
            iconColor: const Color(0xFFE11D48),
            iconBg: const Color(0xFFFFF1F2),
            title: 'Destinasi Favorit',
            subtitle: '${favorites.length} tersimpan',
            trailing: favorites.isNotEmpty
                ? TextButton(
                    onPressed: () => _navigateToTab(1),
                    child: const Text(
                      'Jelajahi',
                      style: TextStyle(
                        color: _blue,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 12),
          if (favorites.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Column(
                children: [
                  Icon(
                    Icons.favorite_border_rounded,
                    size: 36,
                    color: const Color(0xFFCBD5E1),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Belum ada destinasi favorit',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Simpan destinasi favoritmu saat menjelajahi wisata.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _muted, fontSize: 10),
                  ),
                ],
              ),
            )
          else
            for (final destination in favorites) ...[
              _favoriteItem(destination),
              if (destination != favorites.last) const SizedBox(height: 8),
            ],
        ],
      ),
    );
  }

  Widget _favoriteItem(DestinationInfo destination) {
    return Container(
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
              destination.image,
              width: 52,
              height: 52,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  destination.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _navy,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 11,
                      color: Color(0xFFE11D48),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        destination.area,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: _muted, fontSize: 10),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 12,
                      color: Color(0xFFF59E0B),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      destination.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        color: _navy,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Hapus dari favorit',
            onPressed: () =>
                setState(() => _favoriteIds.remove(destination.id)),
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: Color(0xFF94A3B8),
              size: 19,
            ),
          ),
        ],
      ),
    );
  }

  // ── Settings & Services ───────────────────────────────────────────────────

  Widget _buildSettings() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            icon: Icons.tune_rounded,
            iconColor: _navy,
            iconBg: const Color(0xFFF1F5F9),
            title: 'Pengaturan & Layanan',
            subtitle: 'Keamanan, bahasa, dan legalitas',
          ),
          const SizedBox(height: 12),
          // Password / Security
          _settingsTile(
            icon: Icons.lock_outline_rounded,
            title: 'Keamanan / Ubah Kata Sandi',
            trailing: Icon(
              _pwdExpanded
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.chevron_right_rounded,
              color: const Color(0xFFCBD5E1),
            ),
            onTap: () => setState(() => _pwdExpanded = !_pwdExpanded),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeInOut,
            child: _pwdExpanded
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 4),
                    child: Column(
                      children: [
                        _passwordField(
                          label: 'Kata Sandi Lama',
                          controller: _oldPwdController,
                          obscure: _obscureOld,
                          onToggle: () =>
                              setState(() => _obscureOld = !_obscureOld),
                        ),
                        const SizedBox(height: 10),
                        _passwordField(
                          label: 'Kata Sandi Baru',
                          controller: _newPwdController,
                          obscure: _obscureNew,
                          onToggle: () =>
                              setState(() => _obscureNew = !_obscureNew),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () {
                              if (_oldPwdController.text.isEmpty ||
                                  _newPwdController.text.isEmpty) {
                                _showMessage('Isi semua kolom kata sandi.');
                                return;
                              }
                              _oldPwdController.clear();
                              _newPwdController.clear();
                              setState(() => _pwdExpanded = false);
                              _showMessage('Kata sandi berhasil diperbarui.');
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: _navy,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              textStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            child: const Text('Perbarui Kata Sandi'),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          const Divider(height: 16, color: Color(0xFFF1F5F9)),
          // Language toggle
          Row(
            children: [
              const Icon(Icons.language_rounded, color: _muted, size: 18),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Bahasa Antarmuka',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'ID', label: Text('ID')),
                  ButtonSegment(value: 'EN', label: Text('EN')),
                ],
                selected: {AppData.language.value},
                showSelectedIcon: false,
                onSelectionChanged: (value) =>
                    setState(() => AppData.language.value = value.first),
                style: ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  textStyle: const WidgetStatePropertyAll(
                    TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 16, color: Color(0xFFF1F5F9)),
          _settingsTile(
            icon: Icons.description_outlined,
            title: 'Syarat & Ketentuan',
            onTap: () =>
                _showMessage('Syarat & Ketentuan akan segera tersedia.'),
          ),
          _settingsTile(
            icon: Icons.policy_outlined,
            title: 'Kebijakan Privasi',
            onTap: () =>
                _showMessage('Kebijakan Privasi akan segera tersedia.'),
          ),
          _settingsTile(
            icon: Icons.info_outline_rounded,
            title: 'Tentang JemberGo v1.2.0',
            onTap: () => _showMessage('JemberGo v1.2.0 – Jember Tourism App.'),
          ),
        ],
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        dense: true,
        leading: Icon(icon, color: const Color(0xFF94A3B8), size: 19),
        title: Text(
          title,
          style: const TextStyle(
            color: _navy,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing:
            trailing ??
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFCBD5E1),
              size: 20,
            ),
        onTap: onTap,
      ),
    );
  }

  Widget _passwordField({
    required String label,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
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
          obscureText: obscure,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.lock_outline_rounded,
              size: 18,
              color: Color(0xFF94A3B8),
            ),
            suffixIcon: IconButton(
              onPressed: onToggle,
              icon: Icon(
                obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 18,
                color: const Color(0xFF94A3B8),
              ),
            ),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 13,
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

  // ── Logout Button ─────────────────────────────────────────────────────────

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        onPressed: _confirmLogout,
        icon: const Icon(Icons.logout_rounded, size: 18),
        label: const Text('Logout / Keluar dari Akun'),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFDC2626),
          side: const BorderSide(color: Color(0xFFFECACA)),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  // ── Shared Widgets ────────────────────────────────────────────────────────

  Widget _sectionHeader({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 19),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _navy,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(color: _muted, fontSize: 9),
              ),
            ],
          ),
        ),
        ?trailing,
      ],
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8EDF3)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080C192C),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  // ── Logic ─────────────────────────────────────────────────────────────────

  Future<void> _openProfileDetail() async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(builder: (_) => const ProfileDetailScreen()),
    );
    if (saved == true && mounted) {
      _showMessage('Profil berhasil diperbarui.');
    }
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Keluar dari akun?',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: const Text('Kamu bisa masuk kembali kapan saja.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      _showMessage('Kamu telah keluar dari akun.');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _navigateToTab(int index) {
    if (index == 4) return;
    final userName = AppData.profile.value.name;
    final Widget page = switch (index) {
      0 => HomeScreen(userName: userName),
      1 => ExploreScreen(userName: userName),
      2 => MapScreen(userName: userName),
      _ => const TicketsScreen(),
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
}
