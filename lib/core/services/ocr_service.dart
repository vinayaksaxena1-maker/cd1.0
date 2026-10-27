import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../../data/models/extracted_card_data.dart';
import 'card_parser_service.dart';

/// Bilingual On-Device OCR Service executing Dual-Pass Latin & Devanagari Recognition
class OcrService {
  final TextRecognizer _latinRecognizer;
  final TextRecognizer _devanagariRecognizer;

  OcrService({
    TextRecognizer? latinRecognizer,
    TextRecognizer? devanagariRecognizer,
  })  : _latinRecognizer = latinRecognizer ?? TextRecognizer(script: TextRecognitionScript.latin),
        _devanagariRecognizer = devanagariRecognizer ?? TextRecognizer(script: TextRecognitionScript.devanagiri);

  /// Performs offline on-device OCR on image at [imagePath] and extracts card fields
  Future<ExtractedCardData> processCardImage({
    required String imagePath,
    String? backImagePath,
  }) async {
    final file = File(imagePath);
    if (!file.existsSync()) {
      debugPrint('OCR Error: File does not exist at $imagePath');
      return ExtractedCardData(photoFrontPath: imagePath, photoBackPath: backImagePath);
    }

    try {
      final inputImage = InputImage.fromFilePath(imagePath);

      // Pass 1: Latin script (English names, alphanumeric GSTIN, mobile numbers, email, website)
      final RecognizedText latinText = await _latinRecognizer.processImage(inputImage);

      // Pass 2: Devanagari script (Hindi business names, proprietorship roles, regional addresses)
      final RecognizedText devanagariText = await _devanagariRecognizer.processImage(inputImage);

      final combinedFront = _combineRecognizedTexts(latinText.text, devanagariText.text);

      debugPrint('--- Bilingual OCR Front Extracted (${combinedFront.length} chars) ---');

      // If back image is also present, run dual-pass OCR on back image too!
      String fullRawText = combinedFront;
      if (backImagePath != null && File(backImagePath).existsSync()) {
        try {
          final backImage = InputImage.fromFilePath(backImagePath);
          final RecognizedText backLatin = await _latinRecognizer.processImage(backImage);
          final RecognizedText backDevanagari = await _devanagariRecognizer.processImage(backImage);
          final combinedBack = _combineRecognizedTexts(backLatin.text, backDevanagari.text);
          fullRawText = '$combinedFront\n$combinedBack';
        } catch (e) {
          debugPrint('Error processing back card image OCR: $e');
        }
      }

      return CardParserService.parseText(
        fullRawText,
        photoFrontPath: imagePath,
        photoBackPath: backImagePath,
      );
    } catch (e) {
      debugPrint('Error running ML Kit Text Recognition: $e');
      return ExtractedCardData(
        photoFrontPath: imagePath,
        photoBackPath: backImagePath,
      );
    }
  }

  /// Merges Latin and Devanagari recognized text blocks without exact line duplication
  String _combineRecognizedTexts(String latin, String devanagari) {
    if (latin.trim().isEmpty) return devanagari;
    if (devanagari.trim().isEmpty) return latin;

    final latinLines = latin.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toSet();
    final devanagariLines = devanagari.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();

    final buffer = StringBuffer(latin);
    for (final dLine in devanagariLines) {
      if (!latinLines.contains(dLine)) {
        buffer.writeln();
        buffer.write(dLine);
      }
    }
    return buffer.toString();
  }

  void dispose() {
    _latinRecognizer.close();
    _devanagariRecognizer.close();
  }
}
