import 'package:flutter/material.dart';
import '../../../core/services/card_export_service.dart';
import '../../../core/services/vcard_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/contact_card.dart';
import '../../../l10n/app_localizations.dart';
import 'nfc_write_modal.dart';
import 'vcard_qr_modal.dart';

/// Bottom action buttons for Digital Card: WhatsApp export, vCard QR, and NFC Tag Writing
class DigitalCardActionButtons extends StatelessWidget {
  final GlobalKey repaintKey;
  final ContactCard? selectedCard;

  const DigitalCardActionButtons({
    super.key,
    required this.repaintKey,
    required this.selectedCard,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF25D366), // WhatsApp Green
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          onPressed: () {
            if (selectedCard != null) {
              CardExportService.shareCardOnWhatsApp(
                boundaryKey: repaintKey,
                card: selectedCard!,
                context: context,
              );
            }
          },
          icon: const Icon(Icons.share_rounded, size: 20),
          label: Text(
            l10n.shareWhatsAppCard,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            side: const BorderSide(color: AppColors.forestGreen, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          onPressed: () {
            if (selectedCard != null) {
              VCardQrModal.show(context, selectedCard!);
            }
          },
          icon: const Icon(Icons.qr_code_2_rounded, color: AppColors.forestGreen),
          label: Text(
            l10n.offlineVCardQr,
            style: const TextStyle(
              color: AppColors.forestGreen,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            side: const BorderSide(color: AppColors.forestGreen, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          onPressed: () {
            if (selectedCard != null) {
              NfcWriteModal.show(
                context,
                vCardString: VCardService.generateVCardString(selectedCard!),
                onFallbackToQr: () {
                  if (selectedCard != null) {
                    VCardQrModal.show(context, selectedCard!);
                  }
                },
              );
            }
          },
          icon: const Icon(Icons.contactless_rounded, color: AppColors.forestGreen),
          label: const Text(
            'Write to Physical NFC Card',
            style: TextStyle(
              color: AppColors.forestGreen,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
