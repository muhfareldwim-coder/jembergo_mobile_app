import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/app_data.dart';
import '../widgets/app_bottom_navigation.dart';
import 'destination_detail_screen.dart';
import 'explore_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'tickets_screen.dart';
import '../services/route_estimate_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.userName = 'Budi Santoso',
    this.initialDestinationId,
  });

  final String userName;
  final String? initialDestinationId;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapDestination {
  const _MapDestination({
    required this.id,
    required this.name,
    required this.category,
    required this.categoryLabel,
    required this.lat,
    required this.lon,
    required this.area,
    required this.rating,
    required this.reviews,
    required this.priceFormatted,
    required this.image,
    required this.description,
    required this.icon,
    required this.iconColor,
  });

  final String id;
  final String name;
  final String category;
  final String categoryLabel;
  final double lat;
  final double lon;
  final String area;
  final double rating;
  final String reviews;
  final String priceFormatted;
  final String? image;
  final String description;
  final IconData icon;
  final Color iconColor;
}

class _MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {
  static const _navy = Color(0xFF0B2341);
  static const _primaryBlue = Color(0xFF0284C7);
  static const _forestGreen = Color(0xFF059669);
  static const _rose = Color(0xFFE11D48);

  static const _destinations = [
    _MapDestination(
      id: 'papuma',
      name: 'Pantai Tanjung Papuma',
      category: 'bahari',
      categoryLabel: 'Wisata Bahari',
      lat: -8.4325,
      lon: 113.5544,
      area: 'Kec. Wuluhan, Jember Selatan',
      rating: 4.9,
      reviews: '1.4k ulasan',
      priceFormatted: 'Rp 25.000',
      image: 'assets/home/papuma_featured.jpg',
      description: 'Gugusan karang megah Siti Inggil, deburan ombak selatan eksotis, dan hutan lindung monyet ekor panjang yang memesona.',
      icon: Icons.beach_access_rounded,
      iconColor: _primaryBlue,
    ),
    _MapDestination(
      id: 'tancak',
      name: 'Air Terjun Tancak',
      category: 'alam',
      categoryLabel: 'Wisata Alam',
      lat: -8.1189,
      lon: 113.5786,
      area: 'Kec. Panti, Lereng Argopuro',
      rating: 4.9,
      reviews: '1.1k ulasan',
      priceFormatted: 'Rp 10.000',
      image: 'assets/home/air_terjun_tancak.jpg',
      description: 'Air terjun megah setinggi 82 meter di kaki lereng Gunung Argopuro dengan trekking kebun kopi aromatik segar.',
      icon: Icons.waterfall_chart_rounded,
      iconColor: _forestGreen,
    ),
    _MapDestination(
      id: 'teluk-love',
      name: 'Teluk Love',
      category: 'bahari',
      categoryLabel: 'Wisata Bahari',
      lat: -8.4239,
      lon: 113.5936,
      area: 'Kec. Ambulu, Jember Selatan',
      rating: 4.8,
      reviews: '850 ulasan',
      priceFormatted: 'Rp 15.000',
      image: 'assets/home/teluk_love.jpg',
      description: 'Panorama teluk unik berbentuk lekukan hati saat dilihat dari Bukit Suroloyo dan deretan perahu nelayan tradisional.',
      icon: Icons.favorite_rounded,
      iconColor: _rose,
    ),
    _MapDestination(
      id: 'rembangan',
      name: 'Puncak Rembangan',
      category: 'buatan',
      categoryLabel: 'Wisata Buatan',
      lat: -8.1008,
      lon: 113.7228,
      area: 'Kec. Arjasa, Jember Utara',
      rating: 4.7,
      reviews: '620 ulasan',
      priceFormatted: 'Rp 20.000',
      image: 'assets/home/puncak_rembangan.jpg',
      description: 'Kawasan sejuk 650 mdpl dengan kebun buah naga, kolam renang alami sumber pegunungan, dan kuliner pisang agung khas.',
      icon: Icons.landscape_rounded,
      iconColor: _forestGreen,
    ),
  ];

