import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/app_colors.dart';
import '../utils/formatters.dart';

/// رسم بياني بالأعمدة يعرض المصروف اليومي خلال أسبوع واحد (Mon..Sun).
class DailySpendingChart extends StatelessWidget {
  final List<DateTime> days; // 7 أيام بالترتيب
  final List<double> values; // مصروف كل يوم بنفس الترتيب

  const DailySpendingChart({
    super.key,
    required this.days,
    required this.values,
  });

  @override
  Widget build(BuildContext context) {
    final maxVal = values.isEmpty
        ? 1.0
        : values.reduce((a, b) => a > b ? a : b).clamp(1, double.infinity);

    return SizedBox(
      height: 180,
      child: BarChart(
        BarChartData(
          maxY: maxVal * 1.25,
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
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i < 0 || i >= days.length) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      Formatters.weekday3(days[i]),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          barTouchData: BarTouchData(enabled: false),
          barGroups: List.generate(values.length, (i) {
            final isMax = values[i] == maxVal && values[i] > 0;
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: values[i],
                  width: 22,
                  borderRadius: BorderRadius.circular(6),
                  color: isMax
                      ? AppColors.balanceCardStart
                      : AppColors.divider,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}