import 'package:flutter/material.dart';

/// كل ألوان تطبيق SpendWise بمكان واحد، مطابقة لتصميم الشاشات المرفقة.
class AppColors {
  AppColors._();

  // بطاقة الرصيد (Gradient الأخضر المزرق)
  static const Color balanceCardStart = Color(0xFF14555A);
  static const Color balanceCardEnd = Color(0xFF0B8C82);
  static const Color balanceInnerBox = Color(0x33FFFFFF);

  // ألوان أساسية
  static const Color primary = Color(0xFF0F766E); // teal-700
  static const Color accentMint = Color(0xFF7CE0E0); // زر + العائم
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Colors.white;

  // نصوص
  static const Color textPrimary = Color(0xFF14181B);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);

  // دخل / مصروف
  static const Color income = Color(0xFF15803D); // أخضر
  static const Color expense = Color(0xFFDC2626); // أحمر

  // شاشة Add Entry
  static const Color toggleBackground = Color(0xFFF3F4F6);
  static const Color categoryChipBackground = Color(0xFFF6F5FB);
  static const Color categoryChipSelected = Color(0xFFCFF3F0);
  static const Color fieldBackground = Color(0xFFF6F7F9);
  static const Color deleteBackground = Color(0xFFFCE7E3);
  static const Color deleteIcon = Color(0xFFE4572E);

  // بطاقات Analytics
  static const Color analyticsIncomeBg = Color(0xFFCFF3F7);
  static const Color analyticsExpenseBg = Color(0xFFFBE1DC);
  static const Color analyticsThirdBg = Color(0xFFDCE6E7);

  static const Color divider = Color(0xFFEDEDED);

  static const LinearGradient balanceGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [balanceCardStart, balanceCardEnd],
  );
}