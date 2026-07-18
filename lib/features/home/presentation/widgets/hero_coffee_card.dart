import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_buttons.dart';

class HeroCoffeeCard extends StatelessWidget {
  const HeroCoffeeCard({
    required this.coffeeName,
    required this.cafeName,
    required this.readyMinutes,
    required this.onOrderAgain,
    super.key,
    this.imageAsset = 'assets/images/hero_coffee.png',
  });

  static const height = 336.0;

  final String coffeeName;
  final String cafeName;
  final int readyMinutes;
  final VoidCallback? onOrderAgain;
  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      container: true,
      label: '$coffeeName, $cafeName, ${l10n.readyInMinutes(readyMinutes)}',
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.hero),
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withValues(alpha: isDark ? .22 : .08),
                blurRadius: 32,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Material(
            color: colors.surface,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.hero),
              side: BorderSide(
                color: colors.outlineVariant.withValues(alpha: .7),
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final imageWidth = (constraints.maxWidth * .5).clamp(
                  148.0,
                  196.0,
                );
                return Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.xxs,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      coffeeName,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: -.8,
                                            height: 1.08,
                                          ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      cafeName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: colors.onSurfaceVariant,
                                          ),
                                    ),
                                    const SizedBox(height: AppSpacing.xs),
                                    Text(
                                      l10n.readyInMinutes(readyMinutes),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                            color: colors.onSurfaceVariant,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            _FloatingCoffeeImage(
                              imageAsset: imageAsset,
                              semanticLabel: l10n.coffeeVisualLabel,
                              width: imageWidth,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppButton(
                        label: l10n.orderAgain,
                        height: 60,
                        onPressed: onOrderAgain,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _FloatingCoffeeImage extends StatelessWidget {
  const _FloatingCoffeeImage({
    required this.imageAsset,
    required this.semanticLabel,
    required this.width,
  });

  final String imageAsset;
  final String semanticLabel;
  final double width;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: .12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Image.asset(
          imageAsset,
          fit: BoxFit.cover,
          alignment: const Alignment(0, .28),
          semanticLabel: semanticLabel,
        ),
      ),
    );
  }
}
