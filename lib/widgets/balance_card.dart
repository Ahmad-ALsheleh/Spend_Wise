import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/formatters.dart';

/// بطاقة "Net Balance" المتدرجة بأعلى الشاشة الرئيسية.
/// Widget مستقل بالكامل: يستقبل الأرقام جاهزة فقط.
class BalanceCard extends StatelessWidget {
  final double income;
  final double expenses;

  const BalanceCard({
    super.key,
    required this.income,
    required this.expenses,
  });

  double get _netBalance => income - expenses;

  /// round(net / income × 100)، و 0% عندما لا يوجد دخل.
  int get _savingsRate =>
      income <= 0 ? 0 : (_netBalance / income * 100).round();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final strings = AppStrings.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: colors.balanceGradient,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.netBalance,
            style: TextStyle(color: colors.onBalanceMuted, fontSize: 15),
          ),
          const SizedBox(height: 6),
          Text(
            Formatters.currency(_netBalance),
            style: TextStyle(
              color: colors.onBalance,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            strings.savingsRate(Formatters.percent(_savingsRate)),
            style: TextStyle(color: colors.onBalanceMuted, fontSize: 14),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  icon: Icons.arrow_upward_rounded,
                  label: strings.income,
                  value: income,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MiniStat(
                  icon: Icons.arrow_downward_rounded,
                  label: strings.expenses,
                  value: expenses,
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

  const _MiniStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colors.balanceTile,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: colors.onBalanceMuted, size: 14),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: colors.onBalanceMuted, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            Formatters.currency(value),
            style: TextStyle(
              color: colors.onBalance,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
