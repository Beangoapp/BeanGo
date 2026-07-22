import 'package:beango/features/authentication/domain/entities/profile_details.dart';
import 'package:beango/features/authentication/domain/validators/auth_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('complete profile requires valid name and accepted terms', () {
    const valid = ProfileDetails(
      fullName: 'Ali Ahmed',
      email: 'ali@example.com',
      acceptedTerms: true,
    );
    const invalid = ProfileDetails(
      fullName: 'Ali',
      email: 'not-an-email',
      acceptedTerms: false,
    );

    expect(
      AuthValidators.isValidFullName(valid.fullName) &&
          AuthValidators.isValidEmail(valid.email!) &&
          valid.acceptedTerms,
      isTrue,
    );
    expect(
      AuthValidators.isValidFullName(invalid.fullName) &&
          AuthValidators.isValidEmail(invalid.email!) &&
          invalid.acceptedTerms,
      isFalse,
    );
  });
}
