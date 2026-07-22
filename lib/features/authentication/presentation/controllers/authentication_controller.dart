import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/auth_preferences.dart';
import '../../data/datasources/mock_authentication_service.dart';
import '../../data/datasources/session_storage.dart';
import '../../data/repositories/mock_authentication_repository.dart';
import '../../domain/auth_exception.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/auth_state.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/entities/profile_details.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../../domain/validators/auth_validators.dart';

final sessionStorageProvider = Provider<SessionStorage>(
  (ref) => const SecureSessionStorage(
    FlutterSecureStorage(
      aOptions: AndroidOptions(storageNamespace: 'beango_auth'),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.unlocked_this_device,
      ),
    ),
  ),
);

final authPreferencesProvider = Provider<AuthPreferences>(
  (ref) => const SharedPreferencesAuthPreferences(),
);

final mockAuthenticationServiceProvider = Provider<MockAuthenticationService>(
  (ref) => MockAuthenticationService(),
);

final authenticationRepositoryProvider = Provider<AuthenticationRepository>(
  (ref) => MockAuthenticationRepository(
    ref.watch(mockAuthenticationServiceProvider),
    ref.watch(sessionStorageProvider),
    ref.watch(authPreferencesProvider),
  ),
);

final authenticationControllerProvider =
    NotifierProvider<AuthenticationController, AuthState>(
      AuthenticationController.new,
    );

class AuthenticationController extends Notifier<AuthState> {
  AuthenticationRepository get _repository =>
      ref.read(authenticationRepositoryProvider);

  @override
  AuthState build() {
    Future<void>.microtask(restore);
    return const AuthState.restoring();
  }

  Future<void> restore() async {
    try {
      final results = await Future.wait<Object?>([
        _repository.hasCompletedOnboarding(),
        _repository.restoreSession(),
      ]);
      final onboardingCompleted = results[0]! as bool;
      final session = results[1] as AuthSession?;
      if (!ref.mounted) return;
      if (session == null) {
        state = AuthState(
          stage: AuthStage.unauthenticated,
          onboardingCompleted: onboardingCompleted,
        );
      } else {
        state = AuthState(
          stage: session.user.isProfileComplete
              ? AuthStage.authenticated
              : AuthStage.profileRequired,
          onboardingCompleted: onboardingCompleted,
          session: session,
        );
      }
    } on Object {
      if (!ref.mounted) return;
      state = const AuthState(
        stage: AuthStage.unauthenticated,
        onboardingCompleted: false,
        error: AuthErrorType.unknown,
      );
    }
  }

  Future<void> completeOnboarding() async {
    await _repository.completeOnboarding();
    if (!ref.mounted) return;
    state = state.copyWith(onboardingCompleted: true, clearError: true);
  }

  Future<bool> requestOtp(String phoneNumber) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.requestOtp(phoneNumber);
      if (!ref.mounted) return false;
      state = state.copyWith(
        stage: AuthStage.awaitingOtp,
        pendingPhone: phoneNumber,
        isLoading: false,
        clearError: true,
      );
      return true;
    } on AuthException catch (error) {
      if (!ref.mounted) return false;
      state = state.copyWith(isLoading: false, error: error.type);
      return false;
    } on Object {
      if (!ref.mounted) return false;
      state = state.copyWith(isLoading: false, error: AuthErrorType.unknown);
      return false;
    }
  }

  Future<bool> verifyOtp(String code) async {
    final phone = state.pendingPhone;
    if (phone == null) return false;
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final session = await _repository.verifyOtp(phone, code);
      if (!ref.mounted) return false;
      state = state.copyWith(
        stage: session.user.isProfileComplete
            ? AuthStage.authenticated
            : AuthStage.profileRequired,
        session: session,
        isLoading: false,
        clearPendingPhone: true,
        clearError: true,
      );
      return true;
    } on AuthException catch (error) {
      if (!ref.mounted) return false;
      state = state.copyWith(isLoading: false, error: error.type);
      return false;
    } on Object {
      if (!ref.mounted) return false;
      state = state.copyWith(isLoading: false, error: AuthErrorType.unknown);
      return false;
    }
  }

  Future<bool> signIn(AuthProvider provider) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final session = await _repository.signInWithProvider(provider);
      if (!ref.mounted) return false;
      state = state.copyWith(
        stage: AuthStage.profileRequired,
        session: session,
        isLoading: false,
        clearError: true,
      );
      return true;
    } on AuthException catch (error) {
      if (!ref.mounted) return false;
      state = state.copyWith(isLoading: false, error: error.type);
      return false;
    } on Object {
      if (!ref.mounted) return false;
      state = state.copyWith(isLoading: false, error: AuthErrorType.unknown);
      return false;
    }
  }

  Future<bool> completeProfile(ProfileDetails details) async {
    final session = state.session;
    if (session == null ||
        !details.acceptedTerms ||
        !AuthValidators.isValidFullName(details.fullName) ||
        !AuthValidators.isValidEmail(details.email ?? '')) {
      return false;
    }
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final updated = await _repository.completeProfile(session, details);
      if (!ref.mounted) return false;
      state = state.copyWith(
        stage: AuthStage.authenticated,
        session: updated,
        isLoading: false,
        clearError: true,
      );
      return true;
    } on AuthException catch (error) {
      if (!ref.mounted) return false;
      state = state.copyWith(isLoading: false, error: error.type);
      return false;
    } on Object {
      if (!ref.mounted) return false;
      state = state.copyWith(isLoading: false, error: AuthErrorType.unknown);
      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    if (!ref.mounted) return;
    state = AuthState(
      stage: AuthStage.unauthenticated,
      onboardingCompleted: state.onboardingCompleted,
    );
  }

  void clearError() => state = state.copyWith(clearError: true);
}
