import 'package:dio/dio.dart';

import 'package:TBConsult/core/error/failures.dart';
import 'package:TBConsult/features/journey/data/data_sources/journey_remote_data_source.dart';
import 'package:TBConsult/features/journey/domain/entities/journey_entity.dart';
import 'package:TBConsult/features/journey/domain/repositories/journey_repository.dart';

class JourneyRepositoryImpl implements JourneyRepository {
  final JourneyRemoteDataSource remoteDataSource;
  const JourneyRepositoryImpl({required this.remoteDataSource});

  String _extractMessage(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.unknown && e.message?.contains('XMLHttpRequest') == true) {
      return 'Gagal terhubung ke server. Periksa koneksi internet Anda.';
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Koneksi lambat. Server terlalu lama merespons.';
    }

    final data = e.response?.data;
    if (data is Map && data['detail'] != null) {
      return data['detail'].toString();
    }

    return e.message ?? 'Terjadi kesalahan yang tidak diketahui pada server.';
  }

  @override
  Future<List<JourneyListItem>> listJourneys() async {
    try {
      return await remoteDataSource.listJourneys();
    } on DioException catch (e) {
      throw ServerFailure(_extractMessage(e));
    }
  }

  @override
  Future<Journey> createJourney({
    required String name,
    required DateTime startDate,
    DateTime? endDate,
    String? clinicalNotes,
    List<Map<String, dynamic>> prescribedDoses = const [],
  }) async {
    try {
      final body = <String, dynamic>{
        'name': name,
        'start_date': startDate.toUtc().toIso8601String(),
        if (endDate != null) 'end_date': endDate.toUtc().toIso8601String(),
        if (clinicalNotes != null) 'clinical_notes': clinicalNotes,
        'prescribed_doses': prescribedDoses,
      };
      return await remoteDataSource.createJourney(body);
    } on DioException catch (e) {
      throw ServerFailure(_extractMessage(e));
    }
  }

  @override
  Future<Journey> getJourney(String journeyId) async {
    try {
      return await remoteDataSource.getJourney(journeyId);
    } on DioException catch (e) {
      throw ServerFailure(_extractMessage(e));
    }
  }

  @override
  Future<JourneyStats> getJourneyStats(String journeyId) async {
    try {
      return await remoteDataSource.getJourneyStats(journeyId);
    } on DioException catch (e) {
      throw ServerFailure(_extractMessage(e));
    }
  }

  @override
  Future<ResetJourneyResult> resetJourney({
    required String journeyId,
    required String medicationName,
    required double dosageMg,
    String frequency = 'Daily',
    String? clinicalNotes,
  }) async {
    try {
      final body = <String, dynamic>{
        'medication_name': medicationName,
        'dosage_mg': dosageMg,
        'frequency': frequency,
        if (clinicalNotes != null) 'clinical_notes': clinicalNotes,
      };
      return await remoteDataSource.resetJourney(journeyId, body);
    } on DioException catch (e) {
      throw ServerFailure(_extractMessage(e));
    }
  }

  @override
  Future<void> deleteJourney(String journeyId) async {
    try {
      await remoteDataSource.deleteJourney(journeyId);
    } on DioException catch (e) {
      throw ServerFailure(_extractMessage(e));
    }
  }
}