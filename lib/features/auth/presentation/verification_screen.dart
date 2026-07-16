import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_buttons.dart';
import '../application/login_controller.dart';
import '../domain/auth_failure.dart';

class VerificationScreen extends ConsumerStatefulWidget {
  const VerificationScreen({required this.phone, super.key});

  final String phone;

  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen>
    with SingleTickerProviderStateMixin {
  static const _resendDuration = 30;

  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _focusNode = FocusNode();
  late final AnimationController _entranceController;
  late final Animation<Offset> _slideAnimation;
  Timer? _timer;
  int _secondsRemaining = _resendDuration;
  bool _autoSubmitting = false;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: AppMotion.emphasized,
    );
    _slideAnimation = Tween(begin: const Offset(0, .04), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: AppMotion.enterCurve,
          ),
        );
    _entranceController.forward();
    _startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _entranceController.value = 1;
    }
  }

  void _startTimer() {
    _timer?.cancel();
    setStateIfMounted(() => _secondsRemaining = _resendDuration);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 1) {
        timer.cancel();
        setStateIfMounted(() => _secondsRemaining = 0);
      } else {
        setStateIfMounted(() => _secondsRemaining--);
      }
    });
  }

  void setStateIfMounted(VoidCallback update) {
    if (mounted) setState(update);
  }

  Future<void> _verify() async {
    if (_autoSubmitting) return;
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _autoSubmitting = true;
    final success = await ref
        .read(loginControllerProvider.notifier)
        .verifyOtp(phone: widget.phone, token: _codeController.text.trim());
    _autoSubmitting = false;
    if (success && mounted) context.go(AppRoutes.authSuccess);
  }

  Future<void> _resend() async {
    if (_secondsRemaining > 0) return;
    final success = await ref
        .read(loginControllerProvider.notifier)
        .requestOtp(phone: widget.phone);
    if (success) _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _codeController.dispose();
    _focusNode.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final loginState = ref.watch(loginControllerProvider);

    ref.listen(loginControllerProvider, (previous, next) {
      if (!next.hasError || previous?.error == next.error) return;
      final message = switch (next.error) {
        InvalidCredentialsFailure() => l10n.codeInvalid,
        _ => l10n.loginUnavailable,
      };
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    });

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        top: false,
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _entranceController,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.verifyPhoneTitle,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      l10n.verifyPhoneBody(widget.phone),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    TextFormField(
                      controller: _codeController,
                      focusNode: _focusNode,
                      autofocus: true,
                      autofillHints: const [AutofillHints.oneTimeCode],
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      maxLength: 6,
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.headlineLarge?.copyWith(letterSpacing: 10),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: l10n.verificationCode,
                        counterText: '',
                      ),
                      validator: (value) =>
                          RegExp(r'^\d{6}$').hasMatch(value?.trim() ?? '')
                          ? null
                          : l10n.codeInvalid,
                      onChanged: (value) {
                        if (value.length == 6) _verify();
                      },
                      onFieldSubmitted: (_) => _verify(),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppButton(
                      label: l10n.verifyCode,
                      isLoading: loginState.isLoading,
                      onPressed: _verify,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppButton(
                      label: _secondsRemaining == 0
                          ? l10n.resendCode
                          : l10n.resendCodeIn(_secondsRemaining),
                      variant: AppButtonVariant.text,
                      onPressed: _secondsRemaining == 0 ? _resend : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
