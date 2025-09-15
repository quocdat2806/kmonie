part of 'add_transaction_bloc.dart';

@freezed
class AddTransactionState with _$AddTransactionState {
  const factory AddTransactionState.initial({@Default(0) int selectedIndex}) =
      _Initial;

  const factory AddTransactionState.loaded({@Default(0) int selectedIndex}) =
      _Loaded;

  const factory AddTransactionState.error({
    @Default(0) int selectedIndex,
    required String message,
  }) = _Error;
}

extension AddTransactionStateX on AddTransactionState {
  TransactionType get currentTransactionType =>
      TransactionType.fromIndex(selectedIndex);
}
