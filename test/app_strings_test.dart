import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:spendwise/models/currency.dart';
import 'package:spendwise/utils/app_strings_ar.dart';
import 'package:spendwise/utils/app_strings_en.dart';
import 'package:spendwise/utils/category_data.dart';
import 'package:spendwise/utils/formatters.dart';

void main() {
  setUpAll(() => initializeDateFormatting());

  const en = AppStringsEn();
  const ar = AppStringsAr();
  final dash = Formatters.expenseSign;
  String ltr(String text) => Formatters.ltr(text);

  group('money in each currency', () {
    test('dollars look the same in both languages', () {
      expect(en.money(1000, Currency.usd), ltr(r'$1,000.00'));
      expect(ar.money(1000, Currency.usd), ltr(r'$1,000.00'));
      expect(en.money(-350, Currency.usd), ltr(r'-$350.00'));
      expect(
        en.signedMoney(650, Currency.usd, income: false),
        ltr('$dash\$650.00'),
      );
      expect(
        en.signedMoney(1000, Currency.usd, income: true),
        ltr(r'+$1,000.00'),
      );
    });

    test('Syrian pounds: SYP before the number in English', () {
      expect(en.money(150000, Currency.syp), ltr('SYP 150,000'));
      expect(
        en.signedMoney(150000, Currency.syp, income: false),
        ltr('${dash}SYP 150,000'),
      );
      expect(en.money(-2500, Currency.syp), ltr('-SYP 2,500'));
    });

    test('Syrian pounds: number then ل.س in Arabic, sign kept with it', () {
      expect(ar.money(150000, Currency.syp), '${ltr('150,000')} ل.س');
      expect(
        ar.signedMoney(1250.5, Currency.syp, income: true),
        '${ltr('+1,250.50')} ل.س',
      );
      expect(ar.money(-2500, Currency.syp), '${ltr('-2,500')} ل.س');
    });

    test('totals in several currencies are listed, never added', () {
      expect(
        ar.moneyList({Currency.syp: 150000, Currency.usd: 12.5}, Currency.usd),
        '${ar.money(12.5, Currency.usd)} · ${ar.money(150000, Currency.syp)}',
      );
      expect(
        en.moneyList({Currency.usd: 0}, Currency.syp),
        en.money(0, Currency.syp),
      );
    });

    test('chart labels stay short', () {
      expect(en.chartAmount(650, Currency.usd), ltr(r'$650'));
      expect(ar.chartAmount(150000, Currency.syp), ltr('150K'));
    });

    test('currency names and labels', () {
      expect(en.currencyLabel(Currency.syp), 'Syrian pound (SYP)');
      expect(ar.currencyLabel(Currency.syp), 'ليرة سورية (ل.س)');
      expect(ar.currencyLabel(Currency.usd), r'دولار ($)');
    });
  });

  group('dates keep Latin digits in both languages', () {
    test('month and year', () {
      expect(en.monthYear(DateTime(2026, 7)), 'July 2026');
      expect(ar.monthYear(DateTime(2026, 7)), 'يوليو 2026');
    });

    test('date field', () {
      final date = DateTime(2026, 7, 12);
      expect(en.dateField(date), Formatters.ltr('07 / 12 / 2026'));
      expect(ar.dateField(date), Formatters.ltr('12 / 07 / 2026'));
    });

    test('week range inside one month and across two months', () {
      expect(
        en.weekRange(DateTime(2026, 7, 6), DateTime(2026, 7, 12)),
        'Jul 6 – 12',
      );
      expect(
        en.weekRange(DateTime(2026, 6, 29), DateTime(2026, 7, 5)),
        'Jun 29 – Jul 5',
      );
      expect(
        ar.weekRange(DateTime(2026, 7, 6), DateTime(2026, 7, 12)),
        '6 – 12 يوليو',
      );
      expect(
        ar.weekRange(DateTime(2026, 6, 29), DateTime(2026, 7, 5)),
        '29 يونيو – 5 يوليو',
      );
    });

    test('day group labels', () {
      final now = DateTime(2026, 7, 12, 15, 30);
      expect(en.dayGroupLabel(DateTime(2026, 7, 12), now: now), 'TODAY');
      expect(
        en.dayGroupLabel(DateTime(2026, 7, 11, 23, 59), now: now),
        'YESTERDAY',
      );
      expect(en.dayGroupLabel(DateTime(2026, 7, 1), now: now), 'JULY 1');
      expect(ar.dayGroupLabel(DateTime(2026, 7, 12), now: now), 'اليوم');
      expect(ar.dayGroupLabel(DateTime(2026, 7, 11), now: now), 'أمس');
      expect(ar.dayGroupLabel(DateTime(2026, 7, 1), now: now), '1 يوليو');
      expect(
        en.dayGroupLabel(DateTime(2026, 6, 30), now: DateTime(2026, 7, 1)),
        'YESTERDAY',
      );
    });

    test('short weekday names start on Monday', () {
      expect(en.weekdayShort(DateTime(2026, 7, 6)), 'Mon');
      expect(en.weekdayShort(DateTime(2026, 7, 12)), 'Sun');
      expect(ar.weekdayShort(DateTime(2026, 7, 6)), 'إثنين');
    });
  });

  test('Arabic transaction counts follow Arabic number agreement', () {
    expect(ar.transactionsCount(0), '0 معاملة');
    expect(ar.transactionsCount(1), 'معاملة واحدة');
    expect(ar.transactionsCount(2), 'معاملتان');
    expect(ar.transactionsCount(3), '3 معاملات');
    expect(ar.transactionsCount(10), '10 معاملات');
    expect(ar.transactionsCount(11), '11 معاملة');
    expect(ar.transactionsCount(100), '100 معاملة');
    expect(ar.transactionsCount(103), '103 معاملات');
    // الإنجليزية مطابقة لصورة التصميم حرفياً.
    expect(en.transactionsCount(1), '1 transactions');
  });

  test('every category has its own name in both languages', () {
    const otherKeys = {CategoryKeys.otherExpense, CategoryKeys.otherIncome};
    final categories = [
      ...CategoryData.expenseCategories,
      ...CategoryData.incomeCategories,
    ];
    for (final category in categories) {
      if (otherKeys.contains(category.key)) continue;
      expect(en.categoryName(category.key), isNot('Other'),
          reason: category.key);
      expect(ar.categoryName(category.key), isNot('أخرى'),
          reason: category.key);
    }
    expect(en.categoryName(CategoryKeys.foodDrink), 'Food & Drink');
    expect(ar.categoryName(CategoryKeys.fun), 'ترفيه');
    expect(en.categoryName('unknown_key'), 'Other');
  });
}
