import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/entities/entities.dart';

part 'search_transaction_state.freezed.dart';

@freezed
abstract class SearchTransactionState with _$SearchTransactionState {
  const factory SearchTransactionState({@Default('') String query, TransactionType? selectedType, @Default(<Transaction>[]) List<Transaction> results, @Default({}) Map<String, List<Transaction>> groupedResults, @Default({}) Map<int, TransactionCategory> categoriesMap}) = _SearchTransactionState;
}
