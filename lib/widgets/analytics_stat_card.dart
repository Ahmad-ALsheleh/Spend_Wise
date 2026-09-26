import 'package:flutter/material.dart';
import '../utils/formatters.dart';

class AnalyticsStatCard extends StatelessWidget {
  final String label;
  final double value;
  final Color background;
  final Color textColor;

  const AnalyticsStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.background,
    this.textColor = const Color(0xFF14181B),
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
            style: TextStyle(fontSize: 12, color: textColor.withOpacity(0.75)),
          ),
          const SizedBox(height: 6),
          Text(
            Formatters.currency(value),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}