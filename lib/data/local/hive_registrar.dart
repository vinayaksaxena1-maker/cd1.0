import 'dart:io';
import 'package:flutter/foundation.dart' hide Category;
import 'package:hive_flutter/hive_flutter.dart';
import '../models/category.dart';
import '../models/contact_card.dart';
import '../models/meeting_reminder.dart';
import '../models/user_profile.dart';

class HiveRegistrar {
  static const String categoriesBox = 'categories_box';
  static const String contactCardsBox = 'contact_cards_box';
  static const String remindersBox = 'reminders_box';
  static const String userProfileBox = 'user_profile_box';

  static bool _initialized = false;

  /// Initializes Hive, registers TypeAdapters, and opens fundamental boxes.
  static Future<void> initHive({String? subDir}) async {
    if (_initialized) return;

    try {
      await Hive.initFlutter(subDir);
    } catch (_) {
      // Safe fallback for pure unit/widget tests without platform channels
      final tempDir = Directory.systemTemp.createTempSync('cardsaathi_test_hive_');
      Hive.init(tempDir.path);
    }

    registerAdapters();
    _initialized = true;
  }

  /// Registers adapters if not already registered (useful for tests and main app)
  static void registerAdapters() {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(CategoryAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ContactCardAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(MeetingReminderAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(UserProfileAdapter());
    }
  }

  /// Emergency 1-click erasure complying with Google Play Developer Policy 2026
  static Future<void> clearAllUserData() async {
    try {
      if (Hive.isBoxOpen(categoriesBox)) {
        await Hive.box<Category>(categoriesBox).clear();
      }
      if (Hive.isBoxOpen(contactCardsBox)) {
        await Hive.box<ContactCard>(contactCardsBox).clear();
      }
      if (Hive.isBoxOpen(remindersBox)) {
        await Hive.box<MeetingReminder>(remindersBox).clear();
      }
      if (Hive.isBoxOpen(userProfileBox)) {
        await Hive.box<UserProfile>(userProfileBox).clear();
      }
    } catch (e) {
      debugPrint('Error wiping user data: $e');
    }
  }
}
