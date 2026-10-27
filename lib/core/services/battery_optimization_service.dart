import 'package:flutter/services.dart';

/// Service managing Android battery optimization exemptions for accurate client meeting alarms
class BatteryOptimizationService {
  static const MethodChannel _channel = MethodChannel('com.cardsaathi/battery_optimization');

  static final BatteryOptimizationService instance = BatteryOptimizationService._internal();
  BatteryOptimizationService._internal();

  /// Checks if CardSaathi is already exempted from Android battery optimizations
  Future<bool> isExempted() async {
    try {
      final bool? result = await _channel.invokeMethod<bool>('isIgnoringBatteryOptimizations');
      return result ?? true;
    } catch (_) {
      return true; // Fallback to true on non-Android or older OS
    }
  }

  /// Opens system battery optimization settings page
  Future<bool> openBatterySettings() async {
    try {
      final bool? result = await _channel.invokeMethod<bool>('openBatterySettings');
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Returns device manufacturer
  Future<String> getManufacturer() async {
    try {
      final String? manufacturer = await _channel.invokeMethod<String>('getManufacturer');
      return manufacturer ?? 'Generic';
    } catch (_) {
      return 'Generic';
    }
  }

  /// Returns OEM-specific instructions to ensure reliable alarm delivery
  String getOemInstructions(String manufacturer) {
    final lower = manufacturer.toLowerCase();
    if (lower.contains('xiaomi') || lower.contains('poco') || lower.contains('redmi')) {
      return '1. Tap "Open Battery Settings" below.\n2. Set Battery Saver to "No restrictions".\n3. Also enable "Autostart" in App Info so meeting alarms fire on time.';
    } else if (lower.contains('samsung')) {
      return '1. Tap "Open Battery Settings" below.\n2. Navigate to "Battery" ➔ "Background usage limits".\n3. Add CardSaathi to "Never sleeping apps".';
    } else if (lower.contains('vivo') || lower.contains('iqoo')) {
      return '1. Tap "Open Battery Settings" below.\n2. Go to "Battery" ➔ "High background power consumption".\n3. Toggle ON for CardSaathi.';
    } else if (lower.contains('oppo') || lower.contains('realme') || lower.contains('oneplus')) {
      return '1. Tap "Open Battery Settings" below.\n2. In App Battery Management, enable "Allow background activity".';
    }
    return '1. Tap "Open Battery Settings" below.\n2. Set battery usage to "Unrestricted" so scheduled client reminders ring accurately.';
  }
}
