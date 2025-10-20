import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/generated/generated.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/core/tools/tools.dart';
import 'app_texts.dart';

class TransactionCategoryConstants {
  TransactionCategoryConstants._();

  static List<TransactionCategory> get transactionCategorySystem {
    final categories = <TransactionCategory>[];

    final expenseCategories = [
      (AppTextConstants.shopping, Assets.svgsShopping),
      (AppTextConstants.food, Assets.svgsChicken),
      (AppTextConstants.telephone, Assets.svgsTelephone),
      (AppTextConstants.entertainment, Assets.svgsMicro),
      (AppTextConstants.education, Assets.svgsBook),
      (AppTextConstants.beauty, Assets.svgsBeautiful),
      (AppTextConstants.sport, Assets.svgsSwimming),
      (AppTextConstants.social, Assets.svgsGroup),
      (AppTextConstants.transport, Assets.svgsBus),
      (AppTextConstants.clothes, Assets.svgsShirt),
      (AppTextConstants.car, Assets.svgsCar),
      (AppTextConstants.alcohol, Assets.svgsGlass),
      (AppTextConstants.cigarettes, Assets.svgsCigarettes),
      (AppTextConstants.electronic, Assets.svgsElectronicTech),
      (AppTextConstants.travel, Assets.svgsAirPlain),
      (AppTextConstants.health, Assets.svgsHospital),
      (AppTextConstants.pet, Assets.svgsPet),
      (AppTextConstants.repair, Assets.svgsRepair),
      (AppTextConstants.house, Assets.svgsPaint),
      (AppTextConstants.wardrobe, Assets.svgsWardrobe),
      (AppTextConstants.gift, Assets.svgsGift),
      (AppTextConstants.donate, Assets.svgsHeart),
      (AppTextConstants.lottery, Assets.svgsBilliard),
      (AppTextConstants.snack, Assets.svgsFastFood),
      (AppTextConstants.children, Assets.svgsAngel),
      (AppTextConstants.vegetable, Assets.svgsCarrot),
      (AppTextConstants.fruit, Assets.svgsGrape),
    ];

    for (int i = 0; i < expenseCategories.length; i++) {
      final (title, asset) = expenseCategories[i];
      categories.add(TransactionCategory(title: title, pathAsset: asset, gradientColors: GradientHelper.generateSmartGradientColors()));
    }

    final incomeCategories = [(AppTextConstants.salary, Assets.svgsCreditCard), (AppTextConstants.bonus, Assets.svgsInvest), (AppTextConstants.interest, Assets.svgsInterest), (AppTextConstants.gift, Assets.svgsAward), (AppTextConstants.other, Assets.svgsCommand)];

    for (int i = 0; i < incomeCategories.length; i++) {
      final (title, asset) = incomeCategories[i];
      categories.add(TransactionCategory(title: title, pathAsset: asset, transactionType: TransactionType.income, gradientColors: GradientHelper.generateSmartGradientColors()));
    }

    return categories;
  }
}
