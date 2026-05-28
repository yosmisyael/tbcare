import 'package:equatable/equatable.dart';

import 'package:TBConsult/core/usecases/usecase.dart';
import 'package:TBConsult/features/auth/domain/entities/user_entity.dart';
import 'package:TBConsult/features/auth/domain/repositories/auth_repository.dart';

// ─── Register ─────────────────────────────────────────────────────────────────

class RegisterParams extends Equatable {
  final String email;
  final String password;
  final String? fullName;

  const RegisterParams({
    required this.email,
    required this.password,
    this.fullName,
  });

  @override
  List<Object?> get props => [email, password, fullName];
}

class RegisterUseCase implements UseCase<UserEntity, RegisterParams> {
  final AuthRepository repository;

  const RegisterUseCase(this.repository);

  @override
  Future<UserEntity> call(RegisterParams params) => repository.register(
    email: params.email,
    password: params.password,
    fullName: params.fullName,
  );
}

// ─── Login ────────────────────────────────────────────────────────────────────

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LoginUseCase implements UseCase<AuthTokenEntity, LoginParams> {
  final AuthRepository repository;

  const LoginUseCase(this.repository);

  @override
  Future<AuthTokenEntity> call(LoginParams params) =>
      repository.login(email: params.email, password: params.password);
}

// ─── Get Saved Token ──────────────────────────────────────────────────────────

class GetSavedTokenUseCase implements UseCase<String?, NoParams> {
  final AuthRepository repository;

  const GetSavedTokenUseCase(this.repository);

  @override
  Future<String?> call(NoParams params) => repository.getToken();
}

// ─── Logout ───────────────────────────────────────────────────────────────────

class LogoutUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;

  const LogoutUseCase(this.repository);

  @override
  Future<void> call(NoParams params) => repository.clearToken();
}
