import 'package:flutter/services.dart';
import '../../data/models/contact_card.dart';

/// Representation of a contact selected via the native system contact picker.
class PickedContact {
  final String name;
  final String phone;
  final String? email;

  const PickedContact({
    required this.name,
    required this.phone,
    this.email,
  });

  factory PickedContact.fromMap(Map<dynamic, dynamic> map) {
    final rawName = (map['name'] as String?)?.trim() ?? '';
    final rawPhone = (map['phone'] as String?) ?? '';
    final rawEmail = (map['email'] as String?)?.trim();

    // Standardize phone: keep digits and leading + if present
    final cleanPhone = rawPhone.replaceAll(RegExp(r'[^\d+]'), '');

    return PickedContact(
      name: rawName,
      phone: cleanPhone,
      email: (rawEmail != null && rawEmail.isNotEmpty) ? rawEmail : null,
    );
  }

  /// Converts this picked contact into a new [ContactCard] ready for editing or saving.
  ContactCard toContactCard({required String id, String categoryId = 'other'}) {
    return ContactCard(
      id: id,
      name: name,
      phones: phone.isNotEmpty ? [phone] : const [],
      email: email ?? '',
      categoryId: categoryId,
      createdAt: DateTime.now(),
      notes: 'Imported from phone contacts',
    );
  }
}

/// Service providing 0-permission system contact picking via Android Intent.ACTION_PICK.
/// Complies with Google Play Store 2026 guidelines by avoiding dangerous READ_CONTACTS permissions.
class ContactPickerService {
  static const String channelName = 'com.cardsaathi/contact_picker';

  final MethodChannel _channel;

  static final ContactPickerService instance = ContactPickerService();

  ContactPickerService({MethodChannel? channel})
      : _channel = channel ?? const MethodChannel(channelName);

  MethodChannel get channel => _channel;

  /// Launches native system contact picker and returns the selected contact,
  /// or null if the user cancelled.
  Future<PickedContact?> pickContact() async {
    try {
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>('pickContact');
      if (result == null) return null;
      return PickedContact.fromMap(result);
    } on PlatformException catch (_) {
      return null;
    }
  }
}
