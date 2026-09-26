import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../utils/category_data.dart';
import '../utils/app_colors.dart';
import '../utils/formatters.dart';

/// صف معاملة واحدة: أيقونة التصنيف + العنوان + التصنيف + المبلغ الملون.
/// Widget عرض فقط، لا يحتوي أي منطق حذف أو تعديل (ذلك من مسؤولية
/// الشاشة الحاوية عبر onTap/onLongPress إن احتجنا لاحقًا).
class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final category = CategoryData.findByKey(transaction.categoryKey);
    final isIncome = transaction.isIncome;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: category.color,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(category.emoji, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title.isEmpty ? category.label : transaction.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  category.label,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Text(
            Formatters.signedCurrency(transaction.amount, transaction.type),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: isIncome ? AppColors.income : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}