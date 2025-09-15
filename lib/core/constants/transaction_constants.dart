import 'package:flutter/material.dart';
import 'package:kmonie/core/constants/color_constants.dart';
import 'package:kmonie/core/enums/transaction_type.dart';

class TransactionConstants {
  TransactionConstants._();

  static const List<TransactionType> transactionTypes = TransactionType.values;
  static const int totalTransactionTypes = TransactionType.totalTypes;

  static const TransactionType defaultTransactionType = TransactionType.expense;

  static const Map<String, Color> categoryColors = {
    'blue': AppColors.blue,
    'green': AppColors.green,
    'secondary': AppColors.secondary,
    'pink': AppColors.pink,
    'primary': AppColors.primary,
    'red': AppColors.red,
    'teal': AppColors.teal,
    'orange': AppColors.orange,
    'grey': AppColors.grey,
    'purple': AppColors.purple,
    'black': AppColors.black,
    'brown': AppColors.brown,
    'cyan': AppColors.cyan,
    'yellow': AppColors.yellow,
  };
}
