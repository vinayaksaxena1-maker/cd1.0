import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:cardsaathi/core/services/data_export_service.dart';
import 'package:cardsaathi/data/local/hive_registrar.dart';
import 'package:cardsaathi/data/models/contact_card.dart';
import 'package:cardsaathi/data/models/user_profile.dart';
import 'package:cardsaathi/data/repositories/user_profile_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory tempDir;
  late UserProfileRepository profileRepo;

  setUpAll(() async {
    tempDir = Directory.systemTemp.createTempSync('cardsaathi_export_test_');
    Hive.init(tempDir.path);
    HiveRegistrar.registerAdapters();
    profileRepo = UserProfileRepository();
    await profileRepo.init();
  });

  tearDownAll(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('DataExportService & vCard Tests', () {
    test('generateVCardString formats ContactCard to valid RFC 6350 vCard 3.0', () {
      final card = ContactCard(
        id: 'test_card_1',
        name: 'Rajesh Sharma',
        company: 'Sharma Kirana Store',
        jobTitle: 'Proprietor',
        categoryId: 'retail',
        phones: ['+91 98765 43210', '+91 91234 56789'],
        email: 'rajesh@sharmakirana.com',
        website: 'https://sharmakirana.in',
        address: 'B-12, Johari Bazar, Jaipur',
        gstin: '08AAAAA1234A1Z5',
        tags: ['Wholesale', 'DailyOrders'],
        notes: 'Met at Trade Expo',
        createdAt: DateTime(2026, 10, 25),
      );

      final vcard = DataExportService.instance.generateVCardString(card);

      expect(vcard, contains('BEGIN:VCARD'));
      expect(vcard, contains('VERSION:3.0'));
      expect(vcard, contains('FN:Rajesh Sharma'));
      expect(vcard, contains('ORG:Sharma Kirana Store'));
      expect(vcard, contains('TITLE:Proprietor'));
      expect(vcard, contains('TEL;TYPE=CELL:+91 98765 43210'));
      expect(vcard, contains('TEL;TYPE=CELL:+91 91234 56789'));
      expect(vcard, contains('EMAIL:rajesh@sharmakirana.com'));
      expect(vcard, contains('URL:https://sharmakirana.in'));
      expect(vcard, contains('ADR;TYPE=WORK:;;B-12, Johari Bazar, Jaipur;;;;'));
      expect(vcard, contains('GSTIN: 08AAAAA1234A1Z5'));
      expect(vcard, contains('Tags: Wholesale, DailyOrders'));
      expect(vcard, contains('END:VCARD'));
    });

    test('UserProfileRepository saves, retrieves and clears profile correctly', () async {
      await profileRepo.clearProfile();
      expect(profileRepo.getProfile(), isNull);

      final profile = UserProfile(
        name: 'Vinayak Saxena',
        designation: 'Architect',
        company: 'CardSaathi Technologies',
        phone: '+91 99999 88888',
        email: 'vinayak@cardsaathi.app',
        website: 'www.cardsaathi.app',
        address: 'Jaipur, Rajasthan',
      );

      await profileRepo.saveProfile(profile);

      final loaded = profileRepo.getProfile();
      expect(loaded, isNotNull);
      expect(loaded!.name, equals('Vinayak Saxena'));
      expect(loaded.company, equals('CardSaathi Technologies'));
      expect(loaded.designation, equals('Architect'));
      expect(loaded.phone, equals('+91 99999 88888'));

      await profileRepo.clearProfile();
      expect(profileRepo.getProfile(), isNull);
    });
  });
}
