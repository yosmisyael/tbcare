import 'package:equatable/equatable.dart';

// ─── Log Entry ────────────────────────────────────────────────────────────────

class LogEntry extends Equatable {
  final String id;
  final String prescribedDoseId;
  final String medicationName;
  final double dosageMg;
  final int pillCount;
  final bool taken;

  const LogEntry({
    required this.id,
    required this.prescribedDoseId,
    required this.medicationName,
    required this.dosageMg,
    required this.pillCount,
    required this.taken,
  });

  @override
  List<Object?> get props =>
      [id, prescribedDoseId, medicationName, dosageMg, pillCount, taken];
}

// ─── Medication Log ───────────────────────────────────────────────────────────

class MedicationLog extends Equatable {
  final String id;
  final String journeyId;
  final String userId;
  final DateTime timeTaken;
  final String? notes;
  final DateTime createdAt;
  final List<LogEntry> entries;

  const MedicationLog({
    required this.id,
    required this.journeyId,
    required this.userId,
    required this.timeTaken,
    required this.createdAt,
    required this.entries,
    this.notes,
  });

  @override
  List<Object?> get props =>
      [id, journeyId, userId, timeTaken, notes, createdAt, entries];
}

// ─── Achievement ──────────────────────────────────────────────────────────────

class Achievement extends Equatable {
  final String id;
  final String key;
  final String title;
  final String description;
  final String category;
  final String? icon;
  final int requiredValue;
  final String? badgeColor;

  const Achievement({
    required this.id,
    required this.key,
    required this.title,
    required this.description,
    required this.category,
    required this.requiredValue,
    this.icon,
    this.badgeColor,
  });

  @override
  List<Object?> get props =>
      [id, key, title, description, category, icon, requiredValue, badgeColor];
}

class UserAchievement extends Equatable {
  final Achievement achievement;
  final bool unlocked;
  final DateTime? unlockedAt;
  final int currentProgress;
  final double percent;

  const UserAchievement({
    required this.achievement,
    required this.unlocked,
    required this.currentProgress,
    required this.percent,
    this.unlockedAt,
  });

  @override
  List<Object?> get props =>
      [achievement, unlocked, unlockedAt, currentProgress, percent];
}
