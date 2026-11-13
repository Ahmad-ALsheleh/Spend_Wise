import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/analytics_period.dart';
import '../models/currency.dart';
import '../models/transaction_model.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/category_data.dart';
import '../widgets/analytics_stat_card.dart';
import '../widgets/category_breakdown_tile.dart';
import '../widgets/currency_switch.dart';
import '../widgets/daily_spending_chart.dart';
import '../widgets/month_selector.dart';
import '../widgets/screen_header.dart';
import '../widgets/segmented_toggle.dart';
import '../widgets/spending_breakdown_gauge.dart';

/// شاشة Analytics: تبديل شهري/أسبوعي، إحصائيات، رسوم بيانية، توزيع حسب التصنيف.
///
/// كل الأرقام لعملة واحدة ([currency])، يبدّلها مفتاح "$ | ل.س" بجانب
/// مفتاح الفترة؛ الدولار والليرة لا يُجمعان معاً.
class AnalyticsScreen extends StatefulWidget {
  final Currency currency;
  final ValueChanged<Currency> onCurrencyChanged;
  final VoidCallback onSettingsPressed;

  const AnalyticsScreen({
    super.key,
    required this.currency,
    required this.onCurrencyChanged,
    required this.onSettingsPressed,
  });

  @override
  State<AnalyticsScreen> createState() => AnalyticsScreenState();
}

class AnalyticsScreenState extends State<AnalyticsScreen> {
  AnalyticsPeriod _period = AnalyticsPeriod.month;

  DateTime _selectedMonth = _currentMonth();
  DateTime _selectedWeekStart = _startOfWeek(DateTime.now());

  List<TransactionModel> _transactions = [];
  bool _loading = true;

  static DateTime _currentMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  /// الإثنين = بداية الأسبوع. الحساب بمكونات التاريخ وليس بطرح ساعات،
  /// حتى لا ينزاح منتصف الليل يوم تغيير التوقيت الصيفي.
  static DateTime _startOfWeek(DateTime date) => DateTime(
      date.year, date.month, date.day - (date.weekday - DateTime.monday));

  /// أيام الأسبوع المختار من الإثنين إلى الأحد.
  List<DateTime> get _weekDays => List.generate(
        7,
        (i) => DateTime(
          _selectedWeekStart.year,
          _selectedWeekStart.month,
          _selectedWeekStart.day + i,
        ),
      );

  @override
  void initState() {
    super.initState();
    reload();
  }

  Future<void> reload() async {
    final List<TransactionModel> transactions;
    if (_period == AnalyticsPeriod.month) {
      transactions = await DatabaseHelper.instance.getTransactionsByMonth(
        _selectedMonth.year,
        _selectedMonth.month,
      );
    } else {
      final start = _selectedWeekStart;
      transactions = await DatabaseHelper.instance.getTransactionsByRange(
        start,
        DateTime(start.year, start.month, start.day + 7),
      );
    }
    if (!mounted) return;
    setState(() {
      _transactions = transactions;
      _loading = false;
    });
  }

  void _changePeriodType(AnalyticsPeriod period) {
    setState(() => _period = period);
    reload();
  }

  void _changeMonth(int delta) {
    setState(() {
      _selectedMonth =
          DateTime(_selectedMonth.year, _selectedMonth.month + delta);
    });
    reload();
  }

  void _changeWeek(int delta) {
    setState(() {
      _selectedWeekStart = DateTime(
        _selectedWeekStart.year,
        _selectedWeekStart.month,
        _selectedWeekStart.day + 7 * delta,
      );
    });
    reload();
  }

  bool get _canGoNext => _period == AnalyticsPeriod.month
      ? _selectedMonth.isBefore(_currentMonth())
      : _selectedWeekStart.isBefore(_startOfWeek(DateTime.now()));

  /// معاملات الفترة بالعملة المختارة فقط.
  Iterable<TransactionModel> get _inCurrency =>
      _transactions.where((t) => t.currency == widget.currency);

  double get _income =>
      _inCurrency.where((t) => t.isIncome).fold(0.0, (s, t) => s + t.amount);

  double get _expenses =>
      _inCurrency.where((t) => t.isExpense).fold(0.0, (s, t) => s + t.amount);

