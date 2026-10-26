import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/models/contact_card.dart';

/// Service to Export Digital Visiting Card as High-Resolution 4:5 Image
class CardExportService {
  static Future<File?> captureCardToImage(GlobalKey boundaryKey, {double pixelRatio = 3.0}) async {
    try {
      final boundary = boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;

      final buffer = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/cardsaathi_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(filePath);
      await file.writeAsBytes(buffer);
      return file;
    } catch (e) {
      debugPrint('[CardExportService] Error capturing image: $e');
      return null;
    }
  }

  static Future<void> shareCardOnWhatsApp({
    required GlobalKey boundaryKey,
    required ContactCard card,
    required BuildContext context,
  }) async {
    final imageFile = await captureCardToImage(boundaryKey);
    if (imageFile == null) return;

    final greeting = StringBuffer();
    greeting.writeln('Namaste! Here is the digital business card for *${card.name}*.');
    if (card.company.isNotEmpty) greeting.writeln('*${card.company}*');
    if (card.jobTitle.isNotEmpty) greeting.writeln(card.jobTitle);
    if (card.phones.isNotEmpty) greeting.writeln('📞 Phone: ${card.phones.first}');
    if (card.email.isNotEmpty) greeting.writeln('✉️ Email: ${card.email}');
    if (card.website.isNotEmpty) greeting.writeln('🌐 Website: ${card.website}');
    greeting.writeln('\n_Shared via CardSaathi Digital Cards_');

    final xFile = XFile(imageFile.path, mimeType: 'image/png');
    await SharePlus.instance.share(
      ShareParams(
        files: [xFile],
        text: greeting.toString(),
        subject: '${card.name} - Digital Business Card',
      ),
    );
  }
}
