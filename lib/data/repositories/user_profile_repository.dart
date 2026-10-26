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
    final box = _box ?? Hive.box<UserProfile>(HiveRegistrar.userProfileBox);
    return box.get(_profileKey);
  }

  Future<void> saveProfile(UserProfile profile) async {
    final box = _box ?? Hive.box<UserProfile>(HiveRegistrar.userProfileBox);
    await box.put(_profileKey, profile);
  }

  Future<void> clearProfile() async {
    final box = _box ?? Hive.box<UserProfile>(HiveRegistrar.userProfileBox);
    await box.delete(_profileKey);
  }
}
