import 'package:hive/hive.dart';

part 'meeting_reminder.g.dart';

@HiveType(typeId: 2)
class MeetingReminder extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final DateTime dateTime;

  @HiveField(3)
  final String agenda;

  @HiveField(4)
  final String? contactCardId;

  @HiveField(5)
  final int notificationId;

  @HiveField(6)
  final bool isCompleted;

  @HiveField(7)
  final DateTime createdAt;

  MeetingReminder({
    required this.id,
    required this.title,
    required this.dateTime,
    this.agenda = '',
    this.contactCardId,
    required this.notificationId,
    this.isCompleted = false,
    required this.createdAt,
  });

  MeetingReminder copyWith({
    String? id,
    String? title,
    DateTime? dateTime,
    String? agenda,
    String? contactCardId,
    int? notificationId,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return MeetingReminder(
      id: id ?? this.id,
      title: title ?? this.title,
      dateTime: dateTime ?? this.dateTime,
      agenda: agenda ?? this.agenda,
      contactCardId: contactCardId ?? this.contactCardId,
      notificationId: notificationId ?? this.notificationId,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'dateTime': dateTime.toIso8601String(),
      'agenda': agenda,
      'contactCardId': contactCardId,
      'notificationId': notificationId,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory MeetingReminder.fromJson(Map<String, dynamic> json) {
    return MeetingReminder(
      id: json['id'] as String,
      title: json['title'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      agenda: json['agenda'] as String? ?? '',
      contactCardId: json['contactCardId'] as String?,
      notificationId: json['notificationId'] as int,
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
