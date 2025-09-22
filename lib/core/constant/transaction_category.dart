import 'package:flutter/material.dart';

class TransactionCategoryConstants {
  TransactionCategoryConstants._();

  static const Map<String, Map<String, dynamic>> expenseCategories = {
    'shopping': {'name': 'Mua sắm', 'icon': Icons.shopping_cart},
    'food': {'name': 'Đồ ăn', 'icon': Icons.restaurant},
    'phone': {'name': 'Điện thoại', 'icon': Icons.phone_android},
    'entertainment': {'name': 'Giải trí', 'icon': Icons.mic},
    'education': {'name': 'Giáo dục', 'icon': Icons.school},
    'beauty': {'name': 'Sắc đẹp', 'icon': Icons.face},
    'sports': {'name': 'Thể thao', 'icon': Icons.pool},
    'social': {'name': 'Xã hội', 'icon': Icons.people},
    'transport': {'name': 'Vận tải', 'icon': Icons.directions_bus},
    'clothes': {'name': 'Quần áo', 'icon': Icons.checkroom},
    'car': {'name': 'Xe hơi', 'icon': Icons.directions_car},
    'alcohol': {'name': 'Rượu', 'icon': Icons.local_bar},
    'cigarettes': {'name': 'Thuốc lá', 'icon': Icons.smoking_rooms},
    'electronics': {'name': 'Thiết bị điện tử', 'icon': Icons.headphones},
    'travel': {'name': 'Du lịch', 'icon': Icons.flight},
    'health': {'name': 'Sức khỏe', 'icon': Icons.medical_services},
    'pets': {'name': 'Thú cưng', 'icon': Icons.pets},
    'repair': {'name': 'Sửa chữa', 'icon': Icons.build},
    'housing': {'name': 'Nhà ở', 'icon': Icons.home_repair_service},
    'home': {'name': 'Nhà', 'icon': Icons.home},
    'gifts': {'name': 'Quà tặng', 'icon': Icons.card_giftcard},
    'donation': {'name': 'Quyên góp', 'icon': Icons.favorite},
    'lottery': {'name': 'Vé số', 'icon': Icons.casino},
    'snacks': {'name': 'Đồ ăn nhẹ', 'icon': Icons.cake},
    'children': {'name': 'Trẻ em', 'icon': Icons.child_care},
    'vegetables': {'name': 'Rau quả', 'icon': Icons.eco},
    'fruits': {'name': 'Hoa quả', 'icon': Icons.apple},
    'settings': {'name': 'Cài đặt', 'icon': Icons.add},
  };

  static const Map<String, Map<String, dynamic>> incomeCategories = {
    'salary': {'name': 'Lương', 'icon': Icons.credit_card},
    'investment': {
      'name': 'Khoản đầu tư',
      'icon': Icons.account_balance_wallet,
    },
    'part_time': {'name': 'Bán thời gian', 'icon': Icons.access_time},
    'award': {'name': 'Giải thưởng', 'icon': Icons.emoji_events},
    'other': {'name': 'Khác', 'icon': Icons.attach_money},
    'settings': {'name': 'Cài đặt', 'icon': Icons.add},
  };

  static const Map<String, Map<String, dynamic>> transferCategories = {
    'bank_account': {
      'name': 'Tài khoản ngân hàng',
      'icon': Icons.account_balance,
    },
    'e_wallet': {'name': 'Ví điện tử', 'icon': Icons.account_balance_wallet},
    'person_to_person': {'name': 'Chuyển cho người khác', 'icon': Icons.people},
    'savings': {'name': 'Tiết kiệm', 'icon': Icons.savings},
    'other': {'name': 'Khác', 'icon': Icons.attach_money},
    'settings': {'name': 'Cài đặt', 'icon': Icons.add},
  };
}
