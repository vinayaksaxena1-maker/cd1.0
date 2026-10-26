import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.textPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text(l10n.scanTitle, style: AppTypography.headlineMedium(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Prominent Camera Disclosure (Google Play 2026 Compliance)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.saffron.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shield_outlined, color: AppColors.saffron, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.cameraDisclosure,
                      style: AppTypography.bodySmall(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),

            // Card Frame Outline
            Center(
              child: Container(
                width: 320,
                height: 190,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.saffron, width: 2),
                ),
                child: Center(
                  child: Text(
                    l10n.scanInstructions,
                    style: AppTypography.bodySmall(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const Spacer(),

            // Shutter Button
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.reviewTitle)),
                  );
                },
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    color: AppColors.forestGreen,
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 36),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
