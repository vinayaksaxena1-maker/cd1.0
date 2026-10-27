import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';

/// Modal bottom sheet presenting Google Play Developer Content Policy compliance & Innovix Solutions details
class GooglePlayPolicyModal extends StatelessWidget {
  const GooglePlayPolicyModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const GooglePlayPolicyModal(),
    );
  }

  Widget _buildPolicySection({
    required String title,
    required String content,
    required IconData icon,
    String? subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surfaceSage,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: AppColors.forestGreen),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleMedium(color: AppColors.textPrimary)),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTypography.labelSmall(color: AppColors.forestGreen)),
                ],
                const SizedBox(height: 4),
                Text(
                  content,
                  style: AppTypography.bodySmall(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchPolicyUrl(BuildContext context) async {
    final uri = Uri.parse(AppConstants.googlePlayPolicyUrl);
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open external browser: ${AppConstants.googlePlayPolicyUrl}')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error launching policy URL: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.borderSubtle,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.googlePlayPolicy,
                          style: AppTypography.headlineMedium(),
                        ),
                        Text(
                          '${AppConstants.developerName} · ${AppConstants.fullVersionString}',
                          style: AppTypography.bodySmall(color: AppColors.forestGreen),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(height: 24),

              // Developer Entity & Made in India Mission
              _buildPolicySection(
                title: 'Developer Entity & Mission',
                subtitle: AppConstants.madeInIndiaForWorld,
                content: 'CardSaathi is developed by Innovix Solutions in India for users worldwide. Designed to empower MSMEs, traders, and entrepreneurs with sovereign offline-first digital networking.',
                icon: Icons.flag_rounded,
              ),

              // Google Play Content Policy Compliance
              _buildPolicySection(
                title: '1. Developer Content Policy Adherence',
                subtitle: 'https://play.google/developer-content-policy/',
                content: 'This application strictly complies with all Google Play Developer Distribution Agreement terms, content safety guidelines, and prohibited content policies. Contains zero user-generated harmful content.',
                icon: Icons.gavel_rounded,
              ),

              // User Data Transparency & Zero Ad Trackers
              _buildPolicySection(
                title: '2. User Data Safety & Non-Harvesting',
                subtitle: 'Offline-First Encrypted Architecture',
                content: 'All contact card data, meetings, and business profiles remain on-device in encrypted Hive stores. Zero third-party behavioral analytics or advertising tracking SDKs are bundled.',
                icon: Icons.security_rounded,
              ),

              // Explicit Runtime Permission Scopes
              _buildPolicySection(
                title: '3. Minimum Necessary Permissions',
                subtitle: 'Camera, Mic, Exact Alarm & NFC',
                content: '• Camera: Offline Google ML Kit OCR text recognition only.\n• Microphone: Optional 10-second voice memo per card.\n• Exact Alarms: Timely business meeting reminders.\n• NFC: Physical vCard NDEF tag writing on user tap.',
                icon: Icons.checklist_rounded,
              ),

              // Section 4.4 Data Deletion
              _buildPolicySection(
                title: '4. Section 4.4 Permanent Data Deletion',
                subtitle: '1-Click Complete Wipe',
                content: 'Users maintain total control over their data with a permanent 1-click erasure feature in Profile Settings, wiping all local databases, image caches, and optional Firestore cloud backups.',
                icon: Icons.delete_forever_rounded,
              ),

              // Contact & Support
              _buildPolicySection(
                title: '5. Grievance & Developer Contact',
                subtitle: AppConstants.developerEmail,
                content: 'For policy queries, intellectual property notices, or developer inquiries, contact the Innovix Solutions engineering team at ${AppConstants.developerEmail}.',
                icon: Icons.contact_support_rounded,
              ),

              const SizedBox(height: 12),

              // Action Button to Launch Official Google Play Policy
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.forestGreen,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => _launchPolicyUrl(context),
                icon: const Icon(Icons.open_in_browser_rounded),
                label: Text(
                  l10n.openOfficialPolicy,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
              ),

              const SizedBox(height: 16),
              Center(
                child: Text(
                  '${AppConstants.appName} ${AppConstants.fullVersionString}\n${AppConstants.developerTagline}',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodySmall(color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
