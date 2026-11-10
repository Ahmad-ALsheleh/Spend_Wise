import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/formatters.dart';
import 'section_label.dart';

/// رأس مجموعة يوم بشاشة History: TODAY / YESTERDAY / التاريخ، ومصروف ذلك اليوم.
class DateGroupHeader extends StatelessWidget {
  final DateTime date;
  final double dayTotal;

  const DateGroupHeader({
    super.key,
    required this.date,
    required this.dayTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SectionLabel(AppStrings.of(context).dayGroupLabel(date)),
          Text(
            Formatters.currency(dayTotal),
            style: TextStyle(
              fontSize: 12,
              color: AppColors.of(context).textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
