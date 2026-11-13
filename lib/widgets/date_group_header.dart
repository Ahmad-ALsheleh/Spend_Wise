import 'package:flutter/material.dart';
import '../models/currency.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import 'section_label.dart';

/// رأس مجموعة يوم بشاشة History: TODAY / YESTERDAY / التاريخ، ومصروف ذلك اليوم
/// (لكل عملة وحدها إن وُجدت العملتان).
class DateGroupHeader extends StatelessWidget {
  final DateTime date;
  final Map<Currency, double> dayTotals;
  final Currency fallbackCurrency;

  const DateGroupHeader({
    super.key,
    required this.date,
    required this.dayTotals,
    required this.fallbackCurrency,
  });

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SectionLabel(strings.dayGroupLabel(date)),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              strings.moneyList(dayTotals, fallbackCurrency),
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.of(context).textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
