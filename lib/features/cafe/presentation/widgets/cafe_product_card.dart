import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../domain/entities/cafe_entities.dart';
import '../cafe_strings.dart';

class CafeProductCard extends StatelessWidget {
  const CafeProductCard({
    required this.product,
    required this.heroTag,
    required this.onTap,
    required this.onQuickAdd,
    required this.onFavorite,
    required this.isFavorite,
    super.key,
  });
  final CafeProduct product;
  final String heroTag;
  final VoidCallback onTap;
  final VoidCallback onQuickAdd;
  final VoidCallback onFavorite;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    final strings = CafeStrings(context);
    final colors = Theme.of(context).colorScheme;
    final name = product.localizedName(strings.ar);
    return Semantics(
      button: true,
      label: '$name, ${strings.qar(product.price)}',
      child: Material(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.card),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: heroTag,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.input),
                    child: Image.asset(
                      product.imageAsset,
                      width: 112,
                      height: 112,
                      fit: BoxFit.cover,
                      cacheWidth: 336,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          if (product.badges.contains(ProductBadge.bestseller))
                            _Badge(strings.bestseller),
                          if (product.badges.contains(ProductBadge.newArrival))
                            _Badge(strings.newArrival),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      Text(
                        product.localizedDescription(strings.ar),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              strings.qar(product.price),
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ),
                          IconButton(
                            onPressed: onFavorite,
                            tooltip: isFavorite ? 'Unfavorite' : 'Favorite',
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: isFavorite ? colors.error : null,
                            ),
                          ),
                          FilledButton.tonal(
                            onPressed: product.available ? onQuickAdd : null,
                            child: Text(
                              product.available
                                  ? strings.add
                                  : strings.unavailable,
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

class _Badge extends StatelessWidget {
  const _Badge(this.label);
  final String label;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.secondaryContainer,
      borderRadius: BorderRadius.circular(AppRadius.pill),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w800),
      ),
    ),
  );
}
