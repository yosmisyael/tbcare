import 'package:TBConsult/features/medication/domain/entities/medication.dart';

class LogEntryModel extends LogEntry {
  const LogEntryModel({
    required super.id,
    required super.prescribedDoseId,
    required super.medicationName,
    required super.dosageMg,
    required super.pillCount,
    required super.taken,
  });

  factory LogEntryModel.fromJson(Map<String, dynamic> json) => LogEntryModel(
    id: json['id'] as String,
    prescribedDoseId: json['prescribed_dose_id'] as String,
    medicationName: json['medication_name'] as String,
    dosageMg: (json['dosage_mg'] as num).toDouble(),
    pillCount: json['pill_count'] as int,
    taken: json['taken'] as bool,
  );
}

class MedicationLogModel extends MedicationLog {
  const MedicationLogModel({
    required super.id,
    required super.journeyId,
    required super.userId,
    required super.timeTaken,
    required super.createdAt,
    required super.entries,
    super.notes,
  });

  factory MedicationLogModel.fromJson(Map<String, dynamic> json) =>
      MedicationLogModel(
        id: json['id'] as String,
        journeyId: json['journey_id'] as String,
        userId: json['user_id'] as String,
        timeTaken: DateTime.parse(json['time_taken'] as String),
        notes: json['notes'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
        entries: (json['entries'] as List<dynamic>? ?? [])
            .map((e) => LogEntryModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class AchievementModel extends Achievement {
  const AchievementModel({
    required super.id,
    required super.key,
    required super.title,
    required super.description,
    required super.category,
    required super.requiredValue,
    super.icon,
    super.badgeColor,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) =>
      AchievementModel(
        id: json['id'] as String,
        key: json['key'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        category: json['category'] as String,
        icon: json['icon'] as String?,
        requiredValue: json['required_value'] as int,
        badgeColor: json['badge_color'] as String?,
      );
}

class UserAchievementModel extends UserAchievement {
  const UserAchievementModel({
    required super.achievement,
    required super.unlocked,
    required super.currentProgress,
    required super.percent,
    super.unlockedAt,
  });

  factory UserAchievementModel.fromJson(Map<String, dynamic> json) =>
      UserAchievementModel(
        achievement: AchievementModel.fromJson(
            json['achievement'] as Map<String, dynamic>),
        unlocked: json['unlocked'] as bool,
        unlockedAt: json['unlocked_at'] != null
            ? DateTime.parse(json['unlocked_at'] as String)
            : null,
        currentProgress: json['current_progress'] as int,
        percent: (json['percent'] as num).toDouble(),
      );
}
