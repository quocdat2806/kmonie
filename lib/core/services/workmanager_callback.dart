import 'package:drift/drift.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/di/di.dart' as di;
import 'package:kmonie/core/services/services.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/database/database.dart';

@pragma('vm:entry-point')
Future<bool> executeTransactionAutomation() async {
  try {
    await di.init(backgroundMode: true);

    final db = di.sl<KMonieDatabase>();

    final transactionService = di.sl<TransactionService>();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final dayMapping = {1: 2, 2: 3, 3: 4, 4: 5, 5: 6, 6: 7, 7: 0};
    final currentDay = dayMapping[now.weekday] ?? 2;

    final reminderDays =
        await (db.select(db.userReminderTransactionDayTb)..where(
              (t) =>
                  t.day.equals(currentDay) &
                  t.hour.isBiggerOrEqualValue(now.hour - 1) &
                  t.hour.isSmallerOrEqualValue(now.hour + 1) &
                  t.isActive.equals(true),
            ))
            .get();

    int createdCount = 0;

    for (final reminderDay in reminderDays) {
      final scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        reminderDay.hour,
        reminderDay.minute,
      );

      final timeDiff = now.difference(scheduledTime);
      final timeDiffMinutes = timeDiff.inMinutes;

      logger.d(
        'Processing automation ${reminderDay.id}: scheduled=${reminderDay.hour}:${reminderDay.minute.toString().padLeft(2, '0')}, now=${now.hour}:${now.minute.toString().padLeft(2, '0')}, timeDiff=$timeDiffMinutes minutes',
      );

      if (timeDiffMinutes < 0) {
        logger.d(
          'Scheduled time ${reminderDay.hour}:${reminderDay.minute.toString().padLeft(2, '0')} has not arrived yet for automation ${reminderDay.id}',
        );
        continue;
      }

      if (timeDiffMinutes > 5) {
        logger.d(
          'Scheduled time ${reminderDay.hour}:${reminderDay.minute.toString().padLeft(2, '0')} was more than 5 minutes ago for automation ${reminderDay.id}, skipping',
        );
        continue;
      }

      final lastExecutedDate = reminderDay.lastExecutedDate;

      if (lastExecutedDate != null) {
        final lastExecuted = DateTime(
          lastExecutedDate.year,
          lastExecutedDate.month,
          lastExecutedDate.day,
        );

        if (lastExecuted.isAtSameMomentAs(today)) {
          logger.d(
            'Transaction already created today for automation ${reminderDay.id}',
          );
          continue;
        }
      }

      final existingTransactions =
          await (db.select(db.transactionsTb)..where(
                (t) =>
                    t.amount.equals(reminderDay.amount) &
                    t.transactionCategoryId.equals(
                      reminderDay.transactionCategoryId,
                    ) &
                    t.transactionType.equals(reminderDay.transactionType) &
                    t.date.isBiggerOrEqualValue(today.toUtc()) &
                    t.date.isSmallerThanValue(
                      today.add(const Duration(days: 1)).toUtc(),
                    ),
              ))
              .get();

      final hasDuplicate = existingTransactions.any(
        (tx) =>
            tx.amount == reminderDay.amount &&
            tx.transactionCategoryId == reminderDay.transactionCategoryId &&
            tx.transactionType == reminderDay.transactionType &&
            tx.content == reminderDay.content,
      );

      if (hasDuplicate) {
        logger.d(
          'Duplicate transaction found for automation ${reminderDay.id}, skipping',
        );
        continue;
      }

      await transactionService.createTransaction(
        amount: reminderDay.amount,
        date: now,
        transactionCategoryId: reminderDay.transactionCategoryId,
        content: reminderDay.content,
        transactionType: reminderDay.transactionType,
      );

      await (db.update(
        db.userReminderTransactionDayTb,
      )..where((t) => t.id.equals(reminderDay.id))).write(
        UserReminderTransactionDayTbCompanion(
          lastExecutedDate: Value(now.toUtc()),
          updatedAt: Value(now.toUtc()),
        ),
      );

      createdCount++;
      logger.d(
        'Created automated transaction: ${reminderDay.amount} for category ${reminderDay.transactionCategoryId}',
      );
    }

    if (createdCount > 0) {
      di.sl<NotificationService>().showInAppNotification(
        id: DateTime.now().millisecondsSinceEpoch.remainder(2147483647),
        title: AppTextConstants.transactionAddedNotificationTitle,
        body: createdCount == 1
            ? AppTextConstants.transactionAddedNotificationBody
            : '$createdCount ${AppTextConstants.transactionsAddedNotificationBody}',
      );
      logger.d('Shown notification for $createdCount created transaction(s)');
    } else {
      logger.d('No transactions created, skipping notification');
    }
    return true;
  } catch (e) {
    logger.e('Error executing transaction automation: $e');
    return false;
  }
}
