import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_buttons.dart';
import '../../../shared/widgets/app_cards.dart';
import '../application/demo_cart_controller.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final cart = ref.watch(demoCartProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.cart)),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.yourOrder,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.control),
                      child: Image.asset(
                        'assets/images/flat_white.png',
                        width: 88,
                        height: 104,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.signatureFlatWhite,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(cart.isLarge ? l10n.large : l10n.regular),
                          Text('× ${cart.quantity}'),
                        ],
                      ),
                    ),
                    Text(_money(cart.subtotal)),
                  ],
                ),
              ),
              const Spacer(),
              _PriceRow(label: l10n.subtotal, value: _money(cart.subtotal)),
              const SizedBox(height: AppSpacing.sm),
              _PriceRow(label: l10n.serviceFee, value: _money(cart.serviceFee)),
              const Divider(height: AppSpacing.xl),
              _PriceRow(
                label: l10n.total,
                value: _money(cart.total),
                emphasized: true,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: l10n.continueToCheckout,
                onPressed: () => context.push(AppRoutes.checkout),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });
  final String label;
  final String value;
  final bool emphasized;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(child: Text(label)),
      Text(
        value,
        style: emphasized ? Theme.of(context).textTheme.titleMedium : null,
      ),
    ],
  );
}

String _money(double value) => 'QAR ${value.toStringAsFixed(2)}';
