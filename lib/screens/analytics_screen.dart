import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/transaction_model.dart';
import '../utils/app_colors.dart';
import '../utils/category_data.dart';
import '../utils/formatters.dart';
import '../widgets/month_selector.dart';
import '../widgets/period_toggle.dart';
import '../widgets/analytics_stat_card.dart';
import '../widgets/daily_spending_chart.dart';
import '../widgets/spending_breakdown_gauge.dart';
import '../widgets/category_breakdown_tile.dart';

/// شاشة Analytics: تبديل شهري/أسبوعي، إحصائيات، رسوم بيانية، توزيع حسب التصنيف.
class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => AnalyticsScreenState();
}

class AnalyticsScreenState extends State<AnalyticsScreen> {
  AnalyticsPeriod _period = AnalyticsPeriod.month;

  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime _selectedWeekStart = _startOfWeek(DateTime.now());

  List<TransactionModel> _transactions = [];
  bool _loading = true;

  static DateTime _startOfWeek(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    // الاثنين = بداية الأسبوع
    return d.subtract(Duration(days: (d.weekday - DateTime.monday) % 7));
  }

  @override
  void initState() {
    super.initState();
    reload();
  }

  Future<void> reload() async {
    setState(() => _loading = true);
    List<TransactionModel> tx;
    if (_period == AnalyticsPeriod.month) {
      tx = await DatabaseHelper.instance.getTransactionsByMonth(
        _selectedMonth.year,
        _selectedMonth.month,
      );
    } else {
      final end = _selectedWeekStart.add(const Duration(days: 7));
      tx = await DatabaseHelper.instance.getTransactionsByRange(
        _selectedWeekStart,
        end,
      );
    }
    if (!mounted) return;
    setState(() {
      _transactions = tx;
      _loading = false;
    });
  }

  void _changePeriodType(AnalyticsPeriod p) {
    setState(() => _period = p);
    reload();
  }

  void _changeMonth(int delta) {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + delta);
    });
    reload();
  }

  void _changeWeek(int delta) {
    setState(() {
      _selectedWeekStart = _selectedWeekStart.add(Duration(days: 7 * delta));
    });
    reload();
  }

  bool get _canGoNext {
    final now = DateTime.now();
    if (_period == AnalyticsPeriod.month) {
      final current = DateTime(now.year, now.month);
      return _selectedMonth.isBefore(current);
    } else {
      final currentWeekStart = _startOfWeek(now);
      return _selectedWeekStart.isBefore(currentWeekStart);
    }
  }

  double get _income => _transactions
      .where((t) => t.isIncome)
      .fold(0.0, (s, t) => s + t.amount);

  double get _expenses => _transactions
      .where((t) => t.isExpense)
      .fold(0.0, (s, t) => s + t.amount);

  /// خريطة تصنيف -> مجموع المصروف بذلك التصنيف
  Map<String, double> get _byCategory {
    final map = <String, double>{};
    for (final t in _transactions.where((t) => t.isExpense)) {
      map[t.categoryKey] = (map[t.categoryKey] ?? 0) + t.amount;
    }
    return map;
  }

  List<CategorySlice> get _slices {
    final byCat = _byCategory;
    if (_expenses <= 0) return [];
    final entries = byCat.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return List.generate(entries.length, (i) {
      final e = entries[i];
      return CategorySlice(
        categoryKey: e.key,
        amount: e.value,
        percentage: (e.value / _expenses) * 100,
        color: CategoryData.chartPalette[i % CategoryData.chartPalette.length],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final slices = _slices;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: reload,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
          children: [
            const Text(
              'SPENDWISE',
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'Analytics',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            PeriodToggle(selected: _period, onChanged: _changePeriodType),
            const SizedBox(height: 14),
            MonthSelector(
              label: _period == AnalyticsPeriod.month
                  ? Formatters.monthYear(_selectedMonth)
                  : Formatters.weekRange(
                _selectedWeekStart,
                _selectedWeekStart.add(const Duration(days: 6)),
              ),
              onPrevious: () => _period == AnalyticsPeriod.month
                  ? _changeMonth(-1)
                  : _changeWeek(-1),
              onNext: () => _period == AnalyticsPeriod.month
                  ? _changeMonth(1)
                  : _changeWeek(1),
              nextEnabled: _canGoNext,
            ),
            const SizedBox(height: 16),
            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: Center(child: CircularProgressIndicator()),
              )
            else ...[
              Row(
                children: [
                  Expanded(
                    child: AnalyticsStatCard(
                      label: 'Income',
                      value: _income,
                      background: AppColors.analyticsIncomeBg,
                      textColor: const Color(0xFF0E6B78),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AnalyticsStatCard(
                      label: 'Expenses',
                      value: _expenses,
                      background: AppColors.analyticsExpenseBg,
                      textColor: const Color(0xFFB3401F),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AnalyticsStatCard(
                      label: _period == AnalyticsPeriod.month ? 'Saved' : 'Avg/day',
                      value: _period == AnalyticsPeriod.month
                          ? (_income - _expenses)
                          : (_expenses / 7),
                      background: AppColors.analyticsThirdBg,
                      textColor: const Color(0xFF2E4A4C),
                    ),
                  ),
                ],
              ),
              if (_period == AnalyticsPeriod.week) ...[
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Daily Spending',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${Formatters.currency(_expenses)} total',
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DailySpendingChart(
                  days: List.generate(
                      7, (i) => _selectedWeekStart.add(Duration(days: i))),
                  values: List.generate(7, (i) {
                    final day = _selectedWeekStart.add(Duration(days: i));
                    return _transactions
                        .where((t) =>
                    t.isExpense &&
                        t.date.year == day.year &&
                        t.date.month == day.month &&
                        t.date.day == day.day)
                        .fold(0.0, (s, t) => s + t.amount);
                  }),
                ),
              ],
              const SizedBox(height: 28),
              const Text(
                'Spending Breakdown',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              SpendingBreakdownGauge(slices: slices),
              const SizedBox(height: 28),
              const Text(
                'By Category',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              if (slices.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text('No expenses in this period',
                      style: TextStyle(color: AppColors.textMuted)),
                )
              else
                ...slices.map((s) => CategoryBreakdownTile(
                  categoryKey: s.categoryKey,
                  amount: s.amount,
                  ratio: s.percentage / 100,
                  barColor: s.color,
                )),
            ],
          ],
        ),
      ),
    );
  }
}