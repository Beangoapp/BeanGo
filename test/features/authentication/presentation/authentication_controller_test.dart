import 'package:beango/features/authentication/data/datasources/auth_preferences.dart';
import 'package:beango/features/authentication/data/datasources/mock_authentication_service.dart';
import 'package:beango/features/authentication/data/datasources/session_storage.dart';
import 'package:beango/features/authentication/domain/auth_exception.dart';
import 'package:beango/features/authentication/domain/entities/auth_state.dart';
import 'package:beango/features/authentication/domain/entities/profile_details.dart';
import 'package:beango/features/authentication/presentation/controllers/authentication_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        sessionStorageProvider.overrideWithValue(MemorySessionStorage()),
        authPreferencesProvider.overrideWithValue(MemoryAuthPreferences()),
        mockAuthenticationServiceProvider.overrideWithValue(
          MockAuthenticationService(delay: Duration.zero),
        ),
      ],
    );
    addTearDown(container.dispose);
  });

  test('transitions through OTP, profile and authenticated states', () async {
    final controller = container.read(
      authenticationControllerProvider.notifier,
    );
    await controller.restore();
    expect(
      container.read(authenticationControllerProvider).stage,
      AuthStage.unauthenticated,
    );

    expect(await controller.requestOtp('+97455123456'), isTrue);
    expect(
      container.read(authenticationControllerProvider).stage,
      AuthStage.awaitingOtp,
    );

    expect(await controller.verifyOtp('123456'), isTrue);
    expect(
      container.read(authenticationControllerProvider).stage,
      AuthStage.profileRequired,
    );

    expect(
      await controller.completeProfile(
        const ProfileDetails(fullName: 'Ali Ahmed', acceptedTerms: true),
      ),
      isTrue,
    );
    expect(
      container.read(authenticationControllerProvider).stage,
      AuthStage.authenticated,
    );
  });

  test('invalid OTP exposes invalid code state', () async {
    final controller = container.read(
      authenticationControllerProvider.notifier,
    );
    await controller.restore();
    await controller.requestOtp('+97455123456');

    expect(await controller.verifyOtp('654321'), isFalse);
    expect(
      container.read(authenticationControllerProvider).error,
      AuthErrorType.invalidCode,
    );
  });
}
