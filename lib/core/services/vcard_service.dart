import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/models/contact_card.dart';

/// RFC 6350 standard vCard generator and native sharing service for CardSaathi
class VCardService {
  /// Generates an RFC 6350 (vCard 3.0) compliant formatted string
  static String generateVCardString(ContactCard card) {
    final buffer = StringBuffer();
    buffer.writeln('BEGIN:VCARD');
    buffer.writeln('VERSION:3.0');

    // Formatted Name
    final name = card.name.trim().isNotEmpty ? card.name.trim() : 'Visiting Contact';
    buffer.writeln('FN;CHARSET=UTF-8:$name');

    // Structured Name (Family Name; Given Name; Additional; Prefix; Suffix)
    final parts = name.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      final lastName = parts.last;
      final firstName = parts.sublist(0, parts.length - 1).join(' ');
      buffer.writeln('N;CHARSET=UTF-8:$lastName;$firstName;;;');
    } else {
      buffer.writeln('N;CHARSET=UTF-8:$name;;;;');
    }

    // Organization / Company
    if (card.company.trim().isNotEmpty) {
      buffer.writeln('ORG;CHARSET=UTF-8:${card.company.trim()}');
    }

    // Job Title / Designation
    if (card.jobTitle.trim().isNotEmpty) {
      buffer.writeln('TITLE;CHARSET=UTF-8:${card.jobTitle.trim()}');
    }

    // Telephones
    for (int i = 0; i < card.phones.length; i++) {
      final phone = card.phones[i].trim();
      if (phone.isNotEmpty) {
        final type = i == 0 ? 'CELL,VOICE,PREF' : 'WORK,VOICE';
        buffer.writeln('TEL;TYPE=$type:$phone');
      }
    }

    // Email
    if (card.email.trim().isNotEmpty) {
      buffer.writeln('EMAIL;TYPE=WORK,INTERNET:${card.email.trim()}');
    }

    // Work Address
    if (card.address.trim().isNotEmpty) {
      final sanitizedAddress = card.address.trim().replaceAll('\n', ', ');
      buffer.writeln('ADR;TYPE=WORK;CHARSET=UTF-8:;;$sanitizedAddress;;;;');
    }

    // Website URL
    if (card.website.trim().isNotEmpty) {
      var url = card.website.trim();
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        url = 'https://$url';
      }
      buffer.writeln('URL:$url');
    }

    // Notes: GSTIN, personal notes, tags
    final noteLines = <String>[];
    if (card.gstin.trim().isNotEmpty) {
      noteLines.add('GSTIN: ${card.gstin.trim()}');
    }
    if (card.notes.trim().isNotEmpty) {
      noteLines.add(card.notes.trim());
    }
    if (card.tags.isNotEmpty) {
      noteLines.add('Tags: ${card.tags.join(", ")}');
    }
    if (noteLines.isNotEmpty) {
      final noteStr = noteLines.join('\\n').replaceAll('\n', '\\n');
      buffer.writeln('NOTE;CHARSET=UTF-8:$noteStr');
    }

    // Category / Commercial tag
    if (card.categoryId.isNotEmpty) {
      buffer.writeln('CATEGORIES:${card.categoryId}');
    }

    // Revision Timestamp
    buffer.writeln('REV:${card.createdAt.toUtc().toIso8601String()}');
    buffer.writeln('END:VCARD');

    return buffer.toString();
  }

  /// Exports the vCard to a temporary .vcf file for native system sharing
  static Future<File> exportVCardFile(ContactCard card) async {
    final tempDir = await getTemporaryDirectory();
    final sanitizedName = card.name
        .replaceAll(RegExp(r'[^\w\s\-]'), '')
        .trim()
        .replaceAll(RegExp(r'\s+'), '_');
    final filename = sanitizedName.isNotEmpty ? '$sanitizedName.vcf' : 'contact_${card.id}.vcf';
    final file = File('${tempDir.path}/$filename');
    final content = generateVCardString(card);
    await file.writeAsString(content);
    return file;
  }

  /// Shares contact using native vCard file (.vcf)
  static Future<ShareResult> shareVCard(ContactCard card) async {
    final vcfFile = await exportVCardFile(card);
    final subject = '${card.name} Visiting Card';
    final text = 'Visiting card of ${card.name} (${card.company}) via CardSaathi';

    return SharePlus.instance.share(
      ShareParams(
        files: [XFile(vcfFile.path)],
        subject: subject,
        text: text,
      ),
    );
  }

  /// Shares contact as clean formatted plain text
  static Future<ShareResult> shareAsText(ContactCard card) async {
    final lines = <String>[
      '📇 *${card.name}*',
      if (card.company.isNotEmpty) '🏢 ${card.company}',
      if (card.jobTitle.isNotEmpty) '💼 ${card.jobTitle}',
      if (card.phones.isNotEmpty) '📞 ${card.phones.join(" / ")}',
      if (card.email.isNotEmpty) '✉️ ${card.email}',
      if (card.website.isNotEmpty) '🌐 ${card.website}',
      if (card.gstin.isNotEmpty) '🆔 GSTIN: ${card.gstin}',
      if (card.address.isNotEmpty) '📍 ${card.address}',
      '',
      'Shared via CardSaathi — Your Smart Business Card Partner',
    ];

    return SharePlus.instance.share(
      ShareParams(
        text: lines.join('\n'),
        subject: '${card.name} Visiting Card',
      ),
    );
  }
}
