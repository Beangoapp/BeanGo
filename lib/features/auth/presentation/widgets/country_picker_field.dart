import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../domain/country.dart';

class CountryPickerField extends StatelessWidget {
  const CountryPickerField({
    required this.country,
    required this.label,
    required this.onChanged,
    super.key,
  });

  final Country country;
  final String label;
  final ValueChanged<Country> onChanged;

  Future<void> _showPicker(BuildContext context) async {
    final selected = await showModalBottomSheet<Country>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (context) => Semantics(
        label: label,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.xs,
            AppSpacing.md,
            AppSpacing.lg,
          ),
          itemCount: SupportedCountries.all.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final option = SupportedCountries.all[index];
            return ListTile(
              minTileHeight: 56,
              leading: Text(option.flag, style: const TextStyle(fontSize: 24)),
              title: Text(option.isoCode),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(option.dialCode),
                  if (option.isoCode == country.isoCode) ...[
                    const SizedBox(width: AppSpacing.sm),
                    const Icon(AppIcons.check, color: AppColors.success),
                  ],
                ],
              ),
              onTap: () => Navigator.of(context).pop(option),
            );
          },
        ),
      ),
    );
    if (selected != null) onChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$label ${country.isoCode} ${country.dialCode}',
      child: InkWell(
        onTap: () => _showPicker(context),
        borderRadius: BorderRadius.circular(AppRadius.input),
        child: InputDecorator(
          decoration: InputDecoration(labelText: label),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(country.flag, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: AppSpacing.xs),
              Text(country.dialCode),
              const SizedBox(width: AppSpacing.xxs),
              const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
