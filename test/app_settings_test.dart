import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spendwise/models/app_settings.dart';
import 'package:spendwise/models/currency.dart';

void main() {
  test('defaults follow the device language and theme, in dollars', () {
    const settings = AppSettings();
    expect(settings.themeMode, ThemeMode.system);
    expect(settings.language, AppLanguage.system);
    expect(settings.currency, Currency.usd);
    expect(settings.locale, isNull);
  });

  test('round-trips through the settings table rows', () {
    const settings = AppSettings(
      themeMode: ThemeMode.dark,
      language: AppLanguage.arabic,
      currency: Currency.syp,
    );
    expect(AppSettings.fromMap(settings.toMap()), settings);
    expect(settings.locale, const Locale('ar'));
  });

  test('unknown or missing stored values fall back to defaults', () {
    expect(
      AppSettings.fromMap(const {'theme_mode': 'sepia', 'language': 'fr'}),
      const AppSettings(),
    );
    expect(AppSettings.fromMap(const {}), const AppSettings());
  });
}
