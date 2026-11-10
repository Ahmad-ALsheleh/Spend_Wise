import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/formatters.dart';

/// رسم بياني بالأعمدة يعرض المصروف اليومي خلال أسبوع واحد (Mon..Sun).
/// اليوم الذي فيه إنفاق: عموده واسمه بلون التطبيق، ومبلغه أسفل اسمه.
class DailySpendingChart extends StatelessWidget {
  final List<DateTime> days; // 7 أيام بالترتيب من الإثنين
  final List<double> values; // مصروف كل يوم بنفس الترتيب

  const DailySpendingChart({
    super.key,
    required this.days,
    required this.values,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final strings = AppStrings.of(context);

    // fl_chart يرسم دائماً من اليسار لليمين، فنعكس ترتيب الأيام بالعربية
    // ليكون الإثنين على اليمين. نفس التحويل للأعمدة وعناوينها.
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    int dayAt(int slot) => isRtl ? values.length - 1 - slot : slot;

    final maxVal = values.fold<double>(0, (a, b) => a > b ? a : b);

    return SizedBox(
      height: 190,
      child: BarChart(
        BarChartData(
          maxY: maxVal <= 0 ? 1 : maxVal * 1.25,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 46,
                getTitlesWidget: (value, meta) {
                  final slot = value.toInt();
                  if (slot < 0 || slot >= days.length) {
                    return const SizedBox.shrink();
                  }
                  final i = dayAt(slot);
                  final active = values[i] > 0;
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          strings.weekdayShort(days[i]),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight:
                                active ? FontWeight.w600 : FontWeight.w400,
                            color:
                                active ? colors.primary : colors.textSecondary,
                          ),
                        ),
                        if (active)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              Formatters.wholeCurrency(values[i]),
                              style: TextStyle(
                                fontSize: 10,
                                color: colors.textSecondary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          barTouchData: BarTouchData(enabled: false),
          barGroups: List.generate(values.length, (slot) {
            return BarChartGroupData(
              x: slot,
              barRods: [
                BarChartRodData(
                  toY: values[dayAt(slot)],
                  width: 22,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(6),
                  ),
                  color: colors.primary,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
