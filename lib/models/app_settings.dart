import 'package:flutter/material.dart';

import 'currency.dart';

/// لغة الواجهة التي يختارها المستخدم من لوحة الإعدادات.
enum AppLanguage { system, english, arabic }

/// تفضيلات المستخدم. تُحفظ بجدول settings في SQLite حتى تبقى بعد إغلاق التطبيق.
/// الافتراضي: اتباع لغة الجهاز ومظهره، والدولار.
@immutable
class AppSettings {
  static const String themeModeKey = 'theme_mode';
  static const String languageKey = 'language';
  static const String currencyKey = 'currency';

  final ThemeMode themeMode;
  final AppLanguage language;

  /// العملة المعروضة بالرئيسية والتحليلات، وهي الافتراضية للمعاملة الجديدة.
  final Currency currency;

  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.language = AppLanguage.system,
    this.currency = Currency.usd,
  });

  /// null يعني: اتبع لغة الجهاز (العربية إن كانت لغته عربية، وإلا الإنجليزية).
  Locale? get locale => switch (language) {
        AppLanguage.system => null,
        AppLanguage.english => const Locale('en'),
        AppLanguage.arabic => const Locale('ar'),
      };

  AppSettings copyWith({
    ThemeMode? themeMode,
    AppLanguage? language,
    Currency? currency,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      currency: currency ?? this.currency,
    );
  }

  /// صفوف جدول settings: مفتاح ← قيمة نصية.
  Map<String, String> toMap() => {
        themeModeKey: themeMode.name,
        languageKey: language.name,
        currencyKey: currency.code,
      };

  /// أي قيمة مفقودة أو غير معروفة تعود للافتراضي بدل أن تكسر التطبيق.
  factory AppSettings.fromMap(Map<String, String> map) {
    return AppSettings(
      themeMode:
          ThemeMode.values.asNameMap()[map[themeModeKey]] ?? ThemeMode.system,
      language: AppLanguage.values.asNameMap()[map[languageKey]] ??
          AppLanguage.system,
      currency: Currency.fromCode(map[currencyKey]),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is AppSettings &&
      other.themeMode == themeMode &&
      other.language == language &&
      other.currency == currency;

  @override
  int get hashCode => Object.hash(themeMode, language, currency);
}
