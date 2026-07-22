import 'package:beango/features/authentication/data/datasources/auth_preferences.dart';
import 'package:beango/features/authentication/data/datasources/mock_authentication_service.dart';
import 'package:beango/features/authentication/data/datasources/session_storage.dart';
import 'package:beango/features/authentication/data/repositories/mock_authentication_repository.dart';
import 'package:beango/features/authentication/domain/entities/profile_details.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('persists, restores and clears a completed session', () async {
    final storage = MemorySessionStorage();
    final repository = MockAuthenticationRepository(
      MockAuthenticationService(delay: Duration.zero),
      storage,
      MemoryAuthPreferences(completed: true),
    );

    await repository.requestOtp('+97455123456');
    final session = await repository.verifyOtp('+97455123456', '123456');
    final completed = await repository.completeProfile(
      session,
      const ProfileDetails(fullName: 'Ali Ahmed', acceptedTerms: true),
    );

    expect((await repository.restoreSession())?.user.fullName, 'Ali Ahmed');
    expect(completed.user.isProfileComplete, isTrue);

    await repository.logout();
    expect(await repository.restoreSession(), isNull);
  });
}
