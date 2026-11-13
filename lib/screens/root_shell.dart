import 'package:flutter/material.dart';
import '../models/app_settings.dart';
import '../models/currency.dart';
import '../widgets/add_fab.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/settings_sheet.dart';
import 'add_transaction_screen.dart';
import 'analytics_screen.dart';
import 'history_screen.dart';
import 'home_screen.dart';

/// الهيكل الرئيسي: التبويبات الثلاثة (IndexedStack) + الشريط السفلي + زر +.
class RootShell extends StatefulWidget {
  final AppSettings settings;
  final ValueChanged<AppSettings> onSettingsChanged;

  const RootShell({
    super.key,
    required this.settings,
    required this.onSettingsChanged,
  });

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  static const int _historyTab = 1;

  int _currentIndex = 0;

  final GlobalKey<HomeScreenState> _homeKey = GlobalKey<HomeScreenState>();
  final GlobalKey<HistoryScreenState> _historyKey =
      GlobalKey<HistoryScreenState>();
  final GlobalKey<AnalyticsScreenState> _analyticsKey =
      GlobalKey<AnalyticsScreenState>();

  /// العملة المعروضة بالرئيسية والتحليلات (محفوظة مع الإعدادات).
  Currency get _currency => widget.settings.currency;

  /// يُعاد تحميل بيانات كل الشاشات الثلاث معًا بعد أي إضافة/حذف معاملة،
  /// حتى تبقى الأرقام متطابقة أينما ظهرت (Overview / History / Analytics).
  Future<void> _reloadAll() async {
    await _homeKey.currentState?.reload();
    await _historyKey.currentState?.reload();
    await _analyticsKey.currentState?.reload();
  }

  Future<void> _openAddTransaction() async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AddTransactionScreen(initialCurrency: _currency),
      ),
    );
    if (saved == true) {
      await _reloadAll();
    }
  }

  void _selectTab(int index) {
    // مغادرة History تلغي زر الحذف الظاهر على أي معاملة.
    _historyKey.currentState?.cancelDeleteMode();
    setState(() => _currentIndex = index);
  }

  void _changeCurrency(Currency currency) {
    widget.onSettingsChanged(widget.settings.copyWith(currency: currency));
  }

  void _openSettings() {
    SettingsSheet.show(
      context,
      settings: widget.settings,
      onChanged: widget.onSettingsChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(
            key: _homeKey,
            currency: _currency,
            onCurrencyChanged: _changeCurrency,
            onSeeAllPressed: () => _selectTab(_historyTab),
            onSettingsPressed: _openSettings,
          ),
          HistoryScreen(
            key: _historyKey,
            currency: _currency,
            onSettingsPressed: _openSettings,
            onTransactionDeleted: _reloadAll,
          ),
          AnalyticsScreen(
            key: _analyticsKey,
            currency: _currency,
            onCurrencyChanged: _changeCurrency,
            onSettingsPressed: _openSettings,
          ),
        ],
      ),
      floatingActionButton: AddFab(onPressed: _openAddTransaction),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _selectTab,
      ),
    );
  }
}
