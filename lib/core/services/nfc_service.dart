import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:nfc_manager/ndef_record.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/nfc_manager_android.dart';

/// Service managing hardware NFC NDEF vCard writing and card sharing
class NfcService {
  static final NfcService instance = NfcService._internal();
  NfcService._internal();

  /// Checks if NFC hardware is available and enabled
  Future<NfcAvailability> checkAvailability() async {
    try {
      return await NfcManager.instance.checkAvailability();
    } catch (_) {
      return NfcAvailability.unsupported;
    }
  }

  /// Writes standard RFC 6350 vCard to a physical NFC tag/card held near the phone
  Future<void> writeVCardToTag({
    required String vCardString,
    required void Function(String status) onStatus,
    required void Function(bool success, String? error) onComplete,
  }) async {
    final availability = await checkAvailability();
    if (availability == NfcAvailability.unsupported) {
      onComplete(false, 'NFC hardware is not supported on this device.');
      return;
    }

    if (availability == NfcAvailability.disabled) {
      onComplete(false, 'NFC is turned off. Please enable NFC in device settings.');
      return;
    }

    onStatus('Hold NFC card or tag to the back of your phone...');

    try {
      final vCardBytes = Uint8List.fromList(utf8.encode(vCardString));
      final mimeTypeBytes = Uint8List.fromList(utf8.encode('text/vcard'));

      final record = NdefRecord(
        typeNameFormat: TypeNameFormat.media,
        type: mimeTypeBytes,
        identifier: Uint8List(0),
        payload: vCardBytes,
      );

      final message = NdefMessage(records: [record]);

      await NfcManager.instance.startSession(
        pollingOptions: {NfcPollingOption.iso14443, NfcPollingOption.iso15693},
        onDiscovered: (NfcTag tag) async {
          try {
            onStatus('NFC Tag detected! Writing digital card...');

            final ndef = NdefAndroid.from(tag);
            if (ndef == null) {
              await stopSession();
              onComplete(false, 'Detected tag is not NDEF formatted.');
              return;
            }

            if (!ndef.isWritable) {
              await stopSession();
              onComplete(false, 'This NFC card is write-protected (Read-Only).');
              return;
            }

            if (ndef.maxSize < message.byteLength) {
              await stopSession();
              onComplete(false, 'NFC tag storage is too small (${ndef.maxSize} bytes). vCard needs ${message.byteLength} bytes.');
              return;
            }

            await ndef.writeNdefMessage(message);
            await stopSession();
            onComplete(true, null);
          } catch (e) {
            await stopSession();
            onComplete(false, 'Write error: $e');
          }
        },
      );
    } catch (e) {
      onComplete(false, 'Failed to start NFC session: $e');
    }
  }

  /// Stops any active NFC discovery session
  Future<void> stopSession() async {
    try {
      await NfcManager.instance.stopSession();
    } catch (_) {}
  }
}
