import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollCacheExtent;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../order_demo/presentation/coffee_details_screen.dart';
import '../application/home_providers.dart';
import '../domain/entities/home_content.dart';
import 'widgets/home_cards.dart';
import 'widgets/home_header.dart';
import 'widgets/home_states.dart';
import 'widgets/promotion_carousel.dart';

typedef _ProductTap = void Function(HomeProduct product, String heroTag);

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  late final AnimationController _entranceController;
  HomeCategoryType? _selectedCategory;
  var _imagesPrecached = false;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: AppMotion.emphasized,
    )..forward();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) _entranceController.value = 1;
    if (!_imagesPrecached) {
      _imagesPrecached = true;
      for (final asset in const [
        'assets/images/promo_coffee_tonic.png',
        'assets/images/promo_coffee_pairing.png',
        'assets/images/spanish_latte.png',
      ]) {
        precacheImage(AssetImage(asset), context);
      }
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.extentAfter < 420) {
      ref.read(homeFeedProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _openProduct(HomeProduct product, String heroTag) {
    final l10n = AppLocalizations.of(context);
    context.push(
      AppRoutes.coffeeDetails,
      extra: CoffeeDetailsArgs(
        name: _productName(l10n, product),
        cafeName: product.cafeName,
        imageAsset: product.imageAsset,
        heroTag: heroTag,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final feed = ref.watch(homeFeedProvider);
    return Scaffold(
      key: const ValueKey('home-screen'),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        bottom: false,
        child: feed.when(
          loading: () => const HomeLoadingSkeleton(),
          error: (error, _) => HomeUnavailableState(
            error: error,
            onRetry: () => ref.invalidate(homeFeedProvider),
          ),
          data: (content) => content.isEmpty
              ? HomeEmptyState(
                  onRefresh: () =>
                      ref.read(homeFeedProvider.notifier).refreshFeed(),
                )
              : FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _entranceController,
                    curve: AppMotion.enterCurve,
                  ),
                  child: _HomeContent(
                    content: content,
                    scrollController: _scrollController,
                    searchController: _searchController,
                    selectedCategory: _selectedCategory,
                    onCategorySelected: (category) => setState(
                      () => _selectedCategory = _selectedCategory == category
                          ? null
                          : category,
                    ),
                    onProductTap: _openProduct,
                    onQuickAdd: (product) {
                      ref.read(homeCartProvider.notifier).add(product);
                      _showMessage(AppLocalizations.of(context).addedToOrder);
                    },
                    onFavorite: (cafe) => ref
                        .read(homeFeedProvider.notifier)
                        .toggleFavorite(cafe.id),
                    onRefresh: () =>
                        ref.read(homeFeedProvider.notifier).refreshFeed(),
                    onMessage: _showMessage,
                  ),
                ),
        ),
      ),
      bottomNavigationBar: const _HomeNavigation(),
    );
  }
}

class _HomeContent extends ConsumerWidget {
  const _HomeContent({
    required this.content,
    required this.scrollController,
    required this.searchController,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onProductTap,
    required this.onQuickAdd,
    required this.onFavorite,
    required this.onRefresh,
    required this.onMessage,
  });

