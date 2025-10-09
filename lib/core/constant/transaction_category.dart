import '../../entity/export.dart';
import '../../generated/export.dart';
import '../constant/export.dart';
import '../enum/export.dart';

class TransactionCategoryConstants {
  TransactionCategoryConstants._();

  static const List<TransactionCategory> transactionCategorySystem = [
    TransactionCategory(title: TextConstants.shopping, pathAsset: Assets.svgsShopping),
    TransactionCategory(title: TextConstants.food, pathAsset: Assets.svgsChicken),
    TransactionCategory(title: TextConstants.telephone, pathAsset: Assets.svgsTelephone),
    TransactionCategory(title: TextConstants.entertainment, pathAsset: Assets.svgsMicro),
    TransactionCategory(title: TextConstants.education, pathAsset: Assets.svgsBook),
    TransactionCategory(title: TextConstants.beauty, pathAsset: Assets.svgsBeautiful),
    TransactionCategory(title: TextConstants.sport, pathAsset: Assets.svgsSwimming),
    TransactionCategory(title: TextConstants.social, pathAsset: Assets.svgsGroup),
    TransactionCategory(title: TextConstants.transport, pathAsset: Assets.svgsBus),
    TransactionCategory(title: TextConstants.clothes, pathAsset: Assets.svgsShirt),
    TransactionCategory(title: TextConstants.car, pathAsset: Assets.svgsCar),
    TransactionCategory(title: TextConstants.alcohol, pathAsset: Assets.svgsGlass),
    TransactionCategory(title: TextConstants.cigarettes, pathAsset: Assets.svgsCigarettes),
    TransactionCategory(title: TextConstants.electronic, pathAsset: Assets.svgsElectronicTech),
    TransactionCategory(title: TextConstants.travel, pathAsset: Assets.svgsAirPlain),
    TransactionCategory(title: TextConstants.health, pathAsset: Assets.svgsHospital),
    TransactionCategory(title: TextConstants.pet, pathAsset: Assets.svgsPet),
    TransactionCategory(title: TextConstants.repair, pathAsset: Assets.svgsRepair),
    TransactionCategory(title: TextConstants.house, pathAsset: Assets.svgsPaint),
    TransactionCategory(title: TextConstants.house, pathAsset: Assets.svgsWardrobe),
    TransactionCategory(title: TextConstants.gift, pathAsset: Assets.svgsGift),
    TransactionCategory(title: TextConstants.donate, pathAsset: Assets.svgsHeart),
    TransactionCategory(title: TextConstants.lottery, pathAsset: Assets.svgsBilliard),
    TransactionCategory(title: TextConstants.snack, pathAsset: Assets.svgsFastFood),
    TransactionCategory(title: TextConstants.children, pathAsset: Assets.svgsAngel),
    TransactionCategory(title: TextConstants.vegetable, pathAsset: Assets.svgsCarrot),
    TransactionCategory(title: TextConstants.fruit, pathAsset: Assets.svgsGrape),
    TransactionCategory(title: TextConstants.setting, pathAsset: Assets.svgsPlus, isCreateNewCategory: true),
    TransactionCategory(title: TextConstants.salary, pathAsset: Assets.svgsCreditCard, transactionType: TransactionType.income),
    TransactionCategory(title: TextConstants.bonus, pathAsset: Assets.svgsInvest, transactionType: TransactionType.income),
    TransactionCategory(title: TextConstants.interest, pathAsset: Assets.svgsInterest, transactionType: TransactionType.income),
    TransactionCategory(title: TextConstants.gift, pathAsset: Assets.svgsAward, transactionType: TransactionType.income),
    TransactionCategory(title: TextConstants.other, pathAsset: Assets.svgsCommand, transactionType: TransactionType.income),
    TransactionCategory(title: TextConstants.setting, pathAsset: Assets.svgsPlus, transactionType: TransactionType.income, isCreateNewCategory: true),
  ];
}
