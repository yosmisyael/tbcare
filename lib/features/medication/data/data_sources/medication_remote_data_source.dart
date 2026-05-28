import 'package:dio/dio.dart';

import 'package:TBConsult/features/medication/data/models/medication_models.dart';

abstract class MedicationRemoteDataSource {
  Future<MedicationLogModel> createLog(Map<String, dynamic> body);
  Future<({List<MedicationLogModel> logs, int total})> listLogs({
    String? journeyId,
    int limit,
    int offset,
  });
  Future<
      ({
      List<UserAchievementModel> achievements,
      int totalUnlocked,
      int total
      })> listAchievements();
}

class MedicationRemoteDataSourceImpl implements MedicationRemoteDataSource {
  final Dio dio;
  const MedicationRemoteDataSourceImpl({required this.dio});

  @override
  Future<MedicationLogModel> createLog(Map<String, dynamic> body) async {
    final response = await dio.post<Map<String, dynamic>>(
      '/medication/logs',
      data: body,
    );
    return MedicationLogModel.fromJson(response.data!);
  }

  @override
  Future<({List<MedicationLogModel> logs, int total})> listLogs({
    String? journeyId,
    int limit = 20,
    int offset = 0,
  }) async {
    final response = await dio.get<Map<String, dynamic>>(
      '/medication/logs',
      queryParameters: {
        if (journeyId != null) 'journey_id': journeyId,
        'limit': limit,
        'offset': offset,
      },
    );
    final data = response.data!;
    return (
    logs: (data['logs'] as List<dynamic>)
        .map((l) => MedicationLogModel.fromJson(l as Map<String, dynamic>))
        .toList(),
    total: data['total'] as int,
    );
  }

  @override
  Future<
      ({
      List<UserAchievementModel> achievements,
      int totalUnlocked,
      int total
      })> listAchievements() async {
    final response = await dio
        .get<Map<String, dynamic>>('/medication/achievements');
    final data = response.data!;
    return (
    achievements: (data['achievements'] as List<dynamic>)
        .map((a) =>
        UserAchievementModel.fromJson(a as Map<String, dynamic>))
        .toList(),
    totalUnlocked: data['total_unlocked'] as int,
    total: data['total'] as int,
    );
  }
}