  final _searchController = TextEditingController();
  final _routeEstimateService = RouteEstimateService();
  String _searchQuery = '';
  List<_MapDestination> _searchResults = [];
  bool _isSearching = false;
  String? _searchStatusMessage;
  int _searchRequestId = 0;
  DateTime? _lastSearchAt;
  late _MapDestination _selectedDestination;

  Position? _currentPosition;
  bool _isLocating = true;
  bool _isGpsActive = false;
  bool _isLoadingRoute = false;
  String? _routeStatusMessage;
  bool _isRouteEstimate = false;
  int _routeRequestId = 0;
  double _routeDistanceKm = 0;
  int _routeDurationMinutes = 0;
  String _routeViaSummary = 'Menunggu lokasi perangkat';
  List<LatLng> _routePoints = [];

  final MapController _mapController = MapController();
  bool _isMapReady = false;

  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _selectedDestination = _destinations.firstWhere(
      (d) => d.id == widget.initialDestinationId,
      orElse: () => _destinations.first,
    );

    _loadCurrentLocation();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _searchController.dispose();
    _routeEstimateService.close();
    super.dispose();
  }

  List<_MapDestination> get _visibleDestinations {
    final destinations = [
      ..._destinations,
      ..._searchResults,
      if (!_destinations.any((item) => item.id == _selectedDestination.id) &&
          !_searchResults.any((item) => item.id == _selectedDestination.id))
        _selectedDestination,
    ];
    return destinations.where((item) {
      final query = _searchQuery.trim().toLowerCase();
      return query.isEmpty ||
          (item.id == _selectedDestination.id && item.id.startsWith('osm-')) ||
          item.name.toLowerCase().contains(query) ||
          item.area.toLowerCase().contains(query) ||
          item.categoryLabel.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> _loadCurrentLocation() async {
    setState(() {
      _isLocating = true;
      _isGpsActive = false;
      _routeStatusMessage = null;
    });

    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        _setLocationUnavailable('Aktifkan layanan lokasi untuk melihat rute.');
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _setLocationUnavailable(
          'Izin lokasi diperlukan untuk membuat rute dari posisi Anda.',
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 12),
        ),
      );
      if (!mounted) return;

      setState(() {
        _currentPosition = position;
        _isLocating = false;
        _isGpsActive = true;
        _routeStatusMessage = null;
        _routeViaSummary = 'Menghitung rute dari lokasi Anda';
      });
      if (_isMapReady) {
        _mapController.move(LatLng(position.latitude, position.longitude), 13);
      }
      _calculateOsrmRoute();
    } on Exception catch (error) {
      _setLocationUnavailable('Lokasi perangkat tidak dapat diakses: $error');
    }
  }

  void _setLocationUnavailable(String message) {
    if (!mounted) return;
    setState(() {
      _isLocating = false;
      _isGpsActive = false;
      _routeStatusMessage = message;
      _routeViaSummary = 'Lokasi perangkat belum tersedia';
      _routePoints = [];
      _isLoadingRoute = false;
    });
  }

  Future<void> _calculateOsrmRoute() async {
    final position = _currentPosition;
    if (position == null) return;

    final requestId = ++_routeRequestId;
    final destination = _selectedDestination;
    setState(() {
      _isLoadingRoute = true;
      _routeStatusMessage = null;
      _routeViaSummary = 'Menghitung rute dari lokasi Anda';
      _routeDistanceKm = 0;
      _routeDurationMinutes = 0;
      _routePoints = [];
      _isRouteEstimate = false;
    });

    try {
      final estimate = await _routeEstimateService.estimate(
        origin: LatLng(position.latitude, position.longitude),
        destination: LatLng(destination.lat, destination.lon),
      );
      if (mounted && requestId == _routeRequestId) {
        setState(() {
          _routeDistanceKm = double.parse(
            (estimate.distanceMeters / 1000.0).toStringAsFixed(1),
          );
          _routeDurationMinutes = (estimate.durationSeconds / 60.0).round();
          _routeViaSummary = 'Rute berkendara dari OSRM';
          _routePoints = estimate.routePoints;
          _isRouteEstimate = true;
          _routeStatusMessage = null;
          _isLoadingRoute = false;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && requestId == _routeRequestId) _fitRoute();
        });
      }
    } on TimeoutException {
      _setRouteFailure(
        requestId,
        'Layanan rute terlalu lama merespons. Coba lagi.',
      );
    } on FormatException catch (error) {
      _setRouteFailure(requestId, error.message);
    } on Exception {
      _setRouteFailure(
        requestId,
        'Koneksi ke layanan rute gagal. Periksa jaringan lalu coba lagi.',
      );
    } finally {
      if (mounted && requestId == _routeRequestId && _isLoadingRoute) {
        setState(() => _isLoadingRoute = false);
      }
    }
  }

  void _setRouteFailure(int requestId, String message) {
    if (!mounted || requestId != _routeRequestId) return;
    setState(() {
      _routeStatusMessage = message;
      _isLoadingRoute = false;
    });
  }

  Future<void> _startNavigation(_MapDestination destination) async {
    final position = _currentPosition;
    final parameters = <String, String>{
      'api': '1',
      'destination': '${destination.lat},${destination.lon}',
      'travelmode': 'driving',
      'dir_action': 'navigate',
    };
    if (position != null) {
      parameters['origin'] = '${position.latitude},${position.longitude}';
    }
    final uri = Uri.https('www.google.com', '/maps/dir/', parameters);

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && mounted) {
        _showRouteLaunchError();
      }
    } on Exception {
      if (mounted) _showRouteLaunchError();
    }
  }

  void _showRouteLaunchError() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            'Navigasi tidak dapat dibuka. Coba lagi atau periksa aplikasi peta.',
          ),
        ),
      );
  }

  void _selectDestination(_MapDestination destination) {
    setState(() {
      _selectedDestination = destination;
      _searchResults = [];
      _searchStatusMessage = null;
    });
    if (_currentPosition == null && _isMapReady) {
      _mapController.move(LatLng(destination.lat, destination.lon), 12);
    }
    _calculateOsrmRoute();
  }

  void _handleSearchChanged(String value) {
    ++_searchRequestId;
    final query = value.trim().toLowerCase();
    _MapDestination? matchingDestination;
    if (query.isNotEmpty) {
      for (final destination in _destinations) {
        if (destination.name.toLowerCase().contains(query) ||
            destination.area.toLowerCase().contains(query) ||
            destination.categoryLabel.toLowerCase().contains(query)) {
          matchingDestination = destination;
          break;
        }
      }
    }

    final destinationChanged =
        matchingDestination != null &&
        matchingDestination.id != _selectedDestination.id;
    setState(() {
      _searchQuery = value;
      _isSearching = false;
      _searchResults = [];
      _searchStatusMessage = null;
      if (destinationChanged) {
        _selectedDestination = matchingDestination!;
      }
    });

    if (destinationChanged) {
      if (_currentPosition == null && _isMapReady) {
        _mapController.move(
          LatLng(matchingDestination.lat, matchingDestination.lon),
          12,
        );
      }
      _calculateOsrmRoute();
    }
  }

  Future<void> _searchPlaces(String value) async {
    final query = value.trim();
    if (query.isEmpty || _isSearching) return;

    final requestId = ++_searchRequestId;
    setState(() {
      _isSearching = true;
      _searchStatusMessage = null;
      _searchResults = [];
    });

    HttpClient? client;
    try {
      final lastSearchAt = _lastSearchAt;
      if (lastSearchAt != null) {
        final wait =
            const Duration(seconds: 1) -
            DateTime.now().difference(lastSearchAt);
        if (wait > Duration.zero) await Future<void>.delayed(wait);
      }
      if (!mounted || requestId != _searchRequestId) return;
      _lastSearchAt = DateTime.now();

      client = HttpClient()..connectionTimeout = const Duration(seconds: 5);
      final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
        'format': 'jsonv2',
        'q': '$query, Jember, Jawa Timur, Indonesia',
        'countrycodes': 'id',
        'viewbox': '113.30,-7.95,114.05,-8.70',
        'bounded': '1',
        'limit': '5',
        'addressdetails': '1',
      });
      final request = await client.getUrl(uri);
      request.headers
        ..set('User-Agent', 'JemberGo/1.0 (Mobile App; OpenStreetMap)')
        ..set('Accept', 'application/json');
      final response = await request.close().timeout(
        const Duration(seconds: 8),
      );
      if (response.statusCode != HttpStatus.ok) {
        throw HttpException(
          'Nominatim returned ${response.statusCode}',
          uri: uri,
        );
      }

      final body = await response.transform(utf8.decoder).join();
      final data = jsonDecode(body);
      if (data is! List<dynamic>) {
        throw const FormatException('Nominatim returned invalid results.');
      }

      final results = <_MapDestination>[];
      for (final item in data) {
        if (item is! Map<String, dynamic>) continue;
        final lat = double.tryParse(item['lat']?.toString() ?? '');
        final lon = double.tryParse(item['lon']?.toString() ?? '');
        if (lat == null ||
            lon == null ||
            !lat.isFinite ||
            !lon.isFinite ||
            lat < -90 ||
            lat > 90 ||
            lon < -180 ||
            lon > 180) {
          continue;
        }

        final displayName = item['display_name'] as String? ?? query;
        final name =
            item['name'] as String? ?? displayName.split(',').first.trim();
        final category = item['category'] as String? ?? '';
        final type = item['type'] as String? ?? '';
        final isCoastal = '$category $type'.toLowerCase().contains(
          RegExp(r'beach|coast|water|bay|sea|marina'),
        );
        final address = item['address'] as Map<String, dynamic>? ?? {};
        final area =
            address['subdistrict'] as String? ??
            address['district'] as String? ??
            address['city'] as String? ??
            address['town'] as String? ??
            displayName.split(',').skip(1).take(2).join(',').trim();

        results.add(
          _MapDestination(
            id: 'osm-${item['osm_type'] ?? 'place'}-${item['osm_id'] ?? name}',
            name: name,
            category: isCoastal ? 'bahari' : 'alam',
            categoryLabel: isCoastal ? 'Wisata Bahari' : 'Wisata Alam',
            lat: lat,
            lon: lon,
            area: area.isEmpty ? 'Jember, Jawa Timur' : area,
            rating: 0,
            reviews: 'Belum ada ulasan',
            priceFormatted: 'Lihat lokasi',
            image: null,
            description: displayName,
            icon: isCoastal ? Icons.beach_access_rounded : Icons.place_rounded,
            iconColor: isCoastal ? _primaryBlue : _forestGreen,
          ),
        );
      }

      if (!mounted || requestId != _searchRequestId) return;
      setState(() {
        _searchResults = results;
        _isSearching = false;
        _searchStatusMessage = results.isEmpty
            ? 'Lokasi wisata tidak ditemukan di sekitar Jember.'
            : null;
      });
    } on SocketException {
      _setSearchFailure(
        requestId,
        'Koneksi jaringan gagal saat mencari lokasi.',
      );
    } on TimeoutException {
      _setSearchFailure(requestId, 'Pencarian terlalu lama. Coba lagi.');
    } on HttpException {
      _setSearchFailure(
        requestId,
        'Layanan pencarian sedang tidak tersedia. Coba lagi nanti.',
      );
    } on FormatException {
      _setSearchFailure(requestId, 'Data pencarian tidak valid. Coba lagi.');
    } finally {
      client?.close(force: true);
    }
  }

  void _setSearchFailure(int requestId, String message) {
    if (!mounted || requestId != _searchRequestId) return;
    setState(() {
      _isSearching = false;
      _searchStatusMessage = message;
    });
  }

  void _recenterToGps() {
    _loadCurrentLocation();
  }

  void _resetRoute() {
    setState(() {
      _selectedDestination = _destinations.first;
      _searchController.clear();
      _searchQuery = '';
    });
    if (_isMapReady) {
      _mapController.move(const LatLng(-8.25, 113.66), 9.5);
    }
    _calculateOsrmRoute();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Pilihan rute berhasil diatur ulang ke default.'),
          duration: Duration(seconds: 2),
        ),
      );
  }

  void _zoomIn() {
    if (!_isMapReady) return;
    final camera = _mapController.camera;
    _mapController.move(camera.center, math.min(camera.zoom + 1, 18));
  }

  void _zoomOut() {
    if (!_isMapReady) return;
    final camera = _mapController.camera;
    _mapController.move(camera.center, math.max(camera.zoom - 1, 6));
  }

  void _fitRoute() {
    if (!_isMapReady || _routePoints.length < 2) return;
    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: LatLngBounds.fromPoints(_routePoints),
        padding: const EdgeInsets.fromLTRB(40, 150, 48, 110),
        maxZoom: 13,
      ),
    );
  }

  void _openDestinationDetail(_MapDestination destination) {
    final info =
        DestinationInfo.find(destination.id) ??
        DestinationInfo(
          id: destination.id,
          name: destination.name,
          area: destination.area,
          category: destination.categoryLabel,
          price: 0,
          image: destination.image ?? 'assets/home/papuma_featured.jpg',
          rating: destination.rating,
          reviews: destination.reviews,
          description: destination.description,
          latitude: destination.lat,
          longitude: destination.lon,
          distanceKm: 0,
        );
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DestinationDetailScreen(destination: info),
      ),
    );
  }

  void _navigatePage(Widget targetPage) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (context, _, _) => targetPage,
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

  @override
  Widget build(BuildContext context) {
    final visibleDestinations = _visibleDestinations;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        left: false,
        right: false,
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildMapViewportContainer(visibleDestinations),
                        const SizedBox(height: 14),
                        _buildDestinationCard(),
                      ],
                    ),
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: Row(
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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Halo, ',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    ValueListenableBuilder<UserProfile>(
                      valueListenable: AppData.profile,
                      builder: (context, profile, _) => Text(
                        profile.name,
                        style: const TextStyle(
                          color: Color(0xFF0F172A),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                const Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 14,
                      color: _primaryBlue,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Peta Wisata Jember, Jawa Timur',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tidak ada notifikasi baru.')),
              );
            },
            icon: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF0F172A),
            ),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFF8FAFC),
              side: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapViewportContainer(List<_MapDestination> filtered) {
    return Container(
      constraints: const BoxConstraints(minHeight: 460),
      height: 460,
      decoration: BoxDecoration(
        color: const Color(0xFFE5EDF0),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          fit: StackFit.expand,
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: const LatLng(-8.25, 113.66),
                initialZoom: 9.5,
                minZoom: 6,
                maxZoom: 18,
                onMapReady: () => _isMapReady = true,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.jembergo_mobile_app',
                  maxNativeZoom: 19,
                  maxZoom: 19,
                ),
                if (_routePoints.length >= 2)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _routePoints,
                        color: _primaryBlue,
                        strokeWidth: 6,
                        borderColor: Colors.white,
                        borderStrokeWidth: 2,
                      ),
                    ],
                  ),
                MarkerLayer(markers: _buildInteractivePins(filtered)),
              ],
            ),
            Positioned(
              top: 12,
              left: 12,
              right: 12,
              child: Column(
                children: [
                  _buildSearchAndTrackerBar(),
                  if (_isSearching ||
                      _searchResults.isNotEmpty ||
                      _searchStatusMessage != null)
                    _buildSearchResultsPanel(),
                ],
              ),
            ),
            Positioned(right: 12, bottom: 12, child: _buildMapControlsDock()),
            Positioned(
              left: 12,
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Text(
                  '© OpenStreetMap contributors',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResultsPanel() {
    final results = _searchResults.take(4).toList();
    return Container(
      margin: const EdgeInsets.only(top: 8),
      constraints: const BoxConstraints(maxHeight: 208),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: _isSearching
          ? const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'Mencari lokasi wisata...',
                style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
              ),
            )
          : _searchStatusMessage != null
          ? Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                _searchStatusMessage!,
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
              ),
            )
          : ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemCount: results.length,
              separatorBuilder: (context, index) =>
                  const Divider(height: 1, indent: 48),
              itemBuilder: (context, index) {
                final destination = results[index];
                return ListTile(
                  dense: true,
                  leading: Icon(destination.icon, color: destination.iconColor),
                  title: Text(
                    destination.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    destination.area,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11),
                  ),
                  onTap: () => _selectDestination(destination),
                );
              },
            ),
    );
  }

  Widget _buildSearchAndTrackerBar() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x18000000),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.search_rounded, color: _primaryBlue, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: _handleSearchChanged,
                  onSubmitted: _searchPlaces,
                  textInputAction: TextInputAction.search,
                  decoration: const InputDecoration(
                    hintText: 'Cari wisata di Jember...',
                    hintStyle: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 13,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (_isSearching)
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              else
                IconButton(
                  icon: const Icon(Icons.search_rounded, size: 20),
                  tooltip: 'Cari wisata',
                  onPressed: () => _searchPlaces(_searchController.text),
                ),
              if (_searchQuery.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    ++_searchRequestId;
                    setState(() {
                      _searchQuery = '';
                      _searchResults = [];
                      _searchStatusMessage = null;
                    });
                  },
                ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: _recenterToGps,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: const [
                    BoxShadow(color: Color(0x0F000000), blurRadius: 6),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: _forestGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _isLocating
                          ? 'GPS: Mencari lokasi...'
                          : _isGpsActive
                          ? 'GPS: Lokasi saat ini'
                          : 'GPS Nonaktif',
                      style: const TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isLoadingRoute)
                    const SizedBox(
                      width: 10,
                      height: 10,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    const Icon(
                      Icons.alt_route_rounded,
                      size: 13,
                      color: _primaryBlue,
                    ),
                  const SizedBox(width: 5),
                  const Text(
                    'OSRM Jalur Cepat',
                    style: TextStyle(
                      color: _primaryBlue,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMapControlsDock() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x18000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              IconButton(
                icon: const Icon(Icons.add_rounded, size: 20),
                tooltip: 'Perbesar Peta',
                onPressed: _zoomIn,
              ),
              const Divider(height: 1, color: Color(0xFFE2E8F0)),
              IconButton(
                icon: const Icon(Icons.remove_rounded, size: 20),
                tooltip: 'Perkecil Peta',
                onPressed: _zoomOut,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x18000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.my_location_rounded,
                  size: 20,
                  color: _primaryBlue,
                ),
                tooltip: 'Pusatkan Lokasi Saya',
                onPressed: _recenterToGps,
              ),
              const Divider(height: 1, color: Color(0xFFE2E8F0)),
              IconButton(
                icon: const Icon(
                  Icons.refresh_rounded,
                  size: 20,
                  color: Color(0xFF64748B),
                ),
                tooltip: 'Atur Ulang Rute',
                onPressed: _resetRoute,
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Marker> _buildInteractivePins(List<_MapDestination> filtered) {
    final markers = <Marker>[];
    final position = _currentPosition;
    if (position != null) {
      markers.add(
        Marker(
          point: LatLng(position.latitude, position.longitude),
          width: 82,
          height: 66,
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) => Container(
                      width: 24 + (_pulseController.value * 16),
                      height: 24 + (_pulseController.value * 16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _primaryBlue.withValues(
                          alpha: (1 - _pulseController.value) * 0.4,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: _primaryBlue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.5),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                  boxShadow: const [
                    BoxShadow(color: Color(0x14000000), blurRadius: 4),
                  ],
                ),
                child: const Text(
                  'Lokasi Saya',
                  style: TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    for (final destination in filtered) {
      final isSelected = destination.id == _selectedDestination.id;
      markers.add(
        Marker(
          point: LatLng(destination.lat, destination.lon),
          width: isSelected ? 190 : 90,
          height: isSelected ? 70 : 62,
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () => _selectDestination(destination),
            child: isSelected
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        constraints: const BoxConstraints(maxWidth: 180),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: _navy,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white, width: 1.5),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x33000000),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              destination.icon,
                              color: Colors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                destination.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 8,
                        height: 8,
                        transform: Matrix4.rotationZ(math.pi / 4),
                        decoration: const BoxDecoration(color: _navy),
                      ),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: destination.iconColor,
                            width: 2,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x20000000),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          destination.icon,
                          size: 15,
                          color: destination.iconColor,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Text(
                          destination.name.split(' ').first,
                          style: const TextStyle(
                            color: Color(0xFF1E293B),
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      );
    }

    return markers;
  }

  Widget _buildDestinationCard() {
    final dest = _selectedDestination;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: 84,
                  height: 84,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (dest.image != null)
                        Image.asset(dest.image!, fit: BoxFit.cover)
                      else
                        Container(
                          color: const Color(0xFFE0F2FE),
                          child: Icon(
                            dest.icon,
                            color: dest.iconColor,
                            size: 32,
                          ),
                        ),
                      if (dest.rating > 0)
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.75),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  size: 11,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  dest.rating.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'TUJUAN TERPILIH',
                          style: TextStyle(
                            color: _primaryBlue,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.traffic_rounded,
                                size: 12,
                                color: _forestGreen,
                              ),
                              SizedBox(width: 3),
                              Text(
                                'Wisata',
                                style: TextStyle(
                                  color: _forestGreen,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dest.name,
                      style: const TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      dest.area,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.route_rounded,
                              size: 14,
                              color: _primaryBlue,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$_routeDistanceKm km',
                              style: const TextStyle(
                                color: Color(0xFF0F172A),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '•',
                            style: TextStyle(color: Color(0xFFCBD5E1)),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.schedule_rounded,
                              size: 14,
                              color: _primaryBlue,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '~$_routeDurationMinutes mnt',
                              style: const TextStyle(
                                color: Color(0xFF0F172A),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_routeStatusMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    size: 15,
                    color: Color(0xFFB45309),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _routeStatusMessage!,
                      style: const TextStyle(
                        color: Color(0xFF92400E),
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.navigation_rounded,
                  size: 16,
                  color: _primaryBlue,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _routeViaSummary,
                    style: const TextStyle(
                      color: Color(0xFF334155),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  _isRouteEstimate ? 'Estimasi' : 'OSRM v5',
                  style: TextStyle(
                    color: _isRouteEstimate
                        ? const Color(0xFFB45309)
                        : _primaryBlue,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: FilledButton.icon(
                  onPressed: () => _startNavigation(dest),
                  icon: const Icon(Icons.turn_sharp_right_rounded, size: 18),
                  label: const Text('Mulai Navigasi Rute'),
                  style: FilledButton.styleFrom(
                    backgroundColor: _navy,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _openDestinationDetail(dest),
                  icon: const Icon(Icons.info_outline_rounded, size: 17),
                  label: const Text('Detail'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF0F172A),
                    backgroundColor: const Color(0xFFF8FAFC),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
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

  Widget _buildBottomNavigation() {
    return AppBottomNavigationDock(
      selectedIndex: 2,
      onSelected: (index) {
        final userName = AppData.profile.value.name;
        switch (index) {
          case 0:
            _navigatePage(HomeScreen(userName: userName));
            return;
          case 1:
            _navigatePage(ExploreScreen(userName: userName));
            return;
          case 3:
            _navigatePage(const TicketsScreen());
            return;
          case 4:
            _navigatePage(const ProfileScreen());
            return;
        }
      },
    );
  }
}
