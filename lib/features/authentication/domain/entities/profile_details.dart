import 'auth_user.dart';

class ProfileDetails {
  const ProfileDetails({
    required this.fullName,
    required this.acceptedTerms,
    this.email,
    this.dateOfBirth,
    this.gender,
  });

  final String fullName;
  final bool acceptedTerms;
  final String? email;
  final DateTime? dateOfBirth;
  final UserGender? gender;
}
