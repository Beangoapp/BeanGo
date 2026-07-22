import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_buttons.dart';
import '../../domain/repositories/home_repository.dart';

class HomeLoadingSkeleton extends StatefulWidget {
  const HomeLoadingSkeleton({super.key});

  @override
  State<HomeLoadingSkeleton> createState() => _HomeLoadingSkeletonState();
}

class _HomeLoadingSkeletonState extends State<HomeLoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) _controller.stop();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final color = Color.lerp(
          Theme.of(context).colorScheme.surfaceContainer,
          Theme.of(context).colorScheme.surfaceContainerHighest,
          _controller.value,
        )!;
        return ListView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Row(
              children: [
                Expanded(child: _Skeleton(color: color, height: 44)),
                const SizedBox(width: AppSpacing.sm),
                _Skeleton(color: color, height: 48, width: 48, circle: true),
                const SizedBox(width: AppSpacing.xs),
                _Skeleton(color: color, height: 48, width: 48, circle: true),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _Skeleton(color: color, height: 56),
            const SizedBox(height: AppSpacing.lg),
            _Skeleton(color: color, height: 188, radius: AppRadius.hero),
            const SizedBox(height: AppSpacing.xl),
            _Skeleton(color: color, height: 28, width: 190),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 244,
              child: Row(
                children: [
                  Expanded(
                    child: _Skeleton(
                      color: color,
                      height: 244,
                      radius: AppRadius.card,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _Skeleton(
                      color: color,
                      height: 244,
                      radius: AppRadius.card,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ),
  );
}

class HomeUnavailableState extends StatelessWidget {
  const HomeUnavailableState({
    required this.error,
    required this.onRetry,
    super.key,
  });

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final offline =
        error is HomeException &&
        (error as HomeException).type == HomeFailureType.offline;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              offline ? Icons.cloud_off_rounded : Icons.coffee_maker_outlined,
              size: 58,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              offline ? l10n.homeOfflineTitle : l10n.homeErrorTitle,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              offline ? l10n.homeOfflineBody : l10n.homeErrorBody,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(label: l10n.retry, onPressed: onRetry, expand: false),
          ],
        ),
      ),
    );
  }
}

class HomeEmptyState extends StatelessWidget {
  const HomeEmptyState({required this.onRefresh, super.key});

  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.local_cafe_outlined,
              size: 58,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              l10n.homeEmptyTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(l10n.homeEmptyBody, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.lg),
            AppButton(label: l10n.retry, onPressed: onRefresh, expand: false),
          ],
        ),
      ),
    );
  }
}

class HomeNoSearchResults extends StatelessWidget {
  const HomeNoSearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.huge),
      child: Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 52,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.noSearchResults,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(l10n.noSearchResultsBody, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton({
    required this.color,
    required this.height,
    this.width,
    this.radius = AppRadius.input,
    this.circle = false,
  });

  final Color color;
  final double height;
  final double? width;
  final double radius;
  final bool circle;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: color,
      shape: circle ? BoxShape.circle : BoxShape.rectangle,
      borderRadius: circle ? null : BorderRadius.circular(radius),
    ),
  );
}
