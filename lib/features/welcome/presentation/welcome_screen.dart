import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_brand.dart';
import '../../../shared/widgets/app_primary_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _entrance;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppMotion.emphasized,
    );
    _entrance = CurvedAnimation(
      parent: _controller,
      curve: AppMotion.enterCurve,
    );
    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Column(
            children: [
              const Align(
                alignment: AlignmentDirectional.centerStart,
                child: AppBrand(compact: true),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.sizeOf(context).height - 250,
                    ),
                    child: FadeTransition(
                      opacity: _entrance,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: AppSpacing.xl),
                          const _CoffeeVisual(),
                          const SizedBox(height: AppSpacing.xxl),
                          Text(
                            l10n.welcomeHeadline,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 390),
                            child: Text(
                              l10n.welcomeSupportingCopy,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              AppPrimaryButton(
                label: l10n.getStarted,
                onPressed: () => context.go(AppRoutes.login),
              ),
              const SizedBox(height: AppSpacing.xs),
              TextButton(
                onPressed: () => context.go(AppRoutes.language),
                child: Text(l10n.changeLanguage),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CoffeeVisual extends StatelessWidget {
  const _CoffeeVisual();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: AppLocalizations.of(context).coffeeVisualLabel,
      image: true,
      child: const SizedBox.square(
        dimension: 248,
        child: CustomPaint(painter: _CoffeeVisualPainter()),
      ),
    );
  }
}

class _CoffeeVisualPainter extends CustomPainter {
  const _CoffeeVisualPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final saucer = Paint()..color = AppColors.latte;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height * .76),
        width: size.width * .72,
        height: size.height * .15,
      ),
      saucer,
    );

    final cup = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * .22,
        size.height * .31,
        size.width * .56,
        size.height * .43,
      ),
      const Radius.circular(AppRadius.hero),
    );
    canvas.drawRRect(cup, Paint()..color = AppColors.milk);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height * .34),
        width: size.width * .52,
        height: size.height * .14,
      ),
      Paint()..color = AppColors.roast,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height * .335),
        width: size.width * .3,
        height: size.height * .075,
      ),
      Paint()..color = AppColors.caramel,
    );
    canvas.drawArc(
      Rect.fromLTWH(
        size.width * .7,
        size.height * .4,
        size.width * .24,
        size.height * .25,
      ),
      -1.4,
      2.8,
      false,
      Paint()
        ..color = AppColors.milk
        ..style = PaintingStyle.stroke
        ..strokeWidth = AppSpacing.huge / 12,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
