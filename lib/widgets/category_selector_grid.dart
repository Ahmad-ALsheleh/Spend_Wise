import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';

/// شبكة تصنيفات قابلة للاختيار (Wrap)، المختار بخلفية فاتحة وعلامة ✓ قبله.
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
    final strings = AppStrings.of(context);
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final category in categories)
          _CategoryChip(
            emoji: category.emoji,
            label: strings.categoryName(category.key),
            selected: category.key == selectedKey,
            onTap: () => onSelect(category.key),
          ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String emoji;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.emoji,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: selected ? colors.highlight : colors.fieldFill,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected) ...[
                Icon(Icons.check, size: 16, color: colors.textPrimary),
                const SizedBox(width: 6),
              ],
              Text(emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
