class ArticleInfo {
  const ArticleInfo({
    required this.category,
    required this.publishedAt,
    required this.title,
    required this.image,
    required this.readTime,
    required this.introduction,
    required this.destinationId,
    required this.sections,
  });

  final String category;
  final String publishedAt;
  final String title;
  final String image;
  final String readTime;
  final String introduction;
  final String destinationId;
  final List<ArticleSection> sections;

  String get cardLabel => '$category • $publishedAt';

  static const articles = <ArticleInfo>[
    ArticleInfo(
      category: 'Tips Wisata',
      publishedAt: '24 Okt 2024',
      title: 'Panduan Lengkap Eksplorasi Tanjung Papuma dan Spot Foto Sunrise Terbaik',
      image: 'assets/home/papuma_featured.jpg',
      readTime: '5 menit baca',
      destinationId: 'papuma',
      introduction: 'Pantai Tanjung Papuma menawarkan perpaduan pasir putih, laut selatan, dan gugusan batu karang yang ikonik. Simak panduan singkat ini agar kunjungan dan momen berburu foto terasa lebih nyaman.',
      sections: [
        ArticleSection(
          title: 'Kenali pesona Pantai Papuma',
          body: 'Papuma berada di kawasan pesisir selatan Jember. Selain garis pantainya, pemandangan batu karang dan pertemuan warna laut menjadi daya tarik yang bisa dinikmati dari beberapa sudut kawasan.',
        ),
        ArticleSection(
          title: 'Berburu foto saat pagi',
          body: 'Datang lebih pagi untuk menikmati suasana yang lebih tenang dan cahaya matahari yang lembut. Coba ambil foto dari area pantai maupun titik pandang yang aman, lalu sesuaikan posisi dengan arah cahaya dan kondisi cuaca.',
        ),
        ArticleSection(
          title: 'Tips sebelum berangkat',
          body: 'Periksa prakiraan cuaca dan informasi operasional sebelum perjalanan. Gunakan alas kaki yang nyaman, bawa air minum, dan selalu ikuti rambu serta arahan petugas—terutama saat berada dekat ombak atau batu karang.',
        ),
      ],
    ),
    ArticleInfo(
      category: 'Eksplorasi',
      publishedAt: '21 Okt 2024',
      title:
          'Merasakan Kesegaran Alami Air Terjun Tancak di Kaki Gunung Argopuro',
      image: 'assets/home/air_terjun_tancak.jpg',
      readTime: '4 menit baca',
      destinationId: 'tancak',
      introduction: 'Air Terjun Tancak menyuguhkan suasana alam yang sejuk di kawasan Panti, Jember. Perjalanan menuju air terjun menjadi bagian dari pengalaman, dengan pemandangan perbukitan dan kebun di sepanjang kawasan.',
      sections: [
        ArticleSection(
          title: 'Suasana alam di kawasan Tancak',
          body: 'Air terjun ini dikenal dengan aliran air yang jatuh dari ketinggian dan lingkungan hijau di sekitarnya. Luangkan waktu untuk menikmati suasana, tanpa meninggalkan sampah atau mengganggu habitat setempat.',
        ),
        ArticleSection(
          title: 'Persiapkan perjalanan',
          body: 'Pilih pakaian yang nyaman untuk aktivitas luar ruang dan gunakan alas kaki dengan daya cengkeram baik. Kondisi jalur dapat berubah karena cuaca, jadi sesuaikan rencana dengan kemampuan rombongan dan informasi terkini di lokasi.',
        ),
        ArticleSection(
          title: 'Jaga keselamatan dan kelestarian',
          body: 'Tetap berada di jalur yang diizinkan, perhatikan petunjuk pengelola, dan hindari mendekati area licin atau berarus deras. Bawa kembali sampah pribadi agar kawasan wisata tetap bersih untuk pengunjung berikutnya.',
        ),
      ],
    ),
  ];
}

class ArticleSection {
  const ArticleSection({required this.title, required this.body});

  final String title;
  final String body;
}
