// import '../entity/transaction_category/transaction_category.dart';
// import 'drift_local_database.dart';
//
// extension TxCatRowMapper on TransactionCategoryTbData {
//   TransactionCategory toDomain() => TransactionCategory(
//     id: id,
//     title: title,
//     pathAsset: pathAsset,
//     transactionType: transactionType,
//   );
// }
//
// extension TxCatCompanionMapper on TransactionCategory {
//   TransactionCategoryTbCompanion toCompanion() =>
//       TransactionCategoryTbCompanion.insert(
//         id: id,
//         title: title,
//         pathAsset: Value(pathAsset),
//         transactionType: Value(transactionType.typeIndex),
//       );
// }