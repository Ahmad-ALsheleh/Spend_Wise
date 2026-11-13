import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// خيار واحد داخل [SegmentedToggle]: نص مع أيقونة أو إيموجي اختياريين.
class SegmentedToggleOption<T> {
  final T value;
  final String label;
  final IconData? icon;
  final String? emoji;

  /// ما يقرؤه قارئ الشاشة بدل [label] (مثلاً "دولار" بدل "$").
  final String? semanticLabel;

  const SegmentedToggleOption({
    required this.value,
    required this.label,
    this.icon,
    this.emoji,
    this.semanticLabel,
  });
}

/// ألوان بديلة للمفتاح، مثلاً فوق بطاقة الرصيد الملونة.
class SegmentedToggleColors {
  final Color track;
  final Color thumb;
  final Color selected;
  final Color unselected;

  const SegmentedToggleColors({
    required this.track,
    required this.thumb,
    required this.selected,
    required this.unselected,
  });
}

/// مفتاح اختيار مقسّم: Expense/Income، و Month/Week، والعملة، وخيارات الإعدادات.
/// الخيار المحدد بخلفية فاتحة وظل خفيف كما في التصميم.
class SegmentedToggle<T> extends StatelessWidget {
  final List<SegmentedToggleOption<T>> options;
  final T selected;
  final ValueChanged<T> onChanged;

  /// null = ألوان التطبيق العادية.
  final SegmentedToggleColors? palette;

  /// نسخة مدمجة أقل ارتفاعاً.
  final bool dense;

  const SegmentedToggle({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.palette,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final effectivePalette = palette ??
        SegmentedToggleColors(
          track: colors.toggleTrack,
          thumb: colors.toggleThumb,
          selected: colors.textPrimary,
          unselected: colors.textSecondary,
        );
    return Container(
      padding: EdgeInsets.all(dense ? 3 : 4),
      decoration: BoxDecoration(
        color: effectivePalette.track,
        borderRadius: BorderRadius.circular(dense ? 12 : 16),
      ),
      child: Row(
        children: [
          for (final option in options)
            Expanded(
              child: _Segment(
                option: option,
                selected: option.value == selected,
                palette: effectivePalette,
                dense: dense,
                onTap: () => onChanged(option.value),
              ),
            ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  final SegmentedToggleOption<Object?> option;
  final bool selected;
  final SegmentedToggleColors palette;
  final bool dense;
  final VoidCallback onTap;

  const _Segment({
    required this.option,
    required this.selected,
    required this.palette,
    required this.dense,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? palette.selected : palette.unselected;
    return Semantics(
      button: true,
      selected: selected,
      label: option.semanticLabel,
      excludeSemantics: option.semanticLabel != null,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding:
              EdgeInsets.symmetric(vertical: dense ? 6 : 12, horizontal: 4),
          decoration: BoxDecoration(
            // نفس اللون بشفافية صفر حتى يكون الانتقال تلاشياً نظيفاً.
            color:
                selected ? palette.thumb : palette.thumb.withValues(alpha: 0),
            borderRadius: BorderRadius.circular(dense ? 9 : 12),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.of(context).shadow,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (option.icon != null) ...[
                Icon(option.icon, size: 16, color: foreground),
                const SizedBox(width: 6),
              ],
              if (option.emoji != null) ...[
                Text(option.emoji!, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: Text(
                  option.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: dense ? 13 : 14,
                    fontWeight: dense ? FontWeight.w700 : FontWeight.w600,
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
