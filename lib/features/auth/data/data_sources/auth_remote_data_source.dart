import 'package:dio/dio.dart';

import 'package:TBConsult/features/auth/data/models/auth_models.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> register({
    required String email,
    required String password,
    String? fullName,
  });

  Future<AuthTokenModel> login({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  const AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    String? fullName,
  }) async {
    final response = await dio.post<Map<String, dynamic>>(
      '/auth/register',
      data: {
        'email': email,
        'password': password,
        if (fullName != null && fullName.isNotEmpty) 'full_name': fullName,
      },
    );
    return UserModel.fromJson(response.data!);
  }

  @override
  Future<AuthTokenModel> login({
    required String email,
    required String password,
  }) async {
    final response = await dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );
    return AuthTokenModel.fromJson(response.data!);
  }
}
