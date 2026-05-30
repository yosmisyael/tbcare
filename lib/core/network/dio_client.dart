import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// Singleton Dio instance pre-configured with:
///   • Base URL from BACKEND_BASE_URL env var
///   • Automatic JWT acquisition + silent refresh on 401
///   • Android emulator localhost → 10.0.2.2 rewrite
///
/// IMPORTANT: This client is only for your backend.
/// Never pass it to repositories that call external APIs (e.g. Google Maps).
/// Those repositories should create their own plain Dio() instance.
class DioClient {
  DioClient._();

  static DioClient? _instance;
  static DioClient get instance => _instance ??= DioClient._();

  late final Dio dio;
  late final SharedPreferences _prefs;

  static const _uuid = Uuid();

  Future<void> initialize(SharedPreferences prefs) async {
    _prefs = prefs;

    dio = Dio(
      BaseOptions(
        baseUrl: _resolveBaseUrl(),
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onError: _onError,
      ),
    );
  }

  // ── Base URL ────────────────────────────────────────────────────────────

  String _resolveBaseUrl() {
    final base = dotenv.env['BACKEND_BASE_URL'] ?? 'http://localhost:8000';
    if (!kIsWeb && Platform.isAndroid) {
      return base
          .replaceAll('localhost', '10.0.2.2')
          .replaceAll('127.0.0.1', '10.0.2.2');
    }
    return base;
  }

  // ── Auth helpers ────────────────────────────────────────────────────────

  bool _isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;
      final payload =
      utf8.decode(base64.decode(base64Url.normalize(parts[1])));
      final map = jsonDecode(payload) as Map<String, dynamic>;
      if (map.containsKey('exp')) {
        final expiry =
        DateTime.fromMillisecondsSinceEpoch((map['exp'] as int) * 1000);
        return DateTime.now()
            .isAfter(expiry.subtract(const Duration(minutes: 5)));
      }
      return false;
    } catch (_) {
      return true;
    }
  }

  Future<String> _getToken({bool forceRefresh = false}) async {
    final cached = _prefs.getString('backend_jwt_token');
    if (cached != null && !forceRefresh && !_isTokenExpired(cached)) {
      return cached;
    }

    var deviceUserId = _prefs.getString('device_user_id');
    if (deviceUserId == null) {
      deviceUserId = _uuid.v4();
      await _prefs.setString('device_user_id', deviceUserId);
    }

    final plain = Dio(BaseOptions(baseUrl: _resolveBaseUrl()));
    final response = await plain.post<Map<String, dynamic>>(
      '/v1/auth/token',
      data: {'user_id': deviceUserId},
    );
    final token = response.data!['access_token'] as String;
    await _prefs.setString('backend_jwt_token', token);
    return token;
  }

  // ── Interceptor callbacks ───────────────────────────────────────────────

  Future<void> _onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    try {
      final token = await _getToken();
      options.headers['Authorization'] = 'Bearer $token';
    } catch (_) {
      // Proceed without token; server will return 401 handled in _onError
    }
    handler.next(options);
  }

  Future<void> _onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) async {
    if (err.response?.statusCode == 401) {
      try {
        final token = await _getToken(forceRefresh: true);
        final opts = err.requestOptions;
        opts.headers['Authorization'] = 'Bearer $token';
        final retryResponse = await dio.fetch(opts);
        return handler.resolve(retryResponse);
      } catch (_) {
        // Fall through to original error
      }
    }
    handler.next(err);
  }
}
