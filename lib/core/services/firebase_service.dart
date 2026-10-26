import 'dart:developer' as developer;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Service managing Firebase initialization and authentication states.
class FirebaseService {
  static final FirebaseService instance = FirebaseService._internal();
  FirebaseService._internal();

  bool _initialized = false;
  bool _isAvailable = false;

  bool get isInitialized => _initialized;
  bool get isAvailable => _isAvailable;

  FirebaseAuth? get _auth {
    if (!_isAvailable) return null;
    return FirebaseAuth.instance;
  }

  User? get currentUser => _auth?.currentUser;
  Stream<User?>? get authStateChanges => _auth?.authStateChanges();

  /// Initializes Firebase and auto-signs in anonymously if needed.
  Future<bool> init() async {
    if (_initialized) return _isAvailable;

    try {
      await Firebase.initializeApp();
      _isAvailable = true;
      developer.log('Firebase initialized successfully', name: 'FirebaseService');

      // Auto sign in anonymously for friction-free cloud backup UID
      if (currentUser == null) {
        await signInAnonymously();
      }
    } catch (e, stack) {
      _isAvailable = false;
      developer.log(
        'Firebase initialization skipped or failed: $e',
        name: 'FirebaseService',
        error: e,
        stackTrace: stack,
      );
    } finally {
      _initialized = true;
    }

    return _isAvailable;
  }

  /// Signs in anonymously to obtain a cloud sync identity
  Future<UserCredential?> signInAnonymously() async {
    if (!_isAvailable || _auth == null) return null;
    try {
      final credential = await _auth!.signInAnonymously();
      developer.log('Anonymous sign-in success: ${credential.user?.uid}', name: 'FirebaseService');
      return credential;
    } catch (e) {
      developer.log('Anonymous sign-in error: $e', name: 'FirebaseService');
      return null;
    }
  }

  /// Signs out the current user
  Future<void> signOut() async {
    if (!_isAvailable || _auth == null) return;
    try {
      await _auth!.signOut();
      developer.log('Firebase sign-out successful', name: 'FirebaseService');
    } catch (e) {
      developer.log('Firebase sign-out error: $e', name: 'FirebaseService');
    }
  }
}
