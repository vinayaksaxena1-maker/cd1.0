import 'package:hive/hive.dart';
import '../local/hive_registrar.dart';
import '../models/meeting_reminder.dart';

class ReminderRepository {
  Box<MeetingReminder>? _box;

  Future<void> init() async {
    if (_box != null && _box!.isOpen) return;
    _box = await Hive.openBox<MeetingReminder>(HiveRegistrar.remindersBox);
  }

  List<MeetingReminder> getAllReminders() {
    final box = _box ?? Hive.box<MeetingReminder>(HiveRegistrar.remindersBox);
    final list = box.values.toList();
    list.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return list;
  }

  List<MeetingReminder> getUpcomingReminders() {
    final box = _box ?? Hive.box<MeetingReminder>(HiveRegistrar.remindersBox);
    final now = DateTime.now();
    final list = box.values
        .where((r) => !r.isCompleted && r.dateTime.isAfter(now))
        .toList();
    list.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return list;
  }

  List<MeetingReminder> getRemindersForContact(String contactCardId) {
    final box = _box ?? Hive.box<MeetingReminder>(HiveRegistrar.remindersBox);
    final list = box.values
        .where((r) => r.contactCardId == contactCardId)
        .toList();
    list.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return list;
  }

  Future<void> saveReminder(MeetingReminder reminder) async {
    final box = _box ?? Hive.box<MeetingReminder>(HiveRegistrar.remindersBox);
    await box.put(reminder.id, reminder);
  }

  Future<void> toggleCompleted(String id) async {
    final box = _box ?? Hive.box<MeetingReminder>(HiveRegistrar.remindersBox);
    final reminder = box.get(id);
    if (reminder != null) {
      final updated = reminder.copyWith(isCompleted: !reminder.isCompleted);
      await box.put(id, updated);
    }
  }

  Future<void> deleteReminder(String id) async {
    final box = _box ?? Hive.box<MeetingReminder>(HiveRegistrar.remindersBox);
    await box.delete(id);
  }

  Future<void> clearAllReminders() async {
    final box = _box ?? Hive.box<MeetingReminder>(HiveRegistrar.remindersBox);
    await box.clear();
  }
}
