import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/localization/locale_controller.dart';
import 'google_play_policy_modal.dart';

/// Branded Developer Identity & Made in India Footer for Profile & Settings
class DeveloperInfoFooter extends StatelessWidget {
  const DeveloperInfoFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isHindi = localeController.isHindi;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Made in India Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surfaceSage,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🇮🇳 ', style: TextStyle(fontSize: 16)),
              Text(
                isHindi ? AppConstants.madeInIndiaForWorldHi : AppConstants.madeInIndiaForWorld,
                style: AppTypography.labelLarge(color: AppColors.forestGreen),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Company & Version Identity
        Text(
          '${AppConstants.appName} ${AppConstants.fullVersionString}',
          style: AppTypography.titleMedium(color: AppColors.textPrimary),
        ),
        const SizedBox(height: 2),
        Text(
          'Developed by ${AppConstants.developerName}',
          style: AppTypography.bodySmall(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 6),

        // Google Play Content Policy Link
        InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: () {
            // Tapping opens the interactive Google Play Policy modal with browser action
            GooglePlayPolicyModal.show(context);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified_rounded, size: 14, color: AppColors.forestGreen),
                const SizedBox(width: 4),
                Text(
                  'Google Play Developer Content Policy Compliant',
                  style: AppTypography.labelSmall(color: AppColors.forestGreen).copyWith(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
