import 'package:flutter_test/flutter_test.dart';
import 'package:spendwise/models/currency.dart';
import 'package:spendwise/utils/formatters.dart';
import 'package:spendwise/utils/latin_digits_formatter.dart';

void main() {
  test('isolates wrap text in a left-to-right run', () {
    final text = Formatters.ltr('x');
    expect(text.codeUnits.first, 0x2066);
    expect(text.codeUnits.last, 0x2069);
    expect(text.substring(1, text.length - 1), 'x');
  });

  test('raw numbers keep Latin digits', () {
    expect(Formatters.usd(1000), r'$1,000.00');
    expect(Formatters.usdWhole(650), r'$650');
    expect(Formatters.syp(150000), '150,000');
    expect(Formatters.syp(1250.5), '1,250.50');
    expect(Formatters.compact(150000), '150K');
    expect(Formatters.percent(35), Formatters.ltr('35%'));
    expect(Formatters.expenseSign, String.fromCharCode(0x2013));
  });

  test('amount hint follows the currency', () {
    expect(Formatters.amountHint(Currency.usd), '0.00');
    expect(Formatters.amountHint(Currency.syp), '0');
  });

  test('currency codes round-trip and default to dollars', () {
    expect(Currency.fromCode('SYP'), Currency.syp);
    expect(Currency.fromCode('USD'), Currency.usd);
    expect(Currency.fromCode(null), Currency.usd);
    expect(Currency.fromCode('EUR'), Currency.usd);
  });

  test('Arabic-Indic and Persian digits become Latin', () {
    expect(LatinDigitsFormatter.normalize('١٢٣٫٥٠'), '123.50');
    expect(LatinDigitsFormatter.normalize('۴۵'), '45');
    expect(LatinDigitsFormatter.normalize('12,5'), '12.5');
    expect(LatinDigitsFormatter.normalize('99.9'), '99.9');
  });
}
