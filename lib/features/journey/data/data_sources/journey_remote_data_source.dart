import 'package:dio/dio.dart';

import 'package:TBConsult/features/journey/data/models/journey_models.dart';

abstract class JourneyRemoteDataSource {
  Future<List<JourneyListItemModel>> listJourneys();
  Future<JourneyModel> createJourney(Map<String, dynamic> body);
  Future<JourneyModel> getJourney(String journeyId);
  Future<JourneyStatsModel> getJourneyStats(String journeyId);
  Future<ResetJourneyResultModel> resetJourney(
      String journeyId, Map<String, dynamic> body);
  Future<void> deleteJourney(String journeyId);
}

class JourneyRemoteDataSourceImpl implements JourneyRemoteDataSource {
  final Dio dio;
  const JourneyRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<JourneyListItemModel>> listJourneys() async {
    final response =
    await dio.get<Map<String, dynamic>>('/medication/journeys');
    final journeys = response.data!['journeys'] as List<dynamic>;
    return journeys
        .map((j) =>
        JourneyListItemModel.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<JourneyModel> createJourney(Map<String, dynamic> body) async {
    final response = await dio.post<Map<String, dynamic>>(
      '/medication/journeys',
      data: body,
    );
    return JourneyModel.fromJson(response.data!);
  }

  @override
  Future<JourneyModel> getJourney(String journeyId) async {
    final response = await dio
        .get<Map<String, dynamic>>('/medication/journeys/$journeyId');
    return JourneyModel.fromJson(response.data!);
  }

  @override
  Future<JourneyStatsModel> getJourneyStats(String journeyId) async {
    final response = await dio.get<Map<String, dynamic>>(
        '/medication/journeys/$journeyId/stats');
    return JourneyStatsModel.fromJson(response.data!);
  }

  @override
  Future<ResetJourneyResultModel> resetJourney(
      String journeyId, Map<String, dynamic> body) async {
    final response = await dio.post<Map<String, dynamic>>(
      '/medication/journeys/$journeyId/reset',
      data: body,
    );
    return ResetJourneyResultModel.fromJson(response.data!);
  }

  @override
  Future<void> deleteJourney(String journeyId) async {
    await dio.delete('/medication/journeys/$journeyId');
  }
}