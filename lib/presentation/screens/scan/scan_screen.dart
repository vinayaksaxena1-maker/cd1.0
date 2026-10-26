import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/scan/card_guide_overlay.dart';
import '../../widgets/scan/camera_disclosure_dialog.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with WidgetsBindingObserver {
  CameraController? _cameraController;
  List<CameraDescription> _availableCameras = [];
  bool _isCameraInitialized = false;
  bool _isProcessing = false;
  FlashMode _flashMode = FlashMode.auto;
  bool _isFrontSide = true;

  String? _frontImagePath;
  String? _backImagePath;

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPermissionsAndInitCamera();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final cameraController = _cameraController;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initSelectedCamera(cameraController.description);
    }
  }

  Future<void> _checkPermissionsAndInitCamera() async {
    try {
      _availableCameras = await availableCameras();
      if (_availableCameras.isNotEmpty) {
        // Show Google Play 2026 Prominent Disclosure if opening camera
        if (mounted) {
          await CameraDisclosureDialog.show(
            context,
            onAgree: () => _initSelectedCamera(_availableCameras.first),
            onUseGallery: _pickFromGallery,
          );
        }
      }
    } catch (e) {
      debugPrint('No physical camera or error querying: $e');
    }
  }

  Future<void> _initSelectedCamera(CameraDescription camera) async {
    final controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await controller.initialize();
      await controller.setFlashMode(_flashMode);
      if (mounted) {
        setState(() {
          _cameraController = controller;
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;

    FlashMode nextMode;
    switch (_flashMode) {
      case FlashMode.auto:
        nextMode = FlashMode.always;
        break;
      case FlashMode.always:
        nextMode = FlashMode.off;
        break;
      case FlashMode.off:
      case FlashMode.torch:
        nextMode = FlashMode.auto;
        break;
    }

    try {
      await _cameraController!.setFlashMode(nextMode);
      setState(() => _flashMode = nextMode);
    } catch (e) {
      debugPrint('Error toggling flash: $e');
    }
  }

  Future<void> _captureCard() async {
    if (_isProcessing) return;

    if (_cameraController != null && _cameraController!.value.isInitialized) {
      setState(() => _isProcessing = true);
      try {
        final file = await _cameraController!.takePicture();
        _handleCapturedImage(file.path);
      } catch (e) {
        debugPrint('Error taking picture: $e');
      } finally {
        if (mounted) setState(() => _isProcessing = false);
      }
    } else {
      // In case of simulated camera in tests/emulators, open Photo Picker directly
      _pickFromGallery();
    }
  }

  /// Uses Android 13+ Native Photo Picker API (Zero storage permissions required!)
  Future<void> _pickFromGallery() async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 95,
      );

      if (image != null) {
        _handleCapturedImage(image.path);
      }
    } catch (e) {
      debugPrint('Error picking from gallery: $e');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _handleCapturedImage(String path) {
    setState(() {
      if (_isFrontSide) {
        _frontImagePath = path;
      } else {
        _backImagePath = path;
      }
    });

    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${_isFrontSide ? l10n.cardFront : l10n.cardBack}: ${l10n.cardCaptured}',
          style: AppTypography.bodySmall(color: Colors.white),
        ),
        backgroundColor: AppColors.forestGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Live Camera Preview or Simulated Viewfinder Background
          if (_isCameraInitialized && _cameraController != null)
            CameraPreview(_cameraController!)
          else
            Container(
              color: AppColors.primaryContainer,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.camera_alt_outlined,
                      size: 64,
                      color: AppColors.surfaceSage,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Ready to Scan Card',
                      style: AppTypography.titleMedium(color: AppColors.canvasIvory),
                    ),
                  ],
                ),
              ),
            ),

          // 2. Stitch Visiting Card Framing & Laser Overlay
          CardGuideOverlay(
            statusText: _frontImagePath != null && _isFrontSide
                ? 'Front side captured'
                : l10n.alignCardInFrame,
            isFrontSide: _isFrontSide,
          ),

          // 3. Top Action Bar
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Close Button
                    IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black.withValues(alpha: 0.5),
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.close),
                      onPressed: () => context.pop(),
                    ),

                    // Front / Back Side Switcher Pill
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(9999),
                        border: Border.all(color: AppColors.borderSubtle.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          ChoiceChip(
                            label: Text(l10n.cardFront),
                            selected: _isFrontSide,
                            selectedColor: AppColors.forestGreen,
                            labelStyle: AppTypography.labelSmall(
                              color: _isFrontSide ? Colors.white : AppColors.surfaceSage,
                            ),
                            backgroundColor: Colors.transparent,
                            showCheckmark: false,
                            onSelected: (val) => setState(() => _isFrontSide = true),
                          ),
                          const SizedBox(width: 4),
                          ChoiceChip(
                            label: Text(l10n.cardBack),
                            selected: !_isFrontSide,
                            selectedColor: AppColors.forestGreen,
                            labelStyle: AppTypography.labelSmall(
                              color: !_isFrontSide ? Colors.white : AppColors.surfaceSage,
                            ),
                            backgroundColor: Colors.transparent,
                            showCheckmark: false,
                            onSelected: (val) => setState(() => _isFrontSide = false),
                          ),
                        ],
                      ),
                    ),

                    // Flash Toggle Button
                    IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black.withValues(alpha: 0.5),
                        foregroundColor: AppColors.saffron,
                      ),
                      icon: Icon(
                        _flashMode == FlashMode.auto
                            ? Icons.flash_auto
                            : _flashMode == FlashMode.always
                                ? Icons.flash_on
                                : Icons.flash_off,
                      ),
                      onPressed: _toggleFlash,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 4. Lower Interactive Dock (Gallery, Shutter, Offline Notice)
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Captured image indicators (Front & Back status pills)
                    if (_frontImagePath != null || _backImagePath != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_frontImagePath != null)
                              Chip(
                                avatar: const Icon(Icons.check_circle, size: 16, color: AppColors.forestGreen),
                                label: Text(l10n.cardFront, style: AppTypography.labelSmall()),
                                backgroundColor: AppColors.surfaceSage,
                              ),
                            if (_frontImagePath != null && _backImagePath != null)
                              const SizedBox(width: 8),
                            if (_backImagePath != null)
                              Chip(
                                avatar: const Icon(Icons.check_circle, size: 16, color: AppColors.forestGreen),
                                label: Text(l10n.cardBack, style: AppTypography.labelSmall()),
                                backgroundColor: AppColors.surfaceSage,
                              ),
                          ],
                        ),
                      ),

                    // Shutter and Actions Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Native Android Photo Picker Button (Zero storage permission)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white.withValues(alpha: 0.2),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.all(14),
                              ),
                              icon: const Icon(Icons.photo_library_outlined, size: 26),
                              onPressed: _pickFromGallery,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.gallery,
                              style: AppTypography.labelSmall(color: Colors.white),
                            ),
                          ],
                        ),

                        // Shutter Button (Forest Green & Saffron Ring)
                        GestureDetector(
                          onTap: _captureCard,
                          child: Container(
                            width: 76,
                            height: 76,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.forestGreen,
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                color: AppColors.saffron,
                                size: 32,
                              ),
                            ),
                          ),
                        ),

                        // Captured Thumbnail or Status placeholder
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: _frontImagePath != null
                                  ? Image.file(
                                      File(_frontImagePath!),
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.credit_card, color: Colors.white38),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _frontImagePath != null ? 'Preview' : '',
                              style: AppTypography.labelSmall(color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 100% Offline Privacy Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(9999),
                        border: Border.all(color: AppColors.borderSubtle.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.lock_outline, size: 14, color: AppColors.saffron),
                          const SizedBox(width: 6),
                          Text(
                            l10n.offlinePrivacyNotice,
                            style: AppTypography.bodySmall(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
