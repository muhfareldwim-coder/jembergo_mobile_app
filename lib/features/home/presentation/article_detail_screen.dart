import 'package:flutter/material.dart';
import 'package:jembergo_mobile_app/models/app_data.dart';
import 'package:jembergo_mobile_app/models/article_info.dart';
import 'package:jembergo_mobile_app/features/destination/presentation/destination_detail_screen.dart';

class ArticleDetailScreen extends StatelessWidget {
  const ArticleDetailScreen({required this.article, super.key});

  final ArticleInfo article;

  static const _navy = Color(0xFF0C192C);
  static const _muted = Color(0xFF64748B);

  void _openDestination(BuildContext context) {
    final destination = DestinationInfo.find(article.destinationId);
    if (destination == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informasi destinasi belum tersedia.')),
      );
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
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: _navy,
                foregroundColor: Colors.white,
                leading: IconButton(
                  tooltip: 'Kembali',
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(article.image, fit: BoxFit.cover),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0x55000000),
                              Colors.transparent,
                              Color(0xAA000000),
                            ],
                            stops: [0, 0.4, 1],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        bottom: 24,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.25),
                            ),
                          ),
                          child: Text(
                            article.category,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 130),
                sliver: SliverList.list(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_rounded,
                          color: _muted,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          article.publishedAt,
                          style: const TextStyle(color: _muted, fontSize: 12),
                        ),
                        const SizedBox(width: 14),
                        const Icon(
                          Icons.schedule_rounded,
                          color: _muted,
                          size: 15,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          article.readTime,
                          style: const TextStyle(color: _muted, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 13),
                    Text(
                      article.title,
                      style: const TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 24,
                        height: 1.25,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 17),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFDBEAFE)),
                      ),
                      child: Text(
                        article.introduction,
                        style: const TextStyle(
                          color: Color(0xFF334155),
                          fontSize: 14,
                          height: 1.65,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 23),
                    for (
                      var index = 0;
                      index < article.sections.length;
                      index++
                    ) ...[
                      Text(
                        article.sections[index].title,
                        style: const TextStyle(
                          color: Color(0xFF0F172A),
                          fontSize: 18,
                          height: 1.35,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        article.sections[index].body,
                        style: const TextStyle(
                          color: Color(0xFF475569),
                          fontSize: 14,
                          height: 1.7,
                        ),
                      ),
                      if (index != article.sections.length - 1)
                        const SizedBox(height: 22),
                    ],
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.travel_explore_rounded,
                            color: Color(0xFF0284C7),
                            size: 22,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Rencanakan perjalananmu dan nikmati wisata Jember dengan tetap menjaga alam sekitar.',
                              style: TextStyle(
                                color: Color(0xFF475569),
                                fontSize: 12,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.97),
                  border: const Border(
                    top: BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x120C192C),
                      blurRadius: 16,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => _openDestination(context),
                    style: FilledButton.styleFrom(
                      backgroundColor: _navy,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    icon: const Icon(Icons.place_rounded, size: 18),
                    label: const Text('Lihat Destinasi'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
