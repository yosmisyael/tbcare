import 'package:TBConsult/features/medication/domain/entities/medication.dart';

abstract class MedicationRepository {
  /// POST /v1/medication/logs
  Future<MedicationLog> createLog({
    required String journeyId,
    required DateTime timeTaken,
    required List<Map<String, dynamic>> entries, // {prescribed_dose_id, taken}
    String? notes,
  });

  /// GET /v1/medication/logs
  Future<({List<MedicationLog> logs, int total})> listLogs({
    String? journeyId,
    int limit,
    int offset,
  });

  /// GET /v1/medication/achievements
  Future<({List<UserAchievement> achievements, int totalUnlocked, int total})>
  listAchievements();
}
