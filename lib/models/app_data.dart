import 'package:flutter/foundation.dart';

@immutable
class DestinationInfo {
  const DestinationInfo({
    required this.id,
    required this.name,
    required this.area,
    required this.category,
    required this.price,
    required this.image,
    required this.rating,
    required this.reviews,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.distanceKm,
  });

  final String id;
  final String name;
  final String area;
  final String category;
  final int price;
  final String image;
  final double rating;
  final String reviews;
  final String description;
  final double latitude;
  final double longitude;
  final double distanceKm;

  String get priceFormatted => 'Rp ${_formatPrice(price)}';

  static String _formatPrice(int value) {
    final digits = value.toString();
    final parts = <String>[];
    for (var end = digits.length; end > 0; end -= 3) {
      final start = end - 3 < 0 ? 0 : end - 3;
      parts.insert(0, digits.substring(start, end));
    }
    return parts.join('.');
  }

  static const destinations = <DestinationInfo>[
    DestinationInfo(
      id: 'papuma',
      name: 'Pantai Tanjung Papuma',
      area: 'Desa Lojehan, Wuluhan, Jember',
      category: 'Wisata Bahari',
      price: 25000,
      image: 'assets/home/papuma_featured.jpg',
      rating: 4.9,
      reviews: '1.450',
      description: 'Nikmati panorama hamparan pasir putih dan gugusan batu karang megah Malikan di pesisir selatan Kabupaten Jember. Pantai Papuma memadukan hutan lindung yang asri, deburan ombak samudra lepas, dan kuliner ikan bakar segar dari nelayan setempat.',
      latitude: -8.4325,
      longitude: 113.5544,
      distanceKm: 34,
    ),
    DestinationInfo(
      id: 'tancak',
      name: 'Air Terjun Tancak',
      area: 'Kec. Panti, Lereng Argopuro',
      category: 'Wisata Alam',
      price: 10000,
      image: 'assets/home/air_terjun_tancak.jpg',
      rating: 4.9,
      reviews: '1.100',
      description: 'Air terjun megah setinggi 82 meter di kaki lereng Gunung Argopuro dengan trekking kebun kopi yang menyegarkan.',
      latitude: -8.1189,
      longitude: 113.5786,
      distanceKm: 16,
    ),
    DestinationInfo(
      id: 'teluk-love',
      name: 'Teluk Love',
      area: 'Kec. Ambulu, Jember Selatan',
      category: 'Wisata Bahari',
      price: 15000,
      image: 'assets/home/teluk_love.jpg',
      rating: 4.8,
      reviews: '850',
      description: 'Panorama teluk unik berbentuk lekukan hati saat dilihat dari Bukit Suroloyo, ditemani pemandangan perahu nelayan tradisional.',
      latitude: -8.4239,
      longitude: 113.5936,
      distanceKm: 28,
    ),
    DestinationInfo(
      id: 'rembangan',
      name: 'Puncak Rembangan',
      area: 'Kec. Arjasa, Jember Utara',
      category: 'Wisata Alam',
      price: 20000,
      image: 'assets/home/puncak_rembangan.jpg',
      rating: 4.7,
      reviews: '620',
      description: 'Kawasan sejuk di ketinggian dengan kebun buah, kolam renang sumber pegunungan, dan kuliner khas Jember.',
      latitude: -8.1008,
      longitude: 113.7228,
      distanceKm: 12,
    ),
    DestinationInfo(
      id: 'taman-botani-sukorambi',
      name: 'Taman Botani Sukorambi',
      area: 'Sukorambi, Jember',
      category: 'Wisata Alam',
      price: 0,
      image: 'assets/home/teluk_love.jpg',
      rating: 4.6,
      reviews: '480',
      description: 'Jelajahi ruang hijau dan beragam aktivitas rekreasi keluarga di kawasan Taman Botani Sukorambi.',
      latitude: -8.17,
      longitude: 113.69,
      distanceKm: 4.2,
    ),
    DestinationInfo(
      id: 'agrowisata-kebun-kopi-jember',
      name: 'Agrowisata Kebun Kopi Jember',
      area: 'Patrang, Jember',
      category: 'Wisata Alam',
      price: 0,
      image: 'assets/home/puncak_rembangan.jpg',
      rating: 4.7,
      reviews: '312',
      description: 'Kenali suasana kebun kopi Jember dan nikmati udara segar di kawasan Patrang.',
      latitude: -8.13,
      longitude: 113.71,
      distanceKm: 6.8,
    ),
  ];

