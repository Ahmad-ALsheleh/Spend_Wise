import 'package:flutter/material.dart';
import '../models/currency.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import 'segmented_toggle.dart';

/// مفتاح العملة المختصر "$ | ل.س" لبطاقة الرصيد وشاشة Analytics.
/// يبدّل العملة المعروضة؛ الأرقام لا تُحوَّل بين العملتين بل تُحسب كلٌّ وحدها.
class CurrencySwitch extends StatelessWidget {
  final Currency selected;
  final ValueChanged<Currency> onChanged;

  /// ألوان مناسبة لخلفية بطاقة الرصيد الملونة.
  final bool onBalanceCard;

  const CurrencySwitch({
    super.key,
    required this.selected,
    required this.onChanged,
    this.onBalanceCard = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final strings = AppStrings.of(context);
    return SizedBox(
      width: onBalanceCard ? 112 : 120,
      child: SegmentedToggle<Currency>(
        dense: onBalanceCard,
        palette: onBalanceCard
            ? SegmentedToggleColors(
                track: colors.balanceTile,
                thumb: colors.onBalance,
                selected: colors.balanceStart,
                unselected: colors.onBalanceMuted,
              )
            : null,
        options: [
          for (final currency in Currency.values)
            SegmentedToggleOption(
              value: currency,
              label: strings.currencySymbol(currency),
              semanticLabel: strings.currencyName(currency),
            ),
        ],
        selected: selected,
        onChanged: onChanged,
      ),
    );
  }
}
