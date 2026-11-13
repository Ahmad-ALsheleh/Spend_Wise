import 'package:intl/intl.dart';
import '../models/currency.dart';

/// تنسيق الأرقام الخام. الأرقام لاتينية في اللغتين.
///
/// المبلغ الكامل مع رمز عملته يُبنى في AppStrings.money، لأن رمز الليرة
/// يختلف حسب اللغة (SYP / ل.س). كل مبلغ هناك يُعزل باتجاه LTR عبر [ltr]:
/// بدونه تنتقل الإشارة في الواجهة العربية لنهاية الرقم ("$650.00–").
class Formatters {
  Formatters._();

  static final NumberFormat _usd = NumberFormat.currency(
    locale: 'en_US',
    symbol: r'$',
    decimalDigits: 2,
  );

  static final NumberFormat _usdWhole = NumberFormat.currency(
    locale: 'en_US',
    symbol: r'$',
    decimalDigits: 0,
  );

  static final NumberFormat _grouped = NumberFormat('#,##0', 'en_US');
  static final NumberFormat _groupedCents = NumberFormat('#,##0.00', 'en_US');
  static final NumberFormat _compact = NumberFormat.compact(locale: 'en_US');

  /// Left-to-Right Isolate (U+2066) و Pop Directional Isolate (U+2069).
  /// تُبنى من رموزها حتى لا يظهر محرف اتجاه غير مرئي داخل الكود نفسه.
  static final String _lri = String.fromCharCode(0x2066);
  static final String _pdi = String.fromCharCode(0x2069);

  /// شرطة المصروف (en dash U+2013) كما في التصميم.
  static final String expenseSign = String.fromCharCode(0x2013);

  /// يعزل النص كمقطع من اليسار لليمين.
  static String ltr(String text) => '$_lri$text$_pdi';

  /// $1,000.00 — لقيمة موجبة؛ الإشارة يضيفها AppStrings.money.
  static String usd(double abs) => _usd.format(abs);

  /// $650 (أسفل أعمدة Daily Spending)
  static String usdWhole(double abs) => _usdWhole.format(abs);

  /// 150,000 أو 1,250.50 — الكسور تظهر فقط عندما توجد.
  static String syp(double abs) =>
      ((abs * 100).round() % 100 == 0 ? _grouped : _groupedCents).format(abs);

  /// 150K أو 1.5M (أسفل الأعمدة حيث المساحة ضيقة)
  static String compact(double abs) => _compact.format(abs);

  /// 35%
  static String percent(int value) => ltr('$value%');

  /// النص الرمادي داخل حقل المبلغ الفارغ.
  static String amountHint(Currency currency) =>
      currency == Currency.syp ? '0' : '0.00';
}
