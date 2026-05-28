import 'package:TBConsult/features/journey/domain/entities/journey_entity.dart';

class PrescribedDoseModel extends PrescribedDose {
  const PrescribedDoseModel({
    required String id,
    required String medicationName,
    required double dosageMg,
    required int pillCount,
    required String frequency,
    required bool isActive,
    String? instructions,
  }) : super(
    id: id,
    medicationName: medicationName,
    dosageMg: dosageMg,
    pillCount: pillCount,
    frequency: frequency,
    isActive: isActive,
    instructions: instructions,
  );

  factory PrescribedDoseModel.fromJson(Map<String, dynamic> json) =>
      PrescribedDoseModel(
        id: json['id'] as String,
        medicationName: json['medication_name'] as String,
        dosageMg: (json['dosage_mg'] as num).toDouble(),
        pillCount: json['pill_count'] as int,
        frequency: json['frequency'] as String,
        isActive: json['is_active'] as bool,
        instructions: json['instructions'] as String?,
      );

  Map<String, dynamic> toJson() => {
    'medication_name': medicationName,
    'dosage_mg': dosageMg,
    'pill_count': pillCount,
    'frequency': frequency,
    if (instructions != null) 'instructions': instructions,
  };
}

class JourneyModel extends Journey {
  const JourneyModel({
    required String id,
    required String userId,
    required String name,
    required String status,
    required DateTime startDate,
    required int resetCount,
    required DateTime createdAt,
    required DateTime updatedAt,
    required List<PrescribedDoseModel> prescribedDoses,
    DateTime? endDate,
    String? clinicalNotes,
  }) : super(
    id: id,
    userId: userId,
    name: name,
    status: status,
    startDate: startDate,
    resetCount: resetCount,
    createdAt: createdAt,
    updatedAt: updatedAt,
    prescribedDoses: prescribedDoses,
    endDate: endDate,
    clinicalNotes: clinicalNotes,
  );

  factory JourneyModel.fromJson(Map<String, dynamic> json) => JourneyModel(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    name: json['name'] as String,
    status: json['status'] as String,
    startDate: DateTime.parse(json['start_date'] as String),
    endDate: json['end_date'] != null
        ? DateTime.parse(json['end_date'] as String)
        : null,
    resetCount: json['reset_count'] as int,
    clinicalNotes: json['clinical_notes'] as String?,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
    prescribedDoses: (json['prescribed_doses'] as List<dynamic>? ?? [])
        .map((d) => PrescribedDoseModel.fromJson(d as Map<String, dynamic>))
        .toList(),
  );
}

class JourneyListItemModel extends JourneyListItem {
  const JourneyListItemModel({
    required String id,
    required String name,
    required String status,
    required DateTime startDate,
    required bool onTrack,
    DateTime? endDate,
    DateTime? lastLogDate,
  }) : super(
    id: id,
    name: name,
    status: status,
    startDate: startDate,
    onTrack: onTrack,
    endDate: endDate,
    lastLogDate: lastLogDate,
  );

  factory JourneyListItemModel.fromJson(Map<String, dynamic> json) =>
      JourneyListItemModel(
        id: json['id'] as String,
        name: json['name'] as String,
        status: json['status'] as String,
        startDate: DateTime.parse(json['start_date'] as String),
        endDate: json['end_date'] != null
            ? DateTime.parse(json['end_date'] as String)
            : null,
        onTrack: json['on_track'] as bool,
        lastLogDate: json['last_log_date'] != null
            ? DateTime.parse(json['last_log_date'] as String)
            : null,
      );
}

class JourneyStatsModel extends JourneyStats {
  const JourneyStatsModel({
    required String journeyId,
    required int currentStreak,
    required int longestStreak,
    required int totalDosesTaken,
    required int totalDosesMissed,
    required double adherencePercent,
    required int daysElapsed,
    required bool onTrack,
    required bool interrupted,
    required List<DateTime> completedDates,
    int? daysRemaining,
    DateTime? lastLogDate,
    int? daysSinceLastLog,
  }) : super(
    journeyId: journeyId,
    currentStreak: currentStreak,
    longestStreak: longestStreak,
    totalDosesTaken: totalDosesTaken,
    totalDosesMissed: totalDosesMissed,
    adherencePercent: adherencePercent,
    daysElapsed: daysElapsed,
    onTrack: onTrack,
    interrupted: interrupted,
    completedDates: completedDates,
    daysRemaining: daysRemaining,
    lastLogDate: lastLogDate,
    daysSinceLastLog: daysSinceLastLog,
  );

  factory JourneyStatsModel.fromJson(Map<String, dynamic> json) =>
      JourneyStatsModel(
        journeyId: json['journey_id'] as String,
        currentStreak: json['current_streak'] as int,
        longestStreak: json['longest_streak'] as int,
        totalDosesTaken: json['total_doses_taken'] as int,
        totalDosesMissed: json['total_doses_missed'] as int,
        adherencePercent: (json['adherence_percent'] as num).toDouble(),
        daysElapsed: json['days_elapsed'] as int,
        daysRemaining: json['days_remaining'] as int?,
        onTrack: json['on_track'] as bool,
        lastLogDate: json['last_log_date'] != null
            ? DateTime.parse(json['last_log_date'] as String)
            : null,
        interrupted: json['interrupted'] as bool,
        daysSinceLastLog: json['days_since_last_log'] as int?,
        completedDates: (json['completed_dates'] as List<dynamic>? ?? [])
            .map((d) => DateTime.parse(d as String))
            .toList(), // <--- PARSING DATA KALENDER DARI BACKEND
      );
}

class ResetJourneyResultModel extends ResetJourneyResult {
  const ResetJourneyResultModel({
    required String oldJourneyId,
    required JourneyModel newJourney,
    required String message,
  }) : super(
    oldJourneyId: oldJourneyId,
    newJourney: newJourney,
    message: message,
  );

  factory ResetJourneyResultModel.fromJson(Map<String, dynamic> json) =>
      ResetJourneyResultModel(
        oldJourneyId: json['old_journey_id'] as String,
        newJourney: JourneyModel.fromJson(json['new_journey'] as Map<String, dynamic>),
        message: json['message'] as String,
      );
}