import '../../domain/auth_exception.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/validators/auth_validators.dart';

class MockAuthenticationService {
  MockAuthenticationService({
    this.delay = const Duration(milliseconds: 700),
    this.otpLifetime = const Duration(minutes: 5),
    this.simulateNetworkFailure = false,
  });

  final Duration delay;
  final Duration otpLifetime;
  final bool simulateNetworkFailure;
  final Map<String, DateTime> _requests = {};

  Future<void> requestOtp(String phoneNumber) async {
    await _wait();
    if (!AuthValidators.isValidQatarPhone(phoneNumber)) {
      throw const AuthException(AuthErrorType.invalidPhone);
    }
    _requests[AuthValidators.normalizeQatarPhone(phoneNumber)] = DateTime.now();
  }

  Future<AuthSession> verifyOtp(String phoneNumber, String code) async {
    await _wait();
    final phone = AuthValidators.normalizeQatarPhone(phoneNumber);
    final requestedAt = _requests[phone];
    if (requestedAt == null ||
        DateTime.now().difference(requestedAt) > otpLifetime) {
      throw const AuthException(AuthErrorType.expiredCode);
    }
    if (code != '123456') {
      throw const AuthException(AuthErrorType.invalidCode);
    }
    _requests.remove(phone);
    return _session(phone: phone, provider: AuthProvider.phone);
  }

  Future<AuthSession> signInWithProvider(AuthProvider provider) async {
    await _wait();
    return _session(phone: '', provider: provider);
  }

  Future<void> _wait() async {
    await Future<void>.delayed(delay);
    if (simulateNetworkFailure) {
      throw const AuthException(AuthErrorType.network);
    }
  }

  AuthSession _session({
    required String phone,
    required AuthProvider provider,
  }) {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    return AuthSession(
      accessToken: 'mock_access_$timestamp',
      refreshToken: 'mock_refresh_$timestamp',
      user: AuthUser(
        id: 'mock_user_$timestamp',
        phoneNumber: phone,
        provider: provider,
      ),
    );
  }
}
