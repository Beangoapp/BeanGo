import '../../domain/entities/auth_session.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/entities/profile_details.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../datasources/auth_preferences.dart';
import '../datasources/mock_authentication_service.dart';
import '../datasources/session_storage.dart';

class MockAuthenticationRepository implements AuthenticationRepository {
  const MockAuthenticationRepository(
    this._service,
    this._sessionStorage,
    this._preferences,
  );

  final MockAuthenticationService _service;
  final SessionStorage _sessionStorage;
  final AuthPreferences _preferences;

  @override
  Future<bool> hasCompletedOnboarding() =>
      _preferences.hasCompletedOnboarding();

  @override
  Future<void> completeOnboarding() => _preferences.completeOnboarding();

  @override
  Future<AuthSession?> restoreSession() => _sessionStorage.read();

  @override
  Future<void> requestOtp(String phoneNumber) =>
      _service.requestOtp(phoneNumber);

  @override
  Future<AuthSession> verifyOtp(String phoneNumber, String code) async {
    final session = await _service.verifyOtp(phoneNumber, code);
    await _sessionStorage.write(session);
    return session;
  }

  @override
  Future<AuthSession> signInWithProvider(AuthProvider provider) async {
    final session = await _service.signInWithProvider(provider);
    await _sessionStorage.write(session);
    return session;
  }

  @override
  Future<AuthSession> completeProfile(
    AuthSession session,
    ProfileDetails details,
  ) async {
    final updated = session.copyWith(
      user: session.user.copyWith(
        fullName: details.fullName.trim(),
        email: details.email?.trim().isEmpty == true
            ? null
            : details.email?.trim(),
        dateOfBirth: details.dateOfBirth,
        gender: details.gender,
      ),
    );
    await _sessionStorage.write(updated);
    return updated;
  }

  @override
  Future<void> logout() => _sessionStorage.clear();
}
