import 'package:flutter/material.dart';
import '../models/category_model.dart';

/// كل التصنيفات الثابتة بالتطبيق، مطابقة لشاشة "New Entry".
class CategoryData {
  CategoryData._();

  static const List<CategoryModel> expenseCategories = [
    CategoryModel(
      key: 'food_drink',
      label: 'Food & Drink',
      emoji: '🍔',
      color: Color(0xFFFDE7D9),
    ),
    CategoryModel(
      key: 'transport',
      label: 'Transport',
      emoji: '🚗',
      color: Color(0xFFFCE2E2),
    ),
    CategoryModel(
      key: 'housing',
      label: 'Housing',
      emoji: '🏠',
      color: Color(0xFFE3E9FD),
    ),
    CategoryModel(
      key: 'health',
      label: 'Health',
      emoji: '💊',
      color: Color(0xFFFCE2EC),
    ),
    CategoryModel(
      key: 'fun',
      label: 'Fun',
      emoji: '🎮',
      color: Color(0xFFF1E9FD),
    ),
    CategoryModel(
      key: 'shopping',
      label: 'Shopping',
      emoji: '🛍️',
      color: Color(0xFFE0EEFD),
    ),
    CategoryModel(
      key: 'education',
      label: 'Education',
      emoji: '📚',
      color: Color(0xFFE1F4E7),
    ),
    CategoryModel(
      key: 'travel',
      label: 'Travel',
      emoji: '✈️',
      color: Color(0xFFE2F0FD),
    ),
    CategoryModel(
      key: 'utilities',
      label: 'Utilities',
      emoji: '💡',
      color: Color(0xFFFDF6DA),
    ),
    CategoryModel(
      key: 'other_expense',
      label: 'Other',
      emoji: '📦',
      color: Color(0xFFEFE7DC),
    ),
  ];

  static const List<CategoryModel> incomeCategories = [
    CategoryModel(
      key: 'salary',
      label: 'Salary',
      emoji: '💼',
      color: Color(0xFFF6DCDA),
    ),
    CategoryModel(
      key: 'freelance',
      label: 'Freelance',
      emoji: '💻',
      color: Color(0xFFDCEEFB),
    ),
    CategoryModel(
      key: 'investment',
      label: 'Investment',
      emoji: '📈',
      color: Color(0xFFE4E9FC),
    ),
    CategoryModel(
      key: 'gift',
      label: 'Gift',
      emoji: '🎁',
      color: Color(0xFFFCE4DC),
    ),
    CategoryModel(
      key: 'other_income',
      label: 'Other',
      emoji: '💰',
      color: Color(0xFFFCEFDC),
    ),
  ];

  static List<CategoryModel> byType(String type) =>
      type == 'income' ? incomeCategories : expenseCategories;

  /// إيجاد تصنيف بمفتاحه بغض النظر عن نوعه (يُستخدم بعرض المعاملات)
  static CategoryModel findByKey(String key) {
    final all = [...expenseCategories, ...incomeCategories];
    return all.firstWhere(
          (c) => c.key == key,
      orElse: () => const CategoryModel(
        key: 'other_expense',
        label: 'Other',
        emoji: '📦',
        color: Color(0xFFEFE7DC),
      ),
    );
  }

  /// ألوان مميزة تُستخدم بالرسوم البيانية بشاشة Analytics (دائرة لكل تصنيف)
  static const List<Color> chartPalette = [
    Color(0xFFF6B93B), // برتقالي (Fun بالمثال)
    Color(0xFF38B6A6),
    Color(0xFFEF6C6C),
    Color(0xFF6C8FEF),
    Color(0xFFB06CEF),
    Color(0xFF6CEF9D),
    Color(0xFFEF6CC5),
    Color(0xFFEFD46C),
    Color(0xFF6CD9EF),
    Color(0xFFA9856C),
  ];
}