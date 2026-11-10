import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'app_strings_ar.dart';
import 'app_strings_en.dart';
import 'formatters.dart';

/// كل النصوص الظاهرة للمستخدم بمكان واحد، بنسختين:
/// [AppStringsEn] (مطابقة لصور التصميم) و [AppStringsAr].
///
/// الاستخدام داخل أي ودجت: `AppStrings.of(context).seeAll`.
/// الأرقام تبقى لاتينية في اللغتين، بما فيها التواريخ (انظر [formatDate]).
abstract class AppStrings {
  const AppStrings(this.localeName);

  /// رمز اللغة الممرَّر لـ intl عند تنسيق التواريخ ('en' أو 'ar').
  final String localeName;

  static const LocalizationsDelegate<AppStrings> delegate =
      _AppStringsDelegate();

  static const List<Locale> supportedLocales = [Locale('en'), Locale('ar')];

  static AppStrings of(BuildContext context) =>
      Localizations.of<AppStrings>(context, AppStrings)!;

  /// النسخة المناسبة للغة (الإنجليزية لأي لغة غير مدعومة).
  static AppStrings forLocale(Locale locale) =>
      locale.languageCode == 'ar' ? const AppStringsAr() : const AppStringsEn();

  // ----------------------------------------------------- ثابتة باللغتين
  String get appTitle => 'SpendWise';
  String get brand => 'SPENDWISE';
  String get emptyStateEmoji => '💸';
  String get calendarEmoji => '📅';

  /// أسماء اللغات تظهر دائماً بلغتها الأصلية في لوحة الإعدادات.
  String get englishLanguageName => 'English';
  String get arabicLanguageName => 'العربية';

  // ----------------------------------------------------- التنقل والعناوين
  String get navHome;
  String get navHistory;
  String get navAnalytics;
  String get overviewTitle;
  String get historyTitle;
  String get analyticsTitle;
  String get previousPeriod;
  String get nextPeriod;

  // ----------------------------------------------------- Overview
  String get netBalance;

  /// [percent] جاهز من Formatters.percent.
  String savingsRate(String percent);
  String get income;
  String get expenses;
  String get recent;
  String get seeAll;
  String get emptyTitle;
  String get emptySubtitle;

  // ----------------------------------------------------- New Entry
  String get newEntry;
  String get addEntry;
  String get expenseType;
  String get incomeType;
  String get categoryLabel;
  String get noteLabel;
  String get noteHint;
  String get dateLabel;
  String get saveEntry;
  String get clear;
  String get done;

  // ----------------------------------------------------- History
  String transactionsCount(int count);

  /// [amount] جاهز من Formatters.currency.
  String spent(String amount);
  String get today;
  String get yesterday;
  String get delete;

  // ----------------------------------------------------- Analytics
  String get month;
  String get week;
  String get saved;
  String get avgPerDay;
  String get dailySpending;

  /// [amount] جاهز من Formatters.currency.
  String weekTotal(String amount);
  String get spendingBreakdown;
  String get byCategory;
  String get noExpensesInPeriod;
  String get noExpensesYet;

  // ----------------------------------------------------- الإعدادات
  String get settings;
  String get languageLabel;
  String get themeLabel;
  String get systemOption;
  String get lightTheme;
  String get darkTheme;

  // ----------------------------------------------------- الفئات
  /// اسم الفئة حسب مفتاحها المخزَّن (CategoryKeys).
  String categoryName(String key);

  // ----------------------------------------------------- التواريخ
  /// أسماء الأيام المختصرة من الإثنين إلى الأحد.
  List<String> get weekdaysShort;

  /// نمط حقل DATE بشاشة New Entry.
  String get dateFieldPattern;

  /// "JULY 20" / "20 يوليو" (رؤوس مجموعات History).
  String dayMonth(DateTime date);

  /// "Jul 6 – 12" / "6 – 12 يوليو" (أسبوع Analytics).
  String weekRange(DateTime start, DateTime end);

  String weekdayShort(DateTime date) => weekdaysShort[date.weekday - 1];

  /// "July 2026" / "يوليو 2026"
  String monthYear(DateTime date) => formatDate('MMMM yyyy', date);

  /// "07 / 12 / 2026" — معزول LTR حتى لا ينعكس ترتيب أجزائه بالعربية.
  String dateField(DateTime date) =>
      Formatters.ltr(formatDate(dateFieldPattern, date));

  /// TODAY / YESTERDAY / JULY 20
  String dayGroupLabel(DateTime date, {DateTime? now}) {
    final current = now ?? DateTime.now();
    if (_isSameDay(date, current)) return today;
    // بناء "أمس" من مكونات التاريخ وليس بطرح 24 ساعة، حتى لا يخطئ يوم تغيير التوقيت.
    final yesterdayDate =
        DateTime(current.year, current.month, current.day - 1);
    if (_isSameDay(date, yesterdayDate)) return yesterday;
    return dayMonth(date);
  }

  /// تنسيق تاريخ بلغة الواجهة مع إجبار الأرقام اللاتينية
  /// (بيانات intl للعربية تستخدم ٠١٢٣ افتراضياً).
  @protected
  String formatDate(String pattern, DateTime date) =>
      (DateFormat(pattern, localeName)..useNativeDigits = false).format(date);

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const _AppStringsDelegate();

  @override
  bool isSupported(Locale locale) => AppStrings.supportedLocales
      .any((supported) => supported.languageCode == locale.languageCode);

  @override
  Future<AppStrings> load(Locale locale) =>
      SynchronousFuture<AppStrings>(AppStrings.forLocale(locale));

  @override
  bool shouldReload(_AppStringsDelegate old) => false;
}
