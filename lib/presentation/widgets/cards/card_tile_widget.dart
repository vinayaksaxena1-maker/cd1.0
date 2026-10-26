import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/local/storage_service.dart';
import '../../../data/models/contact_card.dart';

class CardTileWidget extends StatelessWidget {
  final ContactCard card;
  final VoidCallback? onTap;

  const CardTileWidget({
    super.key,
    required this.card,
    this.onTap,
  });

  String _getInitials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'CS';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return trimmed.substring(0, trimmed.length >= 2 ? 2 : 1).toUpperCase();
  }

  Future<void> _makeCall(String phone, BuildContext context) async {
    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
    final uri = Uri.parse('tel:$cleanPhone');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Cannot call $phone')),
          );
        }
      }
    } catch (_) {}
  }

  Future<void> _openWhatsApp(String phone, BuildContext context) async {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    final clean = digits.length == 10 ? '91$digits' : digits;
    const greeting = 'Namaste! Connecting via CardSaathi.';
    final uri = Uri.parse('https://wa.me/$clean?text=${Uri.encodeComponent(greeting)}');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Cannot open WhatsApp for $phone')),
          );
        }
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = card.photoFrontPath != null &&
        card.photoFrontPath!.isNotEmpty &&
        File(card.photoFrontPath!).existsSync();

    final hasPhone = card.phones.isNotEmpty && card.phones.first.trim().isNotEmpty;
    final primaryPhone = hasPhone ? card.phones.first.trim() : '';
    final category = StorageService.instance.categoryRepo.getCategoryById(card.categoryId);
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';
    final categoryName = category != null
        ? (isHindi ? category.nameHi : category.nameEn)
        : null;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.borderSubtle, width: 1),
      ),
      color: AppColors.surfaceCard,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar or Image Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 54,
                  height: 54,
                  child: hasImage
                      ? Image.file(
                          File(card.photoFrontPath!),
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => _buildInitialsAvatar(),
                        )
                      : _buildInitialsAvatar(),
                ),
              ),
              const SizedBox(width: 14),

              // Content Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name & Voice memo badge
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            card.name.isNotEmpty ? card.name : 'Unknown Contact',
                            style: AppTypography.titleMedium(color: AppColors.textPrimary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (card.voiceMemoPath != null && card.voiceMemoPath!.isNotEmpty) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.forestGreen.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.mic, size: 12, color: AppColors.forestGreen),
                                SizedBox(width: 2),
                                Text(
                                  'Voice',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.forestGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),

                    // Company & Job title
                    if (card.company.isNotEmpty || card.jobTitle.isNotEmpty)
                      Text(
                        [
                          if (card.jobTitle.isNotEmpty) card.jobTitle,
                          if (card.company.isNotEmpty) card.company,
                        ].join(' • '),
                        style: AppTypography.bodySmall(color: AppColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 6),

                    // Badges: Category & GSTIN
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        if (categoryName != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceSage,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              categoryName,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        if (card.gstin.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.forestGreen.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.verified, size: 12, color: AppColors.forestGreen),
                                const SizedBox(width: 4),
                                Text(
                                  card.gstin,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.forestGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // Quick Action Buttons
              if (hasPhone) ...[
                const SizedBox(width: 8),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // WhatsApp Button (48x48 touch zone)
                    SizedBox(
                      width: 44,
                      height: 44,
                      child: IconButton(
                        icon: const Icon(Icons.chat_bubble_outline, color: AppColors.forestGreen, size: 20),
                        tooltip: 'WhatsApp',
                        padding: EdgeInsets.zero,
                        onPressed: () => _openWhatsApp(primaryPhone, context),
                      ),
                    ),
                    // Call Button (48x48 touch zone)
                    SizedBox(
                      width: 44,
                      height: 44,
                      child: IconButton(
                        icon: const Icon(Icons.call_outlined, color: AppColors.forestGreen, size: 20),
                        tooltip: 'Call',
                        padding: EdgeInsets.zero,
                        onPressed: () => _makeCall(primaryPhone, context),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInitialsAvatar() {
    return Container(
      color: AppColors.forestGreen.withValues(alpha: 0.12),
      alignment: Alignment.center,
      child: Text(
        _getInitials(card.name),
        style: const TextStyle(
          color: AppColors.forestGreen,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
