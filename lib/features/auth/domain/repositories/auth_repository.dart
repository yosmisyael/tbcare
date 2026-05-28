import 'package:TBConsult/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  /// POST /v1/auth/register
  Future<UserEntity> register({
    required String email,
    required String password,
    String? fullName,
  });

  /// POST /v1/auth/login
  Future<AuthTokenEntity> login({
    required String email,
    required String password,
  });

  /// Persist token to SharedPreferences.
  Future<void> saveToken(String token);

  /// Read persisted token; null if never logged in.
  Future<String?> getToken();

  /// Clear token (logout).
  Future<void> clearToken();
}
