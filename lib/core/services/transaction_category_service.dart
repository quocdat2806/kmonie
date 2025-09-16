import 'package:kmonie/core/constants/transaction_category_constants.dart';
import 'package:kmonie/core/enums/transaction_type.dart';
import 'package:kmonie/entities/transaction_category.dart';

class TransactionCategoryService {
  TransactionCategoryService._();

  static final Map<TransactionType, List<TransactionCategory>> _categories = {
    TransactionType.expense: _buildCategoriesFromMap(
      TransactionCategoryConstants.expenseCategories,
    ),
    TransactionType.income: _buildCategoriesFromMap(
      TransactionCategoryConstants.incomeCategories,
    ),
    TransactionType.transfer: _buildCategoriesFromMap(
      TransactionCategoryConstants.transferCategories,
    ),
  };

  static List<TransactionCategory> _buildCategoriesFromMap(
    Map<String, Map<String, dynamic>> categoryMap,
  ) {
    return categoryMap.entries.map((entry) {
      final data = entry.value;
      return TransactionCategory(
        id: entry.key,
        title: data['name'] as String,
        // For now, we do not have image URLs. Keep empty or map later.
        image: '',
      );
    }).toList();
  }

  static List<TransactionCategory> getCategories(TransactionType type) {
    return _categories[type] ?? [];
  }

  static TransactionCategory? getCategoryById(TransactionType type, String id) {
    final categories = getCategories(type);
    try {
      return categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }
}
