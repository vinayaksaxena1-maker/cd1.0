import 'package:flutter/material.dart';
import '../../../core/services/voice_memo_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';

class VoiceMemoWidget extends StatefulWidget {
  final String? initialMemoPath;
  final ValueChanged<String?> onMemoChanged;
  final VoiceMemoService? service;

  const VoiceMemoWidget({
    super.key,
    this.initialMemoPath,
    required this.onMemoChanged,
    this.service,
  });

  @override
  State<VoiceMemoWidget> createState() => _VoiceMemoWidgetState();
}

class _VoiceMemoWidgetState extends State<VoiceMemoWidget>
    with SingleTickerProviderStateMixin {
  late final VoiceMemoService _service;
  late final bool _internalService;
  late AnimationController _pulseController;

  String? _memoPath;
  bool _isRecording = false;
  bool _isPlaying = false;
  int _secondsRemaining = VoiceMemoService.maxDurationSeconds;

  @override
  void initState() {
    super.initState();
    _memoPath = widget.initialMemoPath;
    _internalService = widget.service == null;
    _service = widget.service ?? VoiceMemoService();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _service.recordingStateStream.listen((recording) {
      if (mounted) {
        setState(() => _isRecording = recording);
        if (recording) {
          _pulseController.repeat(reverse: true);
        } else {
          _pulseController.stop();
          if (_service.currentFilePath != null) {
            setState(() => _memoPath = _service.currentFilePath);
            widget.onMemoChanged(_memoPath);
          }
        }
      }
    });

    _service.playingStateStream.listen((playing) {
      if (mounted) {
        setState(() => _isPlaying = playing);
      }
    });

    _service.secondsStream.listen((sec) {
      if (mounted) {
        setState(() => _secondsRemaining = sec);
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    if (_internalService) {
      _service.dispose();
    }
    super.dispose();
  }

  Future<void> _showMicDisclosureAndRecord() async {
    final l10n = AppLocalizations.of(context)!;

    final shouldRecord = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.canvasIvory,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surfaceSage,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.mic, color: AppColors.forestGreen, size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                l10n.recordVoiceMemo,
                style: AppTypography.titleMedium(color: AppColors.forestGreen),
              ),
            ),
          ],
        ),
        content: Text(
          l10n.voiceDisclosure,
          style: AppTypography.bodyMedium(color: AppColors.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel, style: AppTypography.labelMedium(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.forestGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.agreeAndEnable, style: AppTypography.labelMedium(color: Colors.white)),
          ),
        ],
      ),
    );

    if (shouldRecord == true) {
      await _service.startRecording();
    }
  }

  Future<void> _stopRecording() async {
    final path = await _service.stopRecording();
    if (mounted) {
      setState(() => _memoPath = path);
      widget.onMemoChanged(_memoPath);
    }
  }

  Future<void> _togglePlayback() async {
    if (_memoPath == null) return;
    if (_isPlaying) {
      await _service.stop();
    } else {
      await _service.play(_memoPath!);
    }
  }

  Future<void> _deleteMemo() async {
    if (_memoPath != null) {
      final oldPath = _memoPath!;
      setState(() {
        _memoPath = null;
        _isPlaying = false;
      });
      widget.onMemoChanged(null);
      await _service.deleteMemo(oldPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // 1. Recording In-Progress State
    if (_isRecording) {
      final elapsed = VoiceMemoService.maxDurationSeconds - _secondsRemaining;
      final progress = elapsed / VoiceMemoService.maxDurationSeconds;

      return Card(
        color: AppColors.surfaceSage,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.saffron, width: 1.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      FadeTransition(
                        opacity: _pulseController,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.recording,
                        style: AppTypography.labelMedium(color: AppColors.forestGreen),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.canvasIvory,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text(
                      '00:0${_secondsRemaining}s',
                      style: AppTypography.labelSmall(color: AppColors.forestGreen),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                backgroundColor: AppColors.borderSubtle,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.saffron),
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _stopRecording,
                icon: const Icon(Icons.stop_circle_outlined, size: 20),
                label: Text(l10n.tapToStop, style: AppTypography.labelSmall(color: AppColors.error)),
              ),
            ],
          ),
        ),
      );
    }

    // 2. Memo Saved / Playback State
    if (_memoPath != null) {
      return Card(
        color: AppColors.surfaceSage,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderSubtle),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Play / Stop Icon Button
              IconButton.filled(
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.forestGreen,
                  foregroundColor: Colors.white,
                ),
                icon: Icon(_isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded),
                onPressed: _togglePlayback,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.voiceMemoSaved,
                      style: AppTypography.labelMedium(color: AppColors.forestGreen),
                    ),
                    Text(
                      _isPlaying ? 'Playing memo...' : '10s offline audio note',
                      style: AppTypography.bodySmall(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              // Delete Memo Button
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 22),
                tooltip: l10n.deleteMemo,
                onPressed: _deleteMemo,
              ),
            ],
          ),
        ),
      );
    }

    // 3. Idle / Record Button State
    return Card(
      elevation: 0,
      color: AppColors.surfaceSage.withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.borderSubtle),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surfaceSage,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.mic_none_outlined, color: AppColors.forestGreen, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.recordVoiceMemo, style: AppTypography.labelLarge(color: AppColors.forestGreen)),
                  Text(
                    '10-second quick context audio memo',
                    style: AppTypography.bodySmall(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(80, 40),
                backgroundColor: AppColors.forestGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              ),
              onPressed: _showMicDisclosureAndRecord,
              child: const Text('Record'),
            ),
          ],
        ),
      ),
    );
  }
}
