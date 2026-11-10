import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// خيار واحد داخل [SegmentedToggle]: نص مع أيقونة أو إيموجي اختياريين.
class SegmentedToggleOption<T> {
  final T value;
  final String label;
  final IconData? icon;
  final String? emoji;

  const SegmentedToggleOption({
    required this.value,
    required this.label,
    this.icon,
    this.emoji,
  });
}

/// مفتاح اختيار مقسّم: Expense/Income، و Month/Week، وخيارات الإعدادات.
/// الخيار المحدد بخلفية فاتحة وظل خفيف كما في التصميم.
class SegmentedToggle<T> extends StatelessWidget {
  final List<SegmentedToggleOption<T>> options;
  final T selected;
  final ValueChanged<T> onChanged;

  const SegmentedToggle({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.of(context).toggleTrack,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          for (final option in options)
            Expanded(
              child: _Segment(
                label: option.label,
                icon: option.icon,
                emoji: option.emoji,
                selected: option.value == selected,
                onTap: () => onChanged(option.value),
              ),
            ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  final String label;
  final IconData? icon;
  final String? emoji;
  final bool selected;
  final VoidCallback onTap;

  const _Segment({
    required this.label,
    required this.icon,
    required this.emoji,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final foreground = selected ? colors.textPrimary : colors.textSecondary;
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            // نفس اللون بشفافية صفر حتى يكون الانتقال تلاشياً نظيفاً.
            color: selected
                ? colors.toggleThumb
                : colors.toggleThumb.withValues(alpha: 0),
            borderRadius: BorderRadius.circular(12),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: colors.shadow,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: foreground),
                const SizedBox(width: 6),
              ],
              if (emoji != null) ...[
                Text(emoji!, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: foreground,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
