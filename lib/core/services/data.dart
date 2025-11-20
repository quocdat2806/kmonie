import 'package:kmonie/database/database.dart';
import 'package:kmonie/core/services/services.dart';
import 'package:kmonie/core/utils/utils.dart';

class DataService {
  final KMonieDatabase _db;
  final TransactionService _transactionService;

  DataService(this._db, this._transactionService);

  Future<void> deleteAllUserData() async {
    try {
      _transactionService
        ..clearAllGroupCache()
        ..clearYearCache();

      await _db.deleteAllUserData();
    } catch (e) {
      logger.e('Error deleting all user data: $e');
      rethrow;
    }
  }
}