  static DestinationInfo? find(String value) {
    for (final destination in destinations) {
      if (destination.id == value ||
          destination.name.toLowerCase() == value.toLowerCase()) {
        return destination;
      }
    }
    return null;
  }
}

@immutable
class UserProfile {
  const UserProfile({
    required this.name,
    required this.email,
    required this.phone,
  });

  final String name;
  final String email;
  final String phone;

  UserProfile copyWith({String? name, String? email, String? phone}) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
}

enum TicketStatus { active, pending, completed }

@immutable
class TicketOrder {
  const TicketOrder({
    required this.bookingCode,
    required this.destination,
    required this.visitDate,
    required this.people,
    required this.status,
    this.adultCount,
    this.childCount,
  });

  final String bookingCode;
  final DestinationInfo destination;
  final DateTime visitDate;
  final int people;
  final TicketStatus status;
  final int? adultCount;
  final int? childCount;

  int get adults => adultCount ?? people;
  int get children => childCount ?? 0;
  int get total =>
      destination.price * adults + (destination.price * 3 ~/ 5) * children;

  TicketOrder copyWith({TicketStatus? status}) {
    return TicketOrder(
      bookingCode: bookingCode,
      destination: destination,
      visitDate: visitDate,
      people: people,
      status: status ?? this.status,
      adultCount: adultCount,
      childCount: childCount,
    );
  }
}

class AppData {
  AppData._();

  static final ValueNotifier<UserProfile> profile = ValueNotifier(
    const UserProfile(
      name: 'Budi Santoso',
      email: 'budi.santoso@email.com',
      phone: '+62 812-3456-7890',
    ),
  );

  static final ValueNotifier<List<TicketOrder>> tickets = ValueNotifier([
    TicketOrder(
      bookingCode: 'JGO-20261028-8921',
      destination: DestinationInfo.destinations[0],
      visitDate: DateTime.now().add(const Duration(days: 3)),
      people: 3,
      status: TicketStatus.active,
    ),
    TicketOrder(
      bookingCode: 'JGO-20261029-3372',
      destination: DestinationInfo.destinations[3],
      visitDate: DateTime.now().add(const Duration(days: 5)),
      people: 1,
      status: TicketStatus.pending,
    ),
    TicketOrder(
      bookingCode: 'JGO-20260914-1102',
      destination: DestinationInfo.destinations[1],
      visitDate: DateTime.now().subtract(const Duration(days: 4)),
      people: 2,
      status: TicketStatus.completed,
    ),
  ]);

  static TicketOrder createOrder({
    required DestinationInfo destination,
    required DateTime visitDate,
    required int people,
    int? adultCount,
    int? childCount,
  }) {
    final code =
        'JGO-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
    final order = TicketOrder(
      bookingCode: code,
      destination: destination,
      visitDate: visitDate,
      people: people,
      status: TicketStatus.pending,
      adultCount: adultCount,
      childCount: childCount,
    );
    tickets.value = [order, ...tickets.value];
    return order;
  }

  static void updateTicketStatus(String bookingCode, TicketStatus status) {
    tickets.value = [
      for (final ticket in tickets.value)
        if (ticket.bookingCode == bookingCode)
          ticket.copyWith(status: status)
        else
          ticket,
    ];
  }
}
