import 'package:intl/intl.dart';

/// دوال مساعدة لتنسيق العملة والتاريخ بنفس صيغة التصميم المرفق.
class Formatters {
  Formatters._();

  static final NumberFormat _currency = NumberFormat.currency(
    locale: 'en_US',
    symbol: r'$',
    decimalDigits: 2,
  );

  /// $1,000.00
  static String currency(double value) => _currency.format(value);

  /// +$1,000.00 أو -$650.00 حسب النوع
  static String signedCurrency(double value, String type) {
    final sign = type == 'income' ? '+' : '-';
    return '$sign${_currency.format(value.abs())}';
  }

  /// July 2026
  static String monthYear(DateTime date) =>
      DateFormat('MMMM yyyy').format(date);

  /// Jul 6 – 12  (نطاق الأسبوع بشاشة Analytics)
  static String weekRange(DateTime start, DateTime end) {
    final startFmt = DateFormat('MMM d').format(start);
    final endFmt = DateFormat('d').format(end);
    return '$startFmt – $endFmt';
  }

  /// 07 / 12 / 2026
  static String dateSlashed(DateTime date) =>
      DateFormat('MM / dd / yyyy').format(date);

  /// TODAY / YESTERDAY / JULY 20 (رؤوس تجميع History)
  static String dateGroupLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = today.difference(target).inDays;
    if (diff == 0) return 'TODAY';
    if (diff == 1) return 'YESTERDAY';
    return DateFormat('MMMM d').format(date).toUpperCase();
  }

  static String weekday3(DateTime date) => DateFormat('E').format(date);
}