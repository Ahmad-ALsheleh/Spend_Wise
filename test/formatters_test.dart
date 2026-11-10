import 'package:flutter_test/flutter_test.dart';
import 'package:spendwise/models/transaction_model.dart';
import 'package:spendwise/utils/formatters.dart';
import 'package:spendwise/utils/latin_digits_formatter.dart';

void main() {
  final enDash = String.fromCharCode(0x2013);

  test('amounts are wrapped in a left-to-right isolate', () {
    final text = Formatters.currency(1000);
    expect(text.codeUnits.first, 0x2066);
    expect(text.codeUnits.last, 0x2069);
    expect(text.substring(1, text.length - 1), r'$1,000.00');
  });

  test('signed amounts: + for income, en dash for expenses', () {
    expect(
      Formatters.signedCurrency(1000, TransactionType.income),
      Formatters.ltr(r'+$1,000.00'),
    );
    expect(
      Formatters.signedCurrency(650, TransactionType.expense),
      Formatters.ltr('$enDash\$650.00'),
    );
  });

  test('negative balance, whole dollars and percentages', () {
    expect(Formatters.currency(-350), Formatters.ltr(r'-$350.00'));
    expect(Formatters.wholeCurrency(650), Formatters.ltr(r'$650'));
    expect(Formatters.percent(35), Formatters.ltr('35%'));
  });

  test('Arabic-Indic and Persian digits become Latin', () {
    expect(LatinDigitsFormatter.normalize('١٢٣٫٥٠'), '123.50');
    expect(LatinDigitsFormatter.normalize('۴۵'), '45');
    expect(LatinDigitsFormatter.normalize('12,5'), '12.5');
    expect(LatinDigitsFormatter.normalize('99.9'), '99.9');
  });
}
