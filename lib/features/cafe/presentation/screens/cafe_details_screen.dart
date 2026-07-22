import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../application/cafe_providers.dart';
import '../../domain/entities/cafe_entities.dart';
import '../cafe_strings.dart';
import '../widgets/cafe_product_card.dart';
import 'product_details_screen.dart';

class CafeRouteArgs {
  const CafeRouteArgs({this.heroTag});
  final String? heroTag;
}

class CafeDetailsScreen extends ConsumerWidget {
  const CafeDetailsScreen({required this.cafeId, this.heroTag, super.key});
  final String cafeId;
  final String? heroTag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(cafeDetailsProvider(cafeId));
    return details.when(
      loading: () => const _CafeLoadingView(),
      error: (error, _) => _CafeErrorView(
        error: error,
        onRetry: () => ref.invalidate(cafeDetailsProvider(cafeId)),
      ),
      data: (value) => _CafeExperience(details: value, heroTag: heroTag),
    );
  }
}

class _CafeExperience extends ConsumerStatefulWidget {
  const _CafeExperience({required this.details, this.heroTag});
  final CafeDetails details;
  final String? heroTag;
  @override
  ConsumerState<_CafeExperience> createState() => _CafeExperienceState();
}

class _CafeExperienceState extends ConsumerState<_CafeExperience> {
  var _reviewsHighestFirst = false;
  var _selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    final details = widget.details;
    final strings = CafeStrings(context);
    final favorites =
        ref.watch(cafeFavoritesProvider).value ?? const FavoritesState();
    if (details.products.isEmpty) {
      return Scaffold(
        key: const ValueKey('cafe-empty-state'),
        appBar: AppBar(title: Text(details.cafe.name)),
        body: Center(child: Text(strings.emptyMenu)),
      );
    }
    final categories = CafeCategory.values
        .where(
          (category) =>
              details.products.any((product) => product.category == category),
        )
        .toList();
    final selectedIndex = _selectedCategoryIndex.clamp(
      0,
      categories.length - 1,
    );
    final selectedCategory = categories[selectedIndex];
    final categoryBarHeight =
        (52 + (MediaQuery.textScalerOf(context).scale(16) - 16).clamp(0, 18))
            .toDouble();
    return Scaffold(
      key: const ValueKey('cafe-details-screen'),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerScrolled) => [
          SliverAppBar(
            pinned: true,
            expandedHeight: 390,
            stretch: true,
            actions: [
              IconButton.filledTonal(
                onPressed: () => ref
                    .read(cafeFavoritesProvider.notifier)
                    .toggleCafe(details.cafe.id),
                tooltip: 'Favorite',
                icon: Icon(
                  favorites.cafeIds.contains(details.cafe.id)
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                ),
              ),
              IconButton.filledTonal(
                onPressed: () => ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(details.cafe.name))),
                tooltip: 'Share',
                icon: const Icon(Icons.ios_share_rounded),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _CafeHero(
                cafe: details.cafe,
                heroTag: widget.heroTag,
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _CategoryHeaderDelegate(
              selectedIndex: selectedIndex,
              height: categoryBarHeight,
              child: _StickyCategoryBar(
                key: const ValueKey('cafe-category-tabs'),
                categories: categories,
                selectedIndex: selectedIndex,
                arabic: strings.ar,
                onSelected: (index) =>
                    setState(() => _selectedCategoryIndex = index),
              ),
            ),
          ),
        ],
        body: AnimatedSwitcher(
          duration: AppMotion.standard,
          switchInCurve: AppMotion.enterCurve,
          child: _CategoryMenu(
            key: ValueKey(selectedCategory),
            products: details.products
                .where((product) => product.category == selectedCategory)
                .toList(),
            favorites: favorites.productIds,
            onFavorite: (id) =>
                ref.read(cafeFavoritesProvider.notifier).toggleProduct(id),
            onQuickAdd: (product) {
              ref.read(cafeCartProvider.notifier).add(product);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${product.localizedName(strings.ar)} · ${strings.added}',
                  ),
                ),
              );
            },
            onOpen: (product, tag) => context.push(
              AppRoutes.product(product.id),
              extra: ProductRouteArgs(heroTag: tag),
            ),
            footer: selectedIndex == 0
                ? _CafeFooter(
                    details: details,
                    highestFirst: _reviewsHighestFirst,
                    onSort: (value) =>
                        setState(() => _reviewsHighestFirst = value),
                    onProduct: (product, tag) => context.push(
                      AppRoutes.product(product.id),
                      extra: ProductRouteArgs(heroTag: tag),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

class _CafeHero extends StatelessWidget {
  const _CafeHero({required this.cafe, this.heroTag});
  final CafeSummary cafe;
  final String? heroTag;
  @override
  Widget build(BuildContext context) {
    final strings = CafeStrings(context);
    final image = Image.asset(
      cafe.heroImage,
      fit: BoxFit.cover,
      cacheWidth: 1200,
    );
    return Stack(
      fit: StackFit.expand,
      children: [
        heroTag == null ? image : Hero(tag: heroTag!, child: image),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x22000000), Color(0xEE000000)],
              stops: [.25, 1],
            ),
          ),
        ),
        PositionedDirectional(
          start: AppSpacing.lg,
          end: AppSpacing.lg,
          bottom: AppSpacing.lg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(cafe.logoImage),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                cafe.name,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 14,
                runSpacing: 6,
                children: [
                  _HeroMeta(Icons.star_rounded, cafe.rating.toStringAsFixed(1)),
                  _HeroMeta(
                    Icons.near_me_outlined,
                    '${cafe.distanceKm.toStringAsFixed(1)} km',
                  ),
                  _HeroMeta(
                    Icons.schedule_rounded,
                    '${cafe.preparationMinutes} min',
                  ),
                  _HeroMeta(
                    Icons.circle,
                    cafe.isOpen ? strings.open : strings.closed,
                    color: cafe.isOpen ? Colors.greenAccent : Colors.redAccent,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${strings.openingHours}: ${cafe.openingHours}',
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeroMeta extends StatelessWidget {
  const _HeroMeta(this.icon, this.label, {this.color});
  final IconData icon;
  final String label;
  final Color? color;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 16, color: color ?? Colors.white),
      const SizedBox(width: 4),
      Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}

class _CategoryHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _CategoryHeaderDelegate({
    required this.child,
    required this.selectedIndex,
    required this.height,
  });
  final Widget child;
  final int selectedIndex;
  final double height;
  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => Material(
    color: Theme.of(context).colorScheme.surface,
    elevation: overlapsContent ? 2 : 0,
    child: child,
  );
  @override
  bool shouldRebuild(_CategoryHeaderDelegate oldDelegate) =>
      oldDelegate.selectedIndex != selectedIndex ||
      oldDelegate.height != height ||
      oldDelegate.child != child;
}

class _StickyCategoryBar extends StatelessWidget {
  const _StickyCategoryBar({
    required this.categories,
    required this.selectedIndex,
    required this.arabic,
    required this.onSelected,
    super.key,
  });
  final List<CafeCategory> categories;
  final int selectedIndex;
  final bool arabic;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          for (var index = 0; index < categories.length; index++)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: AppSpacing.xs),
              child: Semantics(
                button: true,
                selected: selectedIndex == index,
                child: InkWell(
                  onTap: () => onSelected(index),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: AnimatedContainer(
                    duration: AppMotion.standard,
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: selectedIndex == index
                          ? colors.primaryContainer
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      _categoryLabel(arabic, categories[index]),
                      maxLines: 1,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: selectedIndex == index
                            ? colors.onPrimaryContainer
                            : colors.onSurfaceVariant,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CategoryMenu extends StatelessWidget {
  const _CategoryMenu({
    required this.products,
    required this.favorites,
    required this.onFavorite,
    required this.onQuickAdd,
    required this.onOpen,
    super.key,
    this.footer,
  });
  final List<CafeProduct> products;
  final Set<String> favorites;
  final ValueChanged<String> onFavorite;
  final ValueChanged<CafeProduct> onQuickAdd;
  final void Function(CafeProduct, String) onOpen;
  final Widget? footer;
  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Center(child: Text(CafeStrings(context).emptyMenu));
    }
    return ListView(
      key: PageStorageKey(products.first.category.name),
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        for (final product in products) ...[
          CafeProductCard(
            key: ValueKey('cafe-product-${product.id}'),
            product: product,
            heroTag: 'cafe-product-${product.id}',
            isFavorite: favorites.contains(product.id),
            onFavorite: () => onFavorite(product.id),
            onQuickAdd: () => onQuickAdd(product),
            onTap: () => onOpen(product, 'cafe-product-${product.id}'),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        ?footer,
      ],
    );
  }
}

class _CafeFooter extends StatelessWidget {
  const _CafeFooter({
    required this.details,
    required this.highestFirst,
    required this.onSort,
    required this.onProduct,
  });
  final CafeDetails details;
  final bool highestFirst;
  final ValueChanged<bool> onSort;
  final void Function(CafeProduct, String) onProduct;
  @override
  Widget build(BuildContext context) {
    final strings = CafeStrings(context);
    final reviews = [...details.reviews]
      ..sort(
        (a, b) => highestFirst
            ? b.rating.compareTo(a.rating)
            : b.createdAt.compareTo(a.createdAt),
      );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.xl),
        _RelatedProducts(
          title: strings.frequentlyTogether,
          products: details.frequentlyOrderedTogether,
          onProduct: onProduct,
        ),
        const SizedBox(height: AppSpacing.xl),
        _RelatedProducts(
          title: strings.recommended,
          products: details.recommendedProducts,
          onProduct: onProduct,
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          strings.customerReviews,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            ChoiceChip(
              label: Text(strings.newest),
              selected: !highestFirst,
              onSelected: (_) => onSort(false),
            ),
            ChoiceChip(
              label: Text(strings.highestRated),
              selected: highestFirst,
              onSelected: (_) => onSort(true),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        _RatingSummary(reviews: details.reviews),
        for (final review in reviews.take(5)) _ReviewCard(review: review),
      ],
    );
  }
}

class _RelatedProducts extends StatelessWidget {
  const _RelatedProducts({
    required this.title,
    required this.products,
    required this.onProduct,
  });
  final String title;
  final List<CafeProduct> products;
  final void Function(CafeProduct, String) onProduct;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
      ),
      const SizedBox(height: 10),
      SizedBox(
        height: 190,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: products.length,
          separatorBuilder: (_, _) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            final product = products[index];
            final tag = 'related-${title.hashCode}-${product.id}';
            return SizedBox(
              width: 150,
              child: InkWell(
                onTap: () => onProduct(product, tag),
                borderRadius: BorderRadius.circular(AppRadius.card),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: tag,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        child: Image.asset(
                          product.imageAsset,
                          height: 130,
                          width: 150,
                          fit: BoxFit.cover,
                          cacheWidth: 360,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      product.localizedName(CafeStrings(context).ar),
                      maxLines: 1,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}

class _RatingSummary extends StatelessWidget {
  const _RatingSummary({required this.reviews});
  final List<CafeReview> reviews;
  @override
  Widget build(BuildContext context) {
    final average =
        reviews.fold<int>(0, (sum, review) => sum + review.rating) /
        reviews.length;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Text(
            average.toStringAsFixed(1),
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              children: [
                for (var star = 5; star >= 1; star--)
                  Row(
                    children: [
                      SizedBox(width: 16, child: Text('$star')),
                      Expanded(
                        child: LinearProgressIndicator(
                          value:
                              reviews
                                  .where((review) => review.rating == star)
                                  .length /
                              reviews.length,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});
  final CafeReview review;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(child: Text(review.author.characters.first)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                review.author,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            Text(
              '★' * review.rating,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(review.comment),
        if (review.imageAssets.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                review.imageAssets.first,
                width: 96,
                height: 72,
                fit: BoxFit.cover,
                cacheWidth: 240,
              ),
            ),
          ),
      ],
    ),
  );
}

class _CafeLoadingView extends StatelessWidget {
  const _CafeLoadingView();
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          for (var i = 0; i < 4; i++)
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Container(
                height: 136,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

class _CafeErrorView extends StatelessWidget {
  const _CafeErrorView({required this.error, required this.onRetry});
  final Object error;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) {
    final strings = CafeStrings(context);
    final offline =
        error is CafeException &&
        (error as CafeException).type == CafeFailureType.offline;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                offline ? Icons.wifi_off_rounded : Icons.local_cafe_outlined,
                size: 56,
              ),
              const SizedBox(height: 16),
              Text(
                offline ? strings.offlineTitle : strings.errorTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              FilledButton(onPressed: onRetry, child: Text(strings.retry)),
            ],
          ),
        ),
      ),
    );
  }
}

String _categoryLabel(bool ar, CafeCategory category) => switch (category) {
  CafeCategory.popular => ar ? 'الأكثر طلبًا' : 'Popular',
  CafeCategory.hotCoffee => ar ? 'قهوة ساخنة' : 'Hot coffee',
  CafeCategory.icedCoffee => ar ? 'قهوة باردة' : 'Iced coffee',
  CafeCategory.matcha => ar ? 'ماتشا' : 'Matcha',
  CafeCategory.bakery => ar ? 'مخبوزات' : 'Bakery',
};
