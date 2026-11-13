import 'package:flutter/material.dart';
import '../models/currency.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/formatters.dart';
import 'currency_switch.dart';

/// بطاقة "Net Balance" المتدرجة بأعلى الشاشة الرئيسية، لعملة واحدة في كل مرة.
/// مفتاح "$ | ل.س" بأعلاها يبدّل العملة المعروضة.
/// Widget مستقل بالكامل: يستقبل الأرقام جاهزة فقط.
class BalanceCard extends StatelessWidget {
  final double income;
  final double expenses;
  final Currency currency;
  final ValueChanged<Currency> onCurrencyChanged;

  const BalanceCard({
    super.key,
    required this.income,
    required this.expenses,
    required this.currency,
    required this.onCurrencyChanged,
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
          Row(
            children: [
              Expanded(
                child: Text(
                  strings.netBalance,
                  style: TextStyle(color: colors.onBalanceMuted, fontSize: 15),
                ),
              ),
              CurrencySwitch(
                selected: currency,
                onChanged: onCurrencyChanged,
                onBalanceCard: true,
              ),
            ],
          ),
          const SizedBox(height: 6),
          // مبالغ الليرة قد تكون طويلة: تصغر لتبقى بسطر واحد.
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              strings.money(_netBalance, currency),
              style: TextStyle(
                color: colors.onBalance,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
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
                  amount: strings.money(income, currency),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MiniStat(
                  icon: Icons.arrow_downward_rounded,
                  label: strings.expenses,
                  amount: strings.money(expenses, currency),
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
  final String amount;

  const _MiniStat({
    required this.icon,
    required this.label,
    required this.amount,
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
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              amount,
              style: TextStyle(
                color: colors.onBalance,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
