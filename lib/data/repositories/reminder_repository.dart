import 'package:hive/hive.dart';
import '../local/hive_registrar.dart';
import '../models/meeting_reminder.dart';

class ReminderRepository {
  Box<MeetingReminder>? _box;

  Future<void> init() async {
    if (_box != null && _box!.isOpen) return;
    _box = await Hive.openBox<MeetingReminder>(HiveRegistrar.remindersBox);
  }

  Box<MeetingReminder>? _getSafeBox() {
    if (_box != null && _box!.isOpen) return _box;
    if (Hive.isBoxOpen(HiveRegistrar.remindersBox)) {
      return Hive.box<MeetingReminder>(HiveRegistrar.remindersBox);
    }
    return null;
  }

  MeetingReminder? getReminderById(String id) {
    final box = _getSafeBox();
    return box?.get(id);
  }

  List<MeetingReminder> getAllReminders() {
    final box = _getSafeBox();
    if (box == null) return [];
    final list = box.values.toList();
    list.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return list;
  }

  List<MeetingReminder> getTodayReminders() {
    final box = _getSafeBox();
    if (box == null) return [];
    final now = DateTime.now();
    final list = box.values.where((r) {
      if (r.isCompleted) return false;
      return r.dateTime.year == now.year &&
          r.dateTime.month == now.month &&
          r.dateTime.day == now.day;
    }).toList();
    list.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return list;
  }

  List<MeetingReminder> getUpcomingReminders() {
    final box = _getSafeBox();
    if (box == null) return [];
    final now = DateTime.now();
    final endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
    final list = box.values
        .where((r) => !r.isCompleted && r.dateTime.isAfter(endOfToday))
        .toList();
    list.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return list;
  }

  List<MeetingReminder> getOverdueReminders() {
    final box = _getSafeBox();
    if (box == null) return [];
    final now = DateTime.now();
    final list = box.values.where((r) {
      if (r.isCompleted) return false;
      return r.dateTime.isBefore(now);
    }).toList();
    list.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return list;
  }

  List<MeetingReminder> getCompletedReminders() {
    final box = _getSafeBox();
    if (box == null) return [];
    final list = box.values.where((r) => r.isCompleted).toList();
    list.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return list;
  }

  List<MeetingReminder> getRemindersForContact(String contactCardId) {
    final box = _getSafeBox();
    if (box == null) return [];
    final list = box.values
        .where((r) => r.contactCardId == contactCardId)
        .toList();
    list.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return list;
  }

  Future<void> saveReminder(MeetingReminder reminder) async {
    final box = _getSafeBox() ?? await Hive.openBox<MeetingReminder>(HiveRegistrar.remindersBox);
    await box.put(reminder.id, reminder);
  }

  Future<void> toggleCompleted(String id) async {
    final box = _getSafeBox() ?? await Hive.openBox<MeetingReminder>(HiveRegistrar.remindersBox);
    final reminder = box.get(id);
    if (reminder != null) {
      final updated = reminder.copyWith(isCompleted: !reminder.isCompleted);
      await box.put(id, updated);
    }
  }

  Future<void> deleteReminder(String id) async {
    final box = _getSafeBox() ?? await Hive.openBox<MeetingReminder>(HiveRegistrar.remindersBox);
    await box.delete(id);
  }

  Future<void> clearAllReminders() async {
    final box = _getSafeBox() ?? await Hive.openBox<MeetingReminder>(HiveRegistrar.remindersBox);
    await box.clear();
  }
}