  /// مصروف كل يوم من أيام الأسبوع المختار (Mon..Sun).
  List<double> get _dailyExpenses => [
        for (final day in _weekDays)
          _inCurrency
              .where(
                (t) =>
                    t.isExpense &&
                    t.date.year == day.year &&
                    t.date.month == day.month &&
                    t.date.day == day.day,
              )
              .fold(0.0, (s, t) => s + t.amount),
      ];

  /// المصروفات ÷ عدد الأيام التي فيها مصروف (وليس ÷ 7).
  double get _avgPerDay {
    final activeDays = _dailyExpenses.where((v) => v > 0).length;
    return activeDays == 0 ? 0 : _expenses / activeDays;
  }

  /// تصنيفات المصروف مرتبة من الأكبر، كل منها بلونه الثابت.
  List<CategorySlice> get _slices {
    final total = _expenses;
    if (total <= 0) return [];
    final byCategory = <String, double>{};
    for (final t in _inCurrency.where((t) => t.isExpense)) {
      byCategory[t.categoryKey] = (byCategory[t.categoryKey] ?? 0) + t.amount;
    }
    final entries = byCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return [
      for (final e in entries)
        CategorySlice(
          categoryKey: e.key,
          amount: e.value,
          percentage: e.value / total * 100,
          color: CategoryData.findByKey(e.key).color,
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final strings = AppStrings.of(context);
    final currency = widget.currency;
    final isMonth = _period == AnalyticsPeriod.month;
    final slices = _slices;
    final sectionTitleStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: colors.textPrimary,
    );

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: reload,
        child: ListView(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 100),
          children: [
            ScreenHeader(
              title: strings.analyticsTitle,
              onSettingsPressed: widget.onSettingsPressed,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SegmentedToggle<AnalyticsPeriod>(
                    options: [
                      SegmentedToggleOption(
                        value: AnalyticsPeriod.month,
                        label: strings.month,
                        emoji: strings.calendarEmoji,
                      ),
                      SegmentedToggleOption(
                        value: AnalyticsPeriod.week,
                        label: strings.week,
                        emoji: strings.calendarEmoji,
                      ),
                    ],
                    selected: _period,
                    onChanged: _changePeriodType,
                  ),
                ),
                const SizedBox(width: 10),
                CurrencySwitch(
                  selected: currency,
                  onChanged: widget.onCurrencyChanged,
                ),
              ],
            ),
            const SizedBox(height: 14),
            MonthSelector(
              label: isMonth
                  ? strings.monthYear(_selectedMonth)
                  : strings.weekRange(_selectedWeekStart, _weekDays.last),
              onPrevious: () => isMonth ? _changeMonth(-1) : _changeWeek(-1),
              onNext: () => isMonth ? _changeMonth(1) : _changeWeek(1),
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
                      label: strings.income,
                      value: _income,
                      currency: currency,
                      background: colors.incomeTile,
                      foreground: colors.onIncomeTile,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AnalyticsStatCard(
                      label: strings.expenses,
                      value: _expenses,
                      currency: currency,
                      background: colors.expenseTile,
                      foreground: colors.onExpenseTile,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AnalyticsStatCard(
                      label: isMonth ? strings.saved : strings.avgPerDay,
                      value: isMonth ? _income - _expenses : _avgPerDay,
                      currency: currency,
                      background: colors.savedTile,
                      foreground: colors.onSavedTile,
                    ),
                  ),
                ],
              ),
              if (!isMonth) ...[
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        strings.dailySpending,
                        style: sectionTitleStyle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        strings.weekTotal(strings.money(_expenses, currency)),
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DailySpendingChart(
                  days: _weekDays,
                  values: _dailyExpenses,
                  currency: currency,
                ),
              ],
              const SizedBox(height: 28),
              Text(strings.spendingBreakdown, style: sectionTitleStyle),
              const SizedBox(height: 16),
              SpendingBreakdownGauge(slices: slices),
              const SizedBox(height: 28),
              Text(strings.byCategory, style: sectionTitleStyle),
              const SizedBox(height: 12),
              if (slices.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    strings.noExpensesInPeriod,
                    style: TextStyle(color: colors.textSecondary),
                  ),
                )
              else
                for (final s in slices)
                  CategoryBreakdownTile(
                    categoryKey: s.categoryKey,
                    amount: s.amount,
                    ratio: s.percentage / 100,
                    barColor: s.color,
                    currency: currency,
                  ),
            ],
          ],
        ),
      ),
    );
  }
}
