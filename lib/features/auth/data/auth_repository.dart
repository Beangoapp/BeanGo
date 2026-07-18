import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/auth_failure.dart';

abstract interface class AuthRepository {
  Future<void> requestOtp({required String phone});
  Future<void> verifyOtp({required String phone, required String token});
}

class LocalDemoAuthRepository implements AuthRepository {
  const LocalDemoAuthRepository();

  @override
  Future<void> requestOtp({required String phone}) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
  }

  @override
  Future<void> verifyOtp({required String phone, required String token}) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (token != '123456') throw const InvalidCredentialsFailure();
  }
}

class SupabaseAuthRepository implements AuthRepository {
  const SupabaseAuthRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<void> requestOtp({required String phone}) async {
    try {
      await _client.auth.signInWithOtp(phone: phone);
    } on AuthException catch (error) {
      if (error.statusCode == '400') {
        throw const InvalidCredentialsFailure();
      }
      throw const AuthServiceFailure();
    } catch (_) {
      throw const AuthServiceFailure();
    }
  }

  @override
  Future<void> verifyOtp({required String phone, required String token}) async {
    try {
      await _client.auth.verifyOTP(
        phone: phone,
        token: token,
        type: OtpType.sms,
      );
    } on AuthException catch (error) {
      if (error.statusCode == '400') {
        throw const InvalidCredentialsFailure();
      }
      throw const AuthServiceFailure();
    } catch (_) {
      throw const AuthServiceFailure();
    }
  }
}
