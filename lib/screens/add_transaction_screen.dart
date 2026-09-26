import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/transaction_model.dart';
import '../utils/app_colors.dart';
import '../utils/category_data.dart';
import '../widgets/type_toggle.dart';
import '../widgets/amount_input.dart';
import '../widgets/category_selector_grid.dart';
import '../widgets/date_field.dart';

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
    final categories = CategoryData.byType(_type);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.chevron_left,
                        color: AppColors.textPrimary, size: 28),
                  ),
                  const Text(
                    'New Entry',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                children: [
                  TypeToggle(selectedType: _type, onChanged: _onTypeChanged),
                  const SizedBox(height: 28),
                  AmountInput(
                    controller: _amountController,
                    onChanged: (v) {
                      setState(() => _amount = double.tryParse(v) ?? 0);
                    },
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'CATEGORY',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.6,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 10),
                  CategorySelectorGrid(
                    categories: categories,
                    selectedKey: _selectedCategoryKey,
                    onSelect: (key) =>
                        setState(() => _selectedCategoryKey = key),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'NOTE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.6,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _noteController,
                    decoration: InputDecoration(
                      hintText: 'Add a note...',
                      filled: true,
                      fillColor: AppColors.fieldBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'DATE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.6,
                      color: AppColors.textMuted,
                    ),
                  ),
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
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor:
                        AppColors.fieldBackground,
                        foregroundColor: Colors.white,
                        disabledForegroundColor: AppColors.textMuted,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Save Entry',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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