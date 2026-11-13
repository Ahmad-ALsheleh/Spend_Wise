import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';

/// زر اللغة والمظهر بطرف الترويسة: كبسولة تعرض اللغة الحالية (文A EN / عربي)
/// ووضع الإضاءة الحالي (شمس أو قمر)، فيفهم المستخدم من النظرة الأولى
/// ما الذي يغيّره الزر وما الحالة الآن. الضغط يفتح لوحة الاختيار.
class LanguageThemeButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LanguageThemeButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final strings = AppStrings.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Tooltip(
      message: strings.languageAndTheme,
      child: Material(
        color: colors.surface,
        shape: StadiumBorder(side: BorderSide(color: colors.divider)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            height: 40,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.translate_rounded,
                    size: 18,
                    color: colors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    strings.languageShortName,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(width: 1, height: 16, color: colors.divider),
                  const SizedBox(width: 10),
                  // دوران وتلاشٍ خفيف بين الشمس والقمر عند تبديل الوضع.
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) => RotationTransition(
                      turns:
                          Tween<double>(begin: 0.75, end: 1).animate(animation),
                      child: FadeTransition(opacity: animation, child: child),
                    ),
                    child: Icon(
                      isDark
                          ? Icons.dark_mode_rounded
                          : Icons.light_mode_rounded,
                      key: ValueKey(isDark),
                      size: 18,
                      color: colors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
