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

  static const height = 320.0;

  final String coffeeName;
  final String cafeName;
  final int readyMinutes;
  final VoidCallback? onOrderAgain;
  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    return Semantics(
      container: true,
      label: '$coffeeName, $cafeName, ${l10n.readyInMinutes(readyMinutes)}',
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: Material(
          color: colors.surface,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.hero),
            side: BorderSide(color: colors.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Image.asset(
                  imageAsset,
                  fit: BoxFit.cover,
                  alignment: const Alignment(0, .08),
                  semanticLabel: l10n.coffeeVisualLabel,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.md,
                  AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                coffeeName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: AppSpacing.xxs),
                              Text(
                                cafeName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: colors.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.xxs),
                          child: Text(
                            l10n.readyInMinutes(readyMinutes),
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(color: colors.onSurfaceVariant),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppButton(label: l10n.orderAgain, onPressed: onOrderAgain),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
