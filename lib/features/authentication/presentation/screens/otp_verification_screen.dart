import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_buttons.dart';
import '../../domain/auth_exception.dart';
import '../../domain/validators/auth_validators.dart';
import '../controllers/authentication_controller.dart';
import '../widgets/auth_page_scaffold.dart';
import '../widgets/otp_input.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  static const _resendSeconds = 45;
  final _otpKey = GlobalKey<OtpInputState>();
  Timer? _timer;
  var _seconds = _resendSeconds;
  var _code = '';

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _seconds = _resendSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_seconds <= 1) {
        timer.cancel();
        setState(() => _seconds = 0);
      } else {
        setState(() => _seconds--);
      }
    });
  }

  Future<void> _verify([String? code]) async {
    final value = code ?? _code;
    if (!AuthValidators.isValidOtp(value)) return;
    FocusScope.of(context).unfocus();
    final success = await ref
        .read(authenticationControllerProvider.notifier)
        .verifyOtp(value);
    if (success && mounted) context.go(AppRoutes.completeProfile);
  }

  Future<void> _resend() async {
    final phone = ref.read(authenticationControllerProvider).pendingPhone;
    if (_seconds > 0 || phone == null) return;
    final success = await ref
        .read(authenticationControllerProvider.notifier)
        .requestOtp(phone);
    if (success && mounted) {
      _otpKey.currentState?.clear();
      setState(() => _code = '');
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(authenticationControllerProvider);
    final phone = auth.pendingPhone ?? '';
    return AuthPageScaffold(
      title: l10n.verifyPhoneTitle,
      body: l10n.verifyPhoneBody(phone),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OtpInput(
            key: _otpKey,
            enabled: !auth.isLoading,
            onChanged: (value) {
              setState(() => _code = value);
              if (auth.error != null) {
                ref
                    .read(authenticationControllerProvider.notifier)
                    .clearError();
              }
            },
            onCompleted: _verify,
          ),
          if (auth.error != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              _otpError(l10n, auth.error!),
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: l10n.verifyCode,
            isLoading: auth.isLoading,
            onPressed: AuthValidators.isValidOtp(_code) ? _verify : null,
          ),
          const SizedBox(height: AppSpacing.xs),
          AppButton(
            label: _seconds == 0
                ? l10n.resendCode
                : l10n.resendCodeIn(_seconds),
            variant: AppButtonVariant.text,
            onPressed: _seconds == 0 && !auth.isLoading ? _resend : null,
          ),
          AppButton(
            label: l10n.changePhone,
            variant: AppButtonVariant.text,
            onPressed: auth.isLoading
                ? null
                : () => context.go(AppRoutes.login),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.demoOtpHint,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

String _otpError(AppLocalizations l10n, AuthErrorType error) => switch (error) {
  AuthErrorType.invalidCode => l10n.codeInvalid,
  AuthErrorType.expiredCode => l10n.otpExpired,
  AuthErrorType.network => l10n.networkError,
  _ => l10n.loginUnavailable,
};
