import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';

class SocialSignInButton extends StatelessWidget {
  const SocialSignInButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    super.key,
    this.isLoading = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(minHeight: 56),
    child: OutlinedButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: Icon(icon, size: 22),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.control),
        ),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
    ),
  );
}
