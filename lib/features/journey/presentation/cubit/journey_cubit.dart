import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:TBConsult/core/usecases/usecase.dart';
import 'package:TBConsult/features/journey/domain/usecases/journey_usecases.dart';
import 'journey_state.dart';

class JourneyCubit extends Cubit<JourneyState> {
  final ListJourneysUseCase listJourneysUseCase;
  final CreateJourneyUseCase createJourneyUseCase;
  final GetJourneyUseCase getJourneyUseCase;
  final GetJourneyStatsUseCase getJourneyStatsUseCase;
  final ResetJourneyUseCase resetJourneyUseCase;
  final DeleteJourneyUseCase deleteJourneyUseCase;

  JourneyCubit({
    required this.listJourneysUseCase,
    required this.createJourneyUseCase,
    required this.getJourneyUseCase,
    required this.getJourneyStatsUseCase,
    required this.resetJourneyUseCase,
    required this.deleteJourneyUseCase,
  }) : super(const JourneyInitial());

  Future<void> loadJourneys() async {
    emit(const JourneyLoading());
    try {
      final journeys = await listJourneysUseCase(const NoParams());
      emit(JourneyListLoaded(journeys: journeys));
    } catch (e) {
      emit(JourneyError(message: e.toString()));
    }
  }

  Future<void> loadJourneyDetail(String journeyId) async {
    emit(const JourneyLoading());
    try {
      final journey = await getJourneyUseCase(journeyId);
      final stats = await getJourneyStatsUseCase(journeyId);
      emit(JourneyDetailLoaded(journey: journey, stats: stats));
    } catch (e) {
      emit(JourneyError(message: e.toString()));
    }
  }

  Future<void> createJourney({
    required String name,
    required DateTime startDate,
    DateTime? endDate,
    String? clinicalNotes,
    List<Map<String, dynamic>> prescribedDoses = const [],
  }) async {
    emit(const JourneyLoading());
    try {
      final journey = await createJourneyUseCase(
        CreateJourneyParams(
          name: name,
          startDate: startDate,
          endDate: endDate,
          clinicalNotes: clinicalNotes,
          prescribedDoses: prescribedDoses,
        ),
      );
      emit(JourneyCreated(journey: journey));
    } catch (e) {
      emit(JourneyError(message: e.toString()));
    }
  }

  Future<void> adjustJourney({
    required String journeyId,
    required String medicationName,
    required double dosageMg,
    String frequency = 'Daily',
    String? clinicalNotes,
  }) async {
    emit(const JourneyLoading());
    try {
      final result = await resetJourneyUseCase(
        ResetJourneyParams(
          journeyId: journeyId,
          medicationName: medicationName,
          dosageMg: dosageMg,
          frequency: frequency,
          clinicalNotes: clinicalNotes,
        ),
      );
      emit(JourneyResetSuccess(result: result));
    } catch (e) {
      emit(JourneyError(message: e.toString()));
    }
  }

  Future<void> deleteJourney(String journeyId) async {
    emit(const JourneyLoading());
    try {
      await deleteJourneyUseCase(journeyId);
      emit(const JourneyDeleteSuccess(message: 'Journey successfully deleted'));
    } catch (e) {
      emit(JourneyError(message: e.toString()));
    }
  }

  void refresh() => loadJourneys();
}