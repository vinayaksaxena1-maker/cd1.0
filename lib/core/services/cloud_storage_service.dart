import 'dart:io';
import 'dart:developer' as developer;
import 'package:firebase_storage/firebase_storage.dart';
import 'firebase_service.dart';

/// Service managing photo and voice memo media uploads to Firebase Cloud Storage.
class CloudStorageService {
  static final CloudStorageService instance = CloudStorageService._internal();
  CloudStorageService._internal();

  FirebaseStorage? get _storage {
    if (!FirebaseService.instance.isAvailable) return null;
    return FirebaseStorage.instance;
  }

  /// Uploads front or back visiting card photo to Cloud Storage
  Future<String?> uploadCardPhoto({
    required String cardId,
    required String localPath,
    bool isFront = true,
  }) async {
    final user = FirebaseService.instance.currentUser;
    final storage = _storage;

    if (!FirebaseService.instance.isAvailable || user == null || storage == null) {
      developer.log('Storage skip: Firebase unavailable or user not logged in', name: 'CloudStorageService');
      return null;
    }

    final file = File(localPath);
    if (!file.existsSync()) {
      developer.log('Storage skip: File does not exist at $localPath', name: 'CloudStorageService');
      return null;
    }

    try {
      final suffix = isFront ? 'front.jpg' : 'back.jpg';
      final storagePath = 'users/${user.uid}/cards/$cardId/$suffix';
      final ref = storage.ref().child(storagePath);

      final uploadTask = await ref.putFile(
        file,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      final downloadUrl = await uploadTask.ref.getDownloadURL();
      developer.log('Card photo uploaded successfully: $downloadUrl', name: 'CloudStorageService');
      return downloadUrl;
    } catch (e, stack) {
      developer.log('Card photo upload error: $e', name: 'CloudStorageService', error: e, stackTrace: stack);
      return null;
    }
  }

  /// Uploads voice memo `.m4a` audio to Cloud Storage
  Future<String?> uploadVoiceMemo({
    required String cardId,
    required String localPath,
  }) async {
    final user = FirebaseService.instance.currentUser;
    final storage = _storage;

    if (!FirebaseService.instance.isAvailable || user == null || storage == null) {
      developer.log('Storage skip: Firebase unavailable or user not logged in', name: 'CloudStorageService');
      return null;
    }

    final file = File(localPath);
    if (!file.existsSync()) {
      developer.log('Storage skip: File does not exist at $localPath', name: 'CloudStorageService');
      return null;
    }

    try {
      final storagePath = 'users/${user.uid}/audio/$cardId/memo.m4a';
      final ref = storage.ref().child(storagePath);

      final uploadTask = await ref.putFile(
        file,
        SettableMetadata(contentType: 'audio/m4a'),
      );

      final downloadUrl = await uploadTask.ref.getDownloadURL();
      developer.log('Voice memo uploaded successfully: $downloadUrl', name: 'CloudStorageService');
      return downloadUrl;
    } catch (e, stack) {
      developer.log('Voice memo upload error: $e', name: 'CloudStorageService', error: e, stackTrace: stack);
      return null;
    }
  }
}
