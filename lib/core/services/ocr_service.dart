import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../../data/models/extracted_card_data.dart';
import 'card_parser_service.dart';

class OcrService {
  final TextRecognizer _textRecognizer;

  OcrService({TextRecognizer? recognizer})
      : _textRecognizer = recognizer ?? TextRecognizer(script: TextRecognitionScript.latin);

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
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      final String rawText = recognizedText.text;

      debugPrint('--- OCR Raw Text Extracted (${rawText.length} chars) ---');

      // If back image is also present, extract text from back image too!
      String fullRawText = rawText;
      if (backImagePath != null && File(backImagePath).existsSync()) {
        try {
          final backImage = InputImage.fromFilePath(backImagePath);
          final RecognizedText backText = await _textRecognizer.processImage(backImage);
          fullRawText = '$rawText\n${backText.text}';
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

  void dispose() {
    _textRecognizer.close();
  }
}
