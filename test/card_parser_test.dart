import 'package:flutter_test/flutter_test.dart';
import 'package:cardsaathi/core/services/card_parser_service.dart';

void main() {
  group('Indian Business Card Parser - Realistic Scenarios', () {
    test('Correctly parses Modern Tech Startup Card with 15-char GSTIN and PAN', () {
      const rawTechCard = '''
CardSaathi Technologies Pvt. Ltd.
Vinayak Saxena
Founder & CEO
+91 98765 43210
vinayak@cardsaathi.in
www.cardsaathi.in
GSTIN: 07AAAAA0000A1Z5
Sector 62, Noida, Uttar Pradesh 201301
''';

      final data = CardParserService.parseText(rawTechCard);

      expect(data.gstin, equals('07AAAAA0000A1Z5'));
      expect(data.pan, equals('AAAAA0000A'));
      expect(data.email, equals('vinayak@cardsaathi.in'));
      expect(data.website, equals('www.cardsaathi.in'));
      expect(data.phones.any((p) => p.contains('98765 43210') || p.contains('9876543210')), isTrue);
      expect(data.jobTitle.toLowerCase(), contains('founder'));
      expect(data.name, equals('Vinayak Saxena'));
      expect(data.company, equals('CardSaathi Technologies Pvt. Ltd.'));
      expect(data.address, contains('201301'));
      expect(data.suggestedCategoryId, equals('it_software'));
    });

    test('Correctly parses Traditional Indian Wholesale Textile Merchant Card', () {
      const rawTextileCard = '''
Shree Ganesh Textiles
Rajesh Kumar
Proprietor
M: 98111 22334, Ph: 011-23865432
GST No. 07AAAPG1234F1Z8
Shop No. 42, Katra Neel, Chandni Chowk, Delhi - 110006
ganeshtextiles@gmail.com
''';

      final data = CardParserService.parseText(rawTextileCard);

      expect(data.gstin, equals('07AAAPG1234F1Z8'));
      expect(data.pan, equals('AAAPG1234F'));
      expect(data.name, equals('Rajesh Kumar'));
      expect(data.company, equals('Shree Ganesh Textiles'));
      expect(data.jobTitle.toLowerCase(), contains('proprietor'));
      expect(data.email, equals('ganeshtextiles@gmail.com'));
      expect(data.phones.length, greaterThanOrEqualTo(1));
      expect(data.address, contains('110006'));
      expect(data.suggestedCategoryId, equals('retail'));
    });

    test('Correctly parses Hindi Bilingual Visiting Card', () {
      const rawHindiCard = '''
श्री श्याम स्वीट्स एवं अल्पाहार
रमेश चंद्र गुप्ता
मालिक
मोबाइल: +91 9988776655
जीएसटी: 09BCDPG5678H1Z2
मुख्य बाजार, चौक, लखनऊ - 226001
''';

      final data = CardParserService.parseText(rawHindiCard);

      expect(data.gstin, equals('09BCDPG5678H1Z2'));
      expect(data.pan, equals('BCDPG5678H'));
      expect(data.name, equals('रमेश चंद्र गुप्ता'));
      expect(data.jobTitle, equals('मालिक'));
      expect(data.company, equals('श्री श्याम स्वीट्स एवं अल्पाहार'));
      expect(data.address, contains('226001'));
      expect(data.suggestedCategoryId, equals('food_beverage'));
    });

    test('Correctly parses Healthcare & Clinic Card with Doctor Designation', () {
      const rawDoctorCard = '''
Dr. Ananya Roy
Consultant Physician
Care Life Hospital
Ph: 94333 11223
carelife@hospital.org
www.carelifehospital.com
Plot 15, Salt Lake Sector 5, Kolkata 700091
''';

      final data = CardParserService.parseText(rawDoctorCard);

      expect(data.name, equals('Dr. Ananya Roy'));
      expect(data.jobTitle, equals('Consultant Physician'));
      expect(data.company, equals('Care Life Hospital'));
      expect(data.email, equals('carelife@hospital.org'));
      expect(data.website, equals('www.carelifehospital.com'));
      expect(data.address, contains('700091'));
      expect(data.suggestedCategoryId, equals('healthcare'));
    });

    test('Handles empty and degraded raw text gracefully without crashing', () {
      final emptyData = CardParserService.parseText('');
      expect(emptyData.name, isEmpty);
      expect(emptyData.company, isEmpty);
      expect(emptyData.phones, isEmpty);

      final minimal = CardParserService.parseText('Some random text\nNo structured data');
      expect(minimal.gstin, isEmpty);
      expect(minimal.email, isEmpty);
      expect(minimal.suggestedCategoryId, equals('other'));
    });

    test('Correctly normalizes Hindi numerals and parses phone numbers with Hindi digits and prefixes', () {
      const rawHindiDigitsCard = '''
बालाजी वस्त्र भंडार
प्रो. सत्यनारायण अग्रवाल
मो. ९८२९०१२३४५, दूरभाष: ०१४१-२३४५६७८
जीएसटी: 08AABCB1234D1Z9
जौहरी बाजार, जयपुर - ३०२००३
''';

      final data = CardParserService.parseText(rawHindiDigitsCard);

      expect(data.name, equals('सत्यनारायण अग्रवाल'));
      expect(data.jobTitle, contains('प्रो.'));
      expect(data.company, equals('बालाजी वस्त्र भंडार'));
      expect(data.gstin, equals('08AABCB1234D1Z9'));
      // Verify Hindi phone number 9829012345 extracted cleanly
      expect(data.phones.any((p) => p.contains('9829012345')), isTrue);
      expect(data.address, contains('302003'));
      expect(data.suggestedCategoryId, equals('retail'));
    });
  });
}
