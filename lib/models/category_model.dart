import 'package:flutter/material.dart';

/// نموذج تصنيف ثابت (Food & Drink, Salary...الخ)
class CategoryModel {
  final String key; // معرف داخلي يُخزن بقاعدة البيانات
  final String label; // الاسم المعروض
  final String emoji; // الأيقونة
  final Color color; // لون خلفية الأيقونة

  const CategoryModel({
    required this.key,
    required this.label,
    required this.emoji,
    required this.color,
  });
}