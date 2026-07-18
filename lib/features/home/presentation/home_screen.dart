import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_icons.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_cards.dart';
import '../../recommendations/application/recommendation_providers.dart';
import '../../recommendations/domain/models/coffee_option.dart';
import '../../recommendations/domain/models/nearby_cafe.dart';
import '../../recommendations/domain/models/recommendation.dart';
import '../application/home_providers.dart';
import 'widgets/hero_coffee_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final request = ref.watch(homeRecommendationRequestProvider);
    final recommendations = ref.watch(homeRecommendationsProvider(request));
    final points = ref.watch(homeRewardsPointsProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: recommendations.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => _HomeError(
            onRetry: () => ref.invalidate(homeRecommendationsProvider(request)),
          ),
          data: (bundle) => CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.xxl,
                ),
                sliver: SliverList.list(
                  children: [
                    _GreetingHeader(
                      name: ref.watch(homeUserNameProvider),
                      now: request.now,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _HeroSection(
                      bundle: bundle,
                      onOrder: () => context.push(AppRoutes.coffeeDetails),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _RecommendationCard(bundle: bundle),
                    const SizedBox(height: AppSpacing.xl),
                    _NearbySection(cafes: bundle.nearbyCafes),
                    const SizedBox(height: AppSpacing.xl),
                    _RewardsCard(points: points),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const _HomeNavigation(),
    );
  }
}

class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader({required this.name, required this.now});

  final String? name;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
              Row(
                children: [
                  Icon(
                    AppIcons.weather,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(greeting, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                displayName,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -.5,
                ),
              ),
            ],
          ),
        ),
        IconButton.filledTonal(
          onPressed: () {},
          icon: const Icon(AppIcons.notifications),
          tooltip: l10n.notifications,
        ),
      ],
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.bundle, required this.onOrder});

  final RecommendationBundle bundle;
  final VoidCallback onOrder;

  @override
  Widget build(BuildContext context) {
    final order = bundle.orderAgain?.value;
    final item = order?.items.firstOrNull;
    final style = item?.style ?? bundle.timeBased.value;
    return HeroCoffeeCard(
      coffeeName: item?.name ?? _drinkName(context, style),
      cafeName: bundle.nearby?.value.name ?? 'BeanGo',
      readyMinutes: bundle.nearby?.value.estimatedPreparationMinutes ?? 5,
      imageAsset: _drinkAsset(style),
      onOrderAgain: onOrder,
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({required this.bundle});

  final RecommendationBundle bundle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final recommendation = bundle.weatherBased ?? bundle.timeBased;
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.control),
            child: Image.asset(
              _drinkAsset(recommendation.value),
              width: 84,
              height: 104,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      AppIcons.sparkle,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        l10n.aiRecommendation,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _drinkName(context, recommendation.value),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  l10n.recommendationBody,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                TextButton(
                  onPressed: () => showModalBottomSheet<void>(
                    context: context,
                    showDragHandle: true,
                    builder: (context) => Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Text(l10n.recommendationReason),
                    ),
                  ),
                  child: Text(l10n.why),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NearbySection extends StatelessWidget {
  const _NearbySection({required this.cafes});

  final List<NearbyCafe> cafes;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.nearbyCafes, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        if (cafes.isEmpty)
          AppCard(
            child: Row(
              children: [
                const Icon(AppIcons.location),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: Text(l10n.nearbyEmpty)),
              ],
            ),
          )
        else
          SizedBox(
            height: 176,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: cafes.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
              itemBuilder: (context, index) =>
                  _NearbyCafeCard(cafe: cafes[index]),
            ),
          ),
      ],
    );
  }
}

class _NearbyCafeCard extends StatelessWidget {
  const _NearbyCafeCard({required this.cafe});

  final NearbyCafe cafe;

  @override
  Widget build(BuildContext context) {
    final style = cafe.availableMenu.firstOrNull?.style ?? DrinkStyle.flatWhite;
    return SizedBox(
      width: 232,
      child: AppCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Image.asset(_drinkAsset(style), fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cafe.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    '${(cafe.distanceMeters / 1000).toStringAsFixed(1)} km · ${AppLocalizations.of(context).readyInMinutes(cafe.estimatedPreparationMinutes)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RewardsCard extends StatelessWidget {
  const _RewardsCard({required this.points});

  final int points;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(AppIcons.rewards),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  l10n.rewards,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Text(l10n.points(points)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          LinearProgressIndicator(value: (points % 100) / 100),
          const SizedBox(height: AppSpacing.sm),
          Text(l10n.rewardsBody, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _HomeNavigation extends StatelessWidget {
  const _HomeNavigation();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return NavigationBar(
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

String _drinkName(BuildContext context, DrinkStyle style) {
  final l10n = AppLocalizations.of(context);
  return switch (style) {
    DrinkStyle.espresso => l10n.espresso,
    DrinkStyle.flatWhite => l10n.flatWhite,
    DrinkStyle.coldBrew => l10n.coldBrew,
    DrinkStyle.icedLatte => l10n.icedLatte,
    DrinkStyle.decaf => l10n.decaf,
  };
}

String _drinkAsset(DrinkStyle style) => switch (style) {
  DrinkStyle.espresso => 'assets/images/americano.png',
  DrinkStyle.flatWhite => 'assets/images/flat_white.png',
  DrinkStyle.coldBrew => 'assets/images/cold_brew.png',
  DrinkStyle.icedLatte => 'assets/images/iced_latte.png',
  DrinkStyle.decaf => 'assets/images/cappuccino.png',
};
