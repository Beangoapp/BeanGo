import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../shared/widgets/app_buttons.dart';
import '../../application/cafe_providers.dart';
import '../../domain/entities/cafe_entities.dart';
import '../cafe_strings.dart';

class ProductRouteArgs {
  const ProductRouteArgs({this.heroTag});
  final String? heroTag;
}

class ProductDetailsScreen extends ConsumerWidget {
  const ProductDetailsScreen({
    required this.productId,
    this.heroTag,
    super.key,
  });
  final String productId;
  final String? heroTag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(cafeProductProvider(productId));
    return product.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, _) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: FilledButton(
            onPressed: () => ref.invalidate(cafeProductProvider(productId)),
            child: Text(CafeStrings(context).retry),
          ),
        ),
      ),
      data: (value) => _ProductExperience(product: value, heroTag: heroTag),
    );
  }
}

class _ProductExperience extends ConsumerStatefulWidget {
  const _ProductExperience({required this.product, this.heroTag});
  final CafeProduct product;
  final String? heroTag;
  @override
  ConsumerState<_ProductExperience> createState() => _ProductExperienceState();
}

class _ProductExperienceState extends ConsumerState<_ProductExperience> {
  late final TextEditingController _notesController;
  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final strings = CafeStrings(context);
    final customization = ref.watch(productCustomizationProvider(product.id));
    final controller = ref.read(
      productCustomizationProvider(product.id).notifier,
    );
    final validation = ProductCustomizationEngine.validate(
      product,
      customization,
    );
    final total = ProductCustomizationEngine.total(product, customization);
    final favorites =
        ref.watch(cafeFavoritesProvider).value ?? const FavoritesState();
    final image = Image.asset(
      product.imageAsset,
      width: double.infinity,
      height: 360,
      fit: BoxFit.cover,
      cacheWidth: 1000,
    );
    return Scaffold(
      key: const ValueKey('product-details-screen'),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 360,
            actions: [
              IconButton.filledTonal(
                onPressed: () => ref
                    .read(cafeFavoritesProvider.notifier)
                    .toggleProduct(product.id),
                tooltip: 'Favorite',
                icon: Icon(
                  favorites.productIds.contains(product.id)
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                ),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: widget.heroTag == null
                  ? image
                  : Hero(tag: widget.heroTag!, child: image),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              140,
            ),
            sliver: SliverList.list(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        product.localizedName(strings.ar),
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                    ),
                    Text(
                      strings.qar(product.price),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${product.calories} ${strings.calories}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  product.localizedDescription(strings.ar),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.xl),
                for (final group in product.optionGroups) ...[
                  _OptionGroup(
                    group: group,
                    selected: customization.selections[group.id] ?? const {},
                    invalid: validation.invalidGroupIds.contains(group.id),
                    onSelected: (id) => controller.toggle(group, id),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
                Text(
                  strings.notes,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _notesController,
                  minLines: 2,
                  maxLines: 4,
                  maxLength: 180,
                  onChanged: controller.setNotes,
                  decoration: InputDecoration(hintText: strings.notesHint),
                ),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: Text(strings.saveCustomization),
                  value: customization.saveAsFavorite,
                  onChanged: controller.setSaveAsFavorite,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Text(
                      strings.quantity,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    IconButton.outlined(
                      onPressed: customization.quantity > 1
                          ? () => controller.setQuantity(
                              customization.quantity - 1,
                            )
                          : null,
                      icon: const Icon(Icons.remove_rounded),
                    ),
                    SizedBox(
                      width: 48,
                      child: Text(
                        '${customization.quantity}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    IconButton.outlined(
                      onPressed: () =>
                          controller.setQuantity(customization.quantity + 1),
                      icon: const Icon(Icons.add_rounded),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: AppButton(
            key: const ValueKey('product-add-to-cart'),
            label: validation.isValid
                ? '${strings.addToCart} · ${strings.qar(total)}'
                : strings.chooseRequired,
            onPressed: validation.isValid && product.available
                ? () {
                    ref
                        .read(cafeCartProvider.notifier)
                        .add(product, customization);
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(strings.added)));
                  }
                : null,
            icon: Icons.shopping_bag_outlined,
          ),
        ),
      ),
    );
  }
}

class _OptionGroup extends StatelessWidget {
  const _OptionGroup({
    required this.group,
    required this.selected,
    required this.invalid,
    required this.onSelected,
  });
  final ProductOptionGroup group;
  final Set<String> selected;
  final bool invalid;
  final ValueChanged<String> onSelected;
  @override
  Widget build(BuildContext context) {
    final strings = CafeStrings(context);
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                group.localizedName(strings.ar),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
              ),
            ),
            Text(
              group.isRequired
                  ? strings.required
                  : strings.selectUpTo(group.maxSelections),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: invalid ? colors.error : colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final option in group.options)
              FilterChip(
                selected: selected.contains(option.id),
                onSelected: option.available
                    ? (_) => onSelected(option.id)
                    : null,
                label: Text(
                  '${option.localizedName(strings.ar)}${option.extraPrice > 0 ? '  +${strings.qar(option.extraPrice)}' : ''}',
                ),
              ),
          ],
        ),
        if (invalid)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              strings.chooseRequired,
              style: TextStyle(color: colors.error),
            ),
          ),
      ],
    );
  }
}
