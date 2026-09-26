import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/transaction_model.dart';
import '../utils/app_colors.dart';
import '../utils/formatters.dart';
import '../widgets/transaction_tile.dart';
import '../widgets/empty_transactions_placeholder.dart';

/// تُفتح من زر "See all" بقسم Recent بالشاشة الرئيسية.
/// تعرض كل المعاملات المسجّلة بالتطبيق بدون أي تقييد بالشهر.
class AllTransactionsScreen extends StatefulWidget {
  const AllTransactionsScreen({super.key});

  @override
  State<AllTransactionsScreen> createState() => _AllTransactionsScreenState();
}

class _AllTransactionsScreenState extends State<AllTransactionsScreen> {
  List<TransactionModel> _transactions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final tx = await DatabaseHelper.instance.getAllTransactions();
    if (!mounted) return;
    setState(() {
      _transactions = tx;
      _loading = false;
    });
  }

  /// تجميع حسب الشهر لعرض أوضح لقائمة طويلة عبر كل الفترات
  Map<String, List<TransactionModel>> get _groupedByMonth {
    final map = <String, List<TransactionModel>>{};
    for (final t in _transactions) {
      final key = Formatters.monthYear(t.date);
      map.putIfAbsent(key, () => []).add(t);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupedByMonth;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('All Transactions',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _load,
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _transactions.isEmpty
              ? ListView(
            padding: const EdgeInsets.all(20),
            children: const [EmptyTransactionsPlaceholder()],
          )
              : ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
            children: [
              for (final entry in grouped.entries) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 4),
                  child: Text(
                    entry.key,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
                ...entry.value
                    .map((t) => TransactionTile(transaction: t)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}