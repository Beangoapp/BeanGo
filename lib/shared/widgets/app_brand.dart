import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/constants/app_strings.dart';

class AppBrand extends StatelessWidget {
  const AppBrand({super.key, this.compact = false, this.light = false});

  final bool compact;
  final bool light;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final foreground = light ? AppColors.warmWhite : colors.onSurface;
    final markBackground = light ? AppColors.caramel : colors.primary;
    final markForeground = light ? AppColors.espresso : colors.onPrimary;
    return Semantics(
      label: AppStrings.brandName,
      header: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: compact ? 30 : 44,
            height: compact ? 30 : 44,
            decoration: BoxDecoration(
              color: markBackground,
              borderRadius: BorderRadius.circular(AppRadius.control),
            ),
            child: Icon(
              Icons.coffee_rounded,
              size: compact ? 17 : 25,
              color: markForeground,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            AppStrings.brandName,
            style: TextStyle(
              color: foreground,
              fontSize: compact ? 18 : 26,
              fontWeight: FontWeight.w700,
              letterSpacing: compact ? -.5 : -.8,
            ),
          ),
        ],
      ),
    );
  }
}
