import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_buttons.dart';
import '../../../shared/widgets/app_cards.dart';
import '../application/demo_cart_controller.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final cart = ref.watch(demoCartProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.checkout)),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CheckoutCard(
                icon: AppIcons.location,
                title: l10n.pickup,
                body: l10n.pickupBody,
              ),
              const SizedBox(height: AppSpacing.md),
              _CheckoutCard(
                icon: Icons.credit_card_rounded,
                title: l10n.payment,
                body: l10n.paymentBody,
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.total,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Text(
                    _money(cart.total),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: l10n.placeOrder(_money(cart.total)),
                onPressed: () => context.go(AppRoutes.orderSuccess),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CheckoutCard extends StatelessWidget {
  const _CheckoutCard({
    required this.icon,
    required this.title,
    required this.body,
  });
  final IconData icon;
  final String title;
  final String body;
  @override
  Widget build(BuildContext context) => AppCard(
    padding: const EdgeInsets.all(AppSpacing.lg),
    child: Row(
      children: [
        Icon(icon),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.xxs),
              Text(body),
            ],
          ),
        ),
      ],
    ),
  );
}

String _money(double value) => 'QAR ${value.toStringAsFixed(2)}';
