import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// مُحدد فترة عام: يعرض نص بالمنتصف مع سهمين يمين/يسار.
/// يُستخدم لعرض الشهر (July 2026) أو نطاق الأسبوع (Jul 6 – 12).
class MonthSelector extends StatelessWidget {
  final String label;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool nextEnabled;

  const MonthSelector({
    super.key,
    required this.label,
    required this.onPrevious,
    required this.onNext,
    this.nextEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onPrevious,
          icon: const Icon(Icons.chevron_left, color: AppColors.textPrimary),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        IconButton(
          onPressed: nextEnabled ? onNext : null,
          icon: Icon(
            Icons.chevron_right,
            color: nextEnabled ? AppColors.textPrimary : AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}