import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/services/firebase_service.dart';
import '../../../l10n/app_localizations.dart';

/// Modal bottom sheet providing Guest Login and Phone Number Authentication
class AuthModal extends StatefulWidget {
  const AuthModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => const AuthModal(),
    );
  }

  @override
  State<AuthModal> createState() => _AuthModalState();
}

class _AuthModalState extends State<AuthModal> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  bool _isPhoneMode = false;
  bool _otpSent = false;
  bool _isLoading = false;
  String? _verificationId;
  String? _errorMessage;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _handleGuestLogin() async {
    setState(() => _isLoading = true);
    await FirebaseService.instance.continueAsGuest();
    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.guestMode),
          backgroundColor: AppColors.forestGreen,
        ),
      );
    }
  }

  Future<void> _handleSendOtp() async {
    final rawPhone = _phoneController.text.trim().replaceAll(RegExp(r'\D'), '');
    if (rawPhone.length < 10) {
      setState(() => _errorMessage = 'कृपया 10-अंकों का वैध मोबाइल नंबर दर्ज करें');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final formattedPhone = '+91$rawPhone';
    await FirebaseService.instance.verifyPhone(
      phoneNumber: formattedPhone,
      onCodeSent: (verificationId) {
        if (mounted) {
          setState(() {
            _verificationId = verificationId;
            _otpSent = true;
            _isLoading = false;
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _errorMessage = error;
            _isLoading = false;
          });
        }
      },
    );
  }

  Future<void> _handleVerifyOtp() async {
    final otp = _otpController.text.trim();
    if (otp.length < 6 || _verificationId == null) {
      setState(() => _errorMessage = '6-अंकों का OTP दर्ज करें');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final success = await FirebaseService.instance.verifyOtp(
      verificationId: _verificationId!,
      smsCode: otp,
    );

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('लॉगिन सफल! क्लाउड बैकअप सक्रिय है।'),
            backgroundColor: AppColors.forestGreen,
          ),
        );
      } else {
        setState(() => _errorMessage = 'अमान्य OTP कोड, कृपया पुनः प्रयास करें।');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: AppColors.surfaceSage,
                radius: 20,
                child: Icon(Icons.shield_outlined, color: AppColors.forestGreen),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CardSaathi Account', style: AppTypography.titleMedium()),
                    Text(l10n.guestNotice, style: AppTypography.bodySmall(color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          if (_errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.errorContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _errorMessage!,
                style: AppTypography.bodySmall(color: AppColors.error),
              ),
            ),
            const SizedBox(height: 12),
          ],

          if (!_isPhoneMode) ...[
            // 1. Primary Guest Button (Zero friction, no login required)
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _handleGuestLogin,
              icon: const Icon(Icons.person_outline_rounded, color: Colors.white),
              label: Text(l10n.continueAsGuest, style: AppTypography.titleMedium(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.forestGreen,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),

            // 2. Secondary Phone Login Button
            OutlinedButton.icon(
              onPressed: _isLoading ? null : () => setState(() => _isPhoneMode = true),
              icon: const Icon(Icons.phone_android_rounded, color: AppColors.forestGreen),
              label: Text(l10n.loginWithPhone, style: AppTypography.labelLarge(color: AppColors.forestGreen)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: AppColors.forestGreen),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ] else if (!_otpSent) ...[
            // Phone Number Input
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              decoration: InputDecoration(
                prefixText: '+91 ',
                labelText: l10n.phoneNumber,
                counterText: '',
                prefixIcon: const Icon(Icons.phone_rounded, color: AppColors.forestGreen),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleSendOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.forestGreen,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text(l10n.sendOtp, style: AppTypography.titleMedium(color: Colors.white)),
            ),
            TextButton(
              onPressed: () => setState(() => _isPhoneMode = false),
              child: Text(l10n.continueAsGuest, style: AppTypography.labelLarge(color: AppColors.textSecondary)),
            ),
          ] else ...[
            // OTP Input
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                labelText: l10n.enterOtp,
                counterText: '',
                prefixIcon: const Icon(Icons.lock_clock_rounded, color: AppColors.forestGreen),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleVerifyOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.forestGreen,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text(l10n.verifyOtp, style: AppTypography.titleMedium(color: Colors.white)),
            ),
            TextButton(
              onPressed: () => setState(() => _otpSent = false),
              child: const Text('फ़ोन नंबर बदलें'),
            ),
          ],
        ],
      ),
    );
  }
}
