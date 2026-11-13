import '../models/currency.dart';
import 'app_strings.dart';
import 'category_data.dart';
import 'formatters.dart';

/// النصوص الإنجليزية — مطابقة حرفياً لصور التصميم.
class AppStringsEn extends AppStrings {
  const AppStringsEn() : super('en');

  @override
  String get navHome => 'Home';
  @override
  String get navHistory => 'History';
  @override
  String get navAnalytics => 'Analytics';
  @override
  String get overviewTitle => 'Overview';
  @override
  String get historyTitle => 'History';
  @override
  String get analyticsTitle => 'Analytics';
  @override
  String get previousPeriod => 'Previous';
  @override
  String get nextPeriod => 'Next';

  @override
  String get netBalance => 'Net Balance';
  @override
  String savingsRate(String percent) => '$percent savings rate';
  @override
  String get income => 'Income';
  @override
  String get expenses => 'Expenses';
  @override
  String get recent => 'Recent';
  @override
  String get seeAll => 'See all';
  @override
  String get emptyTitle => 'No transactions yet';
  @override
  String get emptySubtitle => 'Tap + to add your first entry';

  @override
  String get newEntry => 'New Entry';
  @override
  String get addEntry => 'Add entry';
  @override
  String get expenseType => 'Expense';
  @override
  String get incomeType => 'Income';
  @override
  String get categoryLabel => 'CATEGORY';
  @override
  String get noteLabel => 'NOTE';
  @override
  String get noteHint => 'Add a note...';
  @override
  String get dateLabel => 'DATE';
  @override
  String get saveEntry => 'Save Entry';
  @override
  String get clear => 'Clear';
  @override
  String get done => 'Done';

  /// "1 transactions" كما يظهر حرفياً بصورة التصميم.
  @override
  String transactionsCount(int count) => '$count transactions';
  @override
  String spent(String amount) => '$amount spent';
  @override
  String get today => 'TODAY';
  @override
  String get yesterday => 'YESTERDAY';
  @override
  String get delete => 'Delete';

  @override
  String get month => 'Month';
  @override
  String get week => 'Week';
  @override
  String get saved => 'Saved';
  @override
  String get avgPerDay => 'Avg/day';
  @override
  String get dailySpending => 'Daily Spending';
  @override
  String weekTotal(String amount) => '$amount total';
  @override
  String get spendingBreakdown => 'Spending Breakdown';
  @override
  String get byCategory => 'By Category';
  @override
  String get noExpensesInPeriod => 'No expenses in this period';
  @override
  String get noExpensesYet => 'No expenses yet';

  @override
  String get languageAndTheme => 'Language & theme';
  @override
  String get languageShortName => 'EN';
  @override
  String get languageLabel => 'LANGUAGE';
  @override
  String get themeLabel => 'THEME';
  @override
  String get systemOption => 'System';
  @override
  String get lightTheme => 'Light';
  @override
  String get darkTheme => 'Dark';

  @override
  String currencySymbol(Currency currency) => switch (currency) {
        Currency.usd => r'$',
        Currency.syp => 'SYP',
      };
  @override
  String currencyName(Currency currency) => switch (currency) {
        Currency.usd => 'Dollar',
        Currency.syp => 'Syrian pound',
      };

  /// "–SYP 150,000": الرمز قبل الرقم مثل "$".
  @override
  String sypMoney(String sign, String number) =>
      Formatters.ltr('${sign}SYP $number');

  @override
  String categoryName(String key) => switch (key) {
        CategoryKeys.foodDrink => 'Food & Drink',
        CategoryKeys.transport => 'Transport',
        CategoryKeys.housing => 'Housing',
        CategoryKeys.health => 'Health',
        CategoryKeys.fun => 'Fun',
        CategoryKeys.shopping => 'Shopping',
        CategoryKeys.education => 'Education',
        CategoryKeys.travel => 'Travel',
        CategoryKeys.utilities => 'Utilities',
        CategoryKeys.salary => 'Salary',
        CategoryKeys.freelance => 'Freelance',
        CategoryKeys.investment => 'Investment',
        CategoryKeys.gift => 'Gift',
        _ => 'Other',
      };

  @override
  List<String> get weekdaysShort =>
      const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  String get dateFieldPattern => 'MM / dd / yyyy';

  @override
  String dayMonth(DateTime date) => formatDate('MMMM d', date).toUpperCase();

  @override
  String weekRange(DateTime start, DateTime end) {
    final from = formatDate('MMM d', start);
    final to = start.month == end.month
        ? formatDate('d', end)
        : formatDate('MMM d', end);
    return '$from – $to';
  }
}
