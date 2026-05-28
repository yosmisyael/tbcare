import 'package:equatable/equatable.dart';

import 'package:TBConsult/features/auth/domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial — splash is checking for a persisted token.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Token check in progress / network call running.
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// A valid persisted token was found — go straight to OuterShell.
class AuthAuthenticated extends AuthState {
  final UserEntity? user; // may be null if we only have a token, not full profile
  const AuthAuthenticated({this.user});

  @override
  List<Object?> get props => [user];
}

/// No token found — show login/register.
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Register succeeded — user created, prompt to login.
class AuthRegistered extends AuthState {
  final UserEntity user;
  const AuthRegistered({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Login succeeded.
class AuthLoginSuccess extends AuthState {
  final AuthTokenEntity token;
  const AuthLoginSuccess({required this.token});

  @override
  List<Object?> get props => [token];
}

/// Any auth operation failed.
class AuthError extends AuthState {
  final String message;
  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}
