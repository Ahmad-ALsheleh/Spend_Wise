import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spendwise/models/app_settings.dart';
import 'package:spendwise/models/transaction_model.dart';
import 'package:spendwise/utils/app_colors.dart';
import 'package:spendwise/utils/app_strings.dart';
import 'package:spendwise/utils/app_theme.dart';
import 'package:spendwise/utils/category_data.dart';
import 'package:spendwise/utils/formatters.dart';
import 'package:spendwise/widgets/amount_input.dart';
import 'package:spendwise/widgets/date_field.dart';
import 'package:spendwise/widgets/history_summary_bar.dart';
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
    await tester.pumpWidget(
      _harness(
        const HistorySummaryBar(count: 3, totalSpent: 12.5),
        locale: const Locale('ar'),
      ),
    );

    final context = tester.element(find.byType(HistorySummaryBar));
    expect(Directionality.of(context), TextDirection.rtl);
    expect(find.text('3 معاملات'), findsOneWidget);
    expect(
      find.text('تم إنفاق ${Formatters.currency(12.5)}'),
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
    final amount = Formatters.signedCurrency(650, TransactionType.expense);
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
        AmountInput(controller: controller, onChanged: (_) {}),
        locale: const Locale('ar'),
      ),
    );

    await tester.enterText(find.byType(TextField), '١٢٫٥');
    expect(controller.text, '12.5');
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
