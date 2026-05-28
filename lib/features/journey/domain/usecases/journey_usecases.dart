import 'package:equatable/equatable.dart';

import 'package:TBConsult/core/usecases/usecase.dart';
import 'package:TBConsult/features/journey/domain/entities/journey_entity.dart';
import 'package:TBConsult/features/journey/domain/repositories/journey_repository.dart';

// ─── List Journeys ────────────────────────────────────────────────────────────

class ListJourneysUseCase implements UseCase<List<JourneyListItem>, NoParams> {
  final JourneyRepository repository;
  const ListJourneysUseCase(this.repository);

  @override
  Future<List<JourneyListItem>> call(NoParams params) =>
      repository.listJourneys();
}

// ─── Create Journey ───────────────────────────────────────────────────────────

class CreateJourneyParams extends Equatable {
  final String name;
  final DateTime startDate;
  final DateTime? endDate;
  final String? clinicalNotes;
  final List<Map<String, dynamic>> prescribedDoses;

  const CreateJourneyParams({
    required this.name,
    required this.startDate,
    this.endDate,
    this.clinicalNotes,
    this.prescribedDoses = const [],
  });

  @override
  List<Object?> get props =>
      [name, startDate, endDate, clinicalNotes, prescribedDoses];
}

class CreateJourneyUseCase implements UseCase<Journey, CreateJourneyParams> {
  final JourneyRepository repository;
  const CreateJourneyUseCase(this.repository);

  @override
  Future<Journey> call(CreateJourneyParams params) => repository.createJourney(
    name: params.name,
    startDate: params.startDate,
    endDate: params.endDate,
    clinicalNotes: params.clinicalNotes,
    prescribedDoses: params.prescribedDoses,
  );
}

// ─── Get Journey ──────────────────────────────────────────────────────────────

class GetJourneyUseCase implements UseCase<Journey, String> {
  final JourneyRepository repository;
  const GetJourneyUseCase(this.repository);

  @override
  Future<Journey> call(String journeyId) => repository.getJourney(journeyId);
}

// ─── Get Journey Stats ────────────────────────────────────────────────────────

class GetJourneyStatsUseCase implements UseCase<JourneyStats, String> {
  final JourneyRepository repository;
  const GetJourneyStatsUseCase(this.repository);

  @override
  Future<JourneyStats> call(String journeyId) =>
      repository.getJourneyStats(journeyId);
}

// ─── Reset Journey ────────────────────────────────────────────────────────────

class ResetJourneyParams extends Equatable {
  final String journeyId;
  final String medicationName;
  final double dosageMg;
  final String frequency;
  final String? clinicalNotes;

  const ResetJourneyParams({
    required this.journeyId,
    required this.medicationName,
    required this.dosageMg,
    this.frequency = 'Daily',
    this.clinicalNotes,
  });

  @override
  List<Object?> get props =>
      [journeyId, medicationName, dosageMg, frequency, clinicalNotes];
}

class ResetJourneyUseCase
    implements UseCase<ResetJourneyResult, ResetJourneyParams> {
  final JourneyRepository repository;
  const ResetJourneyUseCase(this.repository);

  @override
  Future<ResetJourneyResult> call(ResetJourneyParams params) =>
      repository.resetJourney(
        journeyId: params.journeyId,
        medicationName: params.medicationName,
        dosageMg: params.dosageMg,
        frequency: params.frequency,
        clinicalNotes: params.clinicalNotes,
      );
}

// ─── Delete Journey ───────────────────────────────────────────────────────────

class DeleteJourneyUseCase implements UseCase<void, String> {
  final JourneyRepository repository;
  const DeleteJourneyUseCase(this.repository);

  @override
  Future<void> call(String journeyId) => repository.deleteJourney(journeyId);
}