import 'package:equatable/equatable.dart';

import 'package:TBConsult/features/medication/domain/entities/medication.dart';

abstract class MedicationState extends Equatable {
  const MedicationState();

  @override
  List<Object?> get props => [];
}

class MedicationInitial extends MedicationState {
  const MedicationInitial();
}

class MedicationLoading extends MedicationState {
  const MedicationLoading();
}

class MedicationLogsLoaded extends MedicationState {
  final List<MedicationLog> logs;
  final int total;

  const MedicationLogsLoaded({required this.logs, required this.total});

  @override
  List<Object?> get props => [logs, total];
}

class MedicationLogSubmitted extends MedicationState {
  final MedicationLog log;
  const MedicationLogSubmitted({required this.log});

  @override
  List<Object?> get props => [log];
}

class AchievementsLoaded extends MedicationState {
  final List<UserAchievement> achievements;
  final int totalUnlocked;
  final int total;

  const AchievementsLoaded({
    required this.achievements,
    required this.totalUnlocked,
    required this.total,
  });

  @override
  List<Object?> get props => [achievements, totalUnlocked, total];
}

class MedicationError extends MedicationState {
  final String message;
  const MedicationError({required this.message});

  @override
  List<Object?> get props => [message];
}

