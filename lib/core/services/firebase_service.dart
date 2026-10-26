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

  /// Whether current user is in Guest / Offline mode
  bool get isGuest => currentUser == null || currentUser!.isAnonymous;

  /// Initializes Firebase and auto-signs in as Guest anonymously if needed.
  Future<bool> init() async {
    if (_initialized) return _isAvailable;

    try {
      await Firebase.initializeApp();
      _isAvailable = true;
      developer.log('Firebase initialized successfully', name: 'FirebaseService');

      // Auto sign in as Guest (Anonymous) for zero friction
      if (currentUser == null) {
        await continueAsGuest();
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

  /// Guest Login: allows instant use without phone or email requirement
  Future<UserCredential?> continueAsGuest() async {
    if (!_isAvailable || _auth == null) return null;
    try {
      final credential = await _auth!.signInAnonymously();
      developer.log('Guest sign-in success: ${credential.user?.uid}', name: 'FirebaseService');
      return credential;
    } catch (e) {
      developer.log('Guest sign-in error: $e', name: 'FirebaseService');
      return null;
    }
  }

  /// Initiates Phone Number verification
  Future<void> verifyPhone({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    if (!_isAvailable || _auth == null) {
      onError('Firebase unavailable');
      return;
    }

    try {
      await _auth!.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth!.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onError(e.message ?? 'Phone verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      onError(e.toString());
    }
  }

  /// Verifies OTP and signs in
  Future<bool> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    if (!_isAvailable || _auth == null) return false;
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      // Link with existing anonymous guest if present, otherwise sign in
      if (currentUser != null && currentUser!.isAnonymous) {
        await currentUser!.linkWithCredential(credential);
      } else {
        await _auth!.signInWithCredential(credential);
      }
      return true;
    } catch (e) {
      developer.log('OTP verification error: $e', name: 'FirebaseService');
      return false;
    }
  }

  /// Signs out the current user and returns to Guest mode
  Future<void> signOut() async {
    if (!_isAvailable || _auth == null) return;
    try {
      await _auth!.signOut();
      await continueAsGuest();
      developer.log('Firebase sign-out successful, reverted to Guest', name: 'FirebaseService');
    } catch (e) {
      developer.log('Firebase sign-out error: $e', name: 'FirebaseService');
    }
  }
}
