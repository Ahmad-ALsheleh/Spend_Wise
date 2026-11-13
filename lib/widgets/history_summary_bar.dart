import 'package:flutter/material.dart';
import '../models/currency.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';

/// الشريط الفاتح أعلى شاشة History: "X transactions" و"$Y spent".
/// مع العملتين يظهر مصروف كل عملة وحده، كلٌّ بسطر.
class HistorySummaryBar extends StatelessWidget {
  final int count;

  /// مجموع المصروفات لكل عملة.
  final Map<Currency, double> spent;

  /// عملة الصفر عندما لا توجد مصروفات.
  final Currency fallbackCurrency;

  const HistorySummaryBar({
    super.key,
    required this.count,
    required this.spent,
    required this.fallbackCurrency,
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
              strings.spent(
                strings.moneyList(spent, fallbackCurrency, separator: '\n'),
              ),
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
