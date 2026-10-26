import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/models/contact_card.dart';
import '../../../data/models/digital_card_template.dart';

/// Digital Visiting Card Canvas (Renders Active Stitch Template)
/// Uses 4:5 aspect ratio optimized for WhatsApp sharing & Instagram cards.
class DigitalCardCanvas extends StatelessWidget {
  final GlobalKey repaintBoundaryKey;
  final ContactCard card;
  final DigitalCardTemplate template;
  final bool isHindi;

  const DigitalCardCanvas({
    super.key,
    required this.repaintBoundaryKey,
    required this.card,
    required this.template,
    this.isHindi = false,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: repaintBoundaryKey,
      child: AspectRatio(
        aspectRatio: 4 / 5,
        child: Container(
          decoration: BoxDecoration(
            color: template.backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: template.cardBorderColor,
              width: template.styleFamily == 'brutalist' ? 3.0 : 1.5,
            ),
            boxShadow: template.styleFamily == 'brutalist'
                ? const [BoxShadow(color: Colors.black, offset: Offset(5, 5))]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                // Style-Specific Decorative Accents
                _buildStyleBackgroundAccents(),

                // Main Content Layout
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row: Company & Industry Badge
                      _buildHeader(),
                      const Spacer(),

                      // Center Focus: Name & Designation
                      _buildNameBlock(),
                      const Spacer(),

                      // Divider Accent
                      Container(
                        height: 2,
                        width: 48,
                        decoration: BoxDecoration(
                          color: template.accentColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Contact Details Footer
                      _buildContactFooter(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                card.company.isNotEmpty ? card.company : 'CardSaathi Partner',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: template.primaryColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (card.website.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    card.website,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: template.subtitleColor,
                    ),
                  ),
                ),
            ],
          ),
        ),
        // Template Number / Style Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: template.accentColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: template.accentColor.withValues(alpha: 0.4),
              width: 1,
            ),
          ),
          child: Text(
            '#${template.number.toString().padLeft(2, '0')}',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: template.accentColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNameBlock() {
    TextStyle nameStyle;
    switch (template.styleFamily) {
      case 'editorial':
      case 'luxury':
      case 'signature':
        nameStyle = GoogleFonts.notoSerif(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: template.textColor,
        );
        break;
      case 'devanagari':
        nameStyle = GoogleFonts.rozhaOne(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: template.textColor,
        );
        break;
      case 'blueprint':
      case 'swiss':
        nameStyle = GoogleFonts.spaceMono(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          color: template.textColor,
        );
        break;
      default:
        nameStyle = GoogleFonts.plusJakartaSans(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
          color: template.textColor,
        );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          card.name.isNotEmpty ? card.name : 'Business Owner',
          style: nameStyle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (card.jobTitle.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              card.jobTitle,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: template.subtitleColor,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContactFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (card.phones.isNotEmpty)
          _buildInfoRow(Icons.phone_outlined, card.phones.first),
        if (card.email.isNotEmpty)
          _buildInfoRow(Icons.email_outlined, card.email),
        if (card.address.isNotEmpty)
          _buildInfoRow(Icons.location_on_outlined, card.address),
        if (card.gstin.isNotEmpty)
          _buildInfoRow(Icons.verified_outlined, 'GSTIN: ${card.gstin}'),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 13, color: template.accentColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: template.subtitleColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStyleBackgroundAccents() {
    switch (template.styleFamily) {
      case 'duotone':
        return Positioned(
          top: 0,
          right: 0,
          width: 140,
          height: 140,
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  template.accentColor.withValues(alpha: 0.25),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        );
      case 'luxury':
        return Positioned(
          top: -20,
          right: -20,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: template.accentColor.withValues(alpha: 0.2),
                width: 30,
              ),
            ),
          ),
        );
      case 'blueprint':
        return Positioned(
          bottom: 12,
          right: 12,
          child: Text(
            'CARTSAATHI // BLUEPRINT SPEC',
            style: GoogleFonts.spaceMono(
              fontSize: 8,
              color: template.subtitleColor.withValues(alpha: 0.4),
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
