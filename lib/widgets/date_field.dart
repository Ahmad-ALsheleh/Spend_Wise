import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/formatters.dart';

/// حقل عرض التاريخ المختار، يفتح نافذة تقويم مخصصة (calendar_picker_sheet).
class DateField extends StatelessWidget {
  final DateTime date;
  final ValueChanged<DateTime> onDateSelected;

  const DateField({
    super.key,
    required this.date,
    required this.onDateSelected,
  });

  Future<void> _openPicker(BuildContext context) async {
    final result = await showModalBottomSheet<DateTime?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _CalendarPickerSheet(initialDate: date),
    );
    if (result != null) onDateSelected(result);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openPicker(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.fieldBackground,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              Formatters.dateSlashed(date),
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Icon(Icons.calendar_today_outlined,
                size: 18, color: AppColors.textMuted),
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
  late DateTime _visibleMonth;
  DateTime? _selected;

  @override
  void initState() {
    super.initState();
    _visibleMonth = DateTime(widget.initialDate.year, widget.initialDate.month);
    _selected = widget.initialDate;
  }

  void _changeMonth(int delta) {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + delta);
    });
  }

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(_visibleMonth.year, _visibleMonth.month, 1);
    final daysInMonth =
        DateTime(_visibleMonth.year, _visibleMonth.month + 1, 0).day;
    // Sunday = 0 حتى يطابق ترويسة الأعمدة Sun..Sat
    final leadingEmpty = firstDayOfMonth.weekday % 7;

    final totalCells = leadingEmpty + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => _changeMonth(-1),
                  icon: const Icon(Icons.chevron_left),
                ),
                Text(
                  Formatters.monthYear(_visibleMonth),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                IconButton(
                  onPressed: () => _changeMonth(1),
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                  .map((d) => Expanded(
                child: Center(
                  child: Text(
                    d,
                    style: TextStyle(
                      fontSize: 12,
                      color: (d == 'Sun' || d == 'Sat')
                          ? Colors.redAccent
                          : AppColors.textMuted,
                    ),
                  ),
                ),
              ))
                  .toList(),
            ),
            const SizedBox(height: 4),
            for (int r = 0; r < rows; r++)
              Row(
                children: List.generate(7, (c) {
                  final cellIndex = r * 7 + c;
                  final dayNum = cellIndex - leadingEmpty + 1;
                  final isValid = dayNum >= 1 && dayNum <= daysInMonth;
                  final cellDate = isValid
                      ? DateTime(_visibleMonth.year, _visibleMonth.month, dayNum)
                      : null;
                  final isSelected = isValid &&
                      _selected != null &&
                      cellDate!.year == _selected!.year &&
                      cellDate.month == _selected!.month &&
                      cellDate.day == _selected!.day;
                  final isWeekend = c == 0 || c == 6;

                  return Expanded(
                    child: GestureDetector(
                      onTap: isValid
                          ? () => setState(() => _selected = cellDate)
                          : null,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 3),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : null,
                          border: isSelected
                              ? Border.all(color: AppColors.primary)
                              : null,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          isValid ? '$dayNum' : '',
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : isWeekend
                                ? Colors.redAccent
                                : AppColors.textPrimary,
                            fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                OutlinedButton(
                  onPressed: () => setState(() => _selected = null),
                  child: const Text('Clear'),
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () =>
                      Navigator.pop(context, _selected ?? widget.initialDate),
                  child: const Text('Done'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}