  final HomeFeedState content;
  final ScrollController scrollController;
  final TextEditingController searchController;
  final HomeCategoryType? selectedCategory;
  final ValueChanged<HomeCategoryType> onCategorySelected;
  final _ProductTap onProductTap;
  final ValueChanged<HomeProduct> onQuickAdd;
  final ValueChanged<HomeCafe> onFavorite;
  final Future<void> Function() onRefresh;
  final ValueChanged<String> onMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final query = ref.watch(homeSearchQueryProvider).toLowerCase();
    final products = _uniqueProducts([
      ...content.trendingDrinks,
      ...content.recommendedProducts,
      ...content.recentOrders.map((order) => order.product),
    ]);
    final cafes = _uniqueCafes([
      ...content.nearbyCafes,
      ...content.featuredCafes,
    ]);
    final searchResults = HomeSearchResults(
      cafes: query.isEmpty
          ? const []
          : cafes
                .where((cafe) => cafe.name.toLowerCase().contains(query))
                .toList(),
      products: query.isEmpty
          ? const []
          : products.where((product) {
              final name = _productName(l10n, product).toLowerCase();
              return name.contains(query) ||
                  product.cafeName.toLowerCase().contains(query);
            }).toList(),
    );

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: CustomScrollView(
        key: const PageStorageKey('home-scroll'),
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        scrollCacheExtent: const ScrollCacheExtent.pixels(900),
        slivers: [
          SliverPadding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.xxl,
            ),
            sliver: SliverList.list(
              children: [
                HomeHeader(
                  key: const ValueKey('home-header'),
                  userName: ref.watch(homeUserNameProvider),
                  locationLabel: _locationName(
                    l10n,
                    ref.watch(homeLocationIndexProvider),
                  ),
                  onChangeLocation: () => _showLocationPicker(context, ref),
                  onNotifications: () => onMessage(l10n.notifications),
                ),
                const SizedBox(height: AppSpacing.md),
                AnimatedHomeSearch(
                  controller: searchController,
                  onChanged: ref.read(homeSearchQueryProvider.notifier).update,
                  onClear: ref.read(homeSearchQueryProvider.notifier).clear,
                ),
                const SizedBox(height: AppSpacing.lg),
                if (query.isNotEmpty)
                  _SearchResultsSection(
                    results: searchResults,
                    onProductTap: onProductTap,
                    onQuickAdd: onQuickAdd,
                    onFavorite: onFavorite,
                  )
                else ...[
                  PromotionCarousel(
                    key: const ValueKey('home-section-promotions'),
                    promotions: content.promotions,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _CategoriesSection(
                    categories: content.categories,
                    selected: selectedCategory,
                    onSelected: onCategorySelected,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _NearbySection(
                    cafes: content.nearbyCafes,
                    onFavorite: onFavorite,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _FeaturedSection(cafes: content.featuredCafes),
                  const SizedBox(height: AppSpacing.xl),
                  _ProductSection(
                    key: const ValueKey('home-section-trending'),
                    title: l10n.trendingDrinks,
                    products: _filterProducts(
                      content.trendingDrinks,
                      selectedCategory,
                    ),
                    onTap: onProductTap,
                    onQuickAdd: onQuickAdd,
                  ),
                  if (content.recentOrders.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xl),
                    _RecentlyOrderedSection(
                      key: const ValueKey('home-section-recently-ordered'),
                      orders: content.recentOrders,
                      onTap: onProductTap,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xl),
                  _ProductSection(
                    key: const ValueKey('home-section-recommended'),
                    title: l10n.recommendedForYouTitle,
                    products: _filterProducts(
                      content.recommendedProducts,
                      selectedCategory,
                    ),
                    onTap: onProductTap,
                    onQuickAdd: onQuickAdd,
                  ),
                  if (content.isLoadingMore) ...[
                    const SizedBox(height: AppSpacing.lg),
                    const Center(child: CircularProgressIndicator()),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoriesSection extends StatelessWidget {
  const _CategoriesSection({
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  final List<HomeCategory> categories;
  final HomeCategoryType? selected;
  final ValueChanged<HomeCategoryType> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionHeader(
          key: const ValueKey('home-section-categories'),
          title: l10n.categories,
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 96,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selected == category.type;
              return _CategoryChip(
                category: category.type,
                selected: isSelected,
                onTap: () => onSelected(category.type),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final HomeCategoryType category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final label = _categoryName(AppLocalizations.of(context), category);
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: SizedBox(
          width: 76,
          child: Column(
            children: [
              AnimatedContainer(
                duration: AppMotion.standard,
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected
                      ? colors.primary
                      : colors.surfaceContainerHigh,
                ),
                child: Icon(
                  _categoryIcon(category),
                  color: selected ? colors.onPrimary : colors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NearbySection extends StatelessWidget {
  const _NearbySection({required this.cafes, required this.onFavorite});

  final List<HomeCafe> cafes;
  final ValueChanged<HomeCafe> onFavorite;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionHeader(
          key: const ValueKey('home-section-nearby'),
          title: l10n.nearbyCafes,
          onViewAll: () {},
        ),
        const SizedBox(height: AppSpacing.sm),
        for (final cafe in cafes) ...[
          NearbyCafeCard(
            cafe: cafe,
            onFavorite: () => onFavorite(cafe),
            onTap: () {},
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _FeaturedSection extends StatelessWidget {
  const _FeaturedSection({required this.cafes});

  final List<HomeCafe> cafes;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      HomeSectionHeader(
        key: const ValueKey('home-section-featured'),
        title: AppLocalizations.of(context).featuredCafes,
      ),
      const SizedBox(height: AppSpacing.sm),
      SizedBox(
        height: 224,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: cafes.length,
          separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
          itemBuilder: (context, index) =>
              FeaturedCafeCard(cafe: cafes[index], onTap: () {}),
        ),
      ),
    ],
  );
}

class _ProductSection extends StatelessWidget {
  const _ProductSection({
    required this.title,
    required this.products,
    required this.onTap,
    required this.onQuickAdd,
    super.key,
  });

  final String title;
  final List<HomeProduct> products;
  final _ProductTap onTap;
  final ValueChanged<HomeProduct> onQuickAdd;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();
    final height =
        (264 + (MediaQuery.textScalerOf(context).scale(16) - 16).clamp(0, 32))
            .toDouble();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionHeader(title: title),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: height,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              final product = products[index];
              return HomeProductCard(
                product: product,
                displayName: _productName(
                  AppLocalizations.of(context),
                  product,
                ),
                heroTag: '${title.hashCode}-${product.heroTag}',
                onTap: () =>
                    onTap(product, '${title.hashCode}-${product.heroTag}'),
                onQuickAdd: () => onQuickAdd(product),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RecentlyOrderedSection extends StatelessWidget {
  const _RecentlyOrderedSection({
    required this.orders,
    required this.onTap,
    super.key,
  });

  final List<HomeRecentOrder> orders;
  final _ProductTap onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionHeader(title: l10n.recentlyOrdered),
        const SizedBox(height: AppSpacing.sm),
        for (final order in orders)
          Material(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppRadius.card),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.input),
                    child: Image.asset(
                      order.product.imageAsset,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      cacheWidth: 216,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _productName(l10n, order.product),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        Text(
                          order.product.cafeName,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  FilledButton.tonal(
                    onPressed: () =>
                        onTap(order.product, 'recent-${order.product.heroTag}'),
                    child: Text(l10n.reorder),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _SearchResultsSection extends StatelessWidget {
  const _SearchResultsSection({
    required this.results,
    required this.onProductTap,
    required this.onQuickAdd,
    required this.onFavorite,
  });

  final HomeSearchResults results;
  final _ProductTap onProductTap;
  final ValueChanged<HomeProduct> onQuickAdd;
  final ValueChanged<HomeCafe> onFavorite;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (results.isEmpty) return const HomeNoSearchResults();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionHeader(
          key: const ValueKey('home-section-search-results'),
          title: l10n.searchResults,
        ),
        const SizedBox(height: AppSpacing.md),
        for (final cafe in results.cafes) ...[
          NearbyCafeCard(
            key: ValueKey('home-search-result-cafe-${cafe.id}'),
            cafe: cafe,
            onFavorite: () => onFavorite(cafe),
            onTap: () {},
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (results.products.isNotEmpty)
          _ProductSection(
            key: const ValueKey('home-search-products'),
            title: l10n.trendingDrinks,
            products: results.products,
            onTap: onProductTap,
            onQuickAdd: onQuickAdd,
          ),
      ],
    );
  }
}

class _HomeNavigation extends ConsumerWidget {
  const _HomeNavigation();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final itemCount = ref.watch(
      homeCartProvider.select(
        (items) => items.values.fold<int>(0, (sum, value) => sum + value),
      ),
    );
    return SafeArea(
      top: false,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(
            top: BorderSide(color: colors.outlineVariant.withValues(alpha: .6)),
          ),
        ),
        child: NavigationBar(
          key: const ValueKey('home-navigation'),
          height: 72,
          backgroundColor: Colors.transparent,
          indicatorColor: colors.primaryContainer,
          selectedIndex: 0,
          onDestinationSelected: (_) {},
          destinations: [
            NavigationDestination(
              icon: const Icon(AppIcons.home),
              label: l10n.home,
            ),
            NavigationDestination(
              icon: const Icon(AppIcons.explore),
              label: l10n.explore,
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: itemCount > 0,
                label: Text('$itemCount'),
                child: const Icon(AppIcons.orders),
              ),
              label: l10n.orders,
            ),
            NavigationDestination(
              icon: const Icon(AppIcons.profile),
              label: l10n.profile,
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _showLocationPicker(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  final locations = [
    l10n.currentLocation,
    l10n.pearlLocation,
    l10n.msheirebLocation,
  ];
  final selected = ref.read(homeLocationIndexProvider);
  final result = await showModalBottomSheet<int>(
    context: context,
    showDragHandle: true,
    useSafeArea: true,
    builder: (context) => ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      itemCount: locations.length,
      itemBuilder: (context, index) => ListTile(
        minTileHeight: 56,
        leading: const Icon(Icons.location_on_outlined),
        title: Text(locations[index]),
        trailing: index == selected ? const Icon(Icons.check_rounded) : null,
        onTap: () => Navigator.of(context).pop(index),
      ),
    ),
  );
  if (result != null) {
    ref.read(homeLocationIndexProvider.notifier).select(result);
  }
}

List<HomeProduct> _filterProducts(
  List<HomeProduct> products,
  HomeCategoryType? category,
) => category == null
    ? products
    : products.where((product) => product.category == category).toList();

List<HomeProduct> _uniqueProducts(Iterable<HomeProduct> products) {
  final values = <String, HomeProduct>{};
  for (final product in products) {
    values[product.id] = product;
  }
  return values.values.toList();
}

List<HomeCafe> _uniqueCafes(Iterable<HomeCafe> cafes) {
  final values = <String, HomeCafe>{};
  for (final cafe in cafes) {
    values[cafe.id] = cafe;
  }
  return values.values.toList();
}

String _productName(AppLocalizations l10n, HomeProduct product) =>
    switch (product.nameKey) {
      'spanishLatte' => l10n.spanishLatte,
      'flatWhite' => l10n.flatWhite,
      'coldBrew' => l10n.coldBrew,
      'cappuccino' => l10n.cappuccino,
      'matchaLatte' => l10n.matchaLatte,
      'pistachioLatte' => l10n.pistachioLatte,
      'saffronLatte' => l10n.saffronLatte,
      'americano' => l10n.americano,
      'chocolateCroissant' => l10n.chocolateCroissant,
      _ => product.nameKey,
    };

String _locationName(AppLocalizations l10n, int index) => switch (index) {
  1 => l10n.pearlLocation,
  2 => l10n.msheirebLocation,
  _ => l10n.currentLocation,
};

String _categoryName(AppLocalizations l10n, HomeCategoryType category) =>
    switch (category) {
      HomeCategoryType.hotCoffee => l10n.hotCoffee,
      HomeCategoryType.icedCoffee => l10n.icedCoffee,
      HomeCategoryType.espresso => l10n.espressoCategory,
      HomeCategoryType.matcha => l10n.matchaCategory,
      HomeCategoryType.tea => l10n.teaCategory,
      HomeCategoryType.desserts => l10n.dessertsCategory,
      HomeCategoryType.bakery => l10n.bakeryCategory,
      HomeCategoryType.breakfast => l10n.breakfastCategory,
    };

IconData _categoryIcon(HomeCategoryType category) => switch (category) {
  HomeCategoryType.hotCoffee => Icons.local_cafe_rounded,
  HomeCategoryType.icedCoffee => Icons.ac_unit_rounded,
  HomeCategoryType.espresso => Icons.coffee_maker_rounded,
  HomeCategoryType.matcha => Icons.eco_rounded,
  HomeCategoryType.tea => Icons.emoji_food_beverage_rounded,
  HomeCategoryType.desserts => Icons.cake_rounded,
  HomeCategoryType.bakery => Icons.bakery_dining_rounded,
  HomeCategoryType.breakfast => Icons.breakfast_dining_rounded,
};
