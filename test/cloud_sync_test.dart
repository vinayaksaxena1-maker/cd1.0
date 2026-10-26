import 'package:flutter_test/flutter_test.dart';
import 'package:cardsaathi/data/models/contact_card.dart';
import 'package:cardsaathi/data/models/meeting_reminder.dart';
import 'package:cardsaathi/core/services/cloud_sync_service.dart';
import 'package:cardsaathi/core/services/firebase_service.dart';

void main() {
  group('Cloud Sync Engine & Model Serialization Tests', () {
    test('ContactCard JSON serialization roundtrip', () {
      final now = DateTime.now();
      final card = ContactCard(
        id: 'sync_test_card_1',
        name: 'Virendra Singh',
        company: 'Singh Logistics & Freight',
        jobTitle: 'Chief Operations Officer',
        phones: ['+91 99887 76655'],
        email: 'virendra@singhlogistics.com',
        address: 'Sector 18, Transport Nagar, Jaipur',
        gstin: '08ABCDE1234F1Z5',
        categoryId: 'transport',
        notes: 'Priority interstate logistics partner',
        tags: ['Logistics', 'Fleet Owner'],
        website: 'https://singhlogistics.com',
        createdAt: now,
        updatedAt: now.add(const Duration(minutes: 5)),
      );

      final json = card.toJson();
      expect(json['id'], 'sync_test_card_1');
      expect(json['name'], 'Virendra Singh');
      expect(json['categoryId'], 'transport');
      expect(json['gstin'], '08ABCDE1234F1Z5');

      final deserialized = ContactCard.fromJson(json);
      expect(deserialized.id, card.id);
      expect(deserialized.name, card.name);
      expect(deserialized.company, card.company);
      expect(deserialized.email, card.email);
      expect(deserialized.phones, card.phones);
      expect(deserialized.tags, card.tags);
      expect(deserialized.updatedAt, isNotNull);
    });

    test('MeetingReminder JSON serialization roundtrip', () {
      final now = DateTime.now();
      final reminder = MeetingReminder(
        id: 'sync_reminder_1',
        title: 'GST Filing Discussion',
        dateTime: now.add(const Duration(days: 1)),
        agenda: 'Review quarterly balance sheet and input tax credits',
        contactCardId: 'sync_test_card_1',
        notificationId: 8080,
        isCompleted: false,
        createdAt: now,
      );

      final json = reminder.toJson();
      expect(json['id'], 'sync_reminder_1');
      expect(json['title'], 'GST Filing Discussion');
      expect(json['contactCardId'], 'sync_test_card_1');
      expect(json['notificationId'], 8080);
      expect(json['isCompleted'], isFalse);

      final deserialized = MeetingReminder.fromJson(json);
      expect(deserialized.id, reminder.id);
      expect(deserialized.title, reminder.title);
      expect(deserialized.notificationId, reminder.notificationId);
      expect(deserialized.agenda, reminder.agenda);
    });

    test('LWW (Last-Write-Wins) timestamp comparator logic', () {
      final t1 = DateTime(2026, 10, 26, 12, 0);
      final t2 = DateTime(2026, 10, 26, 12, 30);

      // t2 is strictly newer than t1
      expect(t2.isAfter(t1), isTrue);

      // Local newer than cloud -> Push to Cloud
      final localCard = ContactCard(
        id: 'c1',
        name: 'Local Updated',
        createdAt: t1,
        updatedAt: t2,
      );
      final cloudCardJson = {
        'id': 'c1',
        'name': 'Cloud Stale',
        'createdAt': t1.toIso8601String(),
        'updatedAt': t1.toIso8601String(),
      };

      final cloudUpdated = DateTime.parse(cloudCardJson['updatedAt']!);
      final localUpdated = localCard.updatedAt ?? localCard.createdAt;
      expect(localUpdated.isAfter(cloudUpdated), isTrue);
    });

    test('CloudSyncService handles uninitialized Firebase gracefully without crashing', () async {
      final syncService = CloudSyncService.instance;
      expect(syncService.status.value, SyncStatus.idle);

      // Trigger sync in mock/test environment
      final result = await syncService.syncAll();
      expect(result, isFalse);
      expect(syncService.status.value, SyncStatus.offline);
    });

    test('FirebaseService default offline resilience and guest check', () {
      final fb = FirebaseService.instance;
      // In flutter_test environment without mock native bindings, currentUser is null, hence isGuest is true
      expect(fb.currentUser, isNull);
      expect(fb.isGuest, isTrue);
    });
  });
}
