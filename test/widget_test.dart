import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spendwise/models/app_settings.dart';
import 'package:spendwise/models/currency.dart';
import 'package:spendwise/models/transaction_model.dart';
import 'package:spendwise/utils/app_colors.dart';
import 'package:spendwise/utils/app_strings.dart';
import 'package:spendwise/utils/app_strings_ar.dart';
import 'package:spendwise/utils/app_strings_en.dart';
import 'package:spendwise/utils/app_theme.dart';
import 'package:spendwise/utils/category_data.dart';
import 'package:spendwise/widgets/amount_input.dart';
import 'package:spendwise/widgets/currency_switch.dart';
import 'package:spendwise/widgets/date_field.dart';
import 'package:spendwise/widgets/history_summary_bar.dart';
import 'package:spendwise/widgets/language_theme_button.dart';
import 'package:spendwise/widgets/settings_sheet.dart';
import 'package:spendwise/widgets/transaction_tile.dart';

/// نفس إعداد MaterialApp في app.dart، بدون قاعدة البيانات.
Widget _harness(
  Widget child, {
  Locale locale = const Locale('en'),
  ThemeMode themeMode = ThemeMode.light,
}) {
  return MaterialApp(
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    themeMode: themeMode,
    locale: locale,
    supportedLocales: AppStrings.supportedLocales,
    localizationsDelegates: const [
      AppStrings.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('Arabic lays out right-to-left with Arabic text', (tester) async {
    const spent = {Currency.usd: 12.5, Currency.syp: 150000.0};
    await tester.pumpWidget(
      _harness(
        const HistorySummaryBar(
          count: 3,
          spent: spent,
          fallbackCurrency: Currency.usd,
        ),
        locale: const Locale('ar'),
      ),
    );

    final context = tester.element(find.byType(HistorySummaryBar));
    expect(Directionality.of(context), TextDirection.rtl);
    expect(find.text('3 معاملات'), findsOneWidget);
    // مصروف كل عملة وحده، كلٌّ بسطر.
    const ar = AppStringsAr();
    expect(
      find.text(ar.spent(ar.moneyList(spent, Currency.usd, separator: '\n'))),
      findsOneWidget,
    );
  });

  testWidgets('dark theme resolves the dark palette', (tester) async {
    late AppColors colors;
    await tester.pumpWidget(
      _harness(
        Builder(
          builder: (context) {
            colors = AppColors.of(context);
            return const SizedBox();
          },
        ),
        themeMode: ThemeMode.dark,
      ),
    );

    expect(colors, same(AppColors.dark));
  });

  testWidgets('header button shows the current language and mode',
      (tester) async {
    var presses = 0;
    void onPressed() => presses++;

    await tester
        .pumpWidget(_harness(LanguageThemeButton(onPressed: onPressed)));
    expect(find.text('EN'), findsOneWidget);
    expect(find.byIcon(Icons.light_mode_rounded), findsOneWidget);

    await tester.pumpWidget(
      _harness(
        LanguageThemeButton(onPressed: onPressed),
        locale: const Locale('ar'),
        themeMode: ThemeMode.dark,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('عربي'), findsOneWidget);
    expect(find.byIcon(Icons.dark_mode_rounded), findsOneWidget);
    expect(find.byIcon(Icons.light_mode_rounded), findsNothing);

    await tester.tap(find.byType(LanguageThemeButton));
    expect(presses, 1);
  });

  testWidgets('settings sheet reports language and theme choices',
      (tester) async {
    AppSettings? reported;
    await tester.pumpWidget(
      _harness(
        SettingsSheet(
          settings: const AppSettings(),
          onChanged: (settings) => reported = settings,
        ),
      ),
    );

    await tester.tap(find.text('العربية'));
    await tester.pump();
    expect(reported, const AppSettings(language: AppLanguage.arabic));

    await tester.tap(find.text('Dark'));
    await tester.pump();
    expect(
      reported,
      const AppSettings(
        language: AppLanguage.arabic,
        themeMode: ThemeMode.dark,
      ),
    );
  });

  testWidgets('history tile swaps its amount for a delete button',
      (tester) async {
    final transaction = TransactionModel(
      id: 1,
      title: 'PS5 + GTA6',
      amount: 650,
      categoryKey: CategoryKeys.fun,
      type: TransactionType.expense,
      date: DateTime(2026, 7, 12),
    );
    final amount =
        const AppStringsEn().signedMoney(650, Currency.usd, income: false);
    var deleted = false;

    await tester
        .pumpWidget(_harness(TransactionTile(transaction: transaction)));
    expect(find.text(amount), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline), findsNothing);

    await tester.pumpWidget(
      _harness(
        TransactionTile(
          transaction: transaction,
          deleteMode: true,
          onDelete: () => deleted = true,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(amount), findsNothing);

    await tester.tap(find.byIcon(Icons.delete_outline));
    expect(deleted, isTrue);
  });

  testWidgets('amount input turns Arabic-Indic digits into Latin ones',
      (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _harness(
        AmountInput(
          controller: controller,
          currency: Currency.syp,
          onChanged: (_) {},
        ),
        locale: const Locale('ar'),
      ),
    );

    expect(find.text('ل.س'), findsOneWidget); // رمز العملة المختارة
    await tester.enterText(find.byType(TextField), '١٢٫٥');
    expect(controller.text, '12.5');
  });

  testWidgets('a Syrian pound expense shows its own currency', (tester) async {
    final transaction = TransactionModel(
      id: 2,
      title: '',
      amount: 150000,
      categoryKey: CategoryKeys.foodDrink,
      type: TransactionType.expense,
      date: DateTime(2026, 7, 12),
      currency: Currency.syp,
    );
    await tester.pumpWidget(
      _harness(
        TransactionTile(transaction: transaction),
        locale: const Locale('ar'),
      ),
    );

    expect(
      find.text(
        const AppStringsAr().signedMoney(150000, Currency.syp, income: false),
      ),
      findsOneWidget,
    );
  });

  testWidgets('currency switch reports the chosen currency', (tester) async {
    Currency? chosen;
    await tester.pumpWidget(
      _harness(
        CurrencySwitch(
          selected: Currency.usd,
          onChanged: (currency) => chosen = currency,
        ),
      ),
    );

    expect(find.text(r'$'), findsOneWidget);
    await tester.tap(find.text('SYP'));
    expect(chosen, Currency.syp);
  });

  testWidgets('calendar cannot move past the current month', (tester) async {
    await tester.pumpWidget(
      _harness(DateField(date: DateTime.now(), onDateSelected: (_) {})),
    );

    await tester.tap(find.byType(DateField));
    await tester.pumpAndSettle();

    final next = tester.widget<IconButton>(
      find.widgetWithIcon(IconButton, Icons.chevron_right),
    );
    final previous = tester.widget<IconButton>(
      find.widgetWithIcon(IconButton, Icons.chevron_left),
    );
    expect(next.onPressed, isNull);
    expect(previous.onPressed, isNotNull);
  });
}
