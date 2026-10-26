import 'package:hive/hive.dart';
import '../local/hive_registrar.dart';
import '../models/contact_card.dart';

class ContactRepository {
  Box<ContactCard>? _box;

  Future<void> init() async {
    if (_box != null && _box!.isOpen) return;
    _box = await Hive.openBox<ContactCard>(HiveRegistrar.contactCardsBox);
  }

  List<ContactCard> getAllCards() {
    final box = _box ?? Hive.box<ContactCard>(HiveRegistrar.contactCardsBox);
    final list = box.values.toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  ContactCard? getCardById(String id) {
    final box = _box ?? Hive.box<ContactCard>(HiveRegistrar.contactCardsBox);
    return box.get(id);
  }

  List<ContactCard> getCardsByCategory(String categoryId) {
    final box = _box ?? Hive.box<ContactCard>(HiveRegistrar.contactCardsBox);
    return box.values
        .where((card) => card.categoryId == categoryId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<ContactCard> searchCards(String query) {
    if (query.trim().isEmpty) return getAllCards();
    final lower = query.trim().toLowerCase();
    final box = _box ?? Hive.box<ContactCard>(HiveRegistrar.contactCardsBox);

    return box.values.where((card) {
      final matchesName = card.name.toLowerCase().contains(lower);
      final matchesCompany = card.company.toLowerCase().contains(lower);
      final matchesJob = card.jobTitle.toLowerCase().contains(lower);
      final matchesEmail = card.email.toLowerCase().contains(lower);
      final matchesGstin = card.gstin.toLowerCase().contains(lower);
      final matchesNotes = card.notes.toLowerCase().contains(lower);
      final matchesPhones = card.phones.any((p) => p.contains(lower));
      final matchesTags = card.tags.any((t) => t.toLowerCase().contains(lower));
      return matchesName || matchesCompany || matchesJob || matchesEmail ||
          matchesGstin || matchesNotes || matchesPhones || matchesTags;
    }).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  static String normalizePhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    return digits.length >= 10 ? digits.substring(digits.length - 10) : digits;
  }

  ContactCard? findDuplicate({required String name, required List<String> phones}) {
    final box = _box ?? Hive.box<ContactCard>(HiveRegistrar.contactCardsBox);
    final normalizedInputPhones = phones
        .map(normalizePhone)
        .where((p) => p.isNotEmpty)
        .toSet();

    for (final card in box.values) {
      // Check exact name match (case insensitive)
      if (card.name.trim().toLowerCase() == name.trim().toLowerCase() && name.trim().isNotEmpty) {
        return card;
      }
      // Check phone overlap (normalizing standard 10-digit Indian numbers)
      for (final p in card.phones) {
        final normP = normalizePhone(p);
        if (normP.isNotEmpty && normalizedInputPhones.contains(normP)) {
          return card;
        }
      }
    }
    return null;
  }

  Future<void> saveCard(ContactCard card) async {
    final box = _box ?? Hive.box<ContactCard>(HiveRegistrar.contactCardsBox);
    await box.put(card.id, card);
  }

  Future<void> deleteCard(String id) async {
    final box = _box ?? Hive.box<ContactCard>(HiveRegistrar.contactCardsBox);
    await box.delete(id);
  }

  Future<void> clearAllCards() async {
    final box = _box ?? Hive.box<ContactCard>(HiveRegistrar.contactCardsBox);
    await box.clear();
  }
}
