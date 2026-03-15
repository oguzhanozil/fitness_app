import 'package:flutter/material.dart';

import '../../../../core/themes/theme_colors.dart';

class HistoryDeleteButton extends StatelessWidget {
  const HistoryDeleteButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: 'Delete conversation',
      icon: const Icon(
        Icons.delete_outline,
        size: 20,
        color: ThemeColors.woodTextSecondary,
      ),
    );
  }
}
