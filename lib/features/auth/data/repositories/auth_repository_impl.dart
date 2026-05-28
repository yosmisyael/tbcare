import 'package:dio/dio.dart';

import 'package:TBConsult/core/error/failures.dart';
import 'package:TBConsult/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:TBConsult/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:TBConsult/features/auth/domain/entities/user_entity.dart';
import 'package:TBConsult/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  const AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<UserEntity> register({
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      return await remoteDataSource.register(
        email: email,
        password: password,
        fullName: fullName,
      );
    } on DioException catch (e) {
      throw ServerFailure(_extractMessage(e));
    }
  }

  @override
  Future<AuthTokenEntity> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await remoteDataSource.login(
        email: email,
        password: password,
      );
      // Persist token immediately so DioClient interceptor uses it
      await localDataSource.saveToken(result.accessToken);
      return result;
    } on DioException catch (e) {
      throw ServerFailure(_extractMessage(e));
    }
  }

  @override
  Future<void> saveToken(String token) => localDataSource.saveToken(token);

  @override
  Future<String?> getToken() => localDataSource.getToken();

  @override
  Future<void> clearToken() => localDataSource.clearToken();

  String _extractMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map) {
      // FastAPI validation errors: [{loc, msg, type}]
      final detail = data['detail'];
      if (detail is List && detail.isNotEmpty) {
        return (detail.first as Map)['msg']?.toString() ??
            'Validation error';
      }
      if (detail is String) return detail;
    }
    return e.message ?? 'Server error';
  }
}
