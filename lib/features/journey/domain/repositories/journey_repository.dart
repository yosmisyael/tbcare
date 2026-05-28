import 'package:TBConsult/features/journey/domain/entities/journey_entity.dart';

abstract class JourneyRepository {
  Future<List<JourneyListItem>> listJourneys();

  Future<Journey> createJourney({
    required String name,
    required DateTime startDate,
    DateTime? endDate,
    String? clinicalNotes,
    List<Map<String, dynamic>> prescribedDoses,
  });

  Future<Journey> getJourney(String journeyId);

  Future<JourneyStats> getJourneyStats(String journeyId);

  Future<ResetJourneyResult> resetJourney({
    required String journeyId,
    required String medicationName,
    required double dosageMg,
    String frequency,
    String? clinicalNotes,
  });

  Future<void> deleteJourney(String journeyId);
}