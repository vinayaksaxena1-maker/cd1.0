import 'package:hive/hive.dart';
import '../local/hive_registrar.dart';
import '../models/category.dart';
import 'contact_repository.dart';

class CategoryRepository {
  Box<Category>? _box;

  Future<void> init() async {
    if (_box != null && _box!.isOpen) return;

    _box = await Hive.openBox<Category>(HiveRegistrar.categoriesBox);

    // Auto-seed default 20 commercial categories if empty
    if (_box!.isEmpty) {
      await seedDefaultCategories();
    }
  }

  Future<void> seedDefaultCategories() async {
    final box = _box ?? await Hive.openBox<Category>(HiveRegistrar.categoriesBox);
    final entries = {
      for (final cat in Category.defaultCategories) cat.id: cat,
    };
    await box.putAll(entries);
  }

  List<Category> getAllCategories() {
    final box = _box ?? Hive.box<Category>(HiveRegistrar.categoriesBox);
    final categories = box.values.toList();
    // Sort default categories first, then custom categories alphabetically
    categories.sort((a, b) {
      if (a.isCustom != b.isCustom) {
        return a.isCustom ? 1 : -1;
      }
      return a.nameEn.compareTo(b.nameEn);
    });
    return categories;
  }

  Category? getCategoryById(String id) {
    final box = _box ?? Hive.box<Category>(HiveRegistrar.categoriesBox);
    return box.get(id);
  }

  Future<void> addCustomCategory({
    required String id,
    required String nameEn,
    required String nameHi,
    required int iconCode,
  }) async {
    final box = _box ?? Hive.box<Category>(HiveRegistrar.categoriesBox);
    final category = Category(
      id: id,
      nameEn: nameEn,
      nameHi: nameHi,
      iconCode: iconCode,
      isCustom: true,
      cardCount: 0,
    );
    await box.put(id, category);
  }

  Future<void> updateCategory(Category category) async {
    final box = _box ?? Hive.box<Category>(HiveRegistrar.categoriesBox);
    await box.put(category.id, category);
  }

  Future<bool> deleteCategory(String id, {ContactRepository? contactRepo}) async {
    final box = _box ?? Hive.box<Category>(HiveRegistrar.categoriesBox);
    final category = box.get(id);
    // Protect default categories from being deleted
    if (category == null || !category.isCustom) {
      return false;
    }

    // Safe deletion: reassign any existing cards in this category to 'other'
    if (contactRepo != null) {
      final associatedCards = contactRepo.getCardsByCategory(id);
      for (final card in associatedCards) {
        await contactRepo.saveCard(card.copyWith(categoryId: 'other'));
      }
    }

    await box.delete(id);
    return true;
  }

  Future<void> updateCardCount(String categoryId, int delta) async {
    final box = _box ?? Hive.box<Category>(HiveRegistrar.categoriesBox);
    final category = box.get(categoryId);
    if (category != null) {
      final newCount = (category.cardCount + delta).clamp(0, 999999);
      await box.put(categoryId, category.copyWith(cardCount: newCount));
    }
  }
}
