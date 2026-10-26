import 'package:hive/hive.dart';
import '../local/hive_registrar.dart';
import '../models/user_profile.dart';

class UserProfileRepository {
  static const String _profileKey = 'primary_user_profile';
  Box<UserProfile>? _box;

  Future<void> init() async {
    if (_box != null && _box!.isOpen) return;
    _box = await Hive.openBox<UserProfile>(HiveRegistrar.userProfileBox);
  }

  UserProfile? getProfile() {
    if (_box == null && !Hive.isBoxOpen(HiveRegistrar.userProfileBox)) {
      return null;
    }
    final box = _box ?? Hive.box<UserProfile>(HiveRegistrar.userProfileBox);
    return box.get(_profileKey);
  }

  Future<void> saveProfile(UserProfile profile) async {
    final box = (_box != null && _box!.isOpen)
        ? _box!
        : (Hive.isBoxOpen(HiveRegistrar.userProfileBox)
            ? Hive.box<UserProfile>(HiveRegistrar.userProfileBox)
            : await Hive.openBox<UserProfile>(HiveRegistrar.userProfileBox));
    await box.put(_profileKey, profile);
  }

  Future<void> clearProfile() async {
    if (_box == null && !Hive.isBoxOpen(HiveRegistrar.userProfileBox)) {
      return;
    }
    final box = _box ?? Hive.box<UserProfile>(HiveRegistrar.userProfileBox);
    await box.delete(_profileKey);
  }
}
