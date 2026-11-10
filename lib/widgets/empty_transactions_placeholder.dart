import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';

/// الحالة الفارغة "No transactions yet" عندما لا توجد معاملات بالشهر المعروض.
class EmptyTransactionsPlaceholder extends StatelessWidget {
  const EmptyTransactionsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final strings = AppStrings.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Text(strings.emptyStateEmoji, style: const TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          Text(
            strings.emptyTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            strings.emptySubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
