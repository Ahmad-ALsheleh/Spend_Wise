import 'package:flutter/material.dart';

/// كل ألوان تطبيق SpendWise بمكان واحد، بلوحتين:
/// - [light] مطابقة لصور التصميم (القيم مأخوذة من الصور مباشرة).
/// - [dark] للوضع الداكن بنفس هوية اللون الأخضر المزرق.
///
/// الودجت لا تستخدم أي لون ثابت؛ تقرأ اللوحة الحالية عبر [AppColors.of].
@immutable
class AppColors {
  const AppColors({
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textDisabled,
    required this.divider,
    required this.primary,
    required this.onPrimary,
    required this.fab,
    required this.onFab,
    required this.fabShadow,
    required this.navBar,
    required this.highlight,
    required this.onHighlight,
    required this.toggleTrack,
    required this.toggleThumb,
    required this.fieldFill,
    required this.incomeTile,
    required this.onIncomeTile,
    required this.expenseTile,
    required this.onExpenseTile,
    required this.savedTile,
    required this.onSavedTile,
    required this.deleteFill,
    required this.deleteIcon,
    required this.weekend,
    required this.balanceStart,
    required this.balanceEnd,
    required this.balanceTile,
    required this.onBalance,
    required this.onBalanceMuted,
    required this.chartTrack,
    required this.shadow,
    required this.categoryTintAlpha,
  });

  /// اللوحة المطابقة للمظهر الحالي (فاتح أو داكن).
  static AppColors of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? dark : light;

  // --------------------------------------------------------- أسطح ونصوص
  final Color background; // خلفية الشاشات
  final Color surface; // اللوحات السفلية وزر الإعدادات
  final Color textPrimary;
  final Color textSecondary; // العناوين الصغيرة والنصوص الفرعية
  final Color textMuted; // التلميحات
  final Color textDisabled; // 0.00 الفارغ، الأسهم المعطلة، الأيام المستقبلية
  final Color divider;

  // --------------------------------------------------------- اللون الأساسي
  final Color primary; // زر الحفظ، مبالغ الدخل، الأعمدة، See all
  final Color onPrimary;
  final Color fab; // زر + العائم
  final Color onFab;
  final Color fabShadow; // توهج فاتح بالمظهر الفاتح، ظل عادي بالداكن

  // --------------------------------------------------------- عناصر التحكم
  final Color navBar;
  final Color highlight; // عنصر التنقل المحدد، الفئة المختارة، شريط الملخص
  final Color onHighlight;
  final Color toggleTrack; // خلفية مفاتيح الاختيار
  final Color toggleThumb; // الخيار المحدد بالمفتاح
  final Color fieldFill; // حقول الملاحظة والتاريخ، الفئات، زر الحفظ المعطل

  // --------------------------------------------------------- بطاقات Analytics
  final Color incomeTile;
  final Color onIncomeTile;
  final Color expenseTile;
  final Color onExpenseTile;
  final Color savedTile;
  final Color onSavedTile;

  // --------------------------------------------------------- الحذف والتقويم
  final Color deleteFill;
  final Color deleteIcon;
  final Color weekend;

  // --------------------------------------------------------- بطاقة الرصيد
  final Color balanceStart;
  final Color balanceEnd;
  final Color balanceTile; // مربعا Income / Expenses الشفافان
  final Color onBalance;
  final Color onBalanceMuted;

  // --------------------------------------------------------- الرسوم والظلال
  final Color chartTrack; // خلفية الدائرة وأشرطة التقدم
  final Color shadow;

  /// شفافية خلفية أيقونة الفئة فوق لونها الثابت.
  final double categoryTintAlpha;

  /// خلفية مربع أيقونة الفئة (لون الفئة بشفافية).
  Color categoryTint(Color categoryColor) =>
      categoryColor.withValues(alpha: categoryTintAlpha);

  /// تدرج بطاقة Net Balance (ينعكس اتجاهه مع RTL).
  LinearGradient get balanceGradient => LinearGradient(
        begin: AlignmentDirectional.topStart,
        end: AlignmentDirectional.bottomEnd,
        colors: [balanceStart, balanceEnd],
      );

