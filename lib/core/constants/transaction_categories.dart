import 'package:kmonie/entity/entity.dart';
import 'package:kmonie/generated/export.dart';
import 'constants.dart';
import 'package:kmonie/core/enums/enums.dart';

class TransactionCategoryConstants {
  TransactionCategoryConstants._();

  static const List<TransactionCategory> transactionCategorySystem = [
    TransactionCategory(
      title: AppTextConstants.shopping,
      pathAsset: Assets.svgsShopping,
    ),
    TransactionCategory(
      title: AppTextConstants.food,
      pathAsset: Assets.svgsChicken,
    ),
    TransactionCategory(
      title: AppTextConstants.telephone,
      pathAsset: Assets.svgsTelephone,
    ),
    TransactionCategory(
      title: AppTextConstants.entertainment,
      pathAsset: Assets.svgsMicro,
    ),
    TransactionCategory(
      title: AppTextConstants.education,
      pathAsset: Assets.svgsBook,
    ),
    TransactionCategory(
      title: AppTextConstants.beauty,
      pathAsset: Assets.svgsBeautiful,
    ),
    TransactionCategory(
      title: AppTextConstants.sport,
      pathAsset: Assets.svgsSwimming,
    ),
    TransactionCategory(
      title: AppTextConstants.social,
      pathAsset: Assets.svgsGroup,
    ),
    TransactionCategory(
      title: AppTextConstants.transport,
      pathAsset: Assets.svgsBus,
    ),
    TransactionCategory(
      title: AppTextConstants.clothes,
      pathAsset: Assets.svgsShirt,
    ),
    TransactionCategory(title: AppTextConstants.car, pathAsset: Assets.svgsCar),
    TransactionCategory(
      title: AppTextConstants.alcohol,
      pathAsset: Assets.svgsGlass,
    ),
    TransactionCategory(
      title: AppTextConstants.cigarettes,
      pathAsset: Assets.svgsCigarettes,
    ),
    TransactionCategory(
      title: AppTextConstants.electronic,
      pathAsset: Assets.svgsElectronicTech,
    ),
    TransactionCategory(
      title: AppTextConstants.travel,
      pathAsset: Assets.svgsAirPlain,
    ),
    TransactionCategory(
      title: AppTextConstants.health,
      pathAsset: Assets.svgsHospital,
    ),
    TransactionCategory(title: AppTextConstants.pet, pathAsset: Assets.svgsPet),
    TransactionCategory(
      title: AppTextConstants.repair,
      pathAsset: Assets.svgsRepair,
    ),
    TransactionCategory(
      title: AppTextConstants.house,
      pathAsset: Assets.svgsPaint,
    ),
    TransactionCategory(
      title: AppTextConstants.house,
      pathAsset: Assets.svgsWardrobe,
    ),
    TransactionCategory(
      title: AppTextConstants.gift,
      pathAsset: Assets.svgsGift,
    ),
    TransactionCategory(
      title: AppTextConstants.donate,
      pathAsset: Assets.svgsHeart,
    ),
    TransactionCategory(
      title: AppTextConstants.lottery,
      pathAsset: Assets.svgsBilliard,
    ),
    TransactionCategory(
      title: AppTextConstants.snack,
      pathAsset: Assets.svgsFastFood,
    ),
    TransactionCategory(
      title: AppTextConstants.children,
      pathAsset: Assets.svgsAngel,
    ),
    TransactionCategory(
      title: AppTextConstants.vegetable,
      pathAsset: Assets.svgsCarrot,
    ),
    TransactionCategory(
      title: AppTextConstants.fruit,
      pathAsset: Assets.svgsGrape,
    ),
    TransactionCategory(
      title: AppTextConstants.setting,
      pathAsset: Assets.svgsPlus,
      isCreateNewCategory: true,
    ),
    TransactionCategory(
      title: AppTextConstants.salary,
      pathAsset: Assets.svgsCreditCard,
      transactionType: TransactionType.income,
    ),
    TransactionCategory(
      title: AppTextConstants.bonus,
      pathAsset: Assets.svgsInvest,
      transactionType: TransactionType.income,
    ),
    TransactionCategory(
      title: AppTextConstants.interest,
      pathAsset: Assets.svgsInterest,
      transactionType: TransactionType.income,
    ),
    TransactionCategory(
      title: AppTextConstants.gift,
      pathAsset: Assets.svgsAward,
      transactionType: TransactionType.income,
    ),
    TransactionCategory(
      title: AppTextConstants.other,
      pathAsset: Assets.svgsCommand,
      transactionType: TransactionType.income,
    ),
    TransactionCategory(
      title: AppTextConstants.setting,
      pathAsset: Assets.svgsPlus,
      transactionType: TransactionType.income,
      isCreateNewCategory: true,
    ),
  ];
}
