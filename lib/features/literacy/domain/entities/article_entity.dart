import 'package:equatable/equatable.dart';

enum ArticleCategory {
  prevention,
  diet,
  medication,
  mentalHealth,
}

extension ArticleCategoryX on ArticleCategory {
  String get label {
    switch (this) {
      case ArticleCategory.prevention:
        return 'Prevention';
      case ArticleCategory.diet:
        return 'Diet';
      case ArticleCategory.medication:
        return 'Medication';
      case ArticleCategory.mentalHealth:
        return 'Mental Health';
    }
  }
}

/// A content block inside an article — either a paragraph, heading,
/// bullet list, key-takeaway callout, or inline image.
class ArticleBlock extends Equatable {
  final ArticleBlockType type;
  final String? text;
  final List<String>? bullets;  // for [type == bullet]
  final String? imageUrl;       // for [type == image]
  final String? caption;        // for [type == image]

  const ArticleBlock({
    required this.type,
    this.text,
    this.bullets,
    this.imageUrl,
    this.caption,
  });

  @override
  List<Object?> get props => [type, text, bullets, imageUrl, caption];
}

enum ArticleBlockType { heading, subheading, paragraph, bullet, callout, image }

class ArticleEntity extends Equatable {
  final String id;
  final ArticleCategory category;
  final String title;
  final String summary;
  final String? heroImageUrl;
  final String author;
  final String authorRole;
  final String publishedDate;
  final int readMinutes;
  final List<ArticleBlock> blocks;

  const ArticleEntity({
    required this.id,
    required this.category,
    required this.title,
    required this.summary,
    required this.author,
    required this.authorRole,
    required this.publishedDate,
    required this.readMinutes,
    required this.blocks,
    this.heroImageUrl,
  });

  @override
  List<Object?> get props => [id, category, title];
}
