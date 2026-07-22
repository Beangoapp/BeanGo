abstract final class AuthValidators {
  static final _emailPattern = RegExp(
    r"^[A-Za-z0-9.!#$%&'*+/=?^_`{|}~-]+@[A-Za-z0-9-]+(?:\.[A-Za-z0-9-]+)+$",
  );

  static String normalizeQatarPhone(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('974') && digits.length == 11) {
      return '+$digits';
    }
    return '+974$digits';
  }

  static bool isValidQatarPhone(String value) {
    final normalized = normalizeQatarPhone(value);
    return RegExp(r'^\+974[3567]\d{7}$').hasMatch(normalized);
  }

  static bool isValidOtp(String value) => RegExp(r'^\d{6}$').hasMatch(value);

  static bool isValidFullName(String value) {
    final parts = value.trim().split(RegExp(r'\s+'));
    return parts.length >= 2 && parts.every((part) => part.length >= 2);
  }

  static bool isValidEmail(String value) =>
      value.trim().isEmpty || _emailPattern.hasMatch(value.trim());
}
