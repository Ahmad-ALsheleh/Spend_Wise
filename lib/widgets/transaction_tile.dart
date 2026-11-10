import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/category_data.dart';
import '../utils/formatters.dart';

/// صف معاملة واحدة: أيقونة التصنيف + العنوان + التصنيف + المبلغ الملون.
///
/// بشاشة History: الضغط على الصف يمرَّر عبر [onTap]، وعندما يكون
/// [deleteMode] مفعلاً يحل زر سلة حمراء محل المبلغ ويستدعي [onDelete].
/// الصف لا يحذف شيئاً بنفسه؛ القرار للشاشة الحاوية.
class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onTap;
  final bool deleteMode;
  final VoidCallback? onDelete;

  const TransactionTile({
    super.key,
    required this.transaction,
    this.onTap,
    this.deleteMode = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final strings = AppStrings.of(context);
    final category = CategoryData.findByKey(transaction.categoryKey);
    final categoryName = strings.categoryName(category.key);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colors.categoryTint(category.color),
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
                    transaction.title.isEmpty
                        ? categoryName
                        : transaction.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: colors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    categoryName,
                    style: TextStyle(color: colors.textSecondary, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              child: deleteMode
                  ? IconButton(
                      key: const ValueKey('delete'),
                      onPressed: onDelete,
                      tooltip: strings.delete,
                      style: IconButton.styleFrom(
                        backgroundColor: colors.deleteFill,
                        foregroundColor: colors.deleteIcon,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.delete_outline, size: 22),
                    )
                  : Text(
                      Formatters.signedCurrency(
                        transaction.amount,
                        transaction.type,
                      ),
                      key: const ValueKey('amount'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: transaction.isIncome
                            ? colors.primary
                            : colors.textPrimary,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
