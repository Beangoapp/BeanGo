import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_brand.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    required this.userName,
    required this.locationLabel,
    required this.onChangeLocation,
    required this.onNotifications,
    super.key,
  });

  final String? userName;
  final String locationLabel;
  final VoidCallback onChangeLocation;
  final VoidCallback onNotifications;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final displayName = userName?.trim().isNotEmpty == true
        ? userName!.trim()
        : l10n.coffeeLover;
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: AppBrand(compact: true)),
            IconButton(
              onPressed: onNotifications,
              tooltip: l10n.notifications,
              style: IconButton.styleFrom(
                backgroundColor: colors.surfaceContainerHigh,
                minimumSize: const Size.square(48),
              ),
              icon: const Icon(AppIcons.notifications),
            ),
            const SizedBox(width: AppSpacing.xs),
            Semantics(
              label: displayName,
              image: true,
              child: CircleAvatar(
                radius: 24,
                backgroundColor: colors.primaryContainer,
                child: Text(
                  String.fromCharCode(displayName.runes.first).toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colors.onPrimaryContainer,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Icon(AppIcons.location, size: 18, color: colors.primary),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.deliveryLocation,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    locationLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: onChangeLocation,
              child: Text(l10n.changeLocation),
            ),
          ],
        ),
      ],
    );
  }
}

class AnimatedHomeSearch extends StatefulWidget {
  const AnimatedHomeSearch({
    required this.controller,
    required this.onChanged,
    required this.onClear,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  State<AnimatedHomeSearch> createState() => _AnimatedHomeSearchState();
}

class _AnimatedHomeSearchState extends State<AnimatedHomeSearch> {
  Timer? _timer;
  var _hintIndex = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (mounted && widget.controller.text.isEmpty) {
        setState(() => _hintIndex = (_hintIndex + 1) % 3);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hints = [l10n.searchCafes, l10n.searchDrinks, l10n.searchDesserts];
    return TextField(
      controller: widget.controller,
      onChanged: (value) {
        widget.onChanged(value);
        setState(() {});
      },
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search_rounded),
        hint: AnimatedSwitcher(
          duration: MediaQuery.disableAnimationsOf(context)
              ? Duration.zero
              : AppMotion.standard,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween(
                begin: const Offset(0, .25),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ),
          child: Text(hints[_hintIndex], key: ValueKey(_hintIndex)),
        ),
        suffixIcon: widget.controller.text.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  widget.controller.clear();
                  widget.onClear();
                  setState(() {});
                },
                tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
                icon: const Icon(Icons.close_rounded),
              ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 1.6,
          ),
        ),
      ),
    );
  }
}
