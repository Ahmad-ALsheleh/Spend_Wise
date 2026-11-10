import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';

/// زر + العائم (مربع بزوايا دائرية) الظاهر بالتبويبات الثلاثة.
/// يُمرَّر لـ Scaffold.floatingActionButton فيأخذ موضعه بالطرف حسب اتجاه اللغة.
class AddFab extends StatelessWidget {
  final VoidCallback onPressed;

  const AddFab({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final radius = BorderRadius.circular(18);
    return Tooltip(
      message: AppStrings.of(context).addEntry,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.fab,
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color: colors.fabShadow,
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: radius,
            onTap: onPressed,
            child: SizedBox.square(
              dimension: 56,
              child: Icon(Icons.add, color: colors.onFab, size: 28),
            ),
          ),
        ),
      ),
    );
  }
}
