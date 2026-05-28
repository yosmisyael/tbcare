import 'package:TBConsult/features/medication/domain/entities/medication.dart';
import 'package:dio/dio.dart';

import 'package:TBConsult/core/error/failures.dart';
import 'package:TBConsult/features/medication/data/data_sources/medication_remote_data_source.dart';
import 'package:TBConsult/features/medication/domain/repositories/medication_repository.dart';

class MedicationRepositoryImpl implements MedicationRepository {
  final MedicationRemoteDataSource remoteDataSource;
  const MedicationRepositoryImpl({required this.remoteDataSource});

  String _extractMessage(DioException e) =>
      (e.response?.data as Map?)?['detail']?.toString() ??
          e.message ??
          'Server error';

  @override
  Future<MedicationLog> createLog({
    required String journeyId,
    required DateTime timeTaken,
    required List<Map<String, dynamic>> entries,
    String? notes,
  }) async {
    try {
      return await remoteDataSource.createLog({
        'journey_id': journeyId,
        'time_taken': timeTaken.toUtc().toIso8601String(),
        'entries': entries,
        if (notes != null) 'notes': notes,
      });
    } on DioException catch (e) {
      throw ServerFailure(_extractMessage(e));
    }
  }

  @override
  Future<({List<MedicationLog> logs, int total})> listLogs({
    String? journeyId,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final result = await remoteDataSource.listLogs(
        journeyId: journeyId,
        limit: limit,
        offset: offset,
      );
      return (logs: result.logs, total: result.total);
    } on DioException catch (e) {
      throw ServerFailure(_extractMessage(e));
    }
  }

  @override
  Future<
      ({
      List<UserAchievement> achievements,
      int totalUnlocked,
      int total
      })> listAchievements() async {
    try {
      final result = await remoteDataSource.listAchievements();
      return (
      achievements: result.achievements,
      totalUnlocked: result.totalUnlocked,
      total: result.total,
      );
    } on DioException catch (e) {
      throw ServerFailure(_extractMessage(e));
    }
  }
}
