import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import 'language_theme_button.dart';

/// ترويسة الشاشات الثلاث: "SPENDWISE" صغيرة فوق عنوان كبير،
/// وزر اللغة والمظهر بالطرف.
class ScreenHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSettingsPressed;

  const ScreenHeader({
    super.key,
    required this.title,
    required this.onSettingsPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final strings = AppStrings.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // اسم العلامة لاتيني باللغتين، فالتباعد بين حروفه آمن.
              Text(
                strings.brand,
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        LanguageThemeButton(onPressed: onSettingsPressed),
      ],
    );
  }
}
