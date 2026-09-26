import 'package:flutter/material.dart';
import '../utils/category_data.dart';
import '../utils/app_colors.dart';
import '../utils/formatters.dart';

/// صف واحد بقسم "By Category": أيقونة + اسم + مبلغ + شريط تقدم نسبي.
class CategoryBreakdownTile extends StatelessWidget {
  final String categoryKey;
  final double amount;
  final double ratio; // 0.0 - 1.0 من إجمالي المصروفات
  final Color barColor;

  const CategoryBreakdownTile({
    super.key,
    required this.categoryKey,
    required this.amount,
    required this.ratio,
    required this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    final category = CategoryData.findByKey(categoryKey);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(category.emoji, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Text(category.label,
                      style: const TextStyle(
                          fontSize: 14, color: AppColors.textPrimary)),
                ],
              ),
              Text(
                Formatters.currency(amount),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: ratio.clamp(0, 1),
              minHeight: 8,
              backgroundColor: AppColors.divider,
              valueColor: AlwaysStoppedAnimation(barColor),
            ),
          ),
        ],
      ),
    );
  }
}