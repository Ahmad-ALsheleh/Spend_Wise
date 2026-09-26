import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../utils/app_colors.dart';

/// شبكة تصنيفات قابلة للاختيار (Wrap)، تظهر علامة صح وتمييز عند الاختيار.
class CategorySelectorGrid extends StatelessWidget {
  final List<CategoryModel> categories;
  final String? selectedKey;
  final ValueChanged<String> onSelect;

  const CategorySelectorGrid({
    super.key,
    required this.categories,
    required this.selectedKey,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: categories.map((cat) {
        final selected = cat.key == selectedKey;
        return GestureDetector(
          onTap: () => onSelect(cat.key),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.categoryChipSelected
                  : AppColors.categoryChipBackground,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected ? AppColors.primary : Colors.transparent,
                width: 1.4,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selected) ...[
                  const Icon(Icons.check, size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                ],
                Text(cat.emoji, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Text(
                  cat.label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}