import 'package:TBConsult/features/medication/domain/entities/medication.dart';
import 'package:equatable/equatable.dart';

import 'package:TBConsult/core/usecases/usecase.dart';
import 'package:TBConsult/features/medication/domain/repositories/medication_repository.dart';

// ─── Create Log ───────────────────────────────────────────────────────────────

class CreateLogParams extends Equatable {
  final String journeyId;
  final DateTime timeTaken;
  final List<Map<String, dynamic>> entries;
  final String? notes;

  const CreateLogParams({
    required this.journeyId,
    required this.timeTaken,
    required this.entries,
    this.notes,
  });

  @override
  List<Object?> get props => [journeyId, timeTaken, entries, notes];
}

class CreateMedicationLogUseCase
    implements UseCase<MedicationLog, CreateLogParams> {
  final MedicationRepository repository;
  const CreateMedicationLogUseCase(this.repository);

  @override
  Future<MedicationLog> call(CreateLogParams params) => repository.createLog(
    journeyId: params.journeyId,
    timeTaken: params.timeTaken,
    entries: params.entries,
    notes: params.notes,
  );
}

// ─── List Logs ────────────────────────────────────────────────────────────────

class ListLogsParams extends Equatable {
  final String? journeyId;
  final int limit;
  final int offset;

  const ListLogsParams({this.journeyId, this.limit = 20, this.offset = 0});

  @override
  List<Object?> get props => [journeyId, limit, offset];
}

class ListMedicationLogsUseCase
    implements
        UseCase<({List<MedicationLog> logs, int total}), ListLogsParams> {
  final MedicationRepository repository;
  const ListMedicationLogsUseCase(this.repository);

  @override
  Future<({List<MedicationLog> logs, int total})> call(
      ListLogsParams params) =>
      repository.listLogs(
        journeyId: params.journeyId,
        limit: params.limit,
        offset: params.offset,
      );
}

// ─── List Achievements ────────────────────────────────────────────────────────

class ListAchievementsUseCase
    implements
        UseCase<
            ({
            List<UserAchievement> achievements,
            int totalUnlocked,
            int total
            }),
            NoParams> {
  final MedicationRepository repository;
  const ListAchievementsUseCase(this.repository);

  @override
  Future<
      ({
      List<UserAchievement> achievements,
      int totalUnlocked,
      int total
      })> call(NoParams params) => repository.listAchievements();
}
