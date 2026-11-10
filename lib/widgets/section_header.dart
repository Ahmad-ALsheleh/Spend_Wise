import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// عنوان قسم مع زر نصي اختياري بالطرف (Recent ... See all).
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
        if (actionLabel != null)
          GestureDetector(
            onTap: onActionTap,
            child: Text(
              actionLabel!,
              style: TextStyle(
                color: colors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }
}
