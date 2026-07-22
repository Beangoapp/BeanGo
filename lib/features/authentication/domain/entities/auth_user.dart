enum AuthProvider { phone, apple, google }

enum UserGender { female, male, preferNotToSay }

class AuthUser {
  const AuthUser({
    required this.id,
    required this.phoneNumber,
    required this.provider,
    this.fullName,
    this.email,
    this.dateOfBirth,
    this.gender,
  });

  final String id;
  final String phoneNumber;
  final AuthProvider provider;
  final String? fullName;
  final String? email;
  final DateTime? dateOfBirth;
  final UserGender? gender;

  bool get isProfileComplete => fullName?.trim().isNotEmpty == true;

  AuthUser copyWith({
    String? fullName,
    String? email,
    DateTime? dateOfBirth,
    UserGender? gender,
  }) => AuthUser(
    id: id,
    phoneNumber: phoneNumber,
    provider: provider,
    fullName: fullName ?? this.fullName,
    email: email ?? this.email,
    dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    gender: gender ?? this.gender,
  );
}
