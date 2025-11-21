import 'package:drift/drift.dart';
import 'package:kmonie/database/database.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:workmanager/workmanager.dart';
import 'package:kmonie/entities/entities.dart';

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
      final automation = await (_db.select(
        _db.userReminderTransactionDayTb,
      )..where((t) => t.id.equals(automationId))).getSingleOrNull();

      if (automation == null) return;

      final key = _getGroupKey(automation);
      final allAutomations = await (_db.select(
        _db.userReminderTransactionDayTb,
      )).get();

      final idsToDelete = <int>[];
      for (final row in allAutomations) {
        if (_getGroupKey(row) == key) {
          idsToDelete.add(row.id);
        }
      }

      for (final id in idsToDelete) {
        await (_db.delete(
          _db.userReminderTransactionDayTb,
        )..where((t) => t.id.equals(id))).go();
      }

      final remainingActiveAutomations = await (_db.select(
        _db.userReminderTransactionDayTb,
      )..where((t) => t.isActive.equals(true))).get();

      if (remainingActiveAutomations.isEmpty) {
        try {
          await Workmanager().cancelByUniqueName(_taskName);
          logger.d('WorkManager task cancelled: $_taskName');
        } catch (e) {
          logger.d(
            'WorkManager task cancellation attempted (may not be running): $_taskName',
          );
        }
      }
    } catch (e) {
      logger.e('Error deleting automation: $e');
      rethrow;
    }
  }

  Future<List<TransactionAutomationGroup>> getAllAutomations() async {
    try {
      final rows =
          await (_db.select(_db.userReminderTransactionDayTb)
                ..where((t) => t.isActive.equals(true))
                ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
              .get();

      final Map<String, TransactionAutomationGroup> groups = {};

      for (final row in rows) {
        final key = _getGroupKey(row);
        if (groups.containsKey(key)) {
          groups[key]!.days.add(row.day);
          if (row.id < groups[key]!.firstId) {
            groups[key]!.firstId = row.id;
          }
          if (row.createdAt.isBefore(groups[key]!.createdAt)) {
            groups[key]!.createdAt = row.createdAt;
          }
          if (row.lastExecutedDate != null &&
              (groups[key]!.lastExecutedDate == null ||
                  row.lastExecutedDate!.isAfter(
                    groups[key]!.lastExecutedDate!,
                  ))) {
            groups[key]!.lastExecutedDate = row.lastExecutedDate;
          }
        } else {
          groups[key] = TransactionAutomationGroup(
            firstId: row.id,
            amount: row.amount,
            transactionCategoryId: row.transactionCategoryId,
            content: row.content,
            transactionType: row.transactionType,
            hour: row.hour,
            minute: row.minute,
            days: {row.day},
            isActive: row.isActive,
            createdAt: row.createdAt,
            lastExecutedDate: row.lastExecutedDate,
          );
        }
      }

      return groups.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      logger.e('Error getting all automations: $e');
      return [];
    }
  }

  String _getGroupKey(UserReminderTransactionDayTbData row) {
    return '${row.amount}_${row.transactionCategoryId}_${row.transactionType}_${row.hour}_${row.minute}_${row.content}';
  }
}
