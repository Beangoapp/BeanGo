import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_brand.dart';
import '../../../../shared/widgets/app_buttons.dart';
import '../controllers/authentication_controller.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  var _index = 0;

  Future<void> _finish() async {
    await ref
        .read(authenticationControllerProvider.notifier)
        .completeOnboarding();
    if (mounted) context.go(AppRoutes.language);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pages = [
      (
        l10n.onboardingTitleOne,
        l10n.onboardingBodyOne,
        'assets/images/hero_coffee.png',
      ),
      (
        l10n.onboardingTitleTwo,
        l10n.onboardingBodyTwo,
        'assets/images/promo_coffee_pairing.png',
      ),
      (
        l10n.onboardingTitleThree,
        l10n.onboardingBodyThree,
        'assets/images/pistachio_latte.png',
      ),
    ];
    final last = _index == pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              Row(
                children: [
                  const AppBrand(compact: true),
                  const Spacer(),
                  TextButton(onPressed: _finish, child: Text(l10n.skip)),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: pages.length,
                  onPageChanged: (index) => setState(() => _index = index),
                  itemBuilder: (context, index) => _OnboardingPage(
                    title: pages[index].$1,
                    body: pages[index].$2,
                    image: pages[index].$3,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                  (index) => AnimatedContainer(
                    duration: AppMotion.standard,
                    width: _index == index ? 24 : 7,
                    height: 7,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: _index == index
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: last ? l10n.getStarted : l10n.continueLabel,
                onPressed: last
                    ? _finish
                    : () => _controller.nextPage(
                        duration: AppMotion.emphasized,
                        curve: AppMotion.transitionCurve,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.title,
    required this.body,
    required this.image,
  });

  final String title;
  final String body;
  final String image;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Expanded(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.hero),
            color: Theme.of(context).colorScheme.surfaceContainer,
          ),
          child: Image.asset(image, fit: BoxFit.cover),
        ),
      ),
      Text(
        title,
        textAlign: TextAlign.center,
        style: Theme.of(
          context,
        ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: AppSpacing.sm),
      Text(
        body,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          height: 1.45,
        ),
      ),
      const SizedBox(height: AppSpacing.lg),
    ],
  );
}
