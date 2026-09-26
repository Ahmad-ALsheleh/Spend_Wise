import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../utils/app_colors.dart';

/// مفتاح Expense / Income أعلى شاشة New Entry.
class TypeToggle extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onChanged;

  const TypeToggle({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.toggleBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ToggleOption(
              label: 'Expense',
              icon: Icons.arrow_downward_rounded,
              selected: selectedType == TransactionType.expense,
              onTap: () => onChanged(TransactionType.expense),
            ),
          ),
          Expanded(
            child: _ToggleOption(
              label: 'Income',
              icon: Icons.arrow_upward_rounded,
              selected: selectedType == TransactionType.income,
              onTap: () => onChanged(TransactionType.income),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: selected
              ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected ? AppColors.textPrimary : AppColors.textMuted,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.textPrimary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}