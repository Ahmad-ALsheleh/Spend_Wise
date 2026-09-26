import 'package:flutter/material.dart';
import '../utils/formatters.dart';

/// الشريط الأزرق الفاتح أعلى شاشة History: "X transactions" و"$Y spent".
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFDDF1F7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$count transactions',
              style: const TextStyle(fontSize: 14, color: Color(0xFF14555A))),
          Text(
            '${Formatters.currency(totalSpent)} spent',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF14555A),
            ),
          ),
        ],
      ),
    );
  }
}