import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/transaction_model.dart';
import '../utils/app_colors.dart';
import '../utils/formatters.dart';
import '../widgets/month_selector.dart';
import '../widgets/history_summary_bar.dart';
import '../widgets/date_group_header.dart';
import '../widgets/swipeable_transaction_card.dart';
import '../widgets/empty_transactions_placeholder.dart';

/// شاشة History: كل معاملات الشهر المختار فقط، مجمّعة حسب اليوم،
/// مع إمكانية الحذف بالسحب لليسار.
class HistoryScreen extends StatefulWidget {
  final VoidCallback onAddPressed;
  const HistoryScreen({super.key, required this.onAddPressed});

  @override
  State<HistoryScreen> createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> {
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  List<TransactionModel> _transactions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    reload();
  }

  Future<void> reload() async {
    setState(() => _loading = true);
    final tx = await DatabaseHelper.instance.getTransactionsByMonth(
      _selectedMonth.year,
      _selectedMonth.month,
    );
    if (!mounted) return;
    setState(() {
      _transactions = tx;
      _loading = false;
    });
  }

  void _changeMonth(int delta) {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + delta);
    });
    reload();
  }

  bool get _canGoNext {
    final now = DateTime.now();
    final current = DateTime(now.year, now.month);
    return _selectedMonth.isBefore(current);
  }

  Future<void> _deleteTransaction(TransactionModel tx) async {
    await DatabaseHelper.instance.deleteTransaction(tx.id!);
    if (!mounted) return;
    setState(() {
      _transactions.removeWhere((t) => t.id == tx.id);
    });
  }

  double get _totalSpent => _transactions
      .where((t) => t.isExpense)
      .fold(0.0, (sum, t) => sum + t.amount);

  /// تجميع المعاملات حسب اليوم (تاريخ بدون وقت) مع الحفاظ على الترتيب التنازلي
  Map<DateTime, List<TransactionModel>> get _grouped {
    final map = <DateTime, List<TransactionModel>>{};
    for (final t in _transactions) {
      final day = DateTime(t.date.year, t.date.month, t.date.day);
      map.putIfAbsent(day, () => []).add(t);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _grouped;
    final sortedDays = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

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
              'History',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            MonthSelector(
              label: Formatters.monthYear(_selectedMonth),
              onPrevious: () => _changeMonth(-1),
              onNext: () => _changeMonth(1),
              nextEnabled: _canGoNext,
            ),
            const SizedBox(height: 14),
            HistorySummaryBar(
              count: _transactions.length,
              totalSpent: _totalSpent,
            ),
            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_transactions.isEmpty)
              const EmptyTransactionsPlaceholder()
            else
              for (final day in sortedDays) ...[
                DateGroupHeader(
                  date: day,
                  dayTotal: grouped[day]!
                      .where((t) => t.isExpense)
                      .fold(0.0, (s, t) => s + t.amount),
                ),
                ...grouped[day]!.map(
                      (t) => SwipeableTransactionCard(
                    transaction: t,
                    onDelete: () => _deleteTransaction(t),
                  ),
                ),
              ],
          ],
        ),
      ),
    );
  }
}