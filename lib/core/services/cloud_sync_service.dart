import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/local/storage_service.dart';
import '../../data/models/contact_card.dart';
import '../../data/models/meeting_reminder.dart';
import 'firebase_service.dart';

enum SyncStatus {
  idle,
  syncing,
  synced,
  offline,
  error,
}

/// Bidirectional Cloud Sync engine using Firestore & Hive with Last-Write-Wins (LWW) conflict resolution.
class CloudSyncService {
  static final CloudSyncService instance = CloudSyncService._internal();
  CloudSyncService._internal();

  final ValueNotifier<SyncStatus> status = ValueNotifier<SyncStatus>(SyncStatus.idle);
  final ValueNotifier<DateTime?> lastSyncedAt = ValueNotifier<DateTime?>(null);
  final ValueNotifier<String?> syncError = ValueNotifier<String?>(null);

  FirebaseFirestore? get _firestore {
    if (!FirebaseService.instance.isAvailable) return null;
    return FirebaseFirestore.instance;
  }

  /// Triggers full bidirectional sync for contacts and reminders
  Future<bool> syncAll({bool force = false}) async {
    final user = FirebaseService.instance.currentUser;
    final firestore = _firestore;

    if (!FirebaseService.instance.isAvailable || user == null || firestore == null) {
      status.value = SyncStatus.offline;
      developer.log('Sync skipped: Firebase unavailable or user not signed in', name: 'CloudSyncService');
      return false;
    }

    if (status.value == SyncStatus.syncing && !force) {
      return false;
    }

    try {
      status.value = SyncStatus.syncing;
      syncError.value = null;

      final uid = user.uid;
      final contactsCollection = firestore.collection('users').doc(uid).collection('contacts');
      final remindersCollection = firestore.collection('users').doc(uid).collection('reminders');

      // 1. Sync Contact Cards
      await _syncContacts(contactsCollection);

      // 2. Sync Meeting Reminders
      await _syncReminders(remindersCollection);

      lastSyncedAt.value = DateTime.now();
      status.value = SyncStatus.synced;
      developer.log('Sync completed successfully for user: $uid', name: 'CloudSyncService');
      return true;
    } catch (e, stack) {
      developer.log('Sync failed: $e', name: 'CloudSyncService', error: e, stackTrace: stack);
      status.value = SyncStatus.error;
      syncError.value = e.toString();
      return false;
    }
  }

  Future<void> _syncContacts(CollectionReference<Map<String, dynamic>> cloudCollection) async {
    final contactRepo = StorageService.instance.contactRepo;
    final localCards = contactRepo.getAllCards();
    final localCardsMap = {for (var c in localCards) c.id: c};

    // Fetch cloud documents
    final cloudSnapshot = await cloudCollection.get();
    final cloudCardsMap = <String, Map<String, dynamic>>{};

    for (final doc in cloudSnapshot.docs) {
      cloudCardsMap[doc.id] = doc.data();
    }

    // Push or update local -> cloud
    for (final local in localCards) {
      final cloudData = cloudCardsMap[local.id];
      if (cloudData == null) {
        // Cloud missing: push local to cloud
        await cloudCollection.doc(local.id).set(local.toJson());
      } else {
        // Both exist: Last-Write-Wins (LWW)
        final cloudUpdated = _parseDateTime(cloudData['updatedAt'] ?? cloudData['createdAt']);
        final localUpdated = local.updatedAt ?? local.createdAt;

        if (localUpdated.isAfter(cloudUpdated)) {
          await cloudCollection.doc(local.id).set(local.toJson());
        }
      }
    }

    // Pull cloud -> local
    for (final entry in cloudCardsMap.entries) {
      final cloudCardId = entry.key;
      final cloudData = entry.value;
      final local = localCardsMap[cloudCardId];

      if (local == null) {
        // Local missing: create in local Hive
        final parsedCard = ContactCard.fromJson(cloudData);
        await contactRepo.saveCard(parsedCard);
      } else {
        final cloudUpdated = _parseDateTime(cloudData['updatedAt'] ?? cloudData['createdAt']);
        final localUpdated = local.updatedAt ?? local.createdAt;

        if (cloudUpdated.isAfter(localUpdated)) {
          final parsedCard = ContactCard.fromJson(cloudData);
          await contactRepo.saveCard(parsedCard);
        }
      }
    }
  }

  Future<void> _syncReminders(CollectionReference<Map<String, dynamic>> cloudCollection) async {
    final reminderRepo = StorageService.instance.reminderRepo;
    final localReminders = reminderRepo.getAllReminders();
    final localRemindersMap = {for (var r in localReminders) r.id: r};

    // Fetch cloud documents
    final cloudSnapshot = await cloudCollection.get();
    final cloudRemindersMap = <String, Map<String, dynamic>>{};

    for (final doc in cloudSnapshot.docs) {
      cloudRemindersMap[doc.id] = doc.data();
    }

    // Push local -> cloud
    for (final local in localReminders) {
      final cloudData = cloudRemindersMap[local.id];
      if (cloudData == null) {
        await cloudCollection.doc(local.id).set(local.toJson());
      } else {
        final cloudCreatedAt = _parseDateTime(cloudData['createdAt']);
        if (local.createdAt.isAfter(cloudCreatedAt)) {
          await cloudCollection.doc(local.id).set(local.toJson());
        }
      }
    }

    // Pull cloud -> local
    for (final entry in cloudRemindersMap.entries) {
      final cloudReminderId = entry.key;
      final cloudData = entry.value;
      final local = localRemindersMap[cloudReminderId];

      if (local == null) {
        final parsedReminder = MeetingReminder.fromJson(cloudData);
        await reminderRepo.saveReminder(parsedReminder);
      } else {
        final cloudCreatedAt = _parseDateTime(cloudData['createdAt']);
        if (cloudCreatedAt.isAfter(local.createdAt)) {
          final parsedReminder = MeetingReminder.fromJson(cloudData);
          await reminderRepo.saveReminder(parsedReminder);
        }
      }
    }
  }

  DateTime _parseDateTime(dynamic val) {
    if (val is Timestamp) return val.toDate();
    if (val is String) return DateTime.tryParse(val) ?? DateTime.fromMillisecondsSinceEpoch(0);
    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  /// Google Play 2026 Section 4.4: Permanent cloud data erasure
  Future<bool> wipeUserData() async {
    final user = FirebaseService.instance.currentUser;
    final firestore = _firestore;

    if (!FirebaseService.instance.isAvailable || user == null || firestore == null) {
      return true; // Already empty or offline
    }

    try {
      final uid = user.uid;
      final contacts = await firestore.collection('users').doc(uid).collection('contacts').get();
      for (final doc in contacts.docs) {
        await doc.reference.delete();
      }

      final reminders = await firestore.collection('users').doc(uid).collection('reminders').get();
      for (final doc in reminders.docs) {
        await doc.reference.delete();
      }

      await firestore.collection('users').doc(uid).delete();
      status.value = SyncStatus.idle;
      lastSyncedAt.value = null;
      developer.log('Wiped all cloud data for user: $uid', name: 'CloudSyncService');
      return true;
    } catch (e) {
      developer.log('Error wiping cloud data: $e', name: 'CloudSyncService');
      return false;
    }
  }
}
