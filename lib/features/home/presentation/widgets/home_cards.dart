import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/home_content.dart';

class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader({required this.title, super.key, this.onViewAll});

  final String title;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -.35,
          ),
        ),
      ),
      if (onViewAll != null)
        TextButton(
          onPressed: onViewAll,
          child: Text(AppLocalizations.of(context).viewAll),
        ),
    ],
  );
}

class HomeProductCard extends StatelessWidget {
  const HomeProductCard({
    required this.product,
    required this.displayName,
    required this.heroTag,
    required this.onTap,
    required this.onQuickAdd,
    super.key,
    this.width = 174,
  });

  final HomeProduct product;
  final String displayName;
  final String heroTag;
  final VoidCallback onTap;
  final VoidCallback onQuickAdd;
  final double width;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      width: width,
      child: Semantics(
        button: true,
        label:
            '$displayName, ${product.cafeName}, ${l10n.qarPrice(product.price.toStringAsFixed(0))}',
        child: Material(
          color: colors.surface,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.card),
            side: BorderSide(color: colors.outlineVariant),
          ),
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Hero(
                    tag: heroTag,
                    child: SizedBox(
                      width: double.infinity,
                      child: Image.asset(
                        product.imageAsset,
                        fit: BoxFit.cover,
                        cacheWidth: 420,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        product.cafeName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              l10n.qarPrice(product.price.toStringAsFixed(0)),
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ),
                          Semantics(
                            button: true,
                            label: l10n.addToOrder(displayName),
                            child: IconButton.filled(
                              onPressed: onQuickAdd,
                              tooltip: l10n.addToOrder(displayName),
                              constraints: const BoxConstraints.tightFor(
                                width: 48,
                                height: 48,
                              ),
                              icon: const Icon(Icons.add_rounded),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NearbyCafeCard extends StatelessWidget {
  const NearbyCafeCard({
    required this.cafe,
    required this.onFavorite,
    required this.onTap,
    super.key,
  });

  final HomeCafe cafe;
  final VoidCallback onFavorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final statusColor = cafe.isOpen ? colors.primary : colors.error;
    final cardHeight =
        (148 + (MediaQuery.textScalerOf(context).scale(14) - 14).clamp(0, 62))
            .toDouble();
    return Semantics(
      container: true,
      label:
          '${cafe.name}, ${cafe.rating}, ${l10n.distanceKm(cafe.distanceKm.toStringAsFixed(1))}, ${cafe.isOpen ? l10n.openNow : l10n.closedNow}',
      child: Material(
        color: colors.surface,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: BorderSide(color: colors.outlineVariant),
        ),
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: cardHeight,
            child: Row(
              children: [
                SizedBox(
                  width: 132,
                  height: double.infinity,
                  child: Image.asset(
                    cafe.imageAsset,
                    fit: BoxFit.cover,
                    cacheWidth: 360,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _CafeLogo(cafe: cafe),
                            const Spacer(),
                            IconButton(
                              onPressed: onFavorite,
                              tooltip: cafe.isFavorite
                                  ? l10n.unfavoriteCafe(cafe.name)
                                  : l10n.favoriteCafe(cafe.name),
                              constraints: const BoxConstraints.tightFor(
                                width: 48,
                                height: 48,
                              ),
                              icon: Icon(
                                cafe.isFavorite
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                color: cafe.isFavorite ? colors.error : null,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          cafe.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const Spacer(),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.xxs,
                          children: [
                            _CafeMeta(
                              icon: Icons.star_rounded,
                              label: cafe.rating.toStringAsFixed(1),
                            ),
                            _CafeMeta(
                              icon: Icons.near_me_outlined,
                              label: l10n.distanceKm(
                                cafe.distanceKm.toStringAsFixed(1),
                              ),
                            ),
                            _CafeMeta(
                              icon: Icons.schedule_rounded,
                              label: l10n.readyInMinutes(
                                cafe.preparationMinutes,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          cafe.isOpen ? l10n.openNow : l10n.closedNow,
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: statusColor,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FeaturedCafeCard extends StatelessWidget {
  const FeaturedCafeCard({required this.cafe, required this.onTap, super.key});

  final HomeCafe cafe;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      width: 284,
      child: Material(
        color: colors.surface,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.hero),
          side: BorderSide(color: colors.outlineVariant),
        ),
        child: InkWell(
          onTap: onTap,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(cafe.imageAsset, fit: BoxFit.cover, cacheWidth: 700),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xD9000000)],
                    stops: [.35, 1],
                  ),
                ),
              ),
              PositionedDirectional(
                start: AppSpacing.md,
                end: AppSpacing.md,
                bottom: AppSpacing.md,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _CafeLogo(cafe: cafe, dark: true),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cafe.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          Text(
                            '★ ${cafe.rating.toStringAsFixed(1)} · ${AppLocalizations.of(context).distanceKm(cafe.distanceKm.toStringAsFixed(1))}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
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

class _CafeLogo extends StatelessWidget {
  const _CafeLogo({required this.cafe, this.dark = false});

  final HomeCafe cafe;
  final bool dark;

  @override
  Widget build(BuildContext context) => CircleAvatar(
    radius: 18,
    backgroundColor: dark
        ? Colors.white
        : Theme.of(context).colorScheme.primaryContainer,
    child: Text(
      cafe.monogram,
      style: TextStyle(
        color: dark
            ? Colors.black
            : Theme.of(context).colorScheme.onPrimaryContainer,
        fontWeight: FontWeight.w900,
      ),
    ),
  );
}

class _CafeMeta extends StatelessWidget {
  const _CafeMeta({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 15, color: Theme.of(context).colorScheme.primary),
      const SizedBox(width: 3),
      Text(label, style: Theme.of(context).textTheme.labelSmall),
    ],
  );
}
