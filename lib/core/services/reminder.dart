import 'package:drift/drift.dart';
import 'package:kmonie/database/database.dart';
import 'package:kmonie/core/utils/utils.dart';

class ReminderService {
  final KMonieDatabase _db;

  ReminderService(this._db);

  static const int _defaultReminderId = 1;

  Future<({int hour, int minute})?> getReminderTime() async {
    try {
      final reminder = await (_db.select(
        _db.dailyReminderTb,
      )..where((t) => t.id.equals(_defaultReminderId))).getSingleOrNull();

      if (reminder == null) {
        return null;
      }

      return (hour: reminder.hour, minute: reminder.minute);
    } catch (e) {
      logger.e('Error getting reminder time: $e');
      return null;
    }
  }

  Future<void> saveReminderTime({
    required int hour,
    required int minute,
  }) async {
    try {
      final existing = await (_db.select(
        _db.dailyReminderTb,
      )..where((t) => t.id.equals(_defaultReminderId))).getSingleOrNull();

      if (existing != null) {
        await (_db.update(
          _db.dailyReminderTb,
        )..where((t) => t.id.equals(_defaultReminderId))).write(
          DailyReminderTbCompanion(
            hour: Value(hour),
            minute: Value(minute),
            updatedAt: Value(DateTime.now()),
          ),
        );
      } else {
        await _db
            .into(_db.dailyReminderTb)
            .insert(
              DailyReminderTbCompanion.insert(
                id: const Value(_defaultReminderId),
                hour: Value(hour),
                minute: Value(minute),
              ),
            );
      }
    } catch (e) {
      logger.e('Error saving reminder time: $e');
      rethrow;
    }
  }
}
