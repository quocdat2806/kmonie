import 'package:flutter/material.dart';
import 'package:kmonie/core/constants/color_constants.dart';

class TransactionCategoryConstants {
  TransactionCategoryConstants._();

  static const Map<String, Map<String, dynamic>> expenseCategories = {
    'shopping': {
      'name': 'Mua sắm',
      'icon': Icons.shopping_cart,
      'color': AppColors.blue,
    },
    'food': {
      'name': 'Đồ ăn',
      'icon': Icons.restaurant,
      'color': AppColors.green,
    },
    'phone': {
      'name': 'Điện thoại',
      'icon': Icons.phone_android,
      'color': AppColors.secondary,
    },
    'entertainment': {
      'name': 'Giải trí',
      'icon': Icons.mic,
      'color': AppColors.pink,
    },
    'education': {
      'name': 'Giáo dục',
      'icon': Icons.school,
      'color': AppColors.primary,
    },
    'beauty': {'name': 'Sắc đẹp', 'icon': Icons.face, 'color': AppColors.red},
    'sports': {'name': 'Thể thao', 'icon': Icons.pool, 'color': AppColors.teal},
    'social': {
      'name': 'Xã hội',
      'icon': Icons.people,
      'color': AppColors.orange,
    },
    'transport': {
      'name': 'Vận tải',
      'icon': Icons.directions_bus,
      'color': AppColors.grey,
    },
    'clothes': {
      'name': 'Quần áo',
      'icon': Icons.checkroom,
      'color': AppColors.purple,
    },
    'car': {
      'name': 'Xe hơi',
      'icon': Icons.directions_car,
      'color': AppColors.black,
    },
    'alcohol': {
      'name': 'Rượu',
      'icon': Icons.local_bar,
      'color': AppColors.brown,
    },
    'cigarettes': {
      'name': 'Thuốc lá',
      'icon': Icons.smoking_rooms,
      'color': AppColors.grey,
    },
    'electronics': {
      'name': 'Thiết bị điện tử',
      'icon': Icons.headphones,
      'color': AppColors.blue,
    },
    'travel': {
      'name': 'Du lịch',
      'icon': Icons.flight,
      'color': AppColors.cyan,
    },
    'health': {
      'name': 'Sức khỏe',
      'icon': Icons.medical_services,
      'color': AppColors.red,
    },
    'pets': {'name': 'Thú cưng', 'icon': Icons.pets, 'color': AppColors.orange},
    'repair': {
      'name': 'Sửa chữa',
      'icon': Icons.build,
      'color': AppColors.grey,
    },
    'housing': {
      'name': 'Nhà ở',
      'icon': Icons.home_repair_service,
      'color': AppColors.brown,
    },
    'home': {'name': 'Nhà', 'icon': Icons.home, 'color': AppColors.blue},
    'gifts': {
      'name': 'Quà tặng',
      'icon': Icons.card_giftcard,
      'color': AppColors.pink,
    },
    'donation': {
      'name': 'Quyên góp',
      'icon': Icons.favorite,
      'color': AppColors.red,
    },
    'lottery': {
      'name': 'Vé số',
      'icon': Icons.casino,
      'color': AppColors.green,
    },
    'snacks': {
      'name': 'Đồ ăn nhẹ',
      'icon': Icons.cake,
      'color': AppColors.orange,
    },
    'children': {
      'name': 'Trẻ em',
      'icon': Icons.child_care,
      'color': AppColors.pink,
    },
    'vegetables': {
      'name': 'Rau quả',
      'icon': Icons.eco,
      'color': AppColors.green,
    },
    'fruits': {
      'name': 'Hoa quả',
      'icon': Icons.apple,
      'color': AppColors.orange,
    },
    'settings': {'name': 'Cài đặt', 'icon': Icons.add, 'color': AppColors.grey},
  };

  static const Map<String, Map<String, dynamic>> incomeCategories = {
    'salary': {
      'name': 'Lương',
      'icon': Icons.credit_card,
      'color': AppColors.green,
    },
    'investment': {
      'name': 'Khoản đầu tư',
      'icon': Icons.account_balance_wallet,
      'color': AppColors.blue,
    },
    'part_time': {
      'name': 'Bán thời gian',
      'icon': Icons.access_time,
      'color': AppColors.orange,
    },
    'award': {
      'name': 'Giải thưởng',
      'icon': Icons.emoji_events,
      'color': AppColors.yellow,
    },
    'other': {
      'name': 'Khác',
      'icon': Icons.attach_money,
      'color': AppColors.grey,
    },
    'settings': {'name': 'Cài đặt', 'icon': Icons.add, 'color': AppColors.grey},
  };

  static const Map<String, Map<String, dynamic>> transferCategories = {
    'bank_account': {
      'name': 'Tài khoản ngân hàng',
      'icon': Icons.account_balance,
      'color': AppColors.blue,
    },
    'e_wallet': {
      'name': 'Ví điện tử',
      'icon': Icons.account_balance_wallet,
      'color': AppColors.green,
    },
    'person_to_person': {
      'name': 'Chuyển cho người khác',
      'icon': Icons.people,
      'color': AppColors.orange,
    },
    'savings': {
      'name': 'Tiết kiệm',
      'icon': Icons.savings,
      'color': AppColors.purple,
    },
    'other': {
      'name': 'Khác',
      'icon': Icons.attach_money,
      'color': AppColors.grey,
    },
    'settings': {'name': 'Cài đặt', 'icon': Icons.add, 'color': AppColors.grey},
  };
}
