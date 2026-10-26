import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:cardsaathi/data/local/hive_registrar.dart';
import 'package:cardsaathi/data/models/contact_card.dart';
import 'package:cardsaathi/data/models/meeting_reminder.dart';
import 'package:cardsaathi/data/models/user_profile.dart';
import 'package:cardsaathi/data/repositories/category_repository.dart';
import 'package:cardsaathi/data/repositories/contact_repository.dart';
import 'package:cardsaathi/data/repositories/reminder_repository.dart';
import 'package:cardsaathi/data/repositories/user_profile_repository.dart';

void main() {
  late Directory tempDir;
  late CategoryRepository categoryRepo;
  late ContactRepository contactRepo;
  late ReminderRepository reminderRepo;
  late UserProfileRepository profileRepo;

  setUpAll(() async {
    tempDir = Directory.systemTemp.createTempSync('cardsaathi_repo_test_');
    Hive.init(tempDir.path);
    HiveRegistrar.registerAdapters();
  });

  setUp(() async {
    categoryRepo = CategoryRepository();
    contactRepo = ContactRepository();
    reminderRepo = ReminderRepository();
    profileRepo = UserProfileRepository();

    await categoryRepo.init();
    await contactRepo.init();
    await reminderRepo.init();
    await profileRepo.init();
  });

  tearDown(() async {
    await contactRepo.clearAllCards();
    await reminderRepo.clearAllReminders();
    await profileRepo.clearProfile();
  });

  tearDownAll(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('CategoryRepository Operations', () {
    test('Automatically seeds 20 default commercial categories on first launch', () {
      final categories = categoryRepo.getAllCategories();
      expect(categories.length, greaterThanOrEqualTo(20));

      final retail = categoryRepo.getCategoryById('retail');
      expect(retail, isNotNull);
      expect(retail!.nameEn, equals('Retail'));
      expect(retail.isCustom, isFalse);
    });

    test('Add custom category persists and updates list', () async {
      await categoryRepo.addCustomCategory(
        id: 'dairy_products',
        nameEn: 'Dairy & Milk',
        nameHi: 'डेयरी एवं दुग्ध',
        iconCode: 0xe532,
      );

      final customCat = categoryRepo.getCategoryById('dairy_products');
      expect(customCat, isNotNull);
      expect(customCat!.isCustom, isTrue);
      expect(customCat.nameEn, equals('Dairy & Milk'));

      // Update card count
      await categoryRepo.updateCardCount('dairy_products', 3);
      expect(categoryRepo.getCategoryById('dairy_products')!.cardCount, equals(3));

      // Custom category can be deleted
      await categoryRepo.deleteCategory('dairy_products');
      expect(categoryRepo.getCategoryById('dairy_products'), isNull);
    });

    test('Default category cannot be deleted', () async {
      await categoryRepo.deleteCategory('retail');
      expect(categoryRepo.getCategoryById('retail'), isNotNull);
    });
  });

  group('ContactRepository CRUD, Search & Duplicate Detection', () {
    test('Saves and retrieves contact card', () async {
      final card = ContactCard(
        id: 'c1',
        name: 'Amit Patel',
        company: 'Patel Electronics',
        jobTitle: 'Store Owner',
        phones: ['9876543210'],
        email: 'amit@patel.com',
        categoryId: 'retail',
        tags: ['Gujarat', 'Distributor'],
        createdAt: DateTime.now(),
      );

      await contactRepo.saveCard(card);
      final retrieved = contactRepo.getCardById('c1');

      expect(retrieved, isNotNull);
      expect(retrieved!.name, equals('Amit Patel'));
      expect(retrieved.company, equals('Patel Electronics'));
    });

    test('Search filters across name, company, phone and tags', () async {
      final card1 = ContactCard(
        id: 'c1',
        name: 'Amit Patel',
        company: 'Patel Electronics',
        phones: ['9876543210'],
        tags: ['Wholesale'],
        createdAt: DateTime.now(),
      );
      final card2 = ContactCard(
        id: 'c2',
        name: 'Suresh Kumar',
        company: 'Kumar Logistics',
        phones: ['9123456780'],
        tags: ['Transport'],
        createdAt: DateTime.now(),
      );

      await contactRepo.saveCard(card1);
      await contactRepo.saveCard(card2);

      // Search by name
      expect(contactRepo.searchCards('Amit').length, equals(1));
      // Search by company
      expect(contactRepo.searchCards('Logistics').length, equals(1));
      // Search by phone snippet
      expect(contactRepo.searchCards('43210').length, equals(1));
      // Search by tag
      expect(contactRepo.searchCards('Transport').length, equals(1));
      // Empty query returns all cards
      expect(contactRepo.searchCards('').length, equals(2));
    });

    test('Smart Duplicate Detector identifies existing contact by name or phone', () async {
      final existing = ContactCard(
        id: 'c1',
        name: 'Vikas Sharma',
        company: 'Sharma Mill',
        phones: ['+91 98111 22334'],
        createdAt: DateTime.now(),
      );
      await contactRepo.saveCard(existing);

      // Duplicate by phone (with different formatting)
      final dupByPhone = contactRepo.findDuplicate(
        name: 'Different Name',
        phones: ['09811122334'],
      );
      expect(dupByPhone, isNotNull);
      expect(dupByPhone!.id, equals('c1'));

      // Duplicate by exact name
      final dupByName = contactRepo.findDuplicate(
        name: 'Vikas Sharma',
        phones: ['9999999999'],
      );
      expect(dupByName, isNotNull);
      expect(dupByName!.id, equals('c1'));

      // Non-duplicate
      final noDup = contactRepo.findDuplicate(
        name: 'Brand New User',
        phones: ['8888888888'],
      );
      expect(noDup, isNull);
    });

    test('Delete card and clearAllCards', () async {
      final card = ContactCard(
        id: 'c_del',
        name: 'Temporary Contact',
        createdAt: DateTime.now(),
      );
      await contactRepo.saveCard(card);
      expect(contactRepo.getCardById('c_del'), isNotNull);

      await contactRepo.deleteCard('c_del');
      expect(contactRepo.getCardById('c_del'), isNull);
    });
  });

  group('ReminderRepository Operations', () {
    test('Saves reminder and queries upcoming only', () async {
      final pastDate = DateTime.now().subtract(const Duration(days: 2));
      final futureDate = DateTime.now().add(const Duration(days: 2));

      final pastReminder = MeetingReminder(
        id: 'r_past',
        title: 'Old meeting',
        dateTime: pastDate,
        notificationId: 101,
        createdAt: pastDate,
      );
      final futureReminder = MeetingReminder(
        id: 'r_future',
        title: 'New contract talk',
        dateTime: futureDate,
        notificationId: 102,
        createdAt: DateTime.now(),
      );

      await reminderRepo.saveReminder(pastReminder);
      await reminderRepo.saveReminder(futureReminder);

      final upcoming = reminderRepo.getUpcomingReminders();
      expect(upcoming.length, equals(1));
      expect(upcoming.first.id, equals('r_future'));

      // Toggle completed
      await reminderRepo.toggleCompleted('r_future');
      expect(reminderRepo.getUpcomingReminders().length, equals(0));
    });
  });

  group('UserProfileRepository Operations', () {
    test('Persists user profile and produces vCard export', () async {
      final profile = UserProfile(
        name: 'Vinayak Saxena',
        company: 'CardSaathi',
        phone: '+91 99999 88888',
        email: 'vinayak@cardsaathi.in',
      );

      await profileRepo.saveProfile(profile);
      final loaded = profileRepo.getProfile();

      expect(loaded, isNotNull);
      expect(loaded!.name, equals('Vinayak Saxena'));
      expect(loaded.toVCard(), contains('FN:Vinayak Saxena'));
    });
  });
}
