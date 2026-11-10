import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/formatters.dart';

/// الشريط الفاتح أعلى شاشة History: "X transactions" و"$Y spent".
class HistorySummaryBar extends StatelessWidget {
  final int count;
  final double totalSpent;

  const HistorySummaryBar({
    super.key,
    required this.count,
    required this.totalSpent,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final strings = AppStrings.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: colors.highlight,
        borderRadius: BorderRadius.circular(16),
      ),
      // Flexible: الجمل العربية أطول، ومع تكبير الخط تلتف بدل أن تتجاوز العرض.
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              strings.transactionsCount(count),
              style: TextStyle(fontSize: 14, color: colors.onHighlight),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              strings.spent(Formatters.currency(totalSpent)),
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: colors.onHighlight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
