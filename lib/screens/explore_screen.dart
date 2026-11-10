import 'package:flutter/material.dart';

import '../models/app_data.dart';
import 'destination_detail_screen.dart';
import 'home_screen.dart';
import 'map_screen.dart';
import 'profile_screen.dart';
import 'tickets_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({
    super.key,
    this.userName = 'Budi Santoso',
    this.userLocation = 'Jember, Jawa Timur',
  });

  final String userName;
  final String userLocation;

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  // Theme colors from JemberGo design system
  static const _navy = Color(0xFF0C192C);
  static const _background = Color(0xFFFAF8FF);
  static const _primaryBlue = Color(0xFF006194);
  static const _forestGreen = Color(0xFF006C49);
  static const _rose = Color(0xFFF43F5E);
  static const _amberStar = Color(0xFFFBBF24);
  static const _textDark = Color(0xFF131B2E);
  static const _textMuted = Color(0xFF64748B);
  static const _textSecondary = Color(0xFF3F4850);
  static const _borderSlate = Color(0xFFE2E8F0);
  static const _slateCardBorder = Color(0xFFF1F5F9);
  static const _tipBoxBg = Color(0xFFEAEDFF);
  static const _notifBg = Color(0xFFF2F3FF);
  static const _notifDot = Color(0xFFB90538);

  final TextEditingController _searchController = TextEditingController();
  final Set<String> _favoriteTitles = <String>{};

  String _searchQuery = '';
  String _selectedCategory = 'all';
  String _selectedSort = 'Terpopuler';

  static const _categories = [
    (id: 'all', label: 'Semua'),
    (id: 'alam', label: 'Wisata Alam'),
    (id: 'bahari', label: 'Wisata Bahari'),
    (id: 'buatan', label: 'Wisata Buatan'),
  ];

  static const _sortOptions = [
    'Terpopuler',
    'Rating Tertinggi',
    'Terdekat',
    'Harga Termurah',
  ];

  static const _allDestinations = [
    _DestinationItem(
      title: 'Pantai Tanjung Papuma',
      category: 'bahari',
      categoryLabel: 'Wisata Bahari',
      categoryIcon: Icons.sailing_rounded,
      categoryIconColor: _primaryBlue,
      image: 'assets/home/papuma_featured.jpg',
      rating: 4.9,
      reviews: '1.4k ulasan',
      distance: 34,
      location: 'Wuluhan • 34 km dari lokasi Anda',
      description: 'Gugusan karang megah Siti Inggil, deburan ombak selatan eksotis, dan hutan lindung monyet ekor panjang yang memesona.',
      price: 25000,
      priceFormatted: 'Rp 25.000',
    ),
    _DestinationItem(
      title: 'Air Terjun Tancak',
      category: 'alam',
      categoryLabel: 'Wisata Alam',
      categoryIcon: Icons.forest_rounded,
      categoryIconColor: _forestGreen,
      image: 'assets/home/air_terjun_tancak.jpg',
      rating: 4.9,
      reviews: '1.1k ulasan',
      distance: 16,
      location: 'Panti • 16 km dari lokasi Anda',
      description: 'Air terjun megah setinggi 82 meter di kaki lereng Gunung Argopuro dengan trekking kebun kopi aromatik segar.',
      price: 10000,
      priceFormatted: 'Rp 10.000',
    ),
    _DestinationItem(
      title: 'Teluk Love',
      category: 'bahari',
      categoryLabel: 'Wisata Bahari',
      categoryIcon: Icons.favorite_rounded,
      categoryIconColor: _rose,
      image: 'assets/home/teluk_love.jpg',
      rating: 4.8,
      reviews: '850 ulasan',
      distance: 28,
      location: 'Ambulu • 28 km dari lokasi Anda',
      description: 'Panorama teluk unik berbentuk lekukan hati saat dilihat dari Bukit Suroloyo dan deretan perahu nelayan tradisional.',
      price: 15000,
      priceFormatted: 'Rp 15.000',
    ),
    _DestinationItem(
      title: 'Puncak Rembangan',
      category: 'buatan',
      categoryLabel: 'Wisata Buatan',
      categoryIcon: Icons.landscape_rounded,
      categoryIconColor: _forestGreen,
      image: 'assets/home/puncak_rembangan.jpg',
      rating: 4.7,
      reviews: '620 ulasan',
      distance: 12,
      location: 'Arjasa • 12 km dari lokasi Anda',
      description: 'Kawasan sejuk 650 mdpl dengan kebun buah naga, kolam renang alami sumber pegunungan, dan kuliner pisang agung khas.',
      price: 20000,
      priceFormatted: 'Rp 20.000',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_DestinationItem> get _filteredAndSortedDestinations {
    var list = _allDestinations.where((item) {
      final matchesCategory =
          _selectedCategory == 'all' || item.category == _selectedCategory;
      final query = _searchQuery.trim().toLowerCase();
      final matchesQuery =
          query.isEmpty ||
          item.title.toLowerCase().contains(query) ||
          item.location.toLowerCase().contains(query) ||
          item.categoryLabel.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();

    switch (_selectedSort) {
      case 'Rating Tertinggi':
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Terdekat':
        list.sort((a, b) => a.distance.compareTo(b.distance));
        break;
      case 'Harga Termurah':
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Terpopuler':
      default:
        // Keep original curated order
        break;
    }

    return list;
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF6FFBBE),
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF283044),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 96),
          duration: const Duration(milliseconds: 2200),
        ),
      );
  }

  void _openDestination(_DestinationItem item) {
    final destination = DestinationInfo.find(item.title);
    if (destination == null) {
      _showToast('Detail ${item.title} belum tersedia.');
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DestinationDetailScreen(destination: destination),
      ),
    );
  }

  void _toggleFavorite(String title) {
    setState(() {
      if (_favoriteTitles.contains(title)) {
        _favoriteTitles.remove(title);
        _showToast('Dihapus dari daftar favorit');
      } else {
        _favoriteTitles.add(title);
        _showToast('Ditambahkan ke favorit!');
      }
    });
  }

  void _showSortModal() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    'Urutkan Berdasarkan',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: _navy,
                    ),
                  ),
                ),
                const Divider(height: 1, color: _slateCardBorder),
                for (final sort in _sortOptions)
                  ListTile(
                    onTap: () {
                      setState(() => _selectedSort = sort);
                      Navigator.pop(context);
                    },
                    leading: Icon(
                      _selectedSort == sort
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_off_rounded,
                      color: _selectedSort == sort ? _primaryBlue : _textMuted,
                      size: 20,
                    ),
                    title: Text(
                      sort,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: _selectedSort == sort
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: _selectedSort == sort ? _primaryBlue : _textDark,
                      ),
                    ),
                    trailing: _selectedSort == sort
                        ? const Icon(Icons.check, color: _primaryBlue, size: 18)
                        : null,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFilterModal() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filter Kategori',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: _navy,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _categories.map((cat) {
                        final isSelected = _selectedCategory == cat.id;
                        return ChoiceChip(
                          label: Text(cat.label),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() => _selectedCategory = cat.id);
                            setSheetState(() {});
                            Navigator.pop(context);
                          },
                          selectedColor: _navy,
                          backgroundColor: Colors.white,
                          side: BorderSide(
                            color: isSelected ? _navy : _borderSlate,
                          ),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : _textDark,
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _resetSearchAndFilter() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _selectedCategory = 'all';
      _selectedSort = 'Terpopuler';
    });
  }

  @override
  Widget build(BuildContext context) {
    final destinations = _filteredAndSortedDestinations;

    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        left: false,
        right: false,
        bottom: false,
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildHeader(),
                      const SizedBox(height: 16),
                      _buildHeroTitle(),
                      const SizedBox(height: 14),
                      _buildSearchBar(),
                      const SizedBox(height: 14),
                      _buildCategoryChips(),
                      const SizedBox(height: 14),
                      _buildSortTrigger(),
                      const SizedBox(height: 14),
                      if (destinations.isEmpty)
                        _buildEmptyState()
                      else
                        for (final item in destinations)
                          _buildDestinationCard(item),
                      const SizedBox(height: 10),
                      _buildMicroTipBox(),
                    ]),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: _buildBottomNavigation(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFCCE5FF), width: 2),
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/home/profile_avatar.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Halo, ',
                    style: TextStyle(
                      color: _textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  ValueListenableBuilder<UserProfile>(
                    valueListenable: AppData.profile,
                    builder: (context, profile, _) => Text(
                      profile.name,
                      style: const TextStyle(
                        color: _textDark,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.location_on, color: _primaryBlue, size: 13),
                  const SizedBox(width: 2),
                  Text(
                    widget.userLocation,
                    style: const TextStyle(
                      color: _textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Stack(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: _notifBg,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () => _showToast('Belum ada notifikasi baru'),
                tooltip: 'Notifikasi',
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: _textDark,
                  size: 20,
                ),
              ),
            ),
            Positioned(
              top: 9,
              right: 9,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _notifDot,
                  shape: BoxShape.circle,
                  border: Border.all(color: _background, width: 1.5),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeroTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Jelajahi Wisata',
          style: TextStyle(
            color: _textDark,
            fontSize: 27,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
            height: 1.2,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Temukan pesona laut selatan, air terjun lereng Argopuro & bukit asri Jember.',
          style: TextStyle(
            color: _textSecondary,
            fontSize: 13,
            height: 1.45,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          const Icon(Icons.search_rounded, color: _navy, size: 22),
          const SizedBox(width: 6),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() => _searchQuery = val);
              },
              style: const TextStyle(
                color: _navy,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                hintText: 'Cari pantai, air terjun, bukit...',
                hintStyle: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          if (_searchQuery.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Material(
              color: _navy,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: _showFilterModal,
                customBorder: const CircleBorder(),
                child: const SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.tune_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = cat.id == _selectedCategory;

          return InkWell(
            onTap: () {
              setState(() => _selectedCategory = cat.id);
            },
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? _navy : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isSelected ? _navy : _borderSlate),
                boxShadow: isSelected
                    ? const [
                        BoxShadow(
                          color: Color(0x1F0C192C),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  cat.label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF334155),
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSortTrigger() {
    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: _showSortModal,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _borderSlate),
            boxShadow: const [
              BoxShadow(
                color: Color(0x06000000),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.swap_vert_rounded,
                color: _primaryBlue,
                size: 16,
              ),
              const SizedBox(width: 5),
              Text(
                _selectedSort,
                style: const TextStyle(
                  color: _navy,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.expand_more_rounded,
                color: Color(0xFF94A3B8),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDestinationCard(_DestinationItem item) {
    final isFavorite = _favoriteTitles.contains(item.title);

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: _slateCardBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F0F172A),
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 10,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(item.image, fit: BoxFit.cover),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x33000000),
                          Colors.transparent,
                          Color(0xCC0F172A),
                        ],
                        stops: [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 5.5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x10000000),
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            item.categoryIcon,
                            size: 13,
                            color: item.categoryIconColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.categoryLabel,
                            style: const TextStyle(
                              color: _navy,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Material(
                      color: Colors.white.withValues(alpha: 0.92),
                      shape: const CircleBorder(),
                      child: InkWell(
                        onTap: () => _toggleFavorite(item.title),
                        customBorder: const CircleBorder(),
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Icon(
                            isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: isFavorite ? _rose : _navy,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 12,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4.5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: _amberStar,
                                size: 15,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                item.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(width: 3),
                              Text(
                                '(${item.reviews})',
                                style: const TextStyle(
                                  color: Color(0xCCFFFFFF),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4.5,
                          ),
                          decoration: BoxDecoration(
                            color: _navy.withValues(alpha: 0.82),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${item.distance} km',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: _navy,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: 15,
                        color: item.categoryIconColor,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _textMuted,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF475569),
                      fontSize: 12,
                      height: 1.45,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: _slateCardBorder,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'TIKET MASUK',
                            style: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                item.priceFormatted,
                                style: const TextStyle(
                                  color: _navy,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const Text(
                                ' / org',
                                style: TextStyle(
                                  color: _textMuted,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Material(
                        color: _navy,
                        borderRadius: BorderRadius.circular(24),
                        child: InkWell(
                          onTap: () => _openDestination(item),
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x240C192C),
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Lihat Detail',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ],
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
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: Color(0xFFE2E7FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.travel_explore_rounded,
              color: _primaryBlue,
              size: 38,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Destinasi Tidak Ditemukan',
            style: TextStyle(
              color: _navy,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Kami tidak dapat menemukan kata kunci tersebut. Coba telusuri nama pantai, air terjun, atau reset filter Anda.',
            textAlign: TextAlign.center,
            style: TextStyle(color: _textMuted, fontSize: 12, height: 1.45),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _resetSearchAndFilter,
            style: ElevatedButton.styleFrom(
              backgroundColor: _navy,
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
              elevation: 2,
            ),
            child: const Text(
              'Reset Pencarian',
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMicroTipBox() {
    return Container(
      margin: const EdgeInsets.only(top: 4, bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _tipBoxBg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.lightbulb_outline_rounded, color: _primaryBlue, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TIPS WISATAWAN',
                  style: TextStyle(
                    color: _primaryBlue,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Ingin suasana ombak tenang di Papuma? Kunjungi pada pagi hari pukul 06.00 - 09.00 WIB untuk menyaksikan perahu nelayan merapat dan matahari terbit.',
                  style: TextStyle(
                    color: _textSecondary,
                    fontSize: 12,
                    height: 1.45,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    const items = [
      (label: 'Beranda', icon: Icons.home_rounded, isExplore: false),
      (label: 'Jelajahi', icon: Icons.explore_rounded, isExplore: true),
      (label: 'Peta', icon: Icons.location_on_outlined, isExplore: false),
      (
        label: 'Tiket',
        icon: Icons.confirmation_number_outlined,
        isExplore: false,
      ),
      (label: 'Profil', icon: Icons.person_outline_rounded, isExplore: false),
    ];

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 360),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x18000000),
              blurRadius: 20,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (final item in items)
              _buildNavigationItem(
                label: item.label,
                icon: item.icon,
                isSelected: item.isExplore,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationItem({
    required String label,
    required IconData icon,
    required bool isSelected,
  }) {
    final color = isSelected ? _navy : const Color(0xFF9CA3AF);

    return InkWell(
      onTap: isSelected
          ? null
          : () {
              if (label == 'Beranda') {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else {
                  Navigator.of(context).pushReplacement(
                    PageRouteBuilder<void>(
                      pageBuilder: (context, _, _) =>
                          HomeScreen(userName: widget.userName),
                      transitionDuration: const Duration(milliseconds: 250),
                      transitionsBuilder: (context, animation, _, child) {
                        return FadeTransition(
                          opacity: CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInOutCubic,
                          ),
                          child: child,
                        );
                      },
                    ),
                  );
                }
              } else if (label == 'Peta') {
                Navigator.of(context).push(
                  PageRouteBuilder<void>(
                    pageBuilder: (context, _, _) =>
                        MapScreen(userName: AppData.profile.value.name),
                    transitionDuration: const Duration(milliseconds: 250),
                    reverseTransitionDuration: const Duration(
                      milliseconds: 200,
                    ),
                    transitionsBuilder: (context, animation, _, child) {
                      return FadeTransition(
                        opacity: CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeInOutCubic,
                          reverseCurve: Curves.easeInOutCubic,
                        ),
                        child: child,
                      );
                    },
                  ),
                );
              } else if (label == 'Tiket') {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const TicketsScreen(),
                  ),
                );
              } else if (label == 'Profil') {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const ProfileScreen(),
                  ),
                );
              }
            },
      borderRadius: BorderRadius.circular(28),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected ? _navy : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: isSelected ? 18 : 20,
                color: isSelected ? Colors.white : color,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 9.5,
                height: 1,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DestinationItem {
  const _DestinationItem({
    required this.title,
    required this.category,
    required this.categoryLabel,
    required this.categoryIcon,
    required this.categoryIconColor,
    required this.image,
    required this.rating,
    required this.reviews,
    required this.distance,
    required this.location,
    required this.description,
    required this.price,
    required this.priceFormatted,
  });

  final String title;
  final String category;
  final String categoryLabel;
  final IconData categoryIcon;
  final Color categoryIconColor;
  final String image;
  final double rating;
  final String reviews;
  final int distance;
  final String location;
  final String description;
  final int price;
  final String priceFormatted;
}
