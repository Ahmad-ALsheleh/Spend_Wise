import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/currency.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/formatters.dart';
import '../utils/latin_digits_formatter.dart';

/// حقل إدخال المبلغ الكبير بمنتصف شاشة New Entry، مع سهم علوي/سفلي.
/// رمز العملة بجانبه يتبع العملة المختارة ($ أو SYP / ل.س).
class AmountInput extends StatelessWidget {
  final TextEditingController controller;
  final Currency currency;
  final ValueChanged<String> onChanged;

  const AmountInput({
    super.key,
    required this.controller,
    required this.currency,
    required this.onChanged,
  });

  double get _current => double.tryParse(controller.text) ?? 0;

  /// خطوة السهمين: دولار واحد، أو 100 ليرة.
  int get _stepUnits => currency == Currency.syp ? 100 : 1;

  /// الحساب بالسنتات حتى لا تظهر كسور مثل 8.129999999.
  void _step(int direction) {
    final cents =
        math.max(0, (_current * 100).round() + direction * _stepUnits * 100);
    final text =
        cents % 100 == 0 ? '${cents ~/ 100}' : (cents / 100).toStringAsFixed(2);
    controller.text = text;
    controller.selection = TextSelection.collapsed(offset: text.length);
    onChanged(text);
  }

  /// مبالغ الليرة قد تكون بالملايين: الخط يصغر حتى يبقى الحقل بسطر واحد.
  double get _fontSize {
    final length = controller.text.length;
    if (length > 9) return 34;
    if (length > 7) return 40;
    return 48;
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final symbol = AppStrings.of(context).currencySymbol(currency);
    final hasValue = _current > 0;
    // المبلغ رقم لاتيني: يبقى "$ 0.00" بنفس الترتيب في اللغتين.
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            symbol,
            style: TextStyle(
              fontSize: symbol.length > 1 ? 24 : 34,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(width: 10),
          IntrinsicWidth(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                const LatinDigitsFormatter(),
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: _fontSize,
                fontWeight: FontWeight.bold,
                color: hasValue ? colors.textPrimary : colors.textDisabled,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: Formatters.amountHint(currency),
                hintStyle: TextStyle(color: colors.textDisabled),
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
                child: Icon(
                  Icons.keyboard_arrow_up,
                  color: colors.textMuted,
                  size: 22,
                ),
              ),
              InkWell(
                onTap: () => _step(-1),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: colors.textMuted,
                  size: 22,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
