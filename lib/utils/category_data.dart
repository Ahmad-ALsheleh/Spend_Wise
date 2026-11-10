import '../models/category_model.dart';
import '../models/transaction_model.dart';
import 'app_colors.dart';

/// مفاتيح الفئات كما تُخزن بعمود category_key (لا تُغيَّر أبداً).
class CategoryKeys {
  CategoryKeys._();

  static const String foodDrink = 'food_drink';
  static const String transport = 'transport';
  static const String housing = 'housing';
  static const String health = 'health';
  static const String fun = 'fun';
  static const String shopping = 'shopping';
  static const String education = 'education';
  static const String travel = 'travel';
  static const String utilities = 'utilities';
  static const String otherExpense = 'other_expense';

  static const String salary = 'salary';
  static const String freelance = 'freelance';
  static const String investment = 'investment';
  static const String gift = 'gift';
  static const String otherIncome = 'other_income';
}

/// كل التصنيفات الثابتة بالتطبيق، بنفس ترتيب شاشة "New Entry".
/// أسماؤها المعروضة في AppStrings.categoryName.
class CategoryData {
  CategoryData._();

  static const List<CategoryModel> expenseCategories = [
    CategoryModel(
      key: CategoryKeys.foodDrink,
      emoji: '🍔',
      color: AppColors.categoryFoodDrink,
    ),
    CategoryModel(
      key: CategoryKeys.transport,
      emoji: '🚗',
      color: AppColors.categoryTransport,
    ),
    CategoryModel(
      key: CategoryKeys.housing,
      emoji: '🏠',
      color: AppColors.categoryHousing,
    ),
    CategoryModel(
      key: CategoryKeys.health,
      emoji: '💊',
      color: AppColors.categoryHealth,
    ),
    CategoryModel(
      key: CategoryKeys.fun,
      emoji: '🎮',
      color: AppColors.categoryFun,
    ),
    CategoryModel(
      key: CategoryKeys.shopping,
      emoji: '🛍️',
      color: AppColors.categoryShopping,
    ),
    CategoryModel(
      key: CategoryKeys.education,
      emoji: '📚',
      color: AppColors.categoryEducation,
    ),
    CategoryModel(
      key: CategoryKeys.travel,
      emoji: '✈️',
      color: AppColors.categoryTravel,
    ),
    CategoryModel(
      key: CategoryKeys.utilities,
      emoji: '💡',
      color: AppColors.categoryUtilities,
    ),
    CategoryModel(
      key: CategoryKeys.otherExpense,
      emoji: '📦',
      color: AppColors.categoryOtherExpense,
    ),
  ];

  static const List<CategoryModel> incomeCategories = [
    CategoryModel(
      key: CategoryKeys.salary,
      emoji: '💼',
      color: AppColors.categorySalary,
    ),
    CategoryModel(
      key: CategoryKeys.freelance,
      emoji: '💻',
      color: AppColors.categoryFreelance,
    ),
    CategoryModel(
      key: CategoryKeys.investment,
      emoji: '📈',
      color: AppColors.categoryInvestment,
    ),
    CategoryModel(
      key: CategoryKeys.gift,
      emoji: '🎁',
      color: AppColors.categoryGift,
    ),
    CategoryModel(
      key: CategoryKeys.otherIncome,
      emoji: '💰',
      color: AppColors.categoryOtherIncome,
    ),
  ];

  static List<CategoryModel> byType(String type) =>
      type == TransactionType.income ? incomeCategories : expenseCategories;

  /// إيجاد تصنيف بمفتاحه بغض النظر عن نوعه (يُستخدم بعرض المعاملات).
  static CategoryModel findByKey(String key) {
    for (final category in [...expenseCategories, ...incomeCategories]) {
      if (category.key == key) return category;
    }
    return expenseCategories.last; // Other
  }
}
