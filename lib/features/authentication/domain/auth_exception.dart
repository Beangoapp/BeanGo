enum AuthErrorType { invalidCode, expiredCode, network, invalidPhone, unknown }

class AuthException implements Exception {
  const AuthException(this.type);

  final AuthErrorType type;
}
