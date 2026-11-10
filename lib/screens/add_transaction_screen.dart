import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/transaction_model.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/category_data.dart';
import '../widgets/amount_input.dart';
import '../widgets/category_selector_grid.dart';
import '../widgets/date_field.dart';
import '../widgets/section_label.dart';
import '../widgets/segmented_toggle.dart';

/// شاشة "New Entry" لإضافة معاملة جديدة (مصروف أو دخل).
/// عند الحفظ تُعيد true لتُعلم الشاشة المستدعية بضرورة تحديث بياناتها.
class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  String _type = TransactionType.expense;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String? _selectedCategoryKey;
  DateTime _selectedDate = DateTime.now();
  double _amount = 0;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _onTypeChanged(String type) {
    setState(() {
      _type = type;
      _selectedCategoryKey = null; // التصنيفات تختلف بين النوعين
    });
  }

  bool get _canSave => _amount > 0 && _selectedCategoryKey != null;

  Future<void> _save() async {
    if (!_canSave) return;
    final tx = TransactionModel(
      title: _noteController.text.trim(),
      amount: _amount,
      categoryKey: _selectedCategoryKey!,
      type: _type,
      date: _selectedDate,
    );
    await DatabaseHelper.instance.insertTransaction(tx);
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final strings = AppStrings.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    tooltip:
                        MaterialLocalizations.of(context).backButtonTooltip,
                    // chevron_left ينعكس تلقائياً بالعربية.
                    icon: Icon(
                      Icons.chevron_left,
                      color: colors.textPrimary,
                      size: 28,
                    ),
                  ),
                  Text(
                    strings.newEntry,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 20),
                children: [
                  SegmentedToggle<String>(
                    options: [
                      SegmentedToggleOption(
                        value: TransactionType.expense,
                        label: strings.expenseType,
                        icon: Icons.arrow_downward_rounded,
                      ),
                      SegmentedToggleOption(
                        value: TransactionType.income,
                        label: strings.incomeType,
                        icon: Icons.arrow_upward_rounded,
                      ),
                    ],
                    selected: _type,
                    onChanged: _onTypeChanged,
                  ),
                  const SizedBox(height: 28),
                  AmountInput(
                    controller: _amountController,
                    onChanged: (v) {
                      setState(() => _amount = double.tryParse(v) ?? 0);
                    },
                  ),
                  const SizedBox(height: 28),
                  SectionLabel(strings.categoryLabel),
                  const SizedBox(height: 10),
                  CategorySelectorGrid(
                    categories: CategoryData.byType(_type),
                    selectedKey: _selectedCategoryKey,
                    onSelect: (key) =>
                        setState(() => _selectedCategoryKey = key),
                  ),
                  const SizedBox(height: 24),
                  SectionLabel(strings.noteLabel),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _noteController,
                    style: TextStyle(color: colors.textPrimary),
                    decoration: InputDecoration(
                      hintText: strings.noteHint,
                      hintStyle: TextStyle(color: colors.textMuted),
                      filled: true,
                      fillColor: colors.fieldFill,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SectionLabel(strings.dateLabel),
                  const SizedBox(height: 8),
                  DateField(
                    date: _selectedDate,
                    onDateSelected: (d) => setState(() => _selectedDate = d),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _canSave ? _save : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        disabledBackgroundColor: colors.fieldFill,
                        foregroundColor: colors.onPrimary,
                        disabledForegroundColor: colors.textSecondary,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        strings.saveEntry,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
