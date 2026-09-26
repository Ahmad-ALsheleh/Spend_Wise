import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../utils/app_colors.dart';
import 'transaction_tile.dart';

/// نسخة من TransactionTile قابلة للسحب لليسار لإظهار زر حذف (سلة قمامة)،
/// تُستخدم حصريًا بشاشة History.
class SwipeableTransactionCard extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback onDelete;

  const SwipeableTransactionCard({
    super.key,
    required this.transaction,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(transaction.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) => onDelete(),
      background: Container(),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 4),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.deleteBackground,
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.delete_outline,
              color: AppColors.deleteIcon, size: 22),
        ),
      ),
      child: TransactionTile(transaction: transaction),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف المعاملة؟'),
        content: const Text('لا يمكن التراجع عن هذا الإجراء.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}