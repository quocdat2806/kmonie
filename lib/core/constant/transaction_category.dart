import 'package:kmonie/entity/exports.dart';
import 'package:kmonie/generated/assets.dart';

import '../enum/transaction_type.dart';


class TransactionCategoryConstants {
  TransactionCategoryConstants._();

  static const List<TransactionCategory>  transactionCategorySystem = [
    TransactionCategory( title: 'Mua sắm', pathAsset:Assets.svgsShopping),
    TransactionCategory( title: 'Đồ ăn', pathAsset:Assets.svgsChickend),
    TransactionCategory( title: 'Điện thoại', pathAsset:Assets.svgsTelephone),
    TransactionCategory( title: 'Giải trí', pathAsset:Assets.svgsMicro),
    TransactionCategory( title: 'Giáo dục', pathAsset:Assets.svgsBook),
    TransactionCategory( title: 'Sắc đẹp', pathAsset:Assets.svgsBook),
    TransactionCategory( title: 'Thể thao', pathAsset:Assets.svgsSwimming),
    TransactionCategory( title: 'Xã hội', pathAsset:Assets.svgsGroup),
    TransactionCategory( title: 'Vận tải', pathAsset:Assets.svgsBus),
    TransactionCategory( title: 'Quần áo', pathAsset:Assets.svgsShirt),
    TransactionCategory( title: 'Xe hơi', pathAsset:Assets.svgsCar),
    TransactionCategory( title: 'Rượu', pathAsset:Assets.svgsGlass),
    TransactionCategory( title: 'Thuốc lá', pathAsset:Assets.svgsCigarettes),
    TransactionCategory( title: 'Thiết bị điện tử', pathAsset:Assets.svgsElectronicTech),
    TransactionCategory( title: 'Du lịch', pathAsset:Assets.svgsAirPlain),
    TransactionCategory( title: 'Sức khỏe', pathAsset:Assets.svgsHospital),
    TransactionCategory( title: 'Thú cưng', pathAsset:Assets.svgsPet),
    TransactionCategory( title: 'Sửa chữa', pathAsset:Assets.svgsRepair),
    TransactionCategory( title: 'Nhà ở', pathAsset:Assets.svgsPaint),
    TransactionCategory( title: 'Nhà ở', pathAsset:Assets.svgsWardrobe),
    TransactionCategory( title: 'Quà tặng', pathAsset:Assets.svgsGift),
    TransactionCategory( title: 'Quyên góp', pathAsset:Assets.svgsHeart),
    TransactionCategory( title: 'Vé số', pathAsset:Assets.svgsBilliard),
    TransactionCategory( title: 'Đồ ăn nhẹ', pathAsset:Assets.svgsFastFood),
    TransactionCategory( title: 'Trẻ em', pathAsset:Assets.svgsAngel),
    TransactionCategory( title: 'Rau quả', pathAsset:Assets.svgsCarrot),
    TransactionCategory( title: 'Hoa quả', pathAsset:Assets.svgsGrape),
    TransactionCategory( title: 'Cài đặt', pathAsset:Assets.svgsPlus),
    TransactionCategory( title: 'Lương', pathAsset:Assets.svgsAtm,transactionType: TransactionType.income),
    TransactionCategory( title: 'Thưởng', pathAsset:Assets.svgsInvest,transactionType: TransactionType.income),
    TransactionCategory( title: 'Tiền lãi', pathAsset:Assets.svgsOclock,transactionType: TransactionType.income),
    TransactionCategory( title: 'Quà tặng', pathAsset:Assets.svgsAward,transactionType: TransactionType.income),
    TransactionCategory( title: 'Khác', pathAsset:Assets.svgsCommand,transactionType: TransactionType.income),
    TransactionCategory( title: 'Cài đặt', pathAsset:Assets.svgsPlus,transactionType: TransactionType.income),
  ];





}
