import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => const LocalDemoAuthRepository(),
);

final loginControllerProvider = AsyncNotifierProvider<LoginController, void>(
  LoginController.new,
);

class LoginController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> requestOtp({required String phone}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).requestOtp(phone: phone),
    );
    return !state.hasError;
  }

  Future<bool> verifyOtp({required String phone, required String token}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(authRepositoryProvider)
          .verifyOtp(phone: phone, token: token),
    );
    return !state.hasError;
  }
}
