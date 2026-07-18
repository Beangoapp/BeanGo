import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_cards.dart';
import '../../recommendations/application/recommendation_providers.dart';
import '../../recommendations/domain/models/nearby_cafe.dart';
import '../application/home_providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _promoController = PageController(viewportFraction: .92);
  var _promoIndex = 0;
  var _categoryIndex = 0;

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final request = ref.watch(homeRecommendationRequestProvider);
    final recommendations = ref.watch(homeRecommendationsProvider(request));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        bottom: false,
        child: recommendations.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => _HomeError(
            onRetry: () => ref.invalidate(homeRecommendationsProvider(request)),
          ),
          data: (bundle) => CustomScrollView(
            physics: const BouncingScrollPhysics(),
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
                    _HomeEntrance(
                      child: _CompactHeader(
                        name: ref.watch(homeUserNameProvider),
                        now: request.now,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    const _HomeEntrance(
                      delay: Duration(milliseconds: 50),
                      child: _SearchField(),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _HomeEntrance(
                      delay: const Duration(milliseconds: 100),
                      child: _PromotionCarousel(
                        controller: _promoController,
                        selectedIndex: _promoIndex,
                        onPageChanged: (index) =>
                            setState(() => _promoIndex = index),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _HomeEntrance(
                      delay: const Duration(milliseconds: 150),
                      child: const _OrderAgainSection(),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _HomeEntrance(
                      delay: const Duration(milliseconds: 200),
                      child: _CategoriesSection(
                        selectedIndex: _categoryIndex,
                        onSelected: (index) =>
                            setState(() => _categoryIndex = index),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _HomeEntrance(
                      delay: const Duration(milliseconds: 250),
                      child: const _RecommendedSection(),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _HomeEntrance(
                      delay: const Duration(milliseconds: 300),
                      child: _NearbySection(cafes: bundle.nearbyCafes),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const _HomeEntrance(
                      delay: Duration(milliseconds: 350),
                      child: _PopularSection(),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const _HomeEntrance(
                      delay: Duration(milliseconds: 400),
                      child: _NewArrivalsSection(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const _ModernNavigation(),
    );
  }
}

class _CompactHeader extends StatelessWidget {
  const _CompactHeader({required this.name, required this.now});

  final String? name;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final greeting = now.hour < 12
        ? l10n.goodMorning
        : now.hour < 18
        ? l10n.goodAfternoon
        : l10n.goodEvening;
    final displayName = name?.trim().isNotEmpty == true
        ? name!.trim()
        : l10n.coffeeLover;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$greeting, $displayName',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -.25,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Row(
                children: [
                  Icon(AppIcons.location, size: 14, color: colors.primary),
                  const SizedBox(width: AppSpacing.xxs),
                  Flexible(
                    child: Text(
                      l10n.deliveryLocation,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 17,
                    color: colors.onSurfaceVariant,
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          tooltip: l10n.notifications,
          style: IconButton.styleFrom(
            backgroundColor: colors.surfaceContainerHigh,
          ),
          icon: const Icon(AppIcons.notifications, size: 20),
        ),
        const SizedBox(width: AppSpacing.xs),
        CircleAvatar(
          radius: 21,
          backgroundColor: colors.primaryContainer,
          child: Text(
            displayName.characters.first.toUpperCase(),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: colors.onPrimaryContainer,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      textField: true,
      label: l10n.searchCoffee,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: colors.outlineVariant.withValues(alpha: .7),
          ),
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withValues(alpha: .04),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsetsDirectional.only(
          start: AppSpacing.md,
          end: AppSpacing.xs,
        ),
        child: Row(
          children: [
            Icon(Icons.search_rounded, color: colors.onSurfaceVariant),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                l10n.searchCoffee,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ),
            IconButton.filled(
              onPressed: () {},
              tooltip: l10n.filter,
              icon: const Icon(Icons.tune_rounded, size: 19),
            ),
          ],
        ),
      ),
    );
  }
}

class _PromotionCarousel extends StatelessWidget {
  const _PromotionCarousel({
    required this.controller,
    required this.selectedIndex,
    required this.onPageChanged,
  });

  final PageController controller;
  final int selectedIndex;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final promotions = [
      (
        l10n.promoTitleOne,
        l10n.promoBodyOne,
        'assets/images/promo_coffee_tonic.png',
      ),
      (
        l10n.promoTitleTwo,
        l10n.promoBodyTwo,
        'assets/images/promo_coffee_pairing.png',
      ),
    ];
    return Column(
      children: [
        SizedBox(
          height: 184,
          child: PageView.builder(
            controller: controller,
            itemCount: promotions.length,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              final promo = promotions[index];
              return Padding(
                padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
                child: _PromoCard(
                  title: promo.$1,
                  body: promo.$2,
                  imageAsset: promo.$3,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            promotions.length,
            (index) => AnimatedContainer(
              duration: AppMotion.standard,
              width: selectedIndex == index ? 20 : 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: selectedIndex == index
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PromoCard extends StatelessWidget {
  const _PromoCard({
    required this.title,
    required this.body,
    required this.imageAsset,
  });

  final String title;
  final String body;
  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.hero),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: .08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: colors.onPrimaryContainer,
                      fontWeight: FontWeight.w800,
                      height: 1.08,
                      letterSpacing: -.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colors.onPrimaryContainer.withValues(alpha: .72),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 148,
            height: double.infinity,
            child: Image.asset(imageAsset, fit: BoxFit.cover),
          ),
        ],
      ),
    );
  }
}

class _OrderAgainSection extends StatelessWidget {
  const _OrderAgainSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: l10n.orderAgain),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 176,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              _CoffeeTile(
                name: l10n.spanishLatte,
                cafe: 'Flat White',
                image: 'assets/images/spanish_latte.png',
                onTap: () => context.push(AppRoutes.coffeeDetails),
              ),
              const SizedBox(width: AppSpacing.sm),
              _CoffeeTile(
                name: l10n.flatWhite,
                cafe: '% Arabica',
                image: 'assets/images/flat_white.png',
                onTap: () => context.push(AppRoutes.coffeeDetails),
              ),
              const SizedBox(width: AppSpacing.sm),
              _CoffeeTile(
                name: l10n.cortado,
                cafe: 'Volume Cafe',
                image: 'assets/images/hero_coffee.png',
                onTap: () => context.push(AppRoutes.coffeeDetails),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoriesSection extends StatelessWidget {
  const _CategoriesSection({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final categories = [
      (l10n.hotCoffee, Icons.local_cafe_rounded),
      (l10n.coldCoffee, Icons.ac_unit_rounded),
      (l10n.pastries, Icons.bakery_dining_rounded),
      (l10n.beans, Icons.coffee_rounded),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: l10n.categories),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 86,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.xxs),
            itemBuilder: (context, index) {
              final category = categories[index];
              return _CategoryItem(
                label: category.$1,
                icon: category.$2,
                selected: index == selectedIndex,
                onTap: () => onSelected(index),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RecommendedSection extends StatelessWidget {
  const _RecommendedSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: l10n.recommendedForYou),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 176,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              _CoffeeTile(
                name: l10n.v60,
                cafe: 'Earth Roastery',
                image: 'assets/images/americano.png',
                onTap: () => context.push(AppRoutes.coffeeDetails),
              ),
              const SizedBox(width: AppSpacing.sm),
              _CoffeeTile(
                name: l10n.coldBrew,
                cafe: 'CAF',
                image: 'assets/images/cold_brew.png',
                onTap: () => context.push(AppRoutes.coffeeDetails),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NearbySection extends StatelessWidget {
  const _NearbySection({required this.cafes});

  final List<NearbyCafe> cafes;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final visibleCafes = cafes.isNotEmpty
        ? cafes
        : [
            NearbyCafe(
              id: 'demo-1',
              name: 'CAF',
              distanceMeters: 800,
              estimatedPreparationMinutes: 5,
              menu: const [],
            ),
            NearbyCafe(
              id: 'demo-2',
              name: 'Halo',
              distanceMeters: 1400,
              estimatedPreparationMinutes: 8,
              menu: const [],
            ),
            const NearbyCafe(
              id: 'demo-3',
              name: 'Espresso Lab',
              distanceMeters: 2100,
              estimatedPreparationMinutes: 9,
              menu: [],
            ),
          ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: l10n.nearbyCafes),
        const SizedBox(height: AppSpacing.sm),
        ...visibleCafes.indexed.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _CafeListCard(
              cafe: entry.$2,
              image: const [
                'assets/images/coffee_beans.png',
                'assets/images/croissant.png',
                'assets/images/empty_cup.png',
              ][entry.$1 % 3],
            ),
          ),
        ),
      ],
    );
  }
}

class _PopularSection extends StatelessWidget {
  const _PopularSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: l10n.popularToday),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 176,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              _CoffeeTile(
                name: l10n.icedLatte,
                cafe: 'Halo',
                image: 'assets/images/iced_latte.png',
                onTap: () => context.push(AppRoutes.coffeeDetails),
              ),
              const SizedBox(width: AppSpacing.sm),
              _CoffeeTile(
                name: l10n.cappuccino,
                cafe: 'Espresso Lab',
                image: 'assets/images/cappuccino.png',
                onTap: () => context.push(AppRoutes.coffeeDetails),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NewArrivalsSection extends StatelessWidget {
  const _NewArrivalsSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: l10n.newArrivals),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 176,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              _CoffeeTile(
                name: l10n.matchaLatte,
                cafe: 'Volume Cafe',
                image: 'assets/images/matcha_latte.png',
                onTap: () => context.push(AppRoutes.coffeeDetails),
              ),
              const SizedBox(width: AppSpacing.sm),
              _CoffeeTile(
                name: l10n.pistachioLatte,
                cafe: 'Espresso Lab',
                image: 'assets/images/pistachio_latte.png',
                onTap: () => context.push(AppRoutes.coffeeDetails),
              ),
              const SizedBox(width: AppSpacing.sm),
              _CoffeeTile(
                name: l10n.saffronLatte,
                cafe: '% Arabica',
                image: 'assets/images/saffron_latte.png',
                onTap: () => context.push(AppRoutes.coffeeDetails),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Text(
    title,
    style: Theme.of(context).textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w800,
      letterSpacing: -.35,
    ),
  );
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: SizedBox(
          width: 72,
          child: Column(
            children: [
              AnimatedContainer(
                duration: AppMotion.standard,
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: selected
                      ? colors.primary
                      : colors.surfaceContainerHigh,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: selected ? colors.onPrimary : colors.primary,
                  size: 23,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
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

class _CoffeeTile extends StatelessWidget {
  const _CoffeeTile({
    required this.name,
    required this.cafe,
    required this.image,
    required this.onTap,
  });

  final String name;
  final String cafe;
  final String image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 124,
    child: _HomeCardShadow(
      child: AppCard(
        onTap: onTap,
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xxs),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.control),
                  child: SizedBox(
                    width: double.infinity,
                    child: Image.asset(image, fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                AppSpacing.xs,
                AppSpacing.xs,
                AppSpacing.xs,
                AppSpacing.sm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    cafe,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
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

class _HomeCardShadow extends StatelessWidget {
  const _HomeCardShadow({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: .06),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _CafeListCard extends StatelessWidget {
  const _CafeListCard({required this.cafe, required this.image});

  final NearbyCafe cafe;
  final String image;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 116,
    child: _HomeCardShadow(
      child: AppCard(
        padding: EdgeInsets.zero,
        child: Row(
          children: [
            SizedBox(
              width: 118,
              height: double.infinity,
              child: Image.asset(image, fit: BoxFit.cover),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      cafe.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: AppSpacing.xxs),
                        const Text('4.8'),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            '${(cafe.distanceMeters / 1000).toStringAsFixed(1)} km · ${AppLocalizations.of(context).readyInMinutes(cafe.estimatedPreparationMinutes)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _ModernNavigation extends StatelessWidget {
  const _ModernNavigation();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      child: Material(
        color: colors.surface,
        elevation: 0,
        shadowColor: colors.shadow.withValues(alpha: .12),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: colors.outlineVariant.withValues(alpha: .55),
              ),
            ),
          ),
          child: NavigationBar(
            height: 70,
            backgroundColor: Colors.transparent,
            indicatorColor: colors.primaryContainer,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
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
                icon: const Icon(AppIcons.orders),
                label: l10n.orders,
              ),
              NavigationDestination(
                icon: const Icon(AppIcons.rewards),
                label: l10n.rewards,
              ),
              NavigationDestination(
                icon: const Icon(AppIcons.profile),
                label: l10n.profile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeEntrance extends StatefulWidget {
  const _HomeEntrance({required this.child, this.delay = Duration.zero});

  final Widget child;
  final Duration delay;

  @override
  State<_HomeEntrance> createState() => _HomeEntranceState();
}

class _HomeEntranceState extends State<_HomeEntrance> {
  var _visible = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(widget.delay, () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final visible = MediaQuery.disableAnimationsOf(context) || _visible;
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: AppMotion.standard,
      curve: AppMotion.enterCurve,
      child: AnimatedSlide(
        offset: visible ? Offset.zero : const Offset(0, .018),
        duration: AppMotion.standard,
        curve: AppMotion.enterCurve,
        child: widget.child,
      ),
    );
  }
}

class _HomeError extends StatelessWidget {
  const _HomeError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(AppLocalizations.of(context).recommendationsUnavailable),
          const SizedBox(height: AppSpacing.md),
          IconButton.filled(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
    ),
  );
}
