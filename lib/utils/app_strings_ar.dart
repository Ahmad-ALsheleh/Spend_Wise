import '../models/currency.dart';
import 'app_strings.dart';
import 'category_data.dart';
import 'formatters.dart';

/// النصوص العربية. الأرقام تبقى لاتينية، والمبالغ تصل معزولة LTR من Formatters.
class AppStringsAr extends AppStrings {
  const AppStringsAr() : super('ar');

  @override
  String get navHome => 'الرئيسية';
  @override
  String get navHistory => 'السجل';
  @override
  String get navAnalytics => 'التحليلات';
  @override
  String get overviewTitle => 'نظرة عامة';
  @override
  String get historyTitle => 'السجل';
  @override
  String get analyticsTitle => 'التحليلات';
  @override
  String get previousPeriod => 'السابق';
  @override
  String get nextPeriod => 'التالي';

  @override
  String get netBalance => 'صافي الرصيد';
  @override
  String savingsRate(String percent) => 'نسبة الادخار $percent';
  @override
  String get income => 'الدخل';
  @override
  String get expenses => 'المصروفات';
  @override
  String get recent => 'الأحدث';
  @override
  String get seeAll => 'عرض الكل';
  @override
  String get emptyTitle => 'لا توجد معاملات بعد';
  @override
  String get emptySubtitle => 'اضغط + لإضافة أول معاملة';

  @override
  String get newEntry => 'معاملة جديدة';
  @override
  String get addEntry => 'إضافة معاملة';
  @override
  String get expenseType => 'مصروف';
  @override
  String get incomeType => 'دخل';
  @override
  String get categoryLabel => 'الفئة';
  @override
  String get noteLabel => 'ملاحظة';
  @override
  String get noteHint => 'أضف ملاحظة...';
  @override
  String get dateLabel => 'التاريخ';
  @override
  String get saveEntry => 'حفظ';
  @override
  String get clear => 'مسح';
  @override
  String get done => 'تم';

  /// صيغ العدد بالعربية: 1 واحدة، 2 مثنى، 3-10 جمع، وما بعدها مفرد.
  @override
  String transactionsCount(int count) {
    if (count == 1) return 'معاملة واحدة';
    if (count == 2) return 'معاملتان';
    final lastTwo = count % 100;
    if (lastTwo >= 3 && lastTwo <= 10) return '$count معاملات';
    return '$count معاملة';
  }

  @override
  String spent(String amount) => 'تم إنفاق $amount';
  @override
  String get today => 'اليوم';
  @override
  String get yesterday => 'أمس';
  @override
  String get delete => 'حذف';

  @override
  String get month => 'شهر';
  @override
  String get week => 'أسبوع';
  @override
  String get saved => 'المُدّخر';
  @override
  String get avgPerDay => 'المتوسط اليومي';
  @override
  String get dailySpending => 'الإنفاق اليومي';
  @override
  String weekTotal(String amount) => 'الإجمالي $amount';
  @override
  String get spendingBreakdown => 'توزيع الإنفاق';
  @override
  String get byCategory => 'حسب الفئة';
  @override
  String get noExpensesInPeriod => 'لا توجد مصروفات في هذه الفترة';
  @override
  String get noExpensesYet => 'لا توجد مصروفات بعد';

  @override
  String get languageAndTheme => 'اللغة والمظهر';
  @override
  String get languageShortName => 'عربي';
  @override
  String get languageLabel => 'اللغة';
  @override
  String get themeLabel => 'المظهر';
  @override
  String get systemOption => 'النظام';
  @override
  String get lightTheme => 'فاتح';
  @override
  String get darkTheme => 'داكن';

  @override
  String currencySymbol(Currency currency) => switch (currency) {
        Currency.usd => r'$',
        Currency.syp => 'ل.س',
      };
  @override
  String currencyName(Currency currency) => switch (currency) {
        Currency.usd => 'دولار',
        Currency.syp => 'ليرة سورية',
      };

  /// "–150,000 ل.س": الرقم معزول LTR (لتبقى إشارته معه) ثم الرمز
  /// بترتيب القراءة العربي، فيظهر الرمز يسار الرقم.
  @override
  String sypMoney(String sign, String number) =>
      '${Formatters.ltr('$sign$number')} ل.س';

  @override
  String categoryName(String key) => switch (key) {
        CategoryKeys.foodDrink => 'طعام وشراب',
        CategoryKeys.transport => 'مواصلات',
        CategoryKeys.housing => 'سكن',
        CategoryKeys.health => 'صحة',
        CategoryKeys.fun => 'ترفيه',
        CategoryKeys.shopping => 'تسوق',
        CategoryKeys.education => 'تعليم',
        CategoryKeys.travel => 'سفر',
        CategoryKeys.utilities => 'فواتير',
        CategoryKeys.salary => 'راتب',
        CategoryKeys.freelance => 'عمل حر',
        CategoryKeys.investment => 'استثمار',
        CategoryKeys.gift => 'هدية',
        _ => 'أخرى',
      };

  @override
  List<String> get weekdaysShort =>
      const ['إثنين', 'ثلاثاء', 'أربعاء', 'خميس', 'جمعة', 'سبت', 'أحد'];

  @override
  String get dateFieldPattern => 'dd / MM / yyyy';

  @override
  String dayMonth(DateTime date) => formatDate('d MMMM', date);

  @override
  String weekRange(DateTime start, DateTime end) {
    final from = start.month == end.month
        ? formatDate('d', start)
        : formatDate('d MMMM', start);
    return '$from – ${formatDate('d MMMM', end)}';
  }
}
