import 'package:flutter/material.dart';

/// نموذج تصنيف ثابت (Food & Drink, Salary...الخ).
/// الاسم المعروض يأتي من AppStrings حسب اللغة الحالية عبر [key].
class CategoryModel {
  final String key; // معرف داخلي يُخزن بقاعدة البيانات
  final String emoji; // الأيقونة
  final Color color; // لون ثابت للفئة: الرسوم البيانية وخلفية الأيقونة

  const CategoryModel({
    required this.key,
    required this.emoji,
    required this.color,
  });
}
