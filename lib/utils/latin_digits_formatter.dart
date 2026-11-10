import 'package:flutter/services.dart';

/// يحوّل الأرقام العربية-الهندية (٠-٩) والفارسية (۰-۹) والفاصلة العشرية
/// إلى أرقام لاتينية ونقطة، لأن الأرقام في التطبيق لاتينية دائماً.
/// بدونه لا يستطيع من يكتب بلوحة مفاتيح عربية إدخال أي مبلغ.
class LatinDigitsFormatter extends TextInputFormatter {
  const LatinDigitsFormatter();

  static String normalize(String input) {
    final buffer = StringBuffer();
    for (final unit in input.codeUnits) {
      if (unit >= 0x0660 && unit <= 0x0669) {
        buffer.writeCharCode(0x30 + unit - 0x0660); // ٠-٩
      } else if (unit >= 0x06F0 && unit <= 0x06F9) {
        buffer.writeCharCode(0x30 + unit - 0x06F0); // ۰-۹
      } else if (unit == 0x066B || unit == 0x2C) {
        buffer.writeCharCode(0x2E); // ٫ أو , ← .
      } else {
        buffer.writeCharCode(unit);
      }
    }
    return buffer.toString();
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // الاستبدال حرف بحرف، فيبقى موضع المؤشر صحيحاً.
    final text = normalize(newValue.text);
    return text == newValue.text ? newValue : newValue.copyWith(text: text);
  }
}
