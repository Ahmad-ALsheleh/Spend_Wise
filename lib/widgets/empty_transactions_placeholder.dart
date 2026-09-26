import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// الحالة الفارغة "No transactions yet" المعروضة بالشاشة الرئيسية
/// عندما لا توجد أي معاملة بعد.
class EmptyTransactionsPlaceholder extends StatelessWidget {
  final String title;
  final String subtitle;

  const EmptyTransactionsPlaceholder({
    super.key,
    this.title = 'No transactions yet',
    this.subtitle = 'Tap + to add your first entry',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          const Text('💵', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}