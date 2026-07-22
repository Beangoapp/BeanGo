import 'package:beango/core/router/app_router.dart';
import 'package:beango/features/authentication/domain/entities/auth_session.dart';
import 'package:beango/features/authentication/domain/entities/auth_state.dart';
import 'package:beango/features/authentication/domain/entities/auth_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const incompleteSession = AuthSession(
    accessToken: 'access',
    refreshToken: 'refresh',
    user: AuthUser(
      id: '1',
      phoneNumber: '+97455123456',
      provider: AuthProvider.phone,
    ),
  );
  final completeSession = incompleteSession.copyWith(
    user: incompleteSession.user.copyWith(fullName: 'Ali Ahmed'),
  );

  test('blocks protected routes for unauthenticated users', () {
    const state = AuthState(
      stage: AuthStage.unauthenticated,
      onboardingCompleted: true,
    );
    expect(authRedirectFor(state, AppRoutes.home), AppRoutes.login);
  });

  test('requires incomplete profiles to finish profile', () {
    const state = AuthState(
      stage: AuthStage.profileRequired,
      onboardingCompleted: true,
      session: incompleteSession,
    );
    expect(authRedirectFor(state, AppRoutes.home), AppRoutes.completeProfile);
  });

  test('keeps authenticated users out of login', () {
    final state = AuthState(
      stage: AuthStage.authenticated,
      onboardingCompleted: true,
      session: completeSession,
    );
    expect(authRedirectFor(state, AppRoutes.login), AppRoutes.home);
    expect(authRedirectFor(state, AppRoutes.home), isNull);
  });
}
