import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_colors.dart';

/// حقل إدخال المبلغ الكبير بمنتصف شاشة New Entry، مع سهم علوي/سفلي
/// لزيادة أو إنقاص المبلغ بمقدار 1.
class AmountInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const AmountInput({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  double get _current => double.tryParse(controller.text) ?? 0;

  void _step(double delta) {
    final next = (_current + delta).clamp(0, double.infinity);
    final text = next == next.roundToDouble()
        ? next.toStringAsFixed(0)
        : next.toString();
    controller.text = text;
    controller.selection = TextSelection.collapsed(offset: text.length);
    onChanged(text);
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = _current > 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          r'$',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 10),
        IntrinsicWidth(
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: hasValue ? AppColors.textPrimary : AppColors.textMuted,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: '0.00',
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => _step(1),
              child: const Icon(Icons.keyboard_arrow_up,
                  color: AppColors.textMuted, size: 22),
            ),
            InkWell(
              onTap: () => _step(-1),
              child: const Icon(Icons.keyboard_arrow_down,
                  color: AppColors.textMuted, size: 22),
            ),
          ],
        ),
      ],
    );
  }
}