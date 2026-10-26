import 'package:flutter_test/flutter_test.dart';
import 'package:cardsaathi/data/models/category.dart';
import 'package:cardsaathi/data/models/contact_card.dart';
import 'package:cardsaathi/data/models/meeting_reminder.dart';
import 'package:cardsaathi/data/models/user_profile.dart';

void main() {
  group('Category Model Serialization & Defaults', () {
    test('Default commercial categories count is exactly 20', () {
      final list = Category.defaultCategories;
      expect(list.length, equals(20));
      expect(list.every((c) => c.id.isNotEmpty && c.nameEn.isNotEmpty && c.nameHi.isNotEmpty), isTrue);
      expect(list.any((c) => c.id == 'retail' && c.nameEn == 'Retail'), isTrue);
      expect(list.any((c) => c.id == 'healthcare' && c.nameHi.contains('स्वास्थ्य')), isTrue);
    });

    test('Category toJson and fromJson roundtrip retains all properties', () {
      final category = Category(
        id: 'tech_custom',
        nameEn: 'Tech Startup',
        nameHi: 'टेक स्टार्टअप',
        iconCode: 0xe1b1,
        isCustom: true,
        cardCount: 5,
      );

      final json = category.toJson();
      final revived = Category.fromJson(json);

      expect(revived.id, equals('tech_custom'));
      expect(revived.nameEn, equals('Tech Startup'));
      expect(revived.nameHi, equals('टेक स्टार्टअप'));
      expect(revived.iconCode, equals(0xe1b1));
      expect(revived.isCustom, isTrue);
      expect(revived.cardCount, equals(5));
    });
  });

  group('ContactCard Model Serialization', () {
    test('ContactCard toJson and fromJson roundtrip preserves all 17 fields', () {
      final now = DateTime.now();
      final card = ContactCard(
        id: 'card_123',
        name: 'Rahul Sharma',
        company: 'Sharma Traders',
        jobTitle: 'Managing Director',
        phones: ['+91 98765 43210', '011-23456789'],
        email: 'rahul@sharmatraders.in',
        address: 'Chandni Chowk, Delhi - 110006',
        gstin: '07AAAAA0000A1Z5',
        categoryId: 'retail',
        voiceMemoPath: '/data/memo_123.m4a',
        notes: 'Met at Trade Expo 2026',
        tags: ['Vendor', 'Textile', 'VIP'],
        photoFrontPath: '/data/front_123.jpg',
        photoBackPath: '/data/back_123.jpg',
        createdAt: now,
        website: 'https://sharmatraders.in',
      );

      final json = card.toJson();
      final revived = ContactCard.fromJson(json);

      expect(revived.id, equals('card_123'));
      expect(revived.name, equals('Rahul Sharma'));
      expect(revived.company, equals('Sharma Traders'));
      expect(revived.jobTitle, equals('Managing Director'));
      expect(revived.phones, equals(['+91 98765 43210', '011-23456789']));
      expect(revived.email, equals('rahul@sharmatraders.in'));
      expect(revived.address, equals('Chandni Chowk, Delhi - 110006'));
      expect(revived.gstin, equals('07AAAAA0000A1Z5'));
      expect(revived.categoryId, equals('retail'));
      expect(revived.voiceMemoPath, equals('/data/memo_123.m4a'));
      expect(revived.notes, equals('Met at Trade Expo 2026'));
      expect(revived.tags, equals(['Vendor', 'Textile', 'VIP']));
      expect(revived.photoFrontPath, equals('/data/front_123.jpg'));
      expect(revived.photoBackPath, equals('/data/back_123.jpg'));
      expect(revived.website, equals('https://sharmatraders.in'));
    });
  });

  group('MeetingReminder Model Serialization', () {
    test('MeetingReminder toJson and fromJson roundtrip preserves agenda and notificationId', () {
      final scheduled = DateTime(2026, 11, 15, 14, 30);
      final reminder = MeetingReminder(
        id: 'rem_001',
        title: 'Vendor Contract Discussion',
        dateTime: scheduled,
        agenda: 'Review wholesale fabric pricing',
        contactCardId: 'card_123',
        notificationId: 1001,
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      final json = reminder.toJson();
      final revived = MeetingReminder.fromJson(json);

      expect(revived.id, equals('rem_001'));
      expect(revived.title, equals('Vendor Contract Discussion'));
      expect(revived.dateTime, equals(scheduled));
      expect(revived.agenda, equals('Review wholesale fabric pricing'));
      expect(revived.contactCardId, equals('card_123'));
      expect(revived.notificationId, equals(1001));
      expect(revived.isCompleted, isFalse);
    });
  });

  group('UserProfile Model Serialization & RFC 6350 vCard generation', () {
    test('UserProfile generates RFC 6350 compliant vCard text', () {
      final profile = UserProfile(
        name: 'Vinayak Saxena',
        designation: 'Founder & Architect',
        company: 'CardSaathi Technologies',
        phone: '+91 99999 88888',
        email: 'vinayak@cardsaathi.in',
        website: 'https://cardsaathi.in',
        address: 'Noida, Uttar Pradesh, India',
      );

      final vCard = profile.toVCard();

      expect(vCard, contains('BEGIN:VCARD'));
      expect(vCard, contains('VERSION:3.0'));
      expect(vCard, contains('FN:Vinayak Saxena'));
      expect(vCard, contains('ORG:CardSaathi Technologies'));
      expect(vCard, contains('TITLE:Founder & Architect'));
      expect(vCard, contains('TEL;TYPE=CELL:+91 99999 88888'));
      expect(vCard, contains('EMAIL:vinayak@cardsaathi.in'));
      expect(vCard, contains('URL:https://cardsaathi.in'));
      expect(vCard, contains('ADR;TYPE=WORK:;;Noida, Uttar Pradesh, India;;;;'));
      expect(vCard, contains('END:VCARD'));
    });
  });
}
