import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences prefs;

  // Same key the existing DioClient already uses — so the interceptor
  // immediately picks up the token written after login.
  static const _tokenKey = 'backend_jwt_token';

  const AuthLocalDataSourceImpl({required this.prefs});

  @override
  Future<void> saveToken(String token) =>
      prefs.setString(_tokenKey, token).then((_) {});

  @override
  Future<String?> getToken() async => prefs.getString(_tokenKey);

  @override
  Future<void> clearToken() async {
    await prefs.remove(_tokenKey);
    // Also wipe the device_user_id so a fresh anonymous session can start
    await prefs.remove('device_user_id');
  }
}
