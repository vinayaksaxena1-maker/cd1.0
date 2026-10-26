import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/local/storage_service.dart';
import '../../data/models/contact_card.dart';

/// Service for full offline backup and multi-vCard export
class DataExportService {
  static final DataExportService instance = DataExportService._internal();
  DataExportService._internal();

  /// Exports complete application state into an offline JSON backup file
  Future<bool> exportAllDataAsJson() async {
    try {
      final contactRepo = StorageService.instance.contactRepo;
      final categoryRepo = StorageService.instance.categoryRepo;
      final reminderRepo = StorageService.instance.reminderRepo;
      final profileRepo = StorageService.instance.userProfileRepo;

      final contacts = contactRepo.getAllCards();
      final categories = categoryRepo.getAllCategories();
      final reminders = reminderRepo.getAllReminders();
      final profile = profileRepo.getProfile();

      final backupData = {
        'appName': 'CardSaathi',
        'schemaVersion': '1.0.0',
        'exportedAt': DateTime.now().toIso8601String(),
        'summary': {
          'totalContacts': contacts.length,
          'totalReminders': reminders.length,
          'totalCategories': categories.length,
        },
        'userProfile': profile?.toJson(),
        'categories': categories.map((c) => c.toJson()).toList(),
        'contacts': contacts.map((c) => c.toJson()).toList(),
        'reminders': reminders.map((r) => r.toJson()).toList(),
      };

      final jsonString = const JsonEncoder.withIndent('  ').convert(backupData);
      final tempDir = await getTemporaryDirectory();
      final now = DateTime.now();
      final timestamp = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';
      final file = File('${tempDir.path}/CardSaathi_Backup_$timestamp.json');
      await file.writeAsString(jsonString);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          subject: 'CardSaathi Full Offline Backup ($timestamp)',
        ),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Exports all contact cards into a single multi-vCard (.vcf) archive
  Future<bool> exportAllContactsAsVCard() async {
    try {
      final contacts = StorageService.instance.contactRepo.getAllCards();
      if (contacts.isEmpty) return false;

      final buffer = StringBuffer();
      for (final card in contacts) {
        buffer.writeln(generateVCardString(card));
      }

      final tempDir = await getTemporaryDirectory();
      final now = DateTime.now();
      final timestamp = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
      final file = File('${tempDir.path}/CardSaathi_Contacts_$timestamp.vcf');
      await file.writeAsString(buffer.toString());

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          subject: 'CardSaathi Contacts Archive ($timestamp)',
        ),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Formats a single ContactCard into standard RFC 6350 vCard 3.0 format
  String generateVCardString(ContactCard card) {
    final buffer = StringBuffer();
    buffer.writeln('BEGIN:VCARD');
    buffer.writeln('VERSION:3.0');
    buffer.writeln('FN:${card.name}');
    if (card.company.isNotEmpty) buffer.writeln('ORG:${card.company}');
    if (card.jobTitle.isNotEmpty) buffer.writeln('TITLE:${card.jobTitle}');
    for (final phone in card.phones) {
      if (phone.isNotEmpty) buffer.writeln('TEL;TYPE=CELL:$phone');
    }
    if (card.email.isNotEmpty) buffer.writeln('EMAIL:${card.email}');
    if (card.website.isNotEmpty) buffer.writeln('URL:${card.website}');
    if (card.address.isNotEmpty) {
      buffer.writeln('ADR;TYPE=WORK:;;${card.address.replaceAll('\n', ', ')};;;;');
    }
    final notes = <String>[];
    if (card.gstin.isNotEmpty) notes.add('GSTIN: ${card.gstin}');
    if (card.tags.isNotEmpty) notes.add('Tags: ${card.tags.join(', ')}');
    if (card.notes.isNotEmpty) notes.add(card.notes);
    if (notes.isNotEmpty) {
      buffer.writeln('NOTE:${notes.join(' | ')}');
    }
    buffer.writeln('END:VCARD');
    return buffer.toString();
  }
}
