import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_buttons.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../domain/auth_exception.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/validators/auth_validators.dart';
import '../controllers/authentication_controller.dart';
import '../widgets/auth_page_scaffold.dart';
import '../widgets/social_sign_in_button.dart';

class MobileLoginScreen extends ConsumerStatefulWidget {
  const MobileLoginScreen({super.key});

  @override
  ConsumerState<MobileLoginScreen> createState() => _MobileLoginScreenState();
}

class _MobileLoginScreenState extends ConsumerState<MobileLoginScreen> {
  final _phoneController = TextEditingController();
  var _valid = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _requestOtp() async {
    FocusScope.of(context).unfocus();
    final phone = AuthValidators.normalizeQatarPhone(_phoneController.text);
    final success = await ref
        .read(authenticationControllerProvider.notifier)
        .requestOtp(phone);
    if (success && mounted) context.go(AppRoutes.verification);
  }

  Future<void> _social(AuthProvider provider) async {
    final success = await ref
        .read(authenticationControllerProvider.notifier)
        .signIn(provider);
    if (success && mounted) context.go(AppRoutes.completeProfile);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(authenticationControllerProvider);
    return AuthPageScaffold(
      title: l10n.enterPhoneTitle,
      body: l10n.enterPhoneBody,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            controller: _phoneController,
            label: l10n.phoneNumber,
            hint: l10n.qatarMobileHint,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.telephoneNumberNational],
            prefixIcon: const _QatarPrefix(),
            onChanged: (value) => setState(
              () => _valid = AuthValidators.isValidQatarPhone(value),
            ),
            onFieldSubmitted: (_) => _valid ? _requestOtp() : null,
          ),
          if (auth.error != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              _errorMessage(l10n, auth.error!),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: l10n.sendCode,
            isLoading: auth.isLoading,
            onPressed: _valid ? _requestOtp : null,
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Text(l10n.orContinueWith),
              ),
              const Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SocialSignInButton(
            label: l10n.continueWithApple,
            icon: Icons.apple,
            isLoading: auth.isLoading,
            onPressed: () => _social(AuthProvider.apple),
          ),
          const SizedBox(height: AppSpacing.sm),
          SocialSignInButton(
            label: l10n.continueWithGoogle,
            icon: Icons.g_mobiledata_rounded,
            isLoading: auth.isLoading,
            onPressed: () => _social(AuthProvider.google),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.phonePrivacy,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _QatarPrefix extends StatelessWidget {
  const _QatarPrefix();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsetsDirectional.only(
      start: AppSpacing.md,
      end: AppSpacing.xs,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('🇶🇦', style: TextStyle(fontSize: 21)),
        SizedBox(width: 6),
        Text('+974'),
      ],
    ),
  );
}

String _errorMessage(AppLocalizations l10n, AuthErrorType error) =>
    switch (error) {
      AuthErrorType.invalidPhone => l10n.phoneInvalid,
      AuthErrorType.network => l10n.networkError,
      _ => l10n.loginUnavailable,
    };
