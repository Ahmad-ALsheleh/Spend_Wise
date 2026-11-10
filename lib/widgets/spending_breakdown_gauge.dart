import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/formatters.dart';

/// عنصر بيانات جاهز لعرضه بمخطط "Spending Breakdown".
class CategorySlice {
  final String categoryKey;
  final double amount;
  final double percentage; // 0-100
  final Color color; // لون الفئة الثابت

  const CategorySlice({
    required this.categoryKey,
    required this.amount,
    required this.percentage,
    required this.color,
  });
}

/// دائرة توزيع الإنفاق حسب التصنيف + نص مركزي بأكبر تصنيف + قائمة جانبية.
class SpendingBreakdownGauge extends StatelessWidget {
  final List<CategorySlice> slices;

  const SpendingBreakdownGauge({super.key, required this.slices});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final strings = AppStrings.of(context);

    if (slices.isEmpty) {
      return SizedBox(
        height: 160,
        child: Center(
          child: Text(
            strings.noExpensesYet,
            style: TextStyle(color: colors.textSecondary),
          ),
        ),
      );
    }

    final dominant = slices.reduce((a, b) => a.amount >= b.amount ? a : b);

    return Row(
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: slices.length > 1 ? 3 : 0,
                  centerSpaceRadius: 52,
                  startDegreeOffset: -90, // البداية من الأعلى كما في التصميم
                  sections: slices
                      .map(
                        (s) => PieChartSectionData(
                          value: s.percentage,
                          color: s.color,
                          radius: 22,
                          showTitle: false,
                        ),
                      )
                      .toList(),
                ),
              ),
              SizedBox(
                width: 96,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      Formatters.percent(dominant.percentage.round()),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      strings.categoryName(dominant.categoryKey),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 12, color: colors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final s in slices)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: s.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          strings.categoryName(s.categoryKey),
                          style: TextStyle(
                            fontSize: 13,
                            color: colors.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        Formatters.percent(s.percentage.round()),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
