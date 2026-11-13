import 'package:flutter/material.dart';
import '../models/currency.dart';
import '../utils/app_strings.dart';

/// بطاقة رقم صغيرة بشاشة Analytics (Income / Expenses / Saved أو Avg/day).
class AnalyticsStatCard extends StatelessWidget {
  final String label;
  final double value;
  final Currency currency;
  final Color background;
  final Color foreground;

  const AnalyticsStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.currency,
    required this.background,
    required this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: foreground.withValues(alpha: 0.75),
            ),
          ),
          const SizedBox(height: 6),
          // مبالغ الليرة الطويلة تصغر لتبقى بسطر واحد داخل البطاقة.
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              AppStrings.of(context).money(value, currency),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: foreground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
