import 'package:equatable/equatable.dart';

class PrescribedDose extends Equatable {
  final String id;
  final String medicationName;
  final double dosageMg;
  final int pillCount;
  final String frequency;
  final bool isActive;
  final String? instructions;

  const PrescribedDose({
    required this.id,
    required this.medicationName,
    required this.dosageMg,
    required this.pillCount,
    required this.frequency,
    required this.isActive,
    this.instructions,
  });

  @override
  List<Object?> get props => [
    id,
    medicationName,
    dosageMg,
    pillCount,
    frequency,
    isActive,
    instructions,
  ];
}

class Journey extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String status;
  final DateTime startDate;
  final DateTime? endDate;
  final int resetCount;
  final String? clinicalNotes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<PrescribedDose> prescribedDoses;

  const Journey({
    required this.id,
    required this.userId,
    required this.name,
    required this.status,
    required this.startDate,
    this.endDate,
    required this.resetCount,
    this.clinicalNotes,
    required this.createdAt,
    required this.updatedAt,
    required this.prescribedDoses,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    name,
    status,
    startDate,
    endDate,
    resetCount,
    clinicalNotes,
    createdAt,
    updatedAt,
    prescribedDoses,
  ];
}

class JourneyListItem extends Equatable {
  final String id;
  final String name;
  final String status;
  final DateTime startDate;
  final DateTime? endDate;
  final bool onTrack;
  final DateTime? lastLogDate;

  const JourneyListItem({
    required this.id,
    required this.name,
    required this.status,
    required this.startDate,
    this.endDate,
    required this.onTrack,
    this.lastLogDate,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    status,
    startDate,
    endDate,
    onTrack,
    lastLogDate,
  ];
}

class JourneyStats extends Equatable {
  final String journeyId;
  final int currentStreak;
  final int longestStreak;
  final int totalDosesTaken;
  final int totalDosesMissed;
  final double adherencePercent;
  final int daysElapsed;
  final int? daysRemaining;
  final bool onTrack;
  final DateTime? lastLogDate;
  final bool interrupted;
  final int? daysSinceLastLog;

  final List<DateTime> completedDates;

  const JourneyStats({
    required this.journeyId,
    required this.currentStreak,
    required this.longestStreak,
    required this.totalDosesTaken,
    required this.totalDosesMissed,
    required this.adherencePercent,
    required this.daysElapsed,
    this.daysRemaining,
    required this.onTrack,
    this.lastLogDate,
    required this.interrupted,
    this.daysSinceLastLog,
    required this.completedDates,
  });

  @override
  List<Object?> get props => [
    journeyId,
    currentStreak,
    longestStreak,
    totalDosesTaken,
    totalDosesMissed,
    adherencePercent,
    daysElapsed,
    daysRemaining,
    onTrack,
    lastLogDate,
    interrupted,
    daysSinceLastLog,
    completedDates,
  ];
}

class ResetJourneyResult extends Equatable {
  final String oldJourneyId;
  final Journey newJourney;
  final String message;

  const ResetJourneyResult({
    required this.oldJourneyId,
    required this.newJourney,
    required this.message,
  });

  @override
  List<Object?> get props => [oldJourneyId, newJourney, message];
}