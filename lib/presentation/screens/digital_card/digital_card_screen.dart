import 'package:flutter/material.dart';
import '../../../core/localization/locale_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/local/storage_service.dart';
import '../../../data/models/contact_card.dart';
import '../../../data/models/digital_card_template.dart';
import '../../../data/templates/stitch_template_registry.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/digital_card/digital_card_action_buttons.dart';
import '../../widgets/digital_card/digital_card_canvas.dart';
import '../../widgets/digital_card/template_selector_carousel.dart';
import '../../widgets/digital_card/vcard_qr_modal.dart';

/// Digital Visiting Card Creator Screen (Stitch 20-Template Engine)
class DigitalCardScreen extends StatefulWidget {
  final String? initialCardId;

  const DigitalCardScreen({super.key, this.initialCardId});

  @override
  State<DigitalCardScreen> createState() => _DigitalCardScreenState();
}

class _DigitalCardScreenState extends State<DigitalCardScreen> {
  final GlobalKey _repaintKey = GlobalKey();
  List<ContactCard> _allCards = [];
  ContactCard? _selectedCard;
  late List<DigitalCardTemplate> _availableTemplates;
  late DigitalCardTemplate _activeTemplate;
  String? _selectedCategoryFilter;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    final cards = StorageService.instance.contactRepo.getAllCards();
    _allCards = cards;

    if (cards.isNotEmpty) {
      if (widget.initialCardId != null) {
        _selectedCard = cards.firstWhere(
          (c) => c.id == widget.initialCardId,
          orElse: () => cards.first,
        );
      } else {
        _selectedCard = cards.first;
      }
    } else {
      // Fallback demo card if directory is empty
      _selectedCard = ContactCard(
        id: 'user_default_card',
        name: 'Vinayak Saxena',
        company: 'CardSaathi Technologies',
        jobTitle: 'Founder & Software Architect',
        categoryId: 'it_software',
        phones: const ['+91 98765 43210'],
        email: 'vinayak@cardsaathi.app',
        website: 'www.cardsaathi.app',
        address: 'Jaipur, Rajasthan, India',
        gstin: '08AAAAA0000A1Z5',
        createdAt: DateTime.now(),
      );
    }

    _refreshTemplatesForSelectedCard();
    setState(() => _isLoading = false);
  }

  void _refreshTemplatesForSelectedCard() {
    final categoryId = _selectedCard?.categoryId;
    _availableTemplates = StitchTemplateRegistry.getTemplatesForCategory(categoryId);
    _activeTemplate = _availableTemplates.first;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isHindi = localeController.isHindi;

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.digitalCard, style: AppTypography.headlineMedium()),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_rounded, color: AppColors.forestGreen),
            tooltip: l10n.viewQrCode,
            onPressed: () {
              if (_selectedCard != null) {
                VCardQrModal.show(context, _selectedCard!);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card Selector Dropdown (if user has multiple cards)
            if (_allCards.length > 1) _buildCardSelectorDropdown(),

            // Live Template Canvas (4:5 Aspect Ratio)
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 380),
                child: DigitalCardCanvas(
                  repaintBoundaryKey: _repaintKey,
                  card: _selectedCard!,
                  template: _activeTemplate,
                  isHindi: isHindi,
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Category & Recommendation Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.selectTemplate,
                  style: AppTypography.titleMedium(),
                ),
                Text(
                  '${_availableTemplates.length}/20 Templates',
                  style: AppTypography.labelSmall(color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Category Recommendation Pills
            _buildCategoryRecommendationPills(l10n),
            const SizedBox(height: 12),

            // Horizontal Template Selector Carousel
            TemplateSelectorCarousel(
              availableTemplates: _availableTemplates,
              activeTemplate: _activeTemplate,
              isHindi: isHindi,
              onSelected: (t) => setState(() => _activeTemplate = t),
            ),
            const SizedBox(height: 24),

            // Primary Action Buttons (WhatsApp 4:5 Export, QR Code, & NFC Tag Tap)
            DigitalCardActionButtons(
              repaintKey: _repaintKey,
              selectedCard: _selectedCard,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCardSelectorDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        initialValue: _selectedCard?.id,
        decoration: InputDecoration(
          labelText: 'Select Business Card',
          prefixIcon: const Icon(Icons.badge_outlined, color: AppColors.forestGreen),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
        items: _allCards.map((c) {
          return DropdownMenuItem<String>(
            value: c.id,
            child: Text(
              '${c.name} (${c.company.isNotEmpty ? c.company : "Personal"})',
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: (val) {
          if (val == null) return;
          setState(() {
            _selectedCard = _allCards.firstWhere((c) => c.id == val);
            _refreshTemplatesForSelectedCard();
          });
        },
      ),
    );
  }

  Widget _buildCategoryRecommendationPills(AppLocalizations l10n) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip(
            label: l10n.recommendedForYou,
            isSelected: _selectedCategoryFilter == null,
            onSelected: () => setState(() {
              _selectedCategoryFilter = null;
              _availableTemplates = StitchTemplateRegistry.getTemplatesForCategory(_selectedCard?.categoryId);
            }),
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: l10n.allTemplates,
            isSelected: _selectedCategoryFilter == 'all',
            onSelected: () => setState(() {
              _selectedCategoryFilter = 'all';
              _availableTemplates = StitchTemplateRegistry.allTemplates;
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      selectedColor: AppColors.surfaceSage,
      backgroundColor: Colors.white,
      side: BorderSide(color: isSelected ? AppColors.forestGreen : AppColors.borderSubtle),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.forestGreen : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        fontSize: 12,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
