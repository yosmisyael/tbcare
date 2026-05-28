import 'package:flutter/material.dart';
import 'package:TBConsult/features/journey/domain/entities/achievement_entity.dart';

class AchievementCard extends StatelessWidget {
  final AchievementEntity achievement;

  const AchievementCard({super.key, required this.achievement});

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    Color bgColor;
    Color iconColor;

    if (achievement.isLocked) {
      iconData = Icons.lock_outline;
      bgColor = Colors.grey.shade100;
      iconColor = Colors.grey.shade400;
    } else {
      switch (achievement.iconType) {
        case 'medal':
          iconData = Icons.workspace_premium; // Icon ribbon/medal
          bgColor = const Color(0xFFFBEA68); // Kuning terang
          iconColor = const Color(0xFF005B4F); // Hijau gelap TBCare
          break;
        case 'star':
          iconData = Icons.star; // Icon bintang
          bgColor = const Color(0xFFC4F2E8); // Teal/Cyan muda
          iconColor = const Color(0xFF005B4F); // Hijau gelap TBCare
          break;
        default:
          iconData = Icons.emoji_events;
          bgColor = const Color(0xFFFBEA68);
          iconColor = const Color(0xFF005B4F);
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: bgColor,
            child: Icon(
              iconData,
              color: iconColor,
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            achievement.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              // Teks di-grey-out sedikit kalau masih dilock
              color: achievement.isLocked ? Colors.grey.shade500 : Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            achievement.description,
            style: TextStyle(
              fontSize: 11,
              color: achievement.isLocked ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}