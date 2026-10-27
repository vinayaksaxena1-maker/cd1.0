import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import '../../../core/services/nfc_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';

enum NfcWriteState { idle, scanning, writing, success, error, unsupported }

/// Modal bottom sheet guiding the user to write their digital card to an NFC tag
class NfcWriteModal extends StatefulWidget {
  final String vCardString;
  final VoidCallback onFallbackToQr;

  const NfcWriteModal({
    super.key,
    required this.vCardString,
    required this.onFallbackToQr,
  });

  static void show(
    BuildContext context, {
    required String vCardString,
    required VoidCallback onFallbackToQr,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NfcWriteModal(
        vCardString: vCardString,
        onFallbackToQr: onFallbackToQr,
      ),
    );
  }

  @override
  State<NfcWriteModal> createState() => _NfcWriteModalState();
}

class _NfcWriteModalState extends State<NfcWriteModal> with SingleTickerProviderStateMixin {
  NfcWriteState _state = NfcWriteState.idle;
  String _statusMessage = 'Checking NFC availability...';
  String? _errorMessage;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _startNfcProcess();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    NfcService.instance.stopSession();
    super.dispose();
  }

  Future<void> _startNfcProcess() async {
    final availability = await NfcService.instance.checkAvailability();
    if (!mounted) return;

    if (availability == NfcAvailability.unsupported) {
      setState(() {
        _state = NfcWriteState.unsupported;
        _statusMessage = 'NFC is not supported on this device.';
      });
      return;
    }

    if (availability == NfcAvailability.disabled) {
      setState(() {
        _state = NfcWriteState.error;
        _errorMessage = 'NFC is turned off. Please turn on NFC in phone settings.';
      });
      return;
    }

    setState(() {
      _state = NfcWriteState.scanning;
      _statusMessage = 'Hold physical NFC card or tag to the back of phone...';
    });

    await NfcService.instance.writeVCardToTag(
      vCardString: widget.vCardString,
      onStatus: (msg) {
        if (mounted) setState(() => _statusMessage = msg);
      },
      onComplete: (success, err) {
        if (!mounted) return;
        if (success) {
          setState(() {
            _state = NfcWriteState.success;
            _statusMessage = 'Visiting card written to NFC tag successfully!';
          });
        } else {
          setState(() {
            _state = NfcWriteState.error;
            _errorMessage = err ?? 'Failed to write card to NFC tag.';
          });
        }
      },
    );
  }

  Widget _buildStatusIcon() {
    switch (_state) {
      case NfcWriteState.idle:
      case NfcWriteState.scanning:
      case NfcWriteState.writing:
        return ScaleTransition(
          scale: Tween<double>(begin: 0.9, end: 1.1).animate(
            CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
          ),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.surfaceSage,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.forestGreen, width: 2),
            ),
            child: const Icon(Icons.contactless_rounded, size: 52, color: AppColors.forestGreen),
          ),
        );
      case NfcWriteState.success:
        return Container(
          width: 90,
          height: 90,
          decoration: const BoxDecoration(
            color: AppColors.forestGreen,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_rounded, size: 56, color: Colors.white),
        );
      case NfcWriteState.error:
      case NfcWriteState.unsupported:
        return Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: AppColors.errorContainer.withValues(alpha: 0.4),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.nfc_rounded, size: 48, color: AppColors.error),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderSubtle,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text('Write Card to NFC', style: AppTypography.titleMedium()),
          const SizedBox(height: 6),
          Text(
            'Tap physical NFC card or tag to share contact instantly',
            style: AppTypography.bodySmall(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          _buildStatusIcon(),
          const SizedBox(height: 20),

          Text(
            _state == NfcWriteState.error || _state == NfcWriteState.unsupported
                ? (_errorMessage ?? _statusMessage)
                : _statusMessage,
            style: AppTypography.bodyMedium(
              color: _state == NfcWriteState.error || _state == NfcWriteState.unsupported
                  ? AppColors.error
                  : (_state == NfcWriteState.success ? AppColors.forestGreen : AppColors.textPrimary),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          if (_state == NfcWriteState.unsupported || _state == NfcWriteState.error) ...[
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onFallbackToQr();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.forestGreen,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.qr_code_rounded),
              label: const Text('Use QR Code Instead'),
            ),
            const SizedBox(height: 12),
          ],

          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(44),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              _state == NfcWriteState.success ? l10n.cancel : l10n.cancel,
              style: AppTypography.labelLarge(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
