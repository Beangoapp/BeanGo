import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/locale_controller.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_brand.dart';
import '../../../shared/widgets/app_primary_button.dart';

class LanguageSelectionScreen extends ConsumerStatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  ConsumerState<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState
    extends ConsumerState<LanguageSelectionScreen> {
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = PlatformDispatcher.instance.locale.languageCode == 'ar'
        ? 'ar'
        : 'en';
  }

  void _continue() {
    ref
        .read(localeControllerProvider.notifier)
        .select(Locale(_selectedLanguage));
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const AppBrand(compact: true),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.chooseLanguage,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: AppColors.espresso,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -.8,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.chooseLanguageBody,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.espresso.withValues(alpha: .65),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              _LanguageOption(
                languageCode: 'en',
                title: l10n.englishLanguage,
                subtitle: AppStrings.englishNativeName,
                selected: _selectedLanguage == 'en',
                onTap: () => setState(() => _selectedLanguage = 'en'),
              ),
              const SizedBox(height: AppSpacing.md),
              _LanguageOption(
                languageCode: 'ar',
                title: l10n.arabicLanguage,
                subtitle: AppStrings.arabicNativeName,
                selected: _selectedLanguage == 'ar',
                onTap: () => setState(() => _selectedLanguage = 'ar'),
              ),
              const Spacer(),
              AppPrimaryButton(
                label: l10n.continueLabel,
                icon: _selectedLanguage == 'ar'
                    ? Icons.arrow_back_rounded
                    : Icons.arrow_forward_rounded,
                onPressed: _continue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.languageCode,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String languageCode;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      label: title,
      child: Material(
        color: selected ? AppColors.latte : AppColors.milk,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: selected ? AppColors.caramel : AppColors.latte,
            width: selected ? 1.8 : 1,
          ),
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: AnimatedPadding(
            duration: AppMotion.standard,
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.espresso,
                    borderRadius: BorderRadius.circular(AppRadius.input),
                  ),
                  child: Text(
                    languageCode.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.warmWhite,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.espresso,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: AppMotion.standard,
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.espresso
                        : AppColors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected
                          ? AppColors.espresso
                          : AppColors.textSecondary,
                    ),
                  ),
                  child: selected
                      ? const Icon(
                          Icons.check_rounded,
                          size: 16,
                          color: AppColors.warmWhite,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
