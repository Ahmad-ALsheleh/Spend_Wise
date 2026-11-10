import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

/// سمتا التطبيق (فاتحة وداكنة)، مبنيتان من لوحتي [AppColors].
class AppTheme {
  AppTheme._();

  static final ThemeData light = _build(AppColors.light, Brightness.light);
  static final ThemeData dark = _build(AppColors.dark, Brightness.dark);

  static ThemeData _build(AppColors colors, Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: colors.primary,
      brightness: brightness,
    ).copyWith(
      primary: colors.primary,
      onPrimary: colors.onPrimary,
      surface: colors.surface,
      onSurface: colors.textPrimary,
      onSurfaceVariant: colors.textSecondary,
      outline: colors.textDisabled,
      outlineVariant: colors.divider,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: colors.background,
      canvasColor: colors.background,
      dividerColor: colors.divider,
      splashFactory: InkRipple.splashFactory,
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surface,
        modalBackgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.primary,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colors.primary,
        selectionColor: colors.primary.withValues(alpha: 0.3),
        selectionHandleColor: colors.primary,
      ),
    );
  }

  /// أيقونات شريط الحالة وشريط تنقل النظام تتبع المظهر الحالي.
  static SystemUiOverlayStyle systemOverlayStyle(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;
    final iconBrightness = isDark ? Brightness.light : Brightness.dark;
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: iconBrightness,
      statusBarBrightness: brightness, // iOS
      systemNavigationBarColor: colors.navBar,
      systemNavigationBarIconBrightness: iconBrightness,
    );
  }
}