  static const AppColors light = AppColors(
    background: Color(0xFFF1F9FB),
    surface: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF0B0F10),
    textSecondary: Color(0xFF4D5A5F),
    textMuted: Color(0xFF8E9496),
    textDisabled: Color(0xFFB4BCBE),
    divider: Color(0xFFE5ECEF),
    primary: Color(0xFF00626E),
    onPrimary: Color(0xFFFFFFFF),
    fab: Color(0xFF96E8F4),
    onFab: Color(0xFF0B0F10),
    fabShadow: Color(0x7396E8F4),
    navBar: Color(0xFFEDF2F5),
    highlight: Color(0xFFC9E5E8),
    onHighlight: Color(0xFF0B2E33),
    toggleTrack: Color(0xFFE8EDF1),
    toggleThumb: Color(0xFFFFFFFF),
    fieldFill: Color(0xFFE6EEF0),
    incomeTile: Color(0xFF95E8F4),
    onIncomeTile: Color(0xFF07313A),
    expenseTile: Color(0xFFFEDDD1),
    onExpenseTile: Color(0xFF5C1A12),
    savedTile: Color(0xFFCDE5E9),
    onSavedTile: Color(0xFF0E2A2F),
    deleteFill: Color(0xFFFFDDDB),
    deleteIcon: Color(0xFFA61B1B),
    weekend: Color(0xFFC0392B),
    balanceStart: Color(0xFF00626C),
    balanceEnd: Color(0xFF007B7D),
    balanceTile: Color(0x1FFFFFFF),
    onBalance: Color(0xFFFFFFFF),
    onBalanceMuted: Color(0xFFA5DEE7),
    chartTrack: Color(0xFFE8EEEF),
    shadow: Color(0x14000000),
    categoryTintAlpha: 0.2,
  );

  static const AppColors dark = AppColors(
    background: Color(0xFF0D1517),
    surface: Color(0xFF172124),
    textPrimary: Color(0xFFE8F0F1),
    textSecondary: Color(0xFFA7B5B9),
    textMuted: Color(0xFF7E8E92),
    textDisabled: Color(0xFF4F5D61),
    divider: Color(0xFF243134),
    primary: Color(0xFF5CC9D1),
    onPrimary: Color(0xFF00353A),
    fab: Color(0xFF7DD8E4),
    onFab: Color(0xFF04262B),
    fabShadow: Color(0x59000000),
    navBar: Color(0xFF121C1E),
    highlight: Color(0xFF1D4146),
    onHighlight: Color(0xFFCDEFF3),
    toggleTrack: Color(0xFF1F2B2E),
    toggleThumb: Color(0xFF2E3D41),
    fieldFill: Color(0xFF1F2B2E),
    incomeTile: Color(0xFF12444B),
    onIncomeTile: Color(0xFFCFF6FA),
    expenseTile: Color(0xFF452720),
    onExpenseTile: Color(0xFFFFD9CE),
    savedTile: Color(0xFF1F3438),
    onSavedTile: Color(0xFFDCEBED),
    deleteFill: Color(0xFF4A2222),
    deleteIcon: Color(0xFFFF9A8F),
    weekend: Color(0xFFFF8A80),
    balanceStart: Color(0xFF00515A),
    balanceEnd: Color(0xFF006A6E),
    balanceTile: Color(0x1AFFFFFF),
    onBalance: Color(0xFFFFFFFF),
    onBalanceMuted: Color(0xFF9ED7DF),
    chartTrack: Color(0xFF253337),
    shadow: Color(0x66000000),
    categoryTintAlpha: 0.24,
  );

  // --------------------------------------------------------- ألوان الفئات
  // لون ثابت لكل فئة (نفسه بالمظهرين) يُستخدم بالرسوم وخلفية الأيقونة.
  static const Color categoryFoodDrink = Color(0xFFF97316);
  static const Color categoryTransport = Color(0xFF3B82F6);
  static const Color categoryHousing = Color(0xFF8B5CF6);
  static const Color categoryHealth = Color(0xFFEF4444);
  static const Color categoryFun = Color(0xFFFBBF24);
  static const Color categoryShopping = Color(0xFFEC4899);
  static const Color categoryEducation = Color(0xFF10B981);
  static const Color categoryTravel = Color(0xFF06B6D4);
  static const Color categoryUtilities = Color(0xFF84CC16);
  static const Color categoryOtherExpense = Color(0xFF94A3B8);
  static const Color categorySalary = Color(0xFF5B9A6B);
  static const Color categoryFreelance = Color(0xFF6366F1);
  static const Color categoryInvestment = Color(0xFF0EA5E9);
  static const Color categoryGift = Color(0xFFF43F5E);
  static const Color categoryOtherIncome = Color(0xFFD4A017);
}
