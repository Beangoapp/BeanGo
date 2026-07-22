import '../entities/auth_session.dart';
import '../entities/auth_user.dart';
import '../entities/profile_details.dart';

abstract interface class AuthenticationRepository {
  Future<bool> hasCompletedOnboarding();
  Future<void> completeOnboarding();
  Future<AuthSession?> restoreSession();
  Future<void> requestOtp(String phoneNumber);
  Future<AuthSession> verifyOtp(String phoneNumber, String code);
  Future<AuthSession> signInWithProvider(AuthProvider provider);
  Future<AuthSession> completeProfile(
    AuthSession session,
    ProfileDetails details,
  );
  Future<void> logout();
}
