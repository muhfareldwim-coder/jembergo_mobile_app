import 'package:flutter/material.dart';
import 'package:jembergo_mobile_app/models/app_data.dart';

class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen({super.key});

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  static const _navy = Color(0xFF0C192C);
  static const _blue = Color(0xFF006194);
  static const _muted = Color(0xFF64748B);

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  final Set<String> _favoriteIds = {'papuma', 'rembangan'};
  bool _showAvatar = true;

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
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                children: [
                  _buildPhotoCard(),
                  const SizedBox(height: 16),
                  _buildPersonalInfoCard(),
                  const SizedBox(height: 16),
                  _buildFavoritesCard(),
                  const SizedBox(height: 16),
                  _buildPreferencesCard(),
                  const SizedBox(height: 18),
                  _buildActions(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        border: const Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080C192C),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
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
            icon: const Icon(Icons.arrow_back_rounded, size: 20),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit & Detail Profil',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
          const SizedBox(width: 8),
          Image.asset(
            'assets/logo jembergonobackgroud.png',
            width: 52,
            height: 34,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoCard() {
    return _card(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF1F5F9),
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 4),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x100C192C),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: _showAvatar
                      ? Image.asset(
                          'assets/home/profile_avatar.jpg',
                          fit: BoxFit.cover,
                        )
                      : const Icon(
                          Icons.person_rounded,
                          color: Color(0xFF94A3B8),
                          size: 48,
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
                      'Pemilihan foto dari galeri akan segera tersedia.',
                    ),
                    constraints: const BoxConstraints.tightFor(
                      width: 34,
                      height: 34,
                    ),
                    icon: const Icon(
                      Icons.photo_camera_rounded,
                      color: Colors.white,
                      size: 17,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _nameController,
            builder: (context, value, _) => Text(
              value.text.isEmpty ? 'Nama Pengguna' : value.text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _navy,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showMessage(
                    'Pemilihan foto dari galeri akan segera tersedia.',
                  ),
                  icon: const Icon(
                    Icons.add_photo_alternate_rounded,
                    color: _blue,
                    size: 19,
                  ),
                  label: const Text('Pilih Galeri'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _navy,
                    backgroundColor: const Color(0xFFF8FAFC),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => setState(() => _showAvatar = false),
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Color(0xFFDC2626),
                    size: 19,
                  ),
                  label: const Text('Hapus Foto'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFB91C1C),
                    backgroundColor: const Color(0xFFFFF7F7),
                    side: const BorderSide(color: Color(0xFFFECACA)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
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
        ],
      ),
    );
  }

  Widget _buildPersonalInfoCard() {
    return _card(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeading(
              icon: Icons.badge_outlined,
              title: 'Informasi Pribadi',
              subtitle: 'Perbarui identitas untuk pemesanan tiket wisata',
              iconColor: _blue,
              iconBackground: const Color(0xFFEFF6FF),
            ),
            const SizedBox(height: 16),
            _formField(
              label: 'Nama Lengkap',
              controller: _nameController,
              icon: Icons.person_outline_rounded,
              hint: 'Masukkan nama lengkap',
              validator: (value) => value == null || value.trim().length < 2
                  ? 'Masukkan nama lengkap'
                  : null,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 13),
            _formField(
              label: 'Alamat Email',
              controller: _emailController,
              icon: Icons.mail_outline_rounded,
              hint: 'alamat@email.com',
              keyboardType: TextInputType.emailAddress,
              badge: _statusBadge(
                'Terverifikasi',
                color: const Color(0xFF047857),
                background: const Color(0xFFECFDF5),
                icon: Icons.check_circle_rounded,
              ),
              validator: (value) {
                final email = value?.trim() ?? '';
                return RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email)
                    ? null
                    : 'Masukkan alamat email yang valid';
              },
            ),
            const SizedBox(height: 13),
            _formField(
              label: 'Nomor WhatsApp / Telepon',
              controller: _phoneController,
              icon: Icons.phone_iphone_rounded,
              hint: '+62 8xx-xxxx-xxxx',
              keyboardType: TextInputType.phone,
              badge: _statusBadge(
                'WhatsApp',
                color: const Color(0xFF047857),
                background: const Color(0xFFECFDF5),
              ),
              helperText: 'Dipakai untuk pengiriman voucher tiket elektronik',
              validator: (value) {
                final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
                return digits.length >= 9
                    ? null
                    : 'Masukkan nomor telepon yang valid';
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesCard() {
    final favorites = DestinationInfo.destinations
        .where((destination) => _favoriteIds.contains(destination.id))
        .toList();

    return _card(
      child: Column(
        children: [
          _sectionHeading(
            icon: Icons.favorite_rounded,
            title: 'Destinasi Favorit',
            subtitle: '${favorites.length} Tersimpan',
            iconColor: const Color(0xFFF43F5E),
            iconBackground: const Color(0xFFFFF1F2),
            trailing: TextButton(
              onPressed: () => _showMessage('Daftar destinasi favorit.'),
              child: const Text(
                'Kelola Cepat',
                style: TextStyle(
                  color: _blue,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          if (favorites.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Text(
                'Belum ada destinasi favorit.',
                style: TextStyle(color: _muted, fontSize: 12),
              ),
            )
          else
            for (final destination in favorites) ...[
              _favoriteTile(destination),
              if (destination != favorites.last) const SizedBox(height: 9),
            ],
        ],
      ),
    );
  }

  Widget _favoriteTile(DestinationInfo destination) {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFE8EDF3)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              destination.image,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 11),
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
                const SizedBox(height: 4),
                Text(
                  destination.area,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _muted, fontSize: 11),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Hapus ${destination.name}',
            onPressed: () =>
                setState(() => _favoriteIds.remove(destination.id)),
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: Color(0xFF94A3B8),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeading(
            icon: Icons.tune_rounded,
            title: 'Preferensi & Legalitas',
            subtitle: 'Pengaturan antarmuka & ketentuan resmi',
            iconColor: _navy,
            iconBackground: const Color(0xFFF1F5F9),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE8EDF3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.language_rounded, color: _muted, size: 19),
                const SizedBox(width: 9),
                const Expanded(
                  child: Text(
                    'Bahasa Antarmuka',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
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
                  style: const ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    textStyle: WidgetStatePropertyAll(
                      TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _legalTile(
            icon: Icons.description_outlined,
            title: 'Syarat & Ketentuan Layanan',
          ),
          _legalTile(
            icon: Icons.policy_outlined,
            title: 'Kebijakan Privasi JemberGo',
          ),
          _legalTile(
            icon: Icons.info_outline_rounded,
            title: 'Tentang Aplikasi JemberGo v1.2.0',
          ),
        ],
      ),
    );
  }

  Widget _legalTile({required IconData icon, required String title}) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 4),
        dense: true,
        leading: Icon(icon, color: const Color(0xFF94A3B8), size: 20),
        title: Text(
          title,
          style: const TextStyle(
            color: _navy,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: Color(0xFFCBD5E1),
        ),
        onTap: () => _showMessage('$title akan segera tersedia.'),
      ),
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 54,
          child: FilledButton.icon(
            onPressed: _saveProfile,
            icon: const Icon(Icons.save_outlined, size: 19),
            label: const Text('Simpan Perubahan Profil'),
            style: FilledButton.styleFrom(
              backgroundColor: _navy,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17),
              ),
              elevation: 2,
              textStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            onPressed: _confirmLogout,
            icon: const Icon(Icons.logout_rounded, size: 19),
            label: const Text('Logout / Keluar dari Akun'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFDC2626),
              backgroundColor: Colors.white,
              side: const BorderSide(color: Color(0xFFFECACA)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17),
              ),
              textStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionHeading({
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
          width: 34,
          height: 34,
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
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(color: _muted, fontSize: 10),
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
    required String hint,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    Widget? badge,
    String? helperText,
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
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ?badge,
          ],
        ),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: const Color(0xFF94A3B8), size: 19),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: _blue, width: 1.4),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: Color(0xFFDC2626)),
            ),
          ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              helperText,
              style: const TextStyle(color: _muted, fontSize: 10),
            ),
          ),
        ],
      ],
    );
  }

  Widget _statusBadge(
    String text, {
    required Color color,
    required Color background,
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: color, size: 13),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
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

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;
    AppData.profile.value = UserProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
    );
    Navigator.of(context).pop(true);
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
}
