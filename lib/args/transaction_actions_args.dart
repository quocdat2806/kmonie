import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/entities/entities.dart';

class TransactionActionsPageArgs {
  final ActionsMode mode;
  final Transaction? transaction;
  final DateTime? selectedDate;

  TransactionActionsPageArgs({
    this.mode = ActionsMode.add,
    this.transaction,
    this.selectedDate,
  });
}
