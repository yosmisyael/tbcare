import 'package:TBConsult/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.fullName,
    super.profilePhoto,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String,
    email: json['email'] as String,
    fullName: json['full_name'] as String?,
    profilePhoto: json['profile_photo'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    if (fullName != null) 'full_name': fullName,
    if (profilePhoto != null) 'profile_photo': profilePhoto,
  };
}

class AuthTokenModel extends AuthTokenEntity {
  const AuthTokenModel({
    required super.accessToken,
    required super.tokenType,
    required super.user,
  });

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) =>
      AuthTokenModel(
        accessToken: json['access_token'] as String,
        tokenType: json['token_type'] as String,
        user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      );
}
