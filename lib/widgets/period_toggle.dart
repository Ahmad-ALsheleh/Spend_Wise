import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

enum AnalyticsPeriod { month, week }

/// مفتاح Month / Week أعلى شاشة Analytics.
class PeriodToggle extends StatelessWidget {
  final AnalyticsPeriod selected;
  final ValueChanged<AnalyticsPeriod> onChanged;

  const PeriodToggle({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.toggleBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _Option(
              label: 'Month',
              selected: selected == AnalyticsPeriod.month,
              onTap: () => onChanged(AnalyticsPeriod.month),
            ),
          ),
          Expanded(
            child: _Option(
              label: 'Week',
              selected: selected == AnalyticsPeriod.week,
              onTap: () => onChanged(AnalyticsPeriod.week),
            ),
          ),
        ],
      ),
    );
  }
}

class _Option extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Option({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: selected
              ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('📅', style: TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.textPrimary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}