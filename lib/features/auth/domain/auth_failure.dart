sealed class AuthFailure implements Exception {
  const AuthFailure();
}

class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure();
}

class AuthServiceFailure extends AuthFailure {
  const AuthServiceFailure();
}
