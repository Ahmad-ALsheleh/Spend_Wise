import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/formatters.dart';

/// بطاقة "Net Balance" الخضراء المتدرجة بأعلى الشاشة الرئيسية.
/// Widget مستقل بالكامل: يستقبل الأرقام جاهزة فقط، بدون أي منطق حسابي بداخله.
class BalanceCard extends StatelessWidget {
  final double income;
  final double expenses;

  const BalanceCard({
    super.key,
    required this.income,
    required this.expenses,
  });

  double get _netBalance => income - expenses;

  int get _savingsRate {
    if (income <= 0) return 0;
    final rate = (_netBalance / income) * 100;
    return rate.clamp(0, 999).round();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.balanceGradient,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Net Balance',
            style: TextStyle(color: Colors.white70, fontSize: 15),
          ),
          const SizedBox(height: 6),
          Text(
            Formatters.currency(_netBalance),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$_savingsRate% savings rate',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  icon: Icons.arrow_upward_rounded,
                  label: 'Income',
                  value: income,
                  highlightLabel: income > 0,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MiniStat(
                  icon: Icons.arrow_downward_rounded,
                  label: 'Expenses',
                  value: expenses,
                  highlightLabel: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final double value;
  final bool highlightLabel;

  const _MiniStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.highlightLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.balanceInnerBox,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white70, size: 14),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: highlightLabel ? const Color(0xFFB9F6CA) : Colors.white70,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            Formatters.currency(value),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}