import 'currency.dart';

/// نوع المعاملة
class TransactionType {
  static const String expense = 'expense';
  static const String income = 'income';
}

/// نموذج معاملة مالية واحدة (مصروف أو دخل) — يُخزّن مباشرة بجدول SQLite.
class TransactionModel {
  final int? id;
  final String title; // النص المدخل بحقل NOTE
  final double amount;
  final String categoryKey; // مفتاح التصنيف (يُطابق CategoryModel.key)
  final String type; // expense | income
  final DateTime date;
  final Currency currency; // كل معاملة بعملتها (دولار أو ليرة)

  const TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.categoryKey,
    required this.type,
    required this.date,
    this.currency = Currency.usd,
  });

  bool get isIncome => type == TransactionType.income;
  bool get isExpense => type == TransactionType.expense;

  /// لتخزينها بقاعدة بيانات SQLite
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'amount': amount,
      'category_key': categoryKey,
      'type': type,
      'date': date.toIso8601String(),
      'currency': currency.code,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      categoryKey: map['category_key'] as String,
      type: map['type'] as String,
      date: DateTime.parse(map['date'] as String),
      currency: Currency.fromCode(map['currency'] as String?),
    );
  }

  TransactionModel copyWith({
    int? id,
    String? title,
    double? amount,
    String? categoryKey,
    String? type,
    DateTime? date,
    Currency? currency,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      categoryKey: categoryKey ?? this.categoryKey,
      type: type ?? this.type,
      date: date ?? this.date,
      currency: currency ?? this.currency,
    );
  }
}
