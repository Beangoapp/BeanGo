import 'package:beango/features/authentication/domain/validators/auth_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Qatar phone validation', () {
    test('accepts valid Qatar mobile numbers', () {
      for (final number in ['33123456', '55123456', '66123456', '77123456']) {
        expect(AuthValidators.isValidQatarPhone(number), isTrue);
        expect(AuthValidators.isValidQatarPhone('+974$number'), isTrue);
      }
    });

    test('rejects landlines, short numbers and foreign numbers', () {
      expect(AuthValidators.isValidQatarPhone('44123456'), isFalse);
      expect(AuthValidators.isValidQatarPhone('5512345'), isFalse);
      expect(AuthValidators.isValidQatarPhone('+966551234567'), isFalse);
    });
  });

  test('OTP requires exactly six digits', () {
    expect(AuthValidators.isValidOtp('123456'), isTrue);
    expect(AuthValidators.isValidOtp('12345'), isFalse);
    expect(AuthValidators.isValidOtp('12345a'), isFalse);
  });

  test('profile validators enforce full name and optional valid email', () {
    expect(AuthValidators.isValidFullName('Ali Ahmed'), isTrue);
    expect(AuthValidators.isValidFullName('Ali'), isFalse);
    expect(AuthValidators.isValidEmail(''), isTrue);
    expect(AuthValidators.isValidEmail('ali@example.com'), isTrue);
    expect(AuthValidators.isValidEmail('ali@invalid'), isFalse);
  });
}
