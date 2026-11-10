import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// عنوان قسم صغير عريض رمادي (CATEGORY, NOTE, DATE, TODAY...).
///
/// التباعد بين الحروف للاتينية فقط: الحروف العربية متصلة،
/// وأي تباعد بينها يقطع اتصالها.
class SectionLabel extends StatelessWidget {
  final String text;

  const SectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: isRtl ? 0 : 0.6,
        color: AppColors.of(context).textSecondary,
      ),
    );
  }
}
