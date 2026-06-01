import 'package:flutter/material.dart';

import 'package:TBConsult/core/theme/app_colors.dart';
import 'package:TBConsult/features/literacy/domain/entities/article_entity.dart';

class ArticleReaderPage extends StatefulWidget {
  final ArticleEntity article;
  const ArticleReaderPage({super.key, required this.article});

  @override
  State<ArticleReaderPage> createState() => _ArticleReaderPageState();
}

class _ArticleReaderPageState extends State<ArticleReaderPage> {
  bool _thumbsUp = false;
  bool _thumbsDown = false;

  @override
  Widget build(BuildContext context) {
    final article = widget.article;
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero image ─────────────────────────────────────────────
            _HeroImage(article: article),

            // ── Article content ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Category + read time ───────────────────────────
                  Row(
                    children: [
                      _Pill(
                        label: article.category.label.toUpperCase(),
                        color: AppColors.primary,
                        textColor: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      _Pill(
                        label: '${article.readMinutes} min read',
                        color: Colors.grey.shade100,
                        textColor: AppColors.textSecondary,
                        icon: Icons.timer_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Title ──────────────────────────────────────────
                  Text(
                    article.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Author row ─────────────────────────────────────
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.primary.withOpacity(0.12),
                        child: Text(
                          article.author.isNotEmpty
                              ? article.author[0].toUpperCase()
                              : 'A',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              article.author,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${article.authorRole} · ${article.publishedDate}',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Divider(height: 32),

                  // ── Article blocks ─────────────────────────────────
                  ...article.blocks.map((block) => _buildBlock(block)),

                  const SizedBox(height: 32),

                  // ── Feedback section ───────────────────────────────
                  _FeedbackSection(
                    thumbsUp: _thumbsUp,
                    thumbsDown: _thumbsDown,
                    onThumbsUp: () => setState(() {
                      _thumbsUp = !_thumbsUp;
                      if (_thumbsUp) _thumbsDown = false;
                    }),
                    onThumbsDown: () => setState(() {
                      _thumbsDown = !_thumbsDown;
                      if (_thumbsDown) _thumbsUp = false;
                    }),
                  ),

                  const SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlock(ArticleBlock block) {
    switch (block.type) {
      case ArticleBlockType.heading:
        return Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 10),
          child: Text(
            block.text ?? '',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
        );

      case ArticleBlockType.subheading:
        return Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            block.text ?? '',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
        );

      case ArticleBlockType.paragraph:
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            block.text ?? '',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
              height: 1.7,
            ),
          ),
        );

      case ArticleBlockType.bullet:
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: (block.bullets ?? []).map((b) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Icon(
                        Icons.check_circle,
                        color: AppColors.primary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        b,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );

      case ArticleBlockType.callout:
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5F3),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.lightbulb_outline,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  block.text ?? '',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    height: 1.6,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        );

      case ArticleBlockType.image:
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (block.imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    block.imageUrl!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              if (block.caption != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    block.caption!,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
        );
    }
  }
}

// ── Hero image section ────────────────────────────────────────────────────────

class _HeroImage extends StatelessWidget {
  final ArticleEntity article;
  const _HeroImage({required this.article});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 260,
      color: const Color(0xFF2C3E50),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Real image ───────────────────────────────────────────
          if (article.heroImageUrl != null)
            Image.network(
              article.heroImageUrl!,
              fit: BoxFit.cover,
              loadingBuilder: (_, child, progress) {
                if (progress == null) return child;
                return _placeholder(article.category);
              },
              errorBuilder: (_, __, ___) => _placeholder(article.category),
            )
          else
            _placeholder(article.category),

          // ── Dark gradient from bottom ────────────────────────────
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.65),
                ],
                stops: const [0.45, 1.0],
              ),
            ),
          ),

          // ── Bottom labels (status bar safe) ──────────────────────
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _overlayPill(article.category.label.toUpperCase(),
                        AppColors.primary),
                    const SizedBox(width: 8),
                    _overlayPillWithIcon(
                      '${article.readMinutes} min read',
                      Icons.timer_outlined,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder(ArticleCategory cat) {
    return Container(
      color: const Color(0xFF1A3C34),
      child: const Center(
        child: Icon(Icons.article_outlined, size: 64, color: Colors.white24),
      ),
    );
  }

  Widget _overlayPill(String label, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: const TextStyle(
            color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _overlayPillWithIcon(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.45),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 12),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 10)),
        ],
      ),
    );
  }
}

// ── Pill widget ───────────────────────────────────────────────────────────────

class _Pill extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final IconData? icon;

  const _Pill({
    required this.label,
    required this.color,
    required this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(label,
              style: TextStyle(
                  color: textColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// ── Feedback section ──────────────────────────────────────────────────────────

class _FeedbackSection extends StatelessWidget {
  final bool thumbsUp;
  final bool thumbsDown;
  final VoidCallback onThumbsUp;
  final VoidCallback onThumbsDown;

  const _FeedbackSection({
    required this.thumbsUp,
    required this.thumbsDown,
    required this.onThumbsUp,
    required this.onThumbsDown,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 16),
        const Text(
          'Was this article helpful?',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _FeedbackButton(
              icon: thumbsUp
                  ? Icons.thumb_up
                  : Icons.thumb_up_outlined,
              label: 'Yes',
              active: thumbsUp,
              onTap: onThumbsUp,
            ),
            const SizedBox(width: 12),
            _FeedbackButton(
              icon: thumbsDown
                  ? Icons.thumb_down
                  : Icons.thumb_down_outlined,
              label: 'No',
              active: thumbsDown,
              onTap: onThumbsDown,
            ),
          ],
        ),
        if (thumbsUp || thumbsDown) ...[
          const SizedBox(height: 12),
          Text(
            thumbsUp
                ? 'Thank you for your feedback! 🙏'
                : 'We\'ll work to improve this article.',
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 13),
          ),
        ],
      ],
    );
  }
}

class _FeedbackButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _FeedbackButton({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon,
          size: 18,
          color: active ? AppColors.primary : AppColors.textPrimary),
      label: Text(
        label,
        style: TextStyle(
            color: active ? AppColors.primary : AppColors.textPrimary),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: active ? AppColors.primary : const Color(0xFFE0E0E0),
        ),
        backgroundColor:
        active ? AppColors.primary.withOpacity(0.07) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }
}
