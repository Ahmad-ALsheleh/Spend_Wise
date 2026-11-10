import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';

/// مُحدد فترة عام: نص بالمنتصف مع سهمين.
/// يُستخدم لعرض الشهر (July 2026) أو نطاق الأسبوع (Jul 6 – 12).
/// السهمان ينعكسان تلقائياً بالعربية (السابق يميناً والتالي يساراً).
class MonthSelector extends StatelessWidget {
  final String label;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  /// يُعطَّل عند الوصول للفترة الحالية (لا فترات مستقبلية).
  final bool nextEnabled;

  const MonthSelector({
    super.key,
    required this.label,
    required this.onPrevious,
    required this.onNext,
    this.nextEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final strings = AppStrings.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onPrevious,
          tooltip: strings.previousPeriod,
          icon: Icon(Icons.chevron_left, color: colors.textPrimary),
        ),
        Flexible(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
        ),
        IconButton(
          onPressed: nextEnabled ? onNext : null,
          tooltip: strings.nextPeriod,
          icon: Icon(
            Icons.chevron_right,
            color: nextEnabled ? colors.textPrimary : colors.textDisabled,
          ),
        ),
      ],
    );
  }
}
