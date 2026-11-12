import 'package:flutter/material.dart';

import '../models/app_data.dart';
import '../widgets/app_bottom_navigation.dart';
import 'destination_detail_screen.dart';
import 'explore_screen.dart';
import 'map_screen.dart';
import 'profile_screen.dart';
import 'tickets_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.userName = 'Budi Santoso'});

  final String userName;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _navy = Color(0xFF0B2341);
  static const _categories = [
    'Semua',
    'Wisata Alam',
    'Wisata Bahari',
    'Wisata Buatan',
  ];
  static const _featuredDestinations = {
    'Semua': _FeaturedDestination(
      name: 'Pantai Tanjung Papuma',
      area: 'Wuluhan, Jember',
      distance: '34 km',
      rating: '4.9',
      reviews: '1.4k',
      price: 'Rp 25.000',
      image: 'assets/home/papuma_featured.jpg',
    ),
    'Wisata Alam': _FeaturedDestination(
      name: 'Air Terjun Tancak',
      area: 'Panti, Jember',
      distance: '16 km',
      rating: '4.9',
      reviews: '1.1k',
      price: 'Rp 10.000',
      image: 'assets/home/air_terjun_tancak.jpg',
    ),
    'Wisata Bahari': _FeaturedDestination(
      name: 'Teluk Love',
      area: 'Ambulu, Jember',
      distance: '28 km',
      rating: '4.8',
      reviews: '850',
      price: 'Rp 15.000',
      image: 'assets/home/teluk_love.jpg',
    ),
    'Wisata Buatan': _FeaturedDestination(
      name: 'Puncak Rembangan',
      area: 'Arjasa, Jember',
      distance: '12 km',
      rating: '4.7',
      reviews: '620',
      price: 'Rp 20.000',
      image: 'assets/home/puncak_rembangan.jpg',
    ),
  };

  String _selectedCategory = 'Semua';
  bool _isFavorite = false;

  _FeaturedDestination get _featuredDestination =>
      _featuredDestinations[_selectedCategory]!;

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _isFavorite = false;
    });
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$feature segera hadir.')));
  }

  void _openExplore() {
    // ponytail: custom fade transition; upgrade to shared tab state if combining into single shell scaffold.
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        pageBuilder: (context, _, _) =>
            ExploreScreen(userName: AppData.profile.value.name),
        transitionDuration: const Duration(milliseconds: 250),
        reverseTransitionDuration: const Duration(milliseconds: 200),
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
  }

  void _openMap() {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        pageBuilder: (context, _, _) =>
            MapScreen(userName: AppData.profile.value.name),
        transitionDuration: const Duration(milliseconds: 250),
        reverseTransitionDuration: const Duration(milliseconds: 200),
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
  }

  void _openTickets() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const TicketsScreen()));
  }

  void _openProfile() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const ProfileScreen()));
  }

  void _openDestination(String name) {
    final destination = DestinationInfo.find(name);
    if (destination == null) {
      _showComingSoon('Detail $name');
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DestinationDetailScreen(destination: destination),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                      _buildGreeting(),
                      const SizedBox(height: 22),
                      const Text(
                        'Explore Your Dream\nWisata Jember Today',
                        style: TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 27,
                          height: 1.22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.65,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildCategories(),
                      const SizedBox(height: 22),
                      _buildFeaturedDestination(),
                      const SizedBox(height: 24),
                      _buildPopularDestinations(),
                      const SizedBox(height: 22),
                      _buildNearbyDestinations(),
                      const SizedBox(height: 18),
                      _buildSeeAllButton(),
                      const SizedBox(height: 20),
                      _buildArticles(),
                    ]),
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

  Widget _buildGreeting() {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFDBEAFE), width: 2),
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/home/profile_avatar.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome back!',
                style: TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              ValueListenableBuilder<UserProfile>(
                valueListenable: AppData.profile,
                builder: (context, profile, _) => Text(
                  profile.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => _showComingSoon('Notifikasi'),
          tooltip: 'Notifikasi',
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: Color(0xFFF1F5F9)),
            elevation: 1,
          ),
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: Color(0xFF374151),
            size: 21,
          ),
        ),
      ],
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          return ChoiceChip(
            label: Text(category),
            selected: isSelected,
            onSelected: (_) => _selectCategory(category),
            showCheckmark: false,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF6B7280),
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
            backgroundColor: const Color(0xFFF9FAFB),
            selectedColor: _navy,
            side: BorderSide(
              color: isSelected ? _navy : const Color(0xFFE5E7EB),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            shape: const StadiumBorder(),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedDestination() {
    final destination = _featuredDestination;

    return AspectRatio(
      aspectRatio: 4 / 4.7,
      child: GestureDetector(
        onTap: () => _openDestination(destination.name),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: Image.asset(
                  destination.image,
                  key: ValueKey(destination.image),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xCC000000)],
                    stops: [0.48, 1],
                  ),
                ),
              ),
              Positioned(
                top: 14,
                right: 14,
                child: Material(
                  color: Colors.white.withValues(alpha: 0.92),
                  shape: const CircleBorder(),
                  child: IconButton(
                    onPressed: () => setState(() => _isFavorite = !_isFavorite),
                    tooltip: _isFavorite
                        ? 'Hapus dari favorit'
                        : 'Simpan ke Favorit',
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite
                          ? const Color(0xFFEF4444)
                          : const Color(0xFF374151),
                      size: 19,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(15, 13, 14, 13),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.48),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 6,
                              children: [
                                _ratingBadge(destination.rating),
                                Text(
                                  '(${destination.reviews} ulasan)  •  📍 '
                                  '${destination.distance}',
                                  style: TextStyle(
                                    color: Color(0xFFD1D5DB),
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              destination.name,
                              key: const ValueKey('featured-destination-name'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              destination.area,
                              style: const TextStyle(
                                color: Color(0xFFE5E7EB),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'Per tiket',
                            style: TextStyle(
                              color: Color(0xFFD1D5DB),
                              fontSize: 10,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            destination.price,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ratingBadge(String rating) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '★ $rating',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildPopularDestinations() {
    const destinations = [
      _Destination(
        name: 'Teluk Love',
        area: 'Ambulu',
        distance: '28 km',
        rating: '4.8',
        reviews: '(850)',
        image: 'assets/home/teluk_love.jpg',
      ),
      _Destination(
        name: 'Air Terjun Tancak',
        area: 'Panti',
        distance: '16 km',
        rating: '4.9',
        reviews: '(1.1k)',
        image: 'assets/home/air_terjun_tancak.jpg',
      ),
      _Destination(
        name: 'Puncak Rembangan',
        area: 'Arjasa',
        distance: '12 km',
        rating: '4.7',
        reviews: '(620)',
        image: 'assets/home/puncak_rembangan.jpg',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          title: 'Destinasi Populer',
          subtitle: 'Rekomendasi terbaik di Jember',
          action: 'Lihat Semua',
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 166,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: destinations.length,
            separatorBuilder: (_, _) => const SizedBox(width: 14),
            itemBuilder: (context, index) =>
                _buildDestinationCard(destinations[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildDestinationCard(_Destination destination) {
    return SizedBox(
      width: 144,
      child: InkWell(
        onTap: () => _openDestination(destination.name),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 112,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(destination.image, fit: BoxFit.cover),
                  ),
                  Positioned(
                    bottom: 7,
                    left: 7,
                    child: _ratingBadge(destination.rating),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 7),
            Text(
              destination.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF111827),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 3),
            Row(
              children: [
                Expanded(
                  child: Text(
                    destination.area,
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 11,
                    ),
                  ),
                ),
                Text(
                  destination.distance,
                  style: const TextStyle(
                    color: Color(0xFF0284C7),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader({
    required String title,
    String? subtitle,
    String? action,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 11,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (action != null)
          TextButton(
            onPressed: action == 'Lihat Semua'
                ? _openExplore
                : () => _showComingSoon(action),
            style: TextButton.styleFrom(
              foregroundColor: _navy,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: Row(
              children: [
                Text(action),
                const SizedBox(width: 2),
                const Icon(Icons.chevron_right, size: 16),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildNearbyDestinations() {
    const nearby = [
      _NearbyDestination(
        name: 'Taman Botani Sukorambi',
        area: 'Sukorambi, Jember',
        time: '~12 mnt',
        rating: '4.6',
        reviews: '(480 ulasan)',
        distance: '4.2 km',
        image: 'assets/home/teluk_love.jpg',
      ),
      _NearbyDestination(
        name: 'Agrowisata Kebun Kopi Jember',
        area: 'Patrang, Jember',
        time: '~18 mnt',
        rating: '4.7',
        reviews: '(312 ulasan)',
        distance: '6.8 km',
        image: 'assets/home/puncak_rembangan.jpg',
      ),
    ];

    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.circle, size: 9, color: Color(0xFF10B981)),
            const SizedBox(width: 7),
            const Expanded(
              child: Text(
                'Destinasi Terdekat (GPS)',
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F9FF),
                border: Border.all(color: const Color(0xFFE0F2FE)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Lokasi Aktif',
                style: TextStyle(
                  color: Color(0xFF0284C7),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (var index = 0; index < nearby.length; index++) ...[
          _buildNearbyCard(nearby[index]),
          if (index != nearby.length - 1) const SizedBox(height: 9),
        ],
      ],
    );
  }

  Widget _buildNearbyCard(_NearbyDestination destination) {
    return Material(
      color: const Color(0xFFF9FAFB),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: () => _openDestination(destination.name),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  destination.image,
                  width: 56,
                  height: 56,
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
                        color: Color(0xFF111827),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${destination.area}  •  ${destination.time}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '★ ${destination.rating}   ${destination.reviews}',
                      style: const TextStyle(
                        color: Color(0xFF9A6700),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0x0D0B2341),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  destination.distance,
                  style: const TextStyle(
                    color: _navy,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeeAllButton() {
    return OutlinedButton.icon(
      onPressed: _openExplore,
      style: OutlinedButton.styleFrom(
        foregroundColor: _navy,
        backgroundColor: const Color(0xFFF9FAFB),
        side: const BorderSide(color: Color(0xFFE5E7EB)),
        minimumSize: const Size.fromHeight(46),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      ),
      iconAlignment: IconAlignment.end,
      icon: const Icon(Icons.arrow_forward, size: 16),
      label: const Text('Lihat Semua Destinasi Wisata'),
    );
  }

  Widget _buildArticles() {
    const articles = [
      _Article(
        category: 'Tips Wisata • 24 Okt 2024',
        title: 'Panduan Lengkap Eksplorasi Tanjung Papuma dan Spot Foto Sunrise Terbaik',
        image: 'assets/home/papuma_featured.jpg',
      ),
      _Article(
        category: 'Eksplorasi • 21 Okt 2024',
        title: 'Merasakan Kesegaran Alami Air Terjun Tancak di Kaki Gunung Argopuro',
        image: 'assets/home/air_terjun_tancak.jpg',
      ),
    ];

    return Column(
      children: [
        _sectionHeader(title: 'Artikel Wisata Terbaru', action: 'Semua'),
        const SizedBox(height: 12),
        for (var index = 0; index < articles.length; index++) ...[
          _buildArticleCard(articles[index]),
          if (index != articles.length - 1) const SizedBox(height: 9),
        ],
      ],
    );
  }

  Widget _buildArticleCard(_Article article) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: () => _showComingSoon('Artikel wisata'),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFF3F4F6)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x08000000),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  article.image,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.category,
                      style: const TextStyle(
                        color: Color(0xFF0284C7),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 12,
                        height: 1.3,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return AppBottomNavigationDock(
      selectedIndex: 0,
      onSelected: (index) {
        switch (index) {
          case 1:
            _openExplore();
          case 2:
            _openMap();
          case 3:
            _openTickets();
          case 4:
            _openProfile();
        }
      },
    );
  }
}

class _Destination {
  const _Destination({
    required this.name,
    required this.area,
    required this.distance,
    required this.rating,
    required this.reviews,
    required this.image,
  });

  final String name;
  final String area;
  final String distance;
  final String rating;
  final String reviews;
  final String image;
}

class _FeaturedDestination {
  const _FeaturedDestination({
    required this.name,
    required this.area,
    required this.distance,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.image,
  });

  final String name;
  final String area;
  final String distance;
  final String rating;
  final String reviews;
  final String price;
  final String image;
}

class _NearbyDestination {
  const _NearbyDestination({
    required this.name,
    required this.area,
    required this.time,
    required this.rating,
    required this.reviews,
    required this.distance,
    required this.image,
  });

  final String name;
  final String area;
  final String time;
  final String rating;
  final String reviews;
  final String distance;
  final String image;
}

class _Article {
  const _Article({
    required this.category,
    required this.title,
    required this.image,
  });

  final String category;
  final String title;
  final String image;
}
