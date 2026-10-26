import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/local/storage_service.dart';
import '../../../data/models/contact_card.dart';
import '../../../l10n/app_localizations.dart';

class CardDetailScreen extends StatefulWidget {
  final String cardId;

  const CardDetailScreen({
    super.key,
    required this.cardId,
  });

  @override
  State<CardDetailScreen> createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends State<CardDetailScreen> {
  ContactCard? _card;
  bool _isLoading = true;
  bool _showFront = true;
  
  // Voice memo player state
  late final AudioPlayer _audioPlayer;
  bool _isPlayingMemo = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlayingMemo = state == PlayerState.playing;
        });
      }
    });
    _loadCard();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _loadCard() {
    final card = StorageService.instance.contactRepo.getCardById(widget.cardId);
    setState(() {
      _card = card;
      _isLoading = false;
    });
  }

  Future<void> _makeCall(String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
    final uri = Uri.parse('tel:$cleanPhone');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (_) {}
  }

  Future<void> _openWhatsApp(String phone, String name) async {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    final clean = digits.length == 10 ? '91$digits' : digits;
    final greeting = 'Namaste $name ji! Great connecting with you. Saved your card on CardSaathi.';
    final uri = Uri.parse('https://wa.me/$clean?text=${Uri.encodeComponent(greeting)}');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  Future<void> _sendEmail(String email) async {
    final uri = Uri.parse('mailto:$email');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (_) {}
  }

  Future<void> _openMaps(String address) async {
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  void _copyToClipboard(String text, String label, AppLocalizations l10n) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label: ${l10n.copiedToClipboard}'),
        backgroundColor: AppColors.forestGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _togglePlayMemo(String path) async {
    try {
      if (_isPlayingMemo) {
        await _audioPlayer.stop();
      } else {
        await _audioPlayer.play(DeviceFileSource(path));
      }
    } catch (_) {}
  }

  Future<void> _deleteVoiceMemo() async {
    if (_card == null) return;
    await _audioPlayer.stop();
    if (_card!.voiceMemoPath != null) {
      final file = File(_card!.voiceMemoPath!);
      if (file.existsSync()) {
        try {
          file.deleteSync();
        } catch (_) {}
      }
    }

    final updatedCard = ContactCard(
      id: _card!.id,
      name: _card!.name,
      company: _card!.company,
      jobTitle: _card!.jobTitle,
      phones: _card!.phones,
      email: _card!.email,
      address: _card!.address,
      gstin: _card!.gstin,
      categoryId: _card!.categoryId,
      voiceMemoPath: null,
      notes: _card!.notes,
      tags: _card!.tags,
      photoFrontPath: _card!.photoFrontPath,
      photoBackPath: _card!.photoBackPath,
      createdAt: _card!.createdAt,
      updatedAt: DateTime.now(),
      website: _card!.website,
    );

    await StorageService.instance.contactRepo.saveCard(updatedCard);
    setState(() {
      _card = updatedCard;
    });
  }

  void _shareCard() {
    if (_card == null) return;
    final lines = [
      _card!.name,
      if (_card!.jobTitle.isNotEmpty) _card!.jobTitle,
      if (_card!.company.isNotEmpty) '🏢 ${_card!.company}',
      if (_card!.phones.isNotEmpty) '📞 ${_card!.phones.join(", ")}',
      if (_card!.email.isNotEmpty) '✉️ ${_card!.email}',
      if (_card!.website.isNotEmpty) '🌐 ${_card!.website}',
      if (_card!.gstin.isNotEmpty) '🆔 GSTIN: ${_card!.gstin}',
      if (_card!.address.isNotEmpty) '📍 ${_card!.address}',
      '',
      'Shared via CardSaathi — Your Smart Business Card Partner',
    ];
    SharePlus.instance.share(
      ShareParams(
        text: lines.join('\n'),
        subject: '${_card!.name} Visiting Card',
      ),
    );
  }

  Future<void> _confirmDelete(AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteCard),
        content: Text(l10n.deleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.confirm, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await StorageService.instance.contactRepo.deleteCard(widget.cardId);
      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_card?.name ?? "Card"} deleted'),
            backgroundColor: AppColors.forestGreen,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.forestGreen)),
      );
    }

    if (_card == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.cardDetails)),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.credit_card_off_outlined, size: 64, color: AppColors.textSecondary),
              const SizedBox(height: 16),
              Text(l10n.cardNotFound, style: AppTypography.titleMedium()),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    final category = StorageService.instance.categoryRepo.getCategoryById(_card!.categoryId);
    final categoryName = category != null
        ? (isHindi ? category.nameHi : category.nameEn)
        : null;

    final primaryPhone = _card!.phones.isNotEmpty ? _card!.phones.first : '';
    final hasMemo = _card!.voiceMemoPath != null &&
        _card!.voiceMemoPath!.isNotEmpty &&
        File(_card!.voiceMemoPath!).existsSync();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.cardDetails, style: AppTypography.headlineMedium()),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: l10n.shareContact,
            onPressed: _shareCard,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            tooltip: l10n.deleteCard,
            onPressed: () => _confirmDelete(l10n),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Visiting Card High-Res Pinch-To-Zoom Viewer
            _buildCardImageViewer(l10n),
            const SizedBox(height: 16),

            // Header Info (Name, Title, Company, Category)
            _buildContactHeader(categoryName),
            const SizedBox(height: 16),

            // One-Tap Quick Actions Bar
            _buildQuickActionsBar(primaryPhone, l10n),
            const SizedBox(height: 20),

            // Indian Business Credentials (GSTIN, PAN)
            if (_card!.gstin.isNotEmpty) ...[
              _buildCredentialsSection(l10n),
              const SizedBox(height: 16),
            ],

            // Embedded Voice Memo Player
            if (hasMemo) ...[
              _buildVoiceMemoCard(l10n),
              const SizedBox(height: 16),
            ],

            // Contact Information Details
            _buildContactDetailsCard(l10n),
            const SizedBox(height: 16),

            // Notes & Tags
            if (_card!.notes.isNotEmpty || _card!.tags.isNotEmpty)
              _buildNotesAndTagsSection(l10n),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildCardImageViewer(AppLocalizations l10n) {
    final frontPath = _card!.photoFrontPath;
    final backPath = _card!.photoBackPath;
    final hasFront = frontPath != null && frontPath.isNotEmpty && File(frontPath).existsSync();
    final hasBack = backPath != null && backPath.isNotEmpty && File(backPath).existsSync();

    final currentImagePath = _showFront ? frontPath : backPath;
    final hasCurrentImage = _showFront ? hasFront : hasBack;

    return Column(
      children: [
        if (hasFront && hasBack)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: Text(l10n.viewFront),
                  selected: _showFront,
                  onSelected: (val) => setState(() => _showFront = true),
                  selectedColor: AppColors.forestGreen,
                  labelStyle: TextStyle(color: _showFront ? Colors.white : AppColors.textPrimary),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: Text(l10n.viewBack),
                  selected: !_showFront,
                  onSelected: (val) => setState(() => _showFront = false),
                  selectedColor: AppColors.forestGreen,
                  labelStyle: TextStyle(color: !_showFront ? Colors.white : AppColors.textPrimary),
                ),
              ],
            ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            height: 210,
            decoration: BoxDecoration(
              color: AppColors.surfaceSage,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderSubtle, width: 1),
            ),
            child: hasCurrentImage
                ? InteractiveViewer(
                    panEnabled: true,
                    minScale: 1.0,
                    maxScale: 4.0,
                    child: Image.file(
                      File(currentImagePath!),
                      fit: BoxFit.contain,
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.credit_card, size: 54, color: AppColors.textSecondary),
                        const SizedBox(height: 8),
                        Text(l10n.noCardImage, style: AppTypography.bodySmall()),
                      ],
                    ),
                  ),
          ),
        ),
        if (hasCurrentImage)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              l10n.pinchToZoomHint,
              style: AppTypography.bodySmall(color: AppColors.textSecondary),
            ),
          ),
      ],
    );
  }

  Widget _buildContactHeader(String? categoryName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_card!.name, style: AppTypography.headlineLarge()),
        if (_card!.jobTitle.isNotEmpty || _card!.company.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            [_card!.jobTitle, _card!.company].where((s) => s.isNotEmpty).join(' • '),
            style: AppTypography.bodyLarge(color: AppColors.textSecondary),
          ),
        ],
        if (categoryName != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.forestGreen.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              categoryName,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.forestGreen,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildQuickActionsBar(String phone, AppLocalizations l10n) {
    final hasPhone = phone.isNotEmpty;
    final hasEmail = _card!.email.isNotEmpty;
    final hasAddress = _card!.address.isNotEmpty;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionCircle(
          icon: Icons.phone,
          label: l10n.tapToCall,
          color: AppColors.forestGreen,
          enabled: hasPhone,
          onTap: () => _makeCall(phone),
        ),
        _buildActionCircle(
          icon: Icons.chat_bubble,
          label: l10n.tapToWhatsApp,
          color: AppColors.forestGreen,
          enabled: hasPhone,
          onTap: () => _openWhatsApp(phone, _card!.name),
        ),
        _buildActionCircle(
          icon: Icons.email_outlined,
          label: l10n.sendEmail,
          color: AppColors.primary,
          enabled: hasEmail,
          onTap: () => _sendEmail(_card!.email),
        ),
        _buildActionCircle(
          icon: Icons.location_on_outlined,
          label: l10n.openMaps,
          color: AppColors.primary,
          enabled: hasAddress,
          onTap: () => _openMaps(_card!.address),
        ),
      ],
    );
  }

  Widget _buildActionCircle({
    required IconData icon,
    required String label,
    required Color color,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: enabled ? color.withValues(alpha: 0.12) : AppColors.borderSubtle.withValues(alpha: 0.3),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: enabled ? onTap : null,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Icon(icon, color: enabled ? color : AppColors.textSecondary, size: 24),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: enabled ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildCredentialsSection(AppLocalizations l10n) {
    final gstin = _card!.gstin;
    final pan = gstin.length == 15 ? gstin.substring(2, 12) : '';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified, color: AppColors.forestGreen, size: 20),
              const SizedBox(width: 8),
              Text(
                'GSTIN: $gstin',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.forestGreen,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.copy, size: 18),
                tooltip: l10n.copyGstin,
                onPressed: () => _copyToClipboard(gstin, 'GSTIN', l10n),
              ),
            ],
          ),
          if (pan.isNotEmpty) ...[
            const Divider(height: 16),
            Row(
              children: [
                const Icon(Icons.badge_outlined, color: AppColors.textSecondary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'PAN: $pan',
                  style: AppTypography.titleMedium(),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.copy, size: 18),
                  tooltip: 'Copy PAN',
                  onPressed: () => _copyToClipboard(pan, 'PAN', l10n),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVoiceMemoCard(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        children: [
          IconButton.filled(
            style: IconButton.styleFrom(
              backgroundColor: AppColors.forestGreen,
              foregroundColor: Colors.white,
            ),
            icon: Icon(_isPlayingMemo ? Icons.pause : Icons.play_arrow),
            onPressed: () => _togglePlayMemo(_card!.voiceMemoPath!),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.audioMemo, style: AppTypography.titleMedium()),
                Text(
                  _isPlayingMemo ? 'Playing offline memo...' : '10s offline voice note attached',
                  style: AppTypography.bodySmall(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
            tooltip: l10n.deleteMemo,
            onPressed: _deleteVoiceMemo,
          ),
        ],
      ),
    );
  }

  Widget _buildContactDetailsCard(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        children: [
          if (_card!.phones.isNotEmpty)
            for (final phone in _card!.phones)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.phone_outlined, color: AppColors.forestGreen),
                title: Text(phone),
                trailing: IconButton(
                  icon: const Icon(Icons.copy, size: 18),
                  onPressed: () => _copyToClipboard(phone, l10n.phoneNumber, l10n),
                ),
              ),
          if (_card!.email.isNotEmpty)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.email_outlined, color: AppColors.forestGreen),
              title: Text(_card!.email),
              trailing: IconButton(
                icon: const Icon(Icons.copy, size: 18),
                onPressed: () => _copyToClipboard(_card!.email, l10n.emailAddress, l10n),
              ),
            ),
          if (_card!.website.isNotEmpty)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.language_outlined, color: AppColors.forestGreen),
              title: Text(_card!.website),
              trailing: IconButton(
                icon: const Icon(Icons.open_in_new, size: 18),
                onPressed: () async {
                  final url = _card!.website.startsWith('http') ? _card!.website : 'https://${_card!.website}';
                  final uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) await launchUrl(uri);
                },
              ),
            ),
          if (_card!.address.isNotEmpty)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.location_on_outlined, color: AppColors.forestGreen),
              title: Text(_card!.address),
              trailing: IconButton(
                icon: const Icon(Icons.copy, size: 18),
                onPressed: () => _copyToClipboard(_card!.address, l10n.address, l10n),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNotesAndTagsSection(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_card!.notes.isNotEmpty) ...[
            Text(l10n.notes, style: AppTypography.titleMedium()),
            const SizedBox(height: 6),
            Text(_card!.notes, style: AppTypography.bodyMedium()),
            const SizedBox(height: 12),
          ],
          if (_card!.tags.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: _card!.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSage,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
