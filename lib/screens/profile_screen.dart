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

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
                  children: [
                    _buildProfileCard(),
                    const SizedBox(height: 14),
                    _buildPersonalInformation(),
                    const SizedBox(height: 14),
                    _buildFavorites(),
                    const SizedBox(height: 14),
                    _buildPreferences(),
                    const SizedBox(height: 17),
                    _buildActions(),
                    const SizedBox(height: 18),
                    const Text(
                      'Jember Tourism Center • Layanan Pengaduan 112',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: AppBottomNavigation(
            selectedIndex: 4,
            onSelected: _navigateToTab,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Kembali',
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                _navigateToTab(0);
              }
            },
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFF1F5F9),
            ),
            icon: const Icon(Icons.arrow_back_rounded, color: _navy),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit & Detail Profil',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Kelola informasi akun & preferensi pelancong',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: _muted, fontSize: 10),
                ),
              ],
            ),
          ),
          Image.asset(
            'assets/onboarding/jembergo_logo.png',
            width: 34,
            height: 32,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 5),
          const CircleAvatar(
            radius: 17,
            backgroundColor: _navy,
            child: Icon(Icons.person_rounded, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return _card(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 98,
                height: 98,
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
                bottom: 1,
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
                      size: 17,
                    ),
                    constraints: const BoxConstraints.tightFor(
                      width: 34,
                      height: 34,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          ValueListenableBuilder<UserProfile>(
            valueListenable: AppData.profile,
            builder: (context, profile, _) => Text(
              profile.name,
              style: const TextStyle(
                color: _navy,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showMessage(
                    'Pemilihan foto dari galeri akan segera tersedia.',
                  ),
                  icon: const Icon(
                    Icons.add_photo_alternate_outlined,
                    color: _blue,
                    size: 18,
                  ),
                  label: const Text('Pilih Galeri'),
                  style: _outlineButtonStyle(),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showMessage('Foto profil dihapus.'),
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Color(0xFFDC2626),
                    size: 18,
                  ),
                  label: const Text(
                    'Hapus Foto',
                    style: TextStyle(color: Color(0xFFB91C1C)),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFFFEF2F2),
                    side: const BorderSide(color: Color(0xFFFECACA)),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInformation() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            icon: Icons.badge_outlined,
            title: 'Informasi Pribadi',
            subtitle: 'Perbarui identitas untuk pemesanan tiket wisata',
            iconColor: _blue,
            iconBackground: const Color(0xFFEFF6FF),
          ),
          const SizedBox(height: 17),
          _formField(
            label: 'Nama Lengkap',
            controller: _nameController,
            icon: Icons.person_outline_rounded,
            validator: (value) => value == null || value.trim().length < 2
                ? 'Masukkan nama lengkap'
                : null,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 14),
          _formField(
            label: 'Alamat Email',
            controller: _emailController,
            icon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            suffix: _verifiedBadge(),
            validator: (value) {
              final email = value?.trim() ?? '';
              return RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email)
                  ? null
                  : 'Masukkan alamat email yang valid';
            },
          ),
          const SizedBox(height: 14),
          _formField(
            label: 'Nomor WhatsApp / Telepon',
            controller: _phoneController,
            icon: Icons.phone_iphone_rounded,
            keyboardType: TextInputType.phone,
            suffix: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'WhatsApp',
                style: TextStyle(
                  color: Color(0xFF047857),
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            validator: (value) {
              final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
              return digits.length >= 9
                  ? null
                  : 'Masukkan nomor telepon yang valid';
            },
          ),
          const SizedBox(height: 7),
          const Text(
            'Dipakai untuk pengiriman voucher tiket elektronik',
            style: TextStyle(color: _muted, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required Color iconBackground,
    Widget? trailing,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconBackground,
            shape: BoxShape.circle,
          ),
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
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: _navy,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ?suffix,
          ],
        ),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 19, color: const Color(0xFF94A3B8)),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: _blue, width: 1.4),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFDC2626)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _verifiedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD1FAE5)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_rounded, color: Color(0xFF059669), size: 12),
          SizedBox(width: 4),
          Text(
            'Terverifikasi',
            style: TextStyle(
              color: Color(0xFF047857),
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavorites() {
    final favorites = DestinationInfo.destinations
        .where((destination) => _favoriteIds.contains(destination.id))
        .toList();
    return _card(
      child: Column(
        children: [
          _sectionHeader(
            icon: Icons.favorite_rounded,
            title: 'Destinasi Favorit',
            subtitle: '${favorites.length} tersimpan',
            iconColor: const Color(0xFFE11D48),
            iconBackground: const Color(0xFFFFF1F2),
            trailing: TextButton(
              onPressed: () => _navigateToTab(1),
              child: const Text(
                'Kelola',
                style: TextStyle(
                  color: _blue,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (favorites.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Destinasi favorit yang kamu simpan akan tampil di sini.',
                style: TextStyle(color: _muted, fontSize: 11),
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
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: Image.asset(
              destination.image,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 9),
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
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  destination.area,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _muted, fontSize: 9),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Hapus ${destination.name} dari favorit',
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

  Widget _buildPreferences() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            icon: Icons.tune_rounded,
            title: 'Preferensi & Legalitas',
            subtitle: 'Pengaturan antarmuka & ketentuan resmi',
            iconColor: _navy,
            iconBackground: const Color(0xFFF1F5F9),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.fromLTRB(11, 8, 8, 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Row(
              children: [
                const Icon(Icons.language_rounded, color: _muted, size: 18),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Bahasa Antarmuka',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
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
          ),
          const SizedBox(height: 8),
          _legalAction(
            icon: Icons.description_outlined,
            title: 'Syarat & Ketentuan Layanan',
          ),
          _legalAction(
            icon: Icons.policy_outlined,
            title: 'Kebijakan Privasi JemberGo',
          ),
          _legalAction(
            icon: Icons.info_outline_rounded,
            title: 'Tentang Aplikasi JemberGo v1.2.0',
          ),
        ],
      ),
    );
  }

  Widget _legalAction({required IconData icon, required String title}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 2),
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
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: Color(0xFFCBD5E1),
        size: 20,
      ),
      onTap: () => _showMessage('$title akan segera tersedia.'),
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: FilledButton.icon(
            onPressed: _saveProfile,
            icon: const Icon(Icons.save_outlined, size: 19),
            label: const Text('Simpan Perubahan Profil'),
            style: FilledButton.styleFrom(
              backgroundColor: _navy,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(height: 9),
        SizedBox(
          width: double.infinity,
          height: 47,
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
        ),
      ],
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(15),
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

  ButtonStyle _outlineButtonStyle() {
    return OutlinedButton.styleFrom(
      foregroundColor: _navy,
      backgroundColor: const Color(0xFFF8FAFC),
      side: const BorderSide(color: Color(0xFFE2E8F0)),
      padding: const EdgeInsets.symmetric(vertical: 11),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
    );
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;
    AppData.profile.value = UserProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
    );
    _showMessage('Profil berhasil diperbarui.');
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar dari akun?'),
        content: const Text('Kamu bisa masuk kembali kapan saja.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
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
      _ => TicketsScreen(),
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
