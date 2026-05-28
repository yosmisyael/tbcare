import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:TBConsult/core/usecases/usecase.dart';
import 'package:TBConsult/features/auth/domain/usecases/auth_usecases.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final RegisterUseCase registerUseCase;
  final LoginUseCase loginUseCase;
  final GetSavedTokenUseCase getSavedTokenUseCase;
  final LogoutUseCase logoutUseCase;

  AuthCubit({
    required this.registerUseCase,
    required this.loginUseCase,
    required this.getSavedTokenUseCase,
    required this.logoutUseCase,
  }) : super(const AuthInitial());

  // ── Called by SplashScreen to decide where to route ─────────────────────

  Future<void> checkAuthStatus() async {
    emit(const AuthLoading());
    try {
      final token = await getSavedTokenUseCase(const NoParams());
      if (token != null && token.isNotEmpty) {
        emit(const AuthAuthenticated());
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (_) {
      emit(const AuthUnauthenticated());
    }
  }

  // ── Register ─────────────────────────────────────────────────────────────

  Future<void> register({
    required String email,
    required String password,
    String? fullName,
  }) async {
    emit(const AuthLoading());
    try {
      final user = await registerUseCase(RegisterParams(
        email: email,
        password: password,
        fullName: fullName,
      ));
      emit(AuthRegistered(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  // ── Login ─────────────────────────────────────────────────────────────────

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());
    try {
      final token = await loginUseCase(
        LoginParams(email: email, password: password),
      );
      emit(AuthLoginSuccess(token: token));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  // ── Logout ────────────────────────────────────────────────────────────────

  Future<void> logout() async {
    await logoutUseCase(const NoParams());
    emit(const AuthUnauthenticated());
  }
}
