import 'package:drift/drift.dart';
import 'package:kmonie/database/database.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:workmanager/workmanager.dart';

class TransactionAutomationService {
  final KMonieDatabase _db;

  TransactionAutomationService(this._db);

  static const String _taskName = 'transactionAutomation';

  Future<int> createAutomation({
    required int amount,
    required int hour,
    required int minute,
    required Set<int> selectedDays,
    required int transactionCategoryId,
    required String content,
    required int transactionType,
  }) async {
    try {
      for (final day in selectedDays) {
        await _db
            .into(_db.userReminderTransactionDayTb)
            .insert(
              UserReminderTransactionDayTbCompanion.insert(
                amount: amount,
                transactionCategoryId: transactionCategoryId,
                content: Value(content),
                transactionType: Value(transactionType),
                day: day,
                hour: hour,
                minute: minute,
                isActive: const Value(true),
              ),
            );
      }

      await _ensureWorkManagerRegistered();

      return selectedDays.length;
    } catch (e) {
      logger.e('Error creating transaction automation: $e');
      rethrow;
    }
  }

  Future<void> _ensureWorkManagerRegistered() async {
    try {
      await Workmanager().registerPeriodicTask(
        _taskName,
        _taskName,
        initialDelay: const Duration(minutes: 2),
        frequency: const Duration(minutes: 15),
        constraints: Constraints(networkType: NetworkType.notRequired),
        existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
      );
      logger.d('WorkManager task registered: $_taskName');
    } catch (e) {
      logger.e('Error registering WorkManager task: $e');
    }
  }

  Future<void> deleteAutomation(int automationId) async {
    try {
      await (_db.update(
        _db.userReminderTransactionDayTb,
      )..where((t) => t.id.equals(automationId))).write(
        UserReminderTransactionDayTbCompanion(
          isActive: const Value(false),
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      );
    } catch (e) {
      logger.e('Error deleting automation: $e');
      rethrow;
    }
  }
}
