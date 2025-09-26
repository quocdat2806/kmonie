import 'package:flutter/material.dart';
import 'package:kmonie/generated/assets.dart';

import '../../entity/category/category.dart';

class CategoryConstants {
  CategoryConstants._();

  static const List<Category>  listExpense = [
    Category(id: 1, title: 'Mua sắm', pathAsset:Assets.svgsShopping),
    Category(id: 2, title: 'Đồ ăn', pathAsset:Assets.svgsChickend),
    Category(id: 3, title: 'Điện thoại', pathAsset:Assets.svgsTelephone),
    Category(id: 4, title: 'Giải trí', pathAsset:Assets.svgsEntertainment),
    Category(id: 5, title: 'Giáo dục', pathAsset:Assets.svgsEducation),
    Category(id: 6, title: 'Sắc đẹp', pathAsset:Assets.svgsBeauty),
    Category(id: 7, title: 'Thể thao', pathAsset:Assets.svgsSports),
    Category(id: 8, title: 'Xã hội', pathAsset:Assets.svgsSocial),
    Category(id: 9, title: 'Vận tải', pathAsset:Assets.svgsBus),
    Category(id: 10, title: 'Quần áo', pathAsset:Assets.svgsClothes),
    Category(id: 11, title: 'Xe hơi', pathAsset:Assets.svgsCar),
    Category(id: 12, title: 'Rượu', pathAsset:Assets.svgsAlcohol),
    Category(id: 13, title: 'Thuốc lá', pathAsset:Assets.svgsCigarettes),
    Category(id: 14, title: 'Thiết bị điện tử', pathAsset:Assets.svgsElectronics),
    Category(id: 15, title: 'Du lịch', pathAsset:Assets.svgsTravel),
    Category(id: 16, title: 'Sức khỏe', pathAsset:Assets.svgsHealth),
    Category(id: 17, title: 'Thú cưng', pathAsset:Assets.svgsPets),
    Category(id: 18, title: 'Sửa chữa', pathAsset:Assets.vsvsRepair),
    Category(id: 19, title: 'Nhà ở', pathAsset:Assets.svgsHousing),
    Category(id: 20, title: 'Quaftặng', pathAsset:Assets.svgsGifts),
    Category(id: 21, title: 'Quyên góp', pathAsset:Assets.svgsDonation),
    Category(id: 22, title: 'Vé số', pathAsset:Assets.svgsLottery),
    Category(id: 23, title: 'Đồ ăn nhẹ', pathAsset:Assets.svgsSnacks),
    Category(id: 24, title: 'Trẻ em', pathAsset:Assets.svgsChildren),
    Category(id: 25, title: 'Rau quả', pathAsset:Assets.svgsVegetables),
    Category(id: 26, title: 'Hoa quả', pathAsset:Assets.svgsFruits),
    Category(id: 27, title: 'Khac', pathAsset:Assets.sv)

  ];



  // static const Map<String, Map<String, dynamic>> expenseCategories = {
  //   'shopping': {'name': 'Mua sắm', 'icon': Icons.shopping_cart},
  //   'food': {'name': 'Đồ ăn', 'icon': Icons.restaurant},
  //   'phone': {'name': 'Điện thoại', 'icon': Icons.phone_android},
  //   'entertainment': {'name': 'Giải trí', 'icon': Icons.mic},
  //   'education': {'name': 'Giáo dục', 'icon': Icons.school},
  //   'beauty': {'name': 'Sắc đẹp', 'icon': Icons.face},
  //   'sports': {'name': 'Thể thao', 'icon': Icons.pool},
  //   'social': {'name': 'Xã hội', 'icon': Icons.people},
  //   'transport': {'name': 'Vận tải', 'icon': Icons.directions_bus},
  //   'clothes': {'name': 'Quần áo', 'icon': Icons.checkroom},
  //   'car': {'name': 'Xe hơi', 'icon': Icons.directions_car},
  //   'alcohol': {'name': 'Rượu', 'icon': Icons.local_bar},
  //   'cigarettes': {'name': 'Thuốc lá', 'icon': Icons.smoking_rooms},
  //   'electronics': {'name': 'Thiết bị điện tử', 'icon': Icons.headphones},
  //   'travel': {'name': 'Du lịch', 'icon': Icons.flight},
  //   'health': {'name': 'Sức khỏe', 'icon': Icons.medical_services},
  //   'pets': {'name': 'Thú cưng', 'icon': Icons.pets},
  //   'repair': {'name': 'Sửa chữa', 'icon': Icons.build},
  //   'housing': {'name': 'Nhà ở', 'icon': Icons.home_repair_service},
  //   'home': {'name': 'Nhà', 'icon': Icons.home},
  //   'gifts': {'name': 'Quà tặng', 'icon': Icons.card_giftcard},
  //   'donation': {'name': 'Quyên góp', 'icon': Icons.favorite},
  //   'lottery': {'name': 'Vé số', 'icon': Icons.casino},
  //   'snacks': {'name': 'Đồ ăn nhẹ', 'icon': Icons.cake},
  //   'children': {'name': 'Trẻ em', 'icon': Icons.child_care},
  //   'vegetables': {'name': 'Rau quả', 'icon': Icons.eco},
  //   'fruits': {'name': 'Hoa quả', 'icon': Icons.apple},
  //   'settings': {'name': 'Cài đặt', 'icon': Icons.add},
  // };

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
