import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';

/// حقل عرض التاريخ المختار، يفتح لوحة تقويم لا تسمح بالتواريخ المستقبلية.
class DateField extends StatelessWidget {
  final DateTime date;
  final ValueChanged<DateTime> onDateSelected;

  const DateField({
    super.key,
    required this.date,
    required this.onDateSelected,
  });

  Future<void> _openPicker(BuildContext context) async {
    final result = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _CalendarPickerSheet(initialDate: date),
    );
    if (result != null) onDateSelected(result);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return GestureDetector(
      onTap: () => _openPicker(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: colors.fieldFill,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.of(context).dateField(date),
              style: TextStyle(
                fontSize: 15,
                color: colors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: colors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarPickerSheet extends StatefulWidget {
  final DateTime initialDate;

  const _CalendarPickerSheet({required this.initialDate});

  @override
  State<_CalendarPickerSheet> createState() => _CalendarPickerSheetState();
}

class _CalendarPickerSheetState extends State<_CalendarPickerSheet> {
  /// أعمدة التقويم من الأحد إلى السبت (قيم DateTime.weekday) كما في التصميم.
  static const List<int> _sundayFirst = [7, 1, 2, 3, 4, 5, 6];

  late DateTime _visibleMonth = DateTime(
    widget.initialDate.year,
    widget.initialDate.month,
  );
  late DateTime? _selected = widget.initialDate;

  static DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// لا أشهر بعد الشهر الحالي.
  bool get _canGoNext =>
      _visibleMonth.isBefore(DateTime(_today.year, _today.month));

  void _changeMonth(int delta) {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + delta);
    });
  }

  bool _isSelected(DateTime day) {
    final selected = _selected;
    return selected != null &&
        selected.year == day.year &&
        selected.month == day.month &&
        selected.day == day.day;
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final strings = AppStrings.of(context);
    final today = _today;
    final daysInMonth =
        DateTime(_visibleMonth.year, _visibleMonth.month + 1, 0).day;
    // الأحد = 0 حتى يطابق ترتيب الأعمدة
    final leadingEmpty =
        DateTime(_visibleMonth.year, _visibleMonth.month, 1).weekday % 7;
    final rows = ((leadingEmpty + daysInMonth) / 7).ceil();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.divider,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => _changeMonth(-1),
                  tooltip: strings.previousPeriod,
                  icon: Icon(Icons.chevron_left, color: colors.textPrimary),
                ),
                Text(
                  strings.monthYear(_visibleMonth),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
                IconButton(
                  onPressed: _canGoNext ? () => _changeMonth(1) : null,
                  tooltip: strings.nextPeriod,
                  icon: Icon(
                    Icons.chevron_right,
                    color:
                        _canGoNext ? colors.textPrimary : colors.textDisabled,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                for (var column = 0; column < 7; column++)
                  Expanded(
                    child: Center(
                      child: Text(
                        strings.weekdaysShort[_sundayFirst[column] - 1],
                        style: TextStyle(
                          fontSize: 12,
                          color: column == 0 || column == 6
                              ? colors.weekend
                              : colors.textSecondary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            for (var row = 0; row < rows; row++)
              Row(
                children: List.generate(7, (column) {
                  final dayNumber = row * 7 + column - leadingEmpty + 1;
                  final isValid = dayNumber >= 1 && dayNumber <= daysInMonth;
                  final day = DateTime(
                    _visibleMonth.year,
                    _visibleMonth.month,
                    dayNumber,
                  );
                  return Expanded(
                    child: _DayCell(
                      label: isValid ? '$dayNumber' : '',
                      enabled: isValid && !day.isAfter(today),
                      selected: isValid && _isSelected(day),
                      weekend: column == 0 || column == 6,
                      onTap: () => setState(() => _selected = day),
                    ),
                  );
                }),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                OutlinedButton(
                  onPressed: () => setState(() => _selected = null),
                  child: Text(strings.clear),
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                  ),
                  onPressed: () =>
                      Navigator.pop(context, _selected ?? widget.initialDate),
                  child: Text(strings.done),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// خانة يوم واحد بالتقويم. الأيام المستقبلية باهتة ولا تستجيب للضغط.
class _DayCell extends StatelessWidget {
  final String label;
  final bool enabled;
  final bool selected;
  final bool weekend;
  final VoidCallback onTap;

  const _DayCell({
    required this.label,
    required this.enabled,
    required this.selected,
    required this.weekend,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final Color textColor;
    if (selected) {
      textColor = colors.onPrimary;
    } else if (!enabled) {
      textColor = colors.textDisabled;
    } else if (weekend) {
      textColor = colors.weekend;
    } else {
      textColor = colors.textPrimary;
    }
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? colors.primary : null,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
