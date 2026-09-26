import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/formatters.dart';

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
          Text(
            Formatters.dateGroupLabel(date),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
              letterSpacing: 0.5,
            ),
          ),
          Text(
            Formatters.currency(dayTotal),
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}