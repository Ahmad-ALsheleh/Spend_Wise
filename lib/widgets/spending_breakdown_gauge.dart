import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/app_colors.dart';
import '../utils/category_data.dart';

/// عنصر بيانات جاهز لعرضه بمخطط "Spending Breakdown".
class CategorySlice {
  final String categoryKey;
  final double amount;
  final double percentage; // 0-100
  final Color color;

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
    if (slices.isEmpty) {
      return const SizedBox(
        height: 160,
        child: Center(
          child: Text('No expenses yet', style: TextStyle(color: AppColors.textMuted)),
        ),
      );
    }

    final dominant = slices.reduce((a, b) => a.amount > b.amount ? a : b);
    final dominantLabel = CategoryData.findByKey(dominant.categoryKey).label;

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
                  sectionsSpace: 3,
                  centerSpaceRadius: 52,
                  sections: slices
                      .map((s) => PieChartSectionData(
                    value: s.percentage,
                    color: s.color,
                    radius: 22,
                    showTitle: false,
                  ))
                      .toList(),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${dominant.percentage.round()}%',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    dominantLabel,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: slices.map((s) {
              final label = CategoryData.findByKey(s.categoryKey).label;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration:
                      BoxDecoration(color: s.color, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(label,
                          style: const TextStyle(
                              fontSize: 13, color: AppColors.textPrimary)),
                    ),
                    Text(
                      '${s.percentage.round()}%',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}