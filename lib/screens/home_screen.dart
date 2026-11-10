import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/transaction_model.dart';
import '../utils/app_strings.dart';
import '../widgets/balance_card.dart';
import '../widgets/empty_transactions_placeholder.dart';
import '../widgets/month_selector.dart';
import '../widgets/screen_header.dart';
import '../widgets/section_header.dart';
import '../widgets/transaction_tile.dart';

/// شاشة "Overview" الرئيسية.
/// State Full بالكامل: تحمّل بياناتها من DatabaseHelper وتُحدّث نفسها
/// عبر setState دون أي مدير حالة خارجي.
class HomeScreen extends StatefulWidget {
  /// "See all" ينقل لتبويب History.
  final VoidCallback onSeeAllPressed;
  final VoidCallback onSettingsPressed;

  const HomeScreen({
    super.key,
    required this.onSeeAllPressed,
    required this.onSettingsPressed,
  });

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  /// عدد المعاملات المعروضة بقسم Recent.
  static const int _recentCount = 5;

  DateTime _selectedMonth = _currentMonth();
  List<TransactionModel> _transactions = []; // معاملات الشهر المختار
  bool _loading = true;

  static DateTime _currentMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  @override
  void initState() {
    super.initState();
    reload();
  }

  /// يُستدعى من RootShell بعد إضافة/حذف معاملة لتحديث الشاشة فورًا.
  /// مؤشر التحميل للتحميل الأول فقط، حتى لا تومض الشاشة بعد كل تعديل.
  Future<void> reload() async {
    final transactions = await DatabaseHelper.instance.getTransactionsByMonth(
      _selectedMonth.year,
      _selectedMonth.month,
    );
    if (!mounted) return;
    setState(() {
      _transactions = transactions;
      _loading = false;
    });
  }

  void _changeMonth(int delta) {
    setState(() {
      _selectedMonth =
          DateTime(_selectedMonth.year, _selectedMonth.month + delta);
    });
    reload();
  }

  double get _income => _transactions
      .where((t) => t.isIncome)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get _expenses => _transactions
      .where((t) => t.isExpense)
      .fold(0.0, (sum, t) => sum + t.amount);

  /// يسمح بالتقدم للأمام فقط حتى الشهر الحالي (لا مستقبل)
  bool get _canGoNext => _selectedMonth.isBefore(_currentMonth());

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: reload,
        child: ListView(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 100),
          children: [
            ScreenHeader(
              title: strings.overviewTitle,
              onSettingsPressed: widget.onSettingsPressed,
            ),
            const SizedBox(height: 16),
            MonthSelector(
              label: strings.monthYear(_selectedMonth),
              onPrevious: () => _changeMonth(-1),
              onNext: () => _changeMonth(1),
              nextEnabled: _canGoNext,
            ),
            const SizedBox(height: 8),
            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: Center(child: CircularProgressIndicator()),
              )
            else
              BalanceCard(income: _income, expenses: _expenses),
            const SizedBox(height: 28),
            SectionHeader(
              title: strings.recent,
              actionLabel: strings.seeAll,
              onActionTap: widget.onSeeAllPressed,
            ),
            const SizedBox(height: 8),
            if (!_loading && _transactions.isEmpty)
              const EmptyTransactionsPlaceholder()
            else
              for (final transaction in _transactions.take(_recentCount))
                TransactionTile(transaction: transaction),
          ],
        ),
      ),
    );
  }
}
