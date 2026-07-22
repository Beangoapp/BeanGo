import '../../domain/entities/auth_session.dart';
import '../../domain/entities/auth_user.dart';

class AuthSessionModel {
  const AuthSessionModel({required this.session});

  final AuthSession session;

  Map<String, Object?> toJson() => {
    'accessToken': session.accessToken,
    'refreshToken': session.refreshToken,
    'user': {
      'id': session.user.id,
      'phoneNumber': session.user.phoneNumber,
      'provider': session.user.provider.name,
      'fullName': session.user.fullName,
      'email': session.user.email,
      'dateOfBirth': session.user.dateOfBirth?.toIso8601String(),
      'gender': session.user.gender?.name,
    },
  };

  factory AuthSessionModel.fromJson(Map<String, Object?> json) {
    final userJson = Map<String, Object?>.from(json['user']! as Map);
    final dateOfBirth = userJson['dateOfBirth'] as String?;
    final gender = userJson['gender'] as String?;
    return AuthSessionModel(
      session: AuthSession(
        accessToken: json['accessToken']! as String,
        refreshToken: json['refreshToken']! as String,
        user: AuthUser(
          id: userJson['id']! as String,
          phoneNumber: userJson['phoneNumber']! as String,
          provider: AuthProvider.values.byName(userJson['provider']! as String),
          fullName: userJson['fullName'] as String?,
          email: userJson['email'] as String?,
          dateOfBirth: dateOfBirth == null
              ? null
              : DateTime.tryParse(dateOfBirth),
          gender: gender == null ? null : UserGender.values.byName(gender),
        ),
      ),
    );
  }
}
