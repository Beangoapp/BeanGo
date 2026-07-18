import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_buttons.dart';
import '../application/demo_cart_controller.dart';

class CoffeeDetailsScreen extends ConsumerWidget {
  const CoffeeDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final cart = ref.watch(demoCartProvider);
    final controller = ref.read(demoCartProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.coffeeDetails)),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.hero),
                      child: AspectRatio(
                        aspectRatio: 1.25,
                        child: Image.asset(
                          'assets/images/flat_white.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      l10n.signatureFlatWhite,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l10n.demoCafeName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(l10n.coffeeDescription),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      l10n.size,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    SegmentedButton<bool>(
                      segments: [
                        ButtonSegment(value: false, label: Text(l10n.regular)),
                        ButtonSegment(value: true, label: Text(l10n.large)),
                      ],
                      selected: {cart.isLarge},
                      onSelectionChanged: (value) =>
                          controller.setLarge(value.first),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.quantity,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        IconButton.filledTonal(
                          onPressed: controller.decrement,
                          icon: const Icon(Icons.remove_rounded),
                        ),
                        SizedBox(
                          width: 44,
                          child: Text(
                            '${cart.quantity}',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        IconButton.filled(
                          onPressed: controller.increment,
                          icon: const Icon(Icons.add_rounded),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: AppButton(
                label: l10n.addToCart(_money(cart.subtotal)),
                onPressed: () => context.push(AppRoutes.cart),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _money(double value) => 'QAR ${value.toStringAsFixed(2)}';
