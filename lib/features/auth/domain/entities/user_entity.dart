import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? fullName;
  final String? profilePhoto;

  const UserEntity({
    required this.id,
    required this.email,
    this.fullName,
    this.profilePhoto,
  });

  String get displayName => fullName?.isNotEmpty == true ? fullName! : email;

  @override
  List<Object?> get props => [id, email, fullName, profilePhoto];
}

class AuthTokenEntity extends Equatable {
  final String accessToken;
  final String tokenType;
  final UserEntity user;

  const AuthTokenEntity({
    required this.accessToken,
    required this.tokenType,
    required this.user,
  });

  @override
  List<Object?> get props => [accessToken, tokenType, user];
}
