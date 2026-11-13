import 'package:flutter/material.dart';
import '../models/currency.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/category_data.dart';
import '../utils/formatters.dart';

/// صف واحد بقسم "By Category": أيقونة + اسم + مبلغ + شريط تقدم ونسبته تحته.
class CategoryBreakdownTile extends StatelessWidget {
  final String categoryKey;
  final double amount;
  final double ratio; // 0.0 - 1.0 من إجمالي المصروفات
  final Color barColor;
  final Currency currency;

  const CategoryBreakdownTile({
    super.key,
    required this.categoryKey,
    required this.amount,
    required this.ratio,
    required this.barColor,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final category = CategoryData.findByKey(categoryKey);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(category.emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  AppStrings.of(context).categoryName(category.key),
                  style: TextStyle(fontSize: 14, color: colors.textPrimary),
                ),
              ),
              Text(
                AppStrings.of(context).money(amount, currency),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
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
              backgroundColor: colors.chartTrack,
              valueColor: AlwaysStoppedAnimation(barColor),
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Text(
              Formatters.percent((ratio * 100).round()),
              style: TextStyle(fontSize: 12, color: colors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
