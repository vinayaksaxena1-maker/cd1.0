import 'package:flutter/material.dart';
import '../../../core/services/battery_optimization_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';

/// Google Play 2026 Compliant Battery Optimization Disclosure & Settings Dialog
class BatteryOptimizationDialog extends StatefulWidget {
  const BatteryOptimizationDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => const BatteryOptimizationDialog(),
    );
  }

  @override
  State<BatteryOptimizationDialog> createState() => _BatteryOptimizationDialogState();
}

class _BatteryOptimizationDialogState extends State<BatteryOptimizationDialog> {
  String _manufacturer = 'Generic';
  bool _isExempted = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final manufacturer = await BatteryOptimizationService.instance.getManufacturer();
    final isExempted = await BatteryOptimizationService.instance.isExempted();
    if (mounted) {
      setState(() {
        _manufacturer = manufacturer;
        _isExempted = isExempted;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final instructions = BatteryOptimizationService.instance.getOemInstructions(_manufacturer);

    return AlertDialog(
      backgroundColor: AppColors.surfaceCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _isExempted ? AppColors.surfaceSage : AppColors.errorContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _isExempted ? Icons.battery_charging_full_rounded : Icons.battery_alert_rounded,
              color: _isExempted ? AppColors.forestGreen : AppColors.error,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Timely Alarms & Battery',
              style: AppTypography.titleMedium(),
            ),
          ),
        ],
      ),
      content: _loading
          ? const SizedBox(height: 80, child: Center(child: CircularProgressIndicator()))
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSage,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Detected Device: $_manufacturer',
                      style: AppTypography.bodySmall(color: AppColors.forestGreen),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'To ensure your scheduled client meetings alert you precisely on time when your screen is locked, Android requires battery optimization to be set to "Unrestricted".',
                    style: AppTypography.bodySmall(color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSage.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recommended Steps for $_manufacturer:',
                          style: AppTypography.bodySmall(color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          instructions,
                          style: AppTypography.bodySmall(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Google Play Policy (2026): Exact alarms require system exemption to avoid delayed notifications by OEM battery killers.',
                    style: AppTypography.bodySmall(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel, style: AppTypography.labelLarge(color: AppColors.textSecondary)),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.forestGreen,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () async {
            await BatteryOptimizationService.instance.openBatterySettings();
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
          icon: const Icon(Icons.settings_outlined, size: 18),
          label: const Text('Open Battery Settings'),
        ),
      ],
    );
  }
}
