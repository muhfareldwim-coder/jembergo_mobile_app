import 'package:flutter/material.dart';

import '../models/app_data.dart';
import '../widgets/app_bottom_navigation.dart';
import 'explore_screen.dart';
import 'home_screen.dart';
import 'map_screen.dart';
import 'tickets_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const _navy = Color(0xFF0C192C);
  static const _blue = Color(0xFF006194);
  static const _muted = Color(0xFF64748B);

  // --- Profile edit form ---
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  bool _editExpanded = false;

  // --- Password form ---
  final _oldPwdController = TextEditingController();
  final _newPwdController = TextEditingController();
  bool _pwdExpanded = false;
  bool _obscureOld = true;
  bool _obscureNew = true;

  final Set<String> _favoriteIds = {'papuma', 'rembangan'};
  String _language = 'ID';

  @override
  void initState() {
    super.initState();
    final profile = AppData.profile.value;
    _nameController = TextEditingController(text: profile.name);
    _emailController = TextEditingController(text: profile.email);
    _phoneController = TextEditingController(text: profile.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
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
                    children: [
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
                        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10),
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
          const Expanded(
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
                  'Kelola informasi akun & preferensi',
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
            onPressed: () => _showMessage('Halaman pengaturan akan segera tersedia.'),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFF1F5F9),
            ),
            icon: const Icon(Icons.tune_rounded, color: _navy, size: 21),
          ),
        ],
      ),
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
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                    width: 4,
                  ),
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
              onPressed: () => setState(() => _editExpanded = !_editExpanded),
              icon: Icon(
                _editExpanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.edit_outlined,
                size: 17,
              ),
              label: Text(
                _editExpanded ? 'Tutup Form' : 'Edit Informasi Pribadi',
              ),
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
          // Expandable edit form
          AnimatedSize(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOut,
            child: _editExpanded
                ? Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 14),
                        const Divider(color: Color(0xFFE2E8F0)),
                        const SizedBox(height: 10),
                        _formField(
                          label: 'Nama Lengkap',
                          controller: _nameController,
                          icon: Icons.person_outline_rounded,
                          validator: (value) =>
                              value == null || value.trim().length < 2
                                  ? 'Masukkan nama lengkap'
                                  : null,
                          textCapitalization: TextCapitalization.words,
                        ),
                        const SizedBox(height: 12),
                        _formField(
                          label: 'Alamat Email',
                          controller: _emailController,
                          icon: Icons.mail_outline_rounded,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            final email = value?.trim() ?? '';
                            return RegExp(r'^[^@]+@[^@]+\.[^@]+$')
                                    .hasMatch(email)
                                ? null
                                : 'Masukkan alamat email yang valid';
                          },
                        ),
                        const SizedBox(height: 12),
                        _formField(
                          label: 'Nomor WhatsApp / Telepon',
                          controller: _phoneController,
                          icon: Icons.phone_iphone_rounded,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            final digits =
                                (value ?? '').replaceAll(RegExp(r'\D'), '');
                            return digits.length >= 9
                                ? null
                                : 'Masukkan nomor telepon yang valid';
                          },
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  final profile = AppData.profile.value;
                                  _nameController.text = profile.name;
                                  _emailController.text = profile.email;
                                  _phoneController.text = profile.phone;
                                  setState(() => _editExpanded = false);
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: _muted,
                                  side: const BorderSide(
                                    color: Color(0xFFE2E8F0),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text('Batal'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: _saveProfile,
                                icon: const Icon(Icons.save_outlined, size: 16),
                                label: const Text('Simpan'),
                                style: FilledButton.styleFrom(
                                  backgroundColor: _navy,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
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
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
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
                selected: {_language},
                showSelectedIcon: false,
                onSelectionChanged: (value) =>
                    setState(() => _language = value.first),
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
            onTap: () => _showMessage('Syarat & Ketentuan akan segera tersedia.'),
          ),
          _settingsTile(
            icon: Icons.policy_outlined,
            title: 'Kebijakan Privasi',
            onTap: () => _showMessage('Kebijakan Privasi akan segera tersedia.'),
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
    return ListTile(
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
      trailing: trailing ??
          const Icon(
            Icons.chevron_right_rounded,
            color: Color(0xFFCBD5E1),
            size: 20,
          ),
      onTap: onTap,
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
                obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
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
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
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

  Widget _formField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String? Function(String?) validator,
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
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 18, color: const Color(0xFF94A3B8)),
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFDC2626)),
            ),
          ),
        ),
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

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;
    AppData.profile.value = UserProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
    );
    setState(() => _editExpanded = false);
    _showMessage('Profil berhasil diperbarui.');
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
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFDC2626)),
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
