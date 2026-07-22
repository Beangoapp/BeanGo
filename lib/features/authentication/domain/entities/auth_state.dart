import 'auth_session.dart';
import '../auth_exception.dart';

enum AuthStage {
  restoring,
  unauthenticated,
  awaitingOtp,
  profileRequired,
  authenticated,
}

class AuthState {
  const AuthState({
    required this.stage,
    required this.onboardingCompleted,
    this.session,
    this.pendingPhone,
    this.isLoading = false,
    this.error,
  });

  const AuthState.restoring()
    : stage = AuthStage.restoring,
      onboardingCompleted = false,
      session = null,
      pendingPhone = null,
      isLoading = false,
      error = null;

  final AuthStage stage;
  final bool onboardingCompleted;
  final AuthSession? session;
  final String? pendingPhone;
  final bool isLoading;
  final AuthErrorType? error;

  bool get isAuthenticated =>
      stage == AuthStage.authenticated || stage == AuthStage.profileRequired;

  AuthState copyWith({
    AuthStage? stage,
    bool? onboardingCompleted,
    AuthSession? session,
    String? pendingPhone,
    bool clearSession = false,
    bool clearPendingPhone = false,
    bool? isLoading,
    AuthErrorType? error,
    bool clearError = false,
  }) => AuthState(
    stage: stage ?? this.stage,
    onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    session: clearSession ? null : session ?? this.session,
    pendingPhone: clearPendingPhone ? null : pendingPhone ?? this.pendingPhone,
    isLoading: isLoading ?? this.isLoading,
    error: clearError ? null : error ?? this.error,
  );
}
