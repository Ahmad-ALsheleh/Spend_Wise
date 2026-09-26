import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/transaction_model.dart';
import '../utils/app_colors.dart';
import '../utils/formatters.dart';
import '../widgets/balance_card.dart';
import '../widgets/section_header.dart';
import '../widgets/transaction_tile.dart';
import '../widgets/empty_transactions_placeholder.dart';
import '../widgets/month_selector.dart';

/// شاشة "Overview" الرئيسية.
/// State Full بالكامل: تحمّل بياناتها من DatabaseHelper وتُحدّث نفسها
/// عبر setState دون أي مدير حالة خارجي.
class HomeScreen extends StatefulWidget {
  final VoidCallback onAddPressed;
  final VoidCallback onSeeAllPressed;

  const HomeScreen({
    super.key,
    required this.onAddPressed,
    required this.onSeeAllPressed,
  });

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  List<TransactionModel> _monthTransactions = [];
  List<TransactionModel> _recentTransactions = []; // غير مقيدة بالشهر
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    reload();
  }

  /// يُستدعى من الخارج (main.dart) بعد إضافة/حذف معاملة لتحديث الشاشة فورًا.
  Future<void> reload() async {
    setState(() => _loading = true);
    final monthTx = await DatabaseHelper.instance.getTransactionsByMonth(
      _selectedMonth.year,
      _selectedMonth.month,
    );
    final allTx = await DatabaseHelper.instance.getAllTransactions();
    if (!mounted) return;
    setState(() {
      _monthTransactions = monthTx;
      _recentTransactions = allTx.take(5).toList(); // Recent: كل الشهور
      _loading = false;
    });
  }

  void _changeMonth(int delta) {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + delta);
    });
    reload();
  }

  double get _income => _monthTransactions
      .where((t) => t.isIncome)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get _expenses => _monthTransactions
      .where((t) => t.isExpense)
      .fold(0.0, (sum, t) => sum + t.amount);

  /// يسمح بالتقدم للأمام فقط حتى الشهر الحالي (لا مستقبل)
  bool get _canGoNext {
    final now = DateTime.now();
    final current = DateTime(now.year, now.month);
    return _selectedMonth.isBefore(current);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: reload,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SPENDWISE',
                      style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMuted,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Overview',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Coming soon')),
                    );
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: AppColors.accentMint,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.credit_card_rounded,
                        color: Colors.black87),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            MonthSelector(
              label: Formatters.monthYear(_selectedMonth),
              onPrevious: () => _changeMonth(-1),
              onNext: () => _changeMonth(1),
              nextEnabled: _canGoNext,
            ),
            const SizedBox(height: 8),
            _loading
                ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 60),
              child: Center(child: CircularProgressIndicator()),
            )
                : BalanceCard(income: _income, expenses: _expenses),
            const SizedBox(height: 28),
            SectionHeader(
              title: 'Recent',
              actionLabel: 'See all',
              onActionTap: widget.onSeeAllPressed,
            ),
            const SizedBox(height: 8),
            if (!_loading && _recentTransactions.isEmpty)
              const EmptyTransactionsPlaceholder()
            else
              ..._recentTransactions
                  .map((t) => TransactionTile(transaction: t)),
          ],
        ),
      ),
    );
  }
}