import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/contact_card.dart';
import '../../data/models/meeting_reminder.dart';

/// Google Play 2026 Compliant Meeting Notification & Exact Alarm Service
class NotificationService {
  static final NotificationService instance = NotificationService._internal();
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  bool get isInitialized => _initialized;

  static const String meetingChannelId = 'cardsaathi_meetings';
  static const String meetingChannelName = 'Meeting Reminders';
  static const String meetingChannelDesc =
      'Notifications for scheduled business meetings and client follow-ups';

  static const String stickyChannelId = 'cardsaathi_daily_summary';
  static const String stickyChannelName = 'Daily Meeting Summary';
  static const String stickyChannelDesc = 'Sticky overview of today\'s meetings';

  static const int stickySummaryNotificationId = 99999;

  Future<void> init() async {
    if (_initialized) return;

    try {
      tz.initializeTimeZones();

      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const initSettings = InitializationSettings(android: androidSettings);

      await _plugin.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      _initialized = true;
    } catch (e) {
      debugPrint('[NotificationService] Init error: $e');
      // In test / non-mobile platform environments where channel is not hooked
      _initialized = true;
    }
  }

  void _onNotificationTapped(NotificationResponse response) async {
    if (response.actionId == 'call_client' && response.payload != null) {
      final cleanPhone = response.payload!.replaceAll(RegExp(r'[^\d+]'), '');
      if (cleanPhone.isNotEmpty) {
        final uri = Uri.parse('tel:$cleanPhone');
        try {
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        } catch (_) {}
      }
    }
  }

  Future<bool> requestPermissions() async {
    try {
      final androidImpl = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (androidImpl != null) {
        final granted = await androidImpl.requestNotificationsPermission();
        final exactGranted = await androidImpl.requestExactAlarmsPermission();
        return (granted ?? false) && (exactGranted ?? true);
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> scheduleMeetingNotification(
    MeetingReminder reminder, {
    ContactCard? contact,
  }) async {
    if (!_initialized) await init();

    try {
      final now = DateTime.now();
      if (reminder.dateTime.isBefore(now)) return;

      final tzDateTime = tz.TZDateTime.from(reminder.dateTime, tz.local);

      final List<AndroidNotificationAction> actions = [];
      String? payload;

      if (contact != null && contact.phones.isNotEmpty) {
        payload = contact.phones.first;
        actions.add(
          const AndroidNotificationAction(
            'call_client',
            'Call Client',
            showsUserInterface: true,
          ),
        );
      }

      final androidDetails = AndroidNotificationDetails(
        meetingChannelId,
        meetingChannelName,
        channelDescription: meetingChannelDesc,
        importance: Importance.max,
        priority: Priority.high,
        actions: actions.isNotEmpty ? actions : null,
      );

      final notificationDetails = NotificationDetails(android: androidDetails);

      await _plugin.zonedSchedule(
        id: reminder.notificationId,
        title: reminder.title,
        body: reminder.agenda.isNotEmpty
            ? reminder.agenda
            : (contact != null ? 'Meeting with ${contact.name}' : 'Scheduled Meeting'),
        scheduledDate: tzDateTime,
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );
    } catch (e) {
      debugPrint('[NotificationService] Schedule error: $e');
    }
  }

  Future<void> cancelMeetingNotification(int notificationId) async {
    try {
      await _plugin.cancel(id: notificationId);
    } catch (e) {
      debugPrint('[NotificationService] Cancel error: $e');
    }
  }

  Future<void> showStickyTodayMeetingsSummary(List<MeetingReminder> todayMeetings) async {
    if (!_initialized) await init();

    try {
      if (todayMeetings.isEmpty) {
        await _plugin.cancel(id: stickySummaryNotificationId);
        return;
      }

      final activeToday = todayMeetings.where((m) => !m.isCompleted).toList();
      if (activeToday.isEmpty) {
        await _plugin.cancel(id: stickySummaryNotificationId);
        return;
      }

      final title = 'CardSaathi: Today\'s Meetings (${activeToday.length})';
      final body = activeToday.map((m) => '• ${m.title}').take(3).join('\n');

      const androidDetails = AndroidNotificationDetails(
        stickyChannelId,
        stickyChannelName,
        channelDescription: stickyChannelDesc,
        importance: Importance.low,
        priority: Priority.low,
        ongoing: true,
        autoCancel: false,
      );

      await _plugin.show(
        id: stickySummaryNotificationId,
        title: title,
        body: body,
        notificationDetails: const NotificationDetails(android: androidDetails),
      );
    } catch (e) {
      debugPrint('[NotificationService] Sticky summary error: $e');
    }
  }
}
