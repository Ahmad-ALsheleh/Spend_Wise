import 'package:intl/intl.dart';
import '../models/transaction_model.dart';

/// تنسيق المبالغ والنسب. الأرقام لاتينية في اللغتين ($1,000.00).
///
/// كل ناتج محاط بعزل اتجاه LTR: بدونه تنتقل الإشارة في الواجهة العربية
/// لنهاية الرقم ("$650.00–") وينقلب ترتيب المبلغ داخل الجمل العربية.
/// تواريخ الواجهة (أسماء الأشهر وغيرها) في AppStrings لأنها تختلف حسب اللغة.
class Formatters {
  Formatters._();

  /// رمز العملة الظاهر بجانب حقل المبلغ وداخل كل المبالغ.
  static const String currencySymbol = r'$';

  /// النص الرمادي داخل حقل المبلغ الفارغ.
  static const String amountHint = '0.00';

  static final NumberFormat _currency = NumberFormat.currency(
    locale: 'en_US',
    symbol: currencySymbol,
    decimalDigits: 2,
  );

  static final NumberFormat _wholeCurrency = NumberFormat.currency(
    locale: 'en_US',
    symbol: currencySymbol,
    decimalDigits: 0,
  );

  /// Left-to-Right Isolate (U+2066) و Pop Directional Isolate (U+2069).
  /// تُبنى من رموزها حتى لا يظهر محرف اتجاه غير مرئي داخل الكود نفسه.
  static final String _lri = String.fromCharCode(0x2066);
  static final String _pdi = String.fromCharCode(0x2069);

  /// شرطة المصروف (en dash U+2013) كما في التصميم.
  static final String _minus = String.fromCharCode(0x2013);

  /// يعزل النص كمقطع من اليسار لليمين.
  static String ltr(String text) => '$_lri$text$_pdi';

  /// $1,000.00
  static String currency(double value) => ltr(_currency.format(value));

  /// $650 (أسفل أعمدة Daily Spending)
  static String wholeCurrency(double value) =>
      ltr(_wholeCurrency.format(value));

  /// +$1,000.00 للدخل أو –$650.00 للمصروف
  static String signedCurrency(double value, String type) {
    final sign = type == TransactionType.income ? '+' : _minus;
    return ltr('$sign${_currency.format(value.abs())}');
  }

  /// 35%
  static String percent(int value) => ltr('$value%');
}
