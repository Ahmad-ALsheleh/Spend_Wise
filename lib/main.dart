import 'package:flutter/material.dart';
import 'utils/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/history_screen.dart';
import 'screens/analytics_screen.dart';
import 'screens/add_transaction_screen.dart';
import 'screens/all_transactions_screen.dart';
import 'widgets/custom_bottom_nav_bar.dart';

void main() {
  runApp(const SpendWiseApp());
}

class SpendWiseApp extends StatelessWidget {
  const SpendWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpendWise',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const RootShell(),
    );
  }
}


class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _currentIndex = 0;

  final GlobalKey<HomeScreenState> _homeKey = GlobalKey<HomeScreenState>();
  final GlobalKey<HistoryScreenState> _historyKey =
  GlobalKey<HistoryScreenState>();
  final GlobalKey<AnalyticsScreenState> _analyticsKey =
  GlobalKey<AnalyticsScreenState>();

  /// يُعاد تحميل بيانات كل الشاشات الثلاث معًا بعد أي إضافة/حذف معاملة،
  /// حتى تبقى الأرقام متطابقة أينما ظهرت (Overview / History / Analytics).
  Future<void> _reloadAll() async {
    await _homeKey.currentState?.reload();
    await _historyKey.currentState?.reload();
    await _analyticsKey.currentState?.reload();
  }

  Future<void> _openAddTransaction() async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
    );
    if (saved == true) {
      await _reloadAll();
    }
  }

  Future<void> _openSeeAll() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AllTransactionsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        key: _homeKey,
        onAddPressed: _openAddTransaction,
        onSeeAllPressed: _openSeeAll,
      ),
      HistoryScreen(
        key: _historyKey,
        onAddPressed: _openAddTransaction,
      ),
      AnalyticsScreen(key: _analyticsKey),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        onAddPressed: _openAddTransaction,
      ),
    );
  }
}