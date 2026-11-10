import 'package:flutter/material.dart';

/// لغة الواجهة التي يختارها المستخدم من لوحة الإعدادات.
enum AppLanguage { system, english, arabic }

/// تفضيلات المستخدم (اللغة والمظهر). تُحفظ بجدول settings في SQLite
/// حتى تبقى بعد إغلاق التطبيق. القيمة الافتراضية: اتباع إعدادات الجهاز.
@immutable
class AppSettings {
  static const String themeModeKey = 'theme_mode';
  static const String languageKey = 'language';

  final ThemeMode themeMode;
  final AppLanguage language;

  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.language = AppLanguage.system,
  });

  /// null يعني: اتبع لغة الجهاز (العربية إن كانت لغته عربية، وإلا الإنجليزية).
  Locale? get locale => switch (language) {
        AppLanguage.system => null,
        AppLanguage.english => const Locale('en'),
        AppLanguage.arabic => const Locale('ar'),
      };

  AppSettings copyWith({ThemeMode? themeMode, AppLanguage? language}) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
    );
  }

  /// صفوف جدول settings: مفتاح ← قيمة نصية.
  Map<String, String> toMap() => {
        themeModeKey: themeMode.name,
        languageKey: language.name,
      };

  /// أي قيمة مفقودة أو غير معروفة تعود للافتراضي بدل أن تكسر التطبيق.
  factory AppSettings.fromMap(Map<String, String> map) {
    return AppSettings(
      themeMode:
          ThemeMode.values.asNameMap()[map[themeModeKey]] ?? ThemeMode.system,
      language: AppLanguage.values.asNameMap()[map[languageKey]] ??
          AppLanguage.system,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is AppSettings &&
      other.themeMode == themeMode &&
      other.language == language;

  @override
  int get hashCode => Object.hash(themeMode, language);
}
