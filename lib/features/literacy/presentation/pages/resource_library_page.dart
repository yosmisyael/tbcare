import 'package:flutter/material.dart';

import 'package:TBConsult/core/theme/app_colors.dart';
import 'package:TBConsult/core/widgets/shared_sliver_app_bar.dart';
import 'package:TBConsult/features/literacy/data/tb_articles_data.dart';
import 'package:TBConsult/features/literacy/domain/entities/article_entity.dart';
import 'package:TBConsult/features/literacy/presentation/pages/article_reader_page.dart';

class ResourceLibraryPage extends StatefulWidget {
  const ResourceLibraryPage({super.key});

  @override
  State<ResourceLibraryPage> createState() => _ResourceLibraryPageState();
}

class _ResourceLibraryPageState extends State<ResourceLibraryPage> {
  ArticleCategory? _selectedCategory; // null = All

  List<ArticleEntity> get _filtered {
    if (_selectedCategory == null) return TBArticlesData.all;
    return TBArticlesData.all
        .where((a) => a.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SharedSliverAppBar(),

        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // ── Title ──────────────────────────────────────────────
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resource Library',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Curated medical knowledge for your journey.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── Featured article (first one) ───────────────────────
              if (_selectedCategory == null)
                _FeaturedArticleCard(article: TBArticlesData.all.first),

              const SizedBox(height: 16),

              // ── Category filter chips ──────────────────────────────
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _CategoryChip(
                      label: 'All',
                      isActive: _selectedCategory == null,
                      onTap: () =>
                          setState(() => _selectedCategory = null),
                    ),
                    ...ArticleCategory.values.map((cat) => _CategoryChip(
                      label: cat.label,
                      isActive: _selectedCategory == cat,
                      onTap: () =>
                          setState(() => _selectedCategory = cat),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),

        // ── Article list ─────────────────────────────────────────────
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              // Skip the first article when "All" — it's the featured card
              final list = _selectedCategory == null
                  ? _filtered.skip(1).toList()
                  : _filtered;
              final article = list[index];
              return _ArticleListCard(article: article);
            },
            childCount: _selectedCategory == null
                ? (_filtered.length - 1).clamp(0, _filtered.length)
                : _filtered.length,
          ),
        ),

        const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
      ],
    );
  }
}

// ── Featured article card (hero image, large) ─────────────────────────────────

class _FeaturedArticleCard extends StatelessWidget {
  final ArticleEntity article;
  const _FeaturedArticleCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openArticle(context, article),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[200],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ── Hero image ─────────────────────────────────────
              if (article.heroImageUrl != null)
                Image.network(
                  article.heroImageUrl!,
                  fit: BoxFit.cover,
                  loadingBuilder: (_, child, progress) {
                    if (progress == null) return child;
                    return _imagePlaceholder(article.category);
                  },
                  errorBuilder: (_, __, ___) =>
                      _imagePlaceholder(article.category),
                )
              else
                _imagePlaceholder(article.category),

              // ── Gradient overlay ───────────────────────────────
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.75),
                    ],
                    stops: const [0.4, 1.0],
                  ),
                ),
              ),

              // ── Text content ───────────────────────────────────
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _CategoryBadge(label: article.category.label),
                        const SizedBox(width: 8),
                        _ReadTimeBadge(minutes: article.readMinutes),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
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
}

// ── Standard article list card ────────────────────────────────────────────────

class _ArticleListCard extends StatelessWidget {
  final ArticleEntity article;
  const _ArticleListCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openArticle(context, article),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Thumbnail ──────────────────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 96,
                height: 96,
                child: article.heroImageUrl != null
                    ? Image.network(
                  article.heroImageUrl!,
                  fit: BoxFit.cover,
                  loadingBuilder: (_, child, progress) {
                    if (progress == null) return child;
                    return _imagePlaceholder(article.category);
                  },
                  errorBuilder: (_, __, ___) =>
                      _imagePlaceholder(article.category),
                )
                    : _imagePlaceholder(article.category),
              ),
            ),

            const SizedBox(width: 12),

            // ── Info ───────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        article.category.label.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${article.readMinutes} min',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    article.summary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared helpers ────────────────────────────────────────────────────────────

void _openArticle(BuildContext context, ArticleEntity article) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ArticleReaderPage(article: article),
    ),
  );
}

Widget _imagePlaceholder(ArticleCategory cat) {
  final (color, icon) = switch (cat) {
    ArticleCategory.prevention => (const Color(0xFFE8F5F3), Icons.masks),
    ArticleCategory.diet =>
    (const Color(0xFFF3F8E8), Icons.restaurant_menu),
    ArticleCategory.medication =>
    (AppColors.primary, Icons.medication),
    ArticleCategory.mentalHealth =>
    (const Color(0xFFE0F2F1), Icons.psychology),
  };
  return Container(
    color: color,
    child: Center(
      child: Icon(icon,
          size: 36,
          color: cat == ArticleCategory.medication
              ? Colors.white
              : AppColors.primary),
    ),
  );
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: isActive
                ? null
                : Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: Text(
            label,
            style: TextStyle(
              color:
              isActive ? Colors.white : AppColors.textSecondary,
              fontWeight:
              isActive ? FontWeight.bold : FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final String label;
  const _CategoryBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
            color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _ReadTimeBadge extends StatelessWidget {
  final int minutes;
  const _ReadTimeBadge({required this.minutes});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer_outlined, color: Colors.white, size: 12),
          const SizedBox(width: 4),
          Text('$minutes min read',
              style:
              const TextStyle(color: Colors.white, fontSize: 10)),
        ],
      ),
    );
  }
}
