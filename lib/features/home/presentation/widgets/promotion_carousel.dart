import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/home_content.dart';

class PromotionCarousel extends StatefulWidget {
  const PromotionCarousel({required this.promotions, super.key});

  final List<HomePromotion> promotions;

  @override
  State<PromotionCarousel> createState() => _PromotionCarouselState();
}

class _PromotionCarouselState extends State<PromotionCarousel> {
  static const _initialPage = 1000;
  late final PageController _controller;
  Timer? _timer;
  var _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      initialPage: _initialPage,
      viewportFraction: .92,
    );
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _advance());
  }

  void _advance() {
    if (!mounted || widget.promotions.length < 2 || !_controller.hasClients) {
      return;
    }
    if (MediaQuery.disableAnimationsOf(context)) return;
    _controller.nextPage(
      duration: AppMotion.emphasized,
      curve: AppMotion.transitionCurve,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.promotions.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        SizedBox(
          height: 188,
          child: PageView.builder(
            controller: _controller,
            allowImplicitScrolling: true,
            onPageChanged: (page) => setState(
              () => _selectedIndex = page % widget.promotions.length,
            ),
            itemBuilder: (context, page) {
              final promotion =
                  widget.promotions[page % widget.promotions.length];
              return Padding(
                padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
                child: _PromotionCard(promotion: promotion),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Semantics(
          label: '${_selectedIndex + 1} / ${widget.promotions.length}',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.promotions.length,
              (index) => AnimatedContainer(
                duration: AppMotion.standard,
                width: index == _selectedIndex ? 22 : 7,
                height: 7,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: index == _selectedIndex
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PromotionCard extends StatelessWidget {
  const _PromotionCard({required this.promotion});

  final HomePromotion promotion;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final (title, body) = switch (promotion.titleKey) {
      'promoTwo' => (l10n.promoTitleTwo, l10n.promoBodyTwo),
      'promoThree' => (l10n.promoTitleThree, l10n.promoBodyThree),
      _ => (l10n.promoTitleOne, l10n.promoBodyOne),
    };
    return Semantics(
      container: true,
      label: '$title. $body',
      child: DecoratedBox(
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.hero),
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
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: colors.onPrimaryContainer,
                              fontWeight: FontWeight.w800,
                              height: 1.08,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.onPrimaryContainer.withValues(
                            alpha: .75,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ExcludeSemantics(
                child: SizedBox(
                  width: 142,
                  height: double.infinity,
                  child: Image.asset(
                    promotion.imageAsset,
                    fit: BoxFit.cover,
                    cacheWidth: 420,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
