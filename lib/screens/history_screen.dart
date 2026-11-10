import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/transaction_model.dart';
import '../utils/app_strings.dart';
import '../widgets/date_group_header.dart';
import '../widgets/empty_transactions_placeholder.dart';
import '../widgets/history_summary_bar.dart';
import '../widgets/month_selector.dart';
import '../widgets/screen_header.dart';
import '../widgets/transaction_tile.dart';

/// شاشة History: كل معاملات الشهر المختار فقط، مجمّعة حسب اليوم.
///
/// الحذف: الضغط على معاملة يُظهر زر سلة مكان المبلغ، والضغط على السلة يحذف.
/// الضغط على المعاملة نفسها مجدداً أو على أي مكان آخر يلغي ذلك.
/// معاملة واحدة فقط بوضع الحذف في كل مرة.
class HistoryScreen extends StatefulWidget {
  final VoidCallback onSettingsPressed;

  /// يُبلغ RootShell ليعيد تحميل كل التبويبات بعد الحذف.
  final VoidCallback onTransactionDeleted;

  const HistoryScreen({
    super.key,
    required this.onSettingsPressed,
    required this.onTransactionDeleted,
  });

  @override
  State<HistoryScreen> createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> {
  DateTime _selectedMonth = _currentMonth();
  List<TransactionModel> _transactions = [];
  bool _loading = true;

  /// المعاملة الظاهر عليها زر الحذف حالياً (null = لا شيء).
  int? _pendingDeleteId;

  static DateTime _currentMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  @override
  void initState() {
    super.initState();
    reload();
  }

  Future<void> reload() async {
    final transactions = await DatabaseHelper.instance.getTransactionsByMonth(
      _selectedMonth.year,
      _selectedMonth.month,
    );
    if (!mounted) return;
    setState(() {
      _transactions = transactions;
      _loading = false;
      _pendingDeleteId = null;
    });
  }

  /// يلغي وضع الحذف (يُستدعى أيضاً من RootShell عند تبديل التبويب).
  void cancelDeleteMode() {
    if (_pendingDeleteId == null) return;
    setState(() => _pendingDeleteId = null);
  }

  void _toggleDeleteMode(int id) {
    setState(() => _pendingDeleteId = _pendingDeleteId == id ? null : id);
  }

  void _changeMonth(int delta) {
    setState(() {
      _selectedMonth =
          DateTime(_selectedMonth.year, _selectedMonth.month + delta);
      _pendingDeleteId = null;
    });
    reload();
  }

  bool get _canGoNext => _selectedMonth.isBefore(_currentMonth());

  Future<void> _deleteTransaction(int id) async {
    // إخفاء فوري ثم الحذف الفعلي وتحديث كل التبويبات.
    setState(() {
      _transactions = _transactions.where((t) => t.id != id).toList();
      _pendingDeleteId = null;
    });
    await DatabaseHelper.instance.deleteTransaction(id);
    widget.onTransactionDeleted();
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
    final strings = AppStrings.of(context);
    final grouped = _grouped;
    final sortedDays = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    // أي ضغطة خارج المعاملات تلغي وضع الحذف.
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: cancelDeleteMode,
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: reload,
          child: ListView(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 100),
            children: [
              ScreenHeader(
                title: strings.historyTitle,
                onSettingsPressed: widget.onSettingsPressed,
              ),
              const SizedBox(height: 16),
              MonthSelector(
                label: strings.monthYear(_selectedMonth),
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
                  for (final t in grouped[day]!)
                    TransactionTile(
                      transaction: t,
                      deleteMode: t.id != null && t.id == _pendingDeleteId,
                      onTap:
                          t.id == null ? null : () => _toggleDeleteMode(t.id!),
                      onDelete:
                          t.id == null ? null : () => _deleteTransaction(t.id!),
                    ),
                ],
            ],
          ),
        ),
      ),
    );
  }
}
