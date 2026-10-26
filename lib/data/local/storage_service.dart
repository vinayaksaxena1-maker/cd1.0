import '../repositories/category_repository.dart';
import '../repositories/contact_repository.dart';
import '../repositories/reminder_repository.dart';
import '../repositories/user_profile_repository.dart';
import 'hive_registrar.dart';

class StorageService {
  static final StorageService instance = StorageService._internal();
  StorageService._internal();

  final CategoryRepository categoryRepo = CategoryRepository();
  final ContactRepository contactRepo = ContactRepository();
  final ReminderRepository reminderRepo = ReminderRepository();
  final UserProfileRepository userProfileRepo = UserProfileRepository();

  bool _initialized = false;
  bool get isInitialized => _initialized;

  Future<void> initAll() async {
    if (_initialized) return;

    await HiveRegistrar.initHive();
    await categoryRepo.init();
    await contactRepo.init();
    await reminderRepo.init();
    await userProfileRepo.init();

    _initialized = true;
  }
}
