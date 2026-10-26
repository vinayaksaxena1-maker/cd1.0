import 'package:flutter/material.dart';
import '../models/digital_card_template.dart';

/// Complete Registry of 20 Stitch Digital Visiting Card Templates
/// Bound strictly to Stitch Project: CardSaathi Mobile App UI (7571062141855216909)
class StitchTemplateRegistry {
  static const List<DigitalCardTemplate> allTemplates = [
    // 19: Local Business Quick Contact (Kirana, Retail, Transport, Services)
    DigitalCardTemplate(
      id: 'template_19',
      number: 19,
      nameEn: 'Local Business Quick Contact',
      nameHi: 'स्थानीय व्यापार एवं त्वरित संपर्क',
      targetCategoryIds: ['retail', 'home_services', 'transport'],
      styleFamily: 'quick_contact',
      primaryColor: Color(0xFF003827),
      accentColor: Color(0xFFE6A23A),
      backgroundColor: Color(0xFFFFFFFF),
      textColor: Color(0xFF141E19),
      subtitleColor: Color(0xFF404944),
      cardBorderColor: Color(0xFFE2E8E2),
    ),
    // 15: Healthcare Calm (Medical, Clinic, Pharma)
    DigitalCardTemplate(
      id: 'template_15',
      number: 15,
      nameEn: 'Healthcare Calm',
      nameHi: 'हेल्थकेयर एवं क्लिनिक',
      targetCategoryIds: ['healthcare', 'beauty_wellness'],
      styleFamily: 'calm',
      primaryColor: Color(0xFF0D513B),
      accentColor: Color(0xFF2C6952),
      backgroundColor: Color(0xFFF1FCF4),
      textColor: Color(0xFF141E19),
      subtitleColor: Color(0xFF58675F),
      cardBorderColor: Color(0xFFB0F0D2),
    ),
    // 13: Food and Hospitality (Restaurants, Caterers, Cafes)
    DigitalCardTemplate(
      id: 'template_13',
      number: 13,
      nameEn: 'Food and Hospitality',
      nameHi: 'रेस्तरां एवं कैटरिंग',
      targetCategoryIds: ['food_beverage', 'hospitality'],
      styleFamily: 'food',
      primaryColor: Color(0xFF8B2500),
      accentColor: Color(0xFFE6A23A),
      backgroundColor: Color(0xFFFFFBF5),
      textColor: Color(0xFF291800),
      subtitleColor: Color(0xFF633F00),
      cardBorderColor: Color(0xFFFFDDB4),
    ),
    // 14: Finance and Consulting (CA, Tax, Banking)
    DigitalCardTemplate(
      id: 'template_14',
      number: 14,
      nameEn: 'Finance and Consulting',
      nameHi: 'वित्त एवं सीए कंसल्टिंग',
      targetCategoryIds: ['finance', 'legal'],
      styleFamily: 'finance',
      primaryColor: Color(0xFF1A365D),
      accentColor: Color(0xFF2B6CB0),
      backgroundColor: Color(0xFFF7FAFC),
      textColor: Color(0xFF1A202C),
      subtitleColor: Color(0xFF4A5568),
      cardBorderColor: Color(0xFFCBD5E0),
    ),
    // 11: Architectural Blueprint (Manufacturing, Hardware, Construction)
    DigitalCardTemplate(
      id: 'template_11',
      number: 11,
      nameEn: 'Architectural Blueprint',
      nameHi: 'आर्किटेक्चर व विनिर्माण',
      targetCategoryIds: ['manufacturing', 'home_services', 'real_estate'],
      styleFamily: 'blueprint',
      primaryColor: Color(0xFF0C2340),
      accentColor: Color(0xFF00A3E0),
      backgroundColor: Color(0xFF0F2D4A),
      textColor: Color(0xFFFFFFFF),
      subtitleColor: Color(0xFFBCE3F7),
      cardBorderColor: Color(0xFF00A3E0),
      hasDarkBackground: true,
    ),
    // 17: Fashion Editorial (Garments, Textiles, Boutique)
    DigitalCardTemplate(
      id: 'template_17',
      number: 17,
      nameEn: 'Fashion Editorial',
      nameHi: 'फ़ैशन एवं परिधान',
      targetCategoryIds: ['retail', 'marketing'],
      styleFamily: 'editorial',
      primaryColor: Color(0xFF111111),
      accentColor: Color(0xFF666666),
      backgroundColor: Color(0xFFFAF7F0),
      textColor: Color(0xFF111111),
      subtitleColor: Color(0xFF777777),
      cardBorderColor: Color(0xFFE5E5E5),
    ),
    // 10: Botanical Wellness (Ayurveda, Organics, Salon)
    DigitalCardTemplate(
      id: 'template_10',
      number: 10,
      nameEn: 'Botanical Wellness',
      nameHi: 'आयुर्वेद एवं वैलनेस',
      targetCategoryIds: ['beauty_wellness', 'healthcare'],
      styleFamily: 'wellness',
      primaryColor: Color(0xFF2D4739),
      accentColor: Color(0xFF8BA888),
      backgroundColor: Color(0xFFF4F7F4),
      textColor: Color(0xFF1C2E24),
      subtitleColor: Color(0xFF526B5C),
      cardBorderColor: Color(0xFFC8D6C7),
    ),
    // 09: Midnight Professional (Lawyers, Advocates, IT Consultants)
    DigitalCardTemplate(
      id: 'template_09',
      number: 9,
      nameEn: 'Midnight Professional',
      nameHi: 'मिडनाइट कॉर्पोरेट',
      targetCategoryIds: ['legal', 'it_software'],
      styleFamily: 'midnight',
      primaryColor: Color(0xFF0F172A),
      accentColor: Color(0xFF38BDF8),
      backgroundColor: Color(0xFF0B0F19),
      textColor: Color(0xFFF8FAFC),
      subtitleColor: Color(0xFF94A3B8),
      cardBorderColor: Color(0xFF1E293B),
      hasDarkBackground: true,
    ),
    // 16: Real Estate and Places (Builders, Brokers, Property)
    DigitalCardTemplate(
      id: 'template_16',
      number: 16,
      nameEn: 'Real Estate and Places',
      nameHi: 'रियल एस्टेट एवं प्रॉपर्टी',
      targetCategoryIds: ['real_estate', 'home_services'],
      styleFamily: 'real_estate',
      primaryColor: Color(0xFF1C3144),
      accentColor: Color(0xFFD00000),
      backgroundColor: Color(0xFFF0F4F8),
      textColor: Color(0xFF0D1B2A),
      subtitleColor: Color(0xFF415A77),
      cardBorderColor: Color(0xFFB0C4DE),
    ),
    // 07: Devanagari-First (Hindi First, Traditional, Social)
    DigitalCardTemplate(
      id: 'template_07',
      number: 7,
      nameEn: 'Devanagari-First',
      nameHi: 'देवनागरी-प्रथम पारंपरिक',
      targetCategoryIds: ['govt_ngo', 'agriculture', 'other'],
      styleFamily: 'devanagari',
      primaryColor: Color(0xFF800020), // Royal Maroon
      accentColor: Color(0xFFD4AF37), // Metallic Gold
      backgroundColor: Color(0xFFFFFDF9),
      textColor: Color(0xFF4A0E17),
      subtitleColor: Color(0xFF7A3B43),
      cardBorderColor: Color(0xFFE8D7B8),
    ),
    // 06: Indian Modern Geometry (Wholesale, Traders, Export)
    DigitalCardTemplate(
      id: 'template_06',
      number: 6,
      nameEn: 'Indian Modern Geometry',
      nameHi: 'भारतीय आधुनिक ज्यामिति',
      targetCategoryIds: ['wholesale', 'manufacturing'],
      styleFamily: 'geometry',
      primaryColor: Color(0xFF1E3A8A), // Heritage Indigo
      accentColor: Color(0xFFF59E0B),
      backgroundColor: Color(0xFFF8FAFC),
      textColor: Color(0xFF0F172A),
      subtitleColor: Color(0xFF475569),
      cardBorderColor: Color(0xFFE2E8F0),
    ),
    // 04: Swiss Modern (Software, Tech Startups, B2B)
    DigitalCardTemplate(
      id: 'template_04',
      number: 4,
      nameEn: 'Swiss Modern',
      nameHi: 'स्विस मॉडर्न टेक',
      targetCategoryIds: ['it_software', 'prof_services'],
      styleFamily: 'swiss',
      primaryColor: Color(0xFFE11D48),
      accentColor: Color(0xFF000000),
      backgroundColor: Color(0xFFFFFFFF),
      textColor: Color(0xFF000000),
      subtitleColor: Color(0xFF525252),
      cardBorderColor: Color(0xFF000000),
    ),
    // 05: Quiet Luxury (Jewellery, Gems, Luxury Goods)
    DigitalCardTemplate(
      id: 'template_05',
      number: 5,
      nameEn: 'Quiet Luxury',
      nameHi: 'रॉयल लक्ज़री एवं ज्वेलरी',
      targetCategoryIds: ['retail', 'wholesale'],
      styleFamily: 'luxury',
      primaryColor: Color(0xFF003827),
      accentColor: Color(0xFFD4AF37),
      backgroundColor: Color(0xFF002115),
      textColor: Color(0xFFF1FCF4),
      subtitleColor: Color(0xFF95D4B7),
      cardBorderColor: Color(0xFFD4AF37),
      hasDarkBackground: true,
    ),
    // 08: Earthy Craft (Handicrafts, Artisans, Khadi)
    DigitalCardTemplate(
      id: 'template_08',
      number: 8,
      nameEn: 'Earthy Craft',
      nameHi: 'हस्तशिल्प एवं कारीगरी',
      targetCategoryIds: ['other', 'agriculture'],
      styleFamily: 'craft',
      primaryColor: Color(0xFF9C4124), // Terracotta
      accentColor: Color(0xFF6B4226),
      backgroundColor: Color(0xFFFAF3EC),
      textColor: Color(0xFF4A2511),
      subtitleColor: Color(0xFF7A4E33),
      cardBorderColor: Color(0xFFDECFBE),
    ),
    // 18: Photographer and Visual Creator (Studio, Video, Creative)
    DigitalCardTemplate(
      id: 'template_18',
      number: 18,
      nameEn: 'Visual Creator',
      nameHi: 'फ़ोटोग्राफ़ी एवं मीडिया',
      targetCategoryIds: ['marketing', 'other'],
      styleFamily: 'creator',
      primaryColor: Color(0xFF18181B),
      accentColor: Color(0xFFA1A1AA),
      backgroundColor: Color(0xFF09090B),
      textColor: Color(0xFFFAFAFA),
      subtitleColor: Color(0xFF71717A),
      cardBorderColor: Color(0xFF27272A),
      hasDarkBackground: true,
    ),
    // 12: Creative Studio Duotone (Design, Advertising, Branding)
    DigitalCardTemplate(
      id: 'template_12',
      number: 12,
      nameEn: 'Creative Studio Duotone',
      nameHi: 'क्रिएटिव स्टूडियो डुओटोन',
      targetCategoryIds: ['marketing', 'prof_services'],
      styleFamily: 'duotone',
      primaryColor: Color(0xFF4F46E5),
      accentColor: Color(0xFFEC4899),
      backgroundColor: Color(0xFFEEF2FF),
      textColor: Color(0xFF1E1B4B),
      subtitleColor: Color(0xFF4338CA),
      cardBorderColor: Color(0xFFC7D2FE),
    ),
    // 01: Editorial Grid (Publishing, Agencies, Press)
    DigitalCardTemplate(
      id: 'template_01',
      number: 1,
      nameEn: 'Editorial Grid',
      nameHi: 'एडिटोरियल पब्लिशिंग',
      targetCategoryIds: ['prof_services', 'legal'],
      styleFamily: 'grid',
      primaryColor: Color(0xFF262626),
      accentColor: Color(0xFF737373),
      backgroundColor: Color(0xFFFFFFFF),
      textColor: Color(0xFF171717),
      subtitleColor: Color(0xFF525252),
      cardBorderColor: Color(0xFFE5E5E5),
    ),
    // 02: Humanist Paper (Artisans, Writers, Heritage)
    DigitalCardTemplate(
      id: 'template_02',
      number: 2,
      nameEn: 'Humanist Paper',
      nameHi: 'ह्यूमैनिस्ट पेपर टेक्सचर',
      targetCategoryIds: ['other', 'agriculture'],
      styleFamily: 'paper',
      primaryColor: Color(0xFF3F3D56),
      accentColor: Color(0xFF8A817C),
      backgroundColor: Color(0xFFF7F4EB),
      textColor: Color(0xFF2B2A33),
      subtitleColor: Color(0xFF6E6863),
      cardBorderColor: Color(0xFFE3DEC3),
    ),
    // 03: Neo-Brutalist Blocks (Gen-Z Brands, Cafes, Apparel)
    DigitalCardTemplate(
      id: 'template_03',
      number: 3,
      nameEn: 'Neo-Brutalist Blocks',
      nameHi: 'नियो-ब्रूटलिस्ट ब्लॉक्स',
      targetCategoryIds: ['other', 'retail'],
      styleFamily: 'brutalist',
      primaryColor: Color(0xFF000000),
      accentColor: Color(0xFFFFDE59),
      backgroundColor: Color(0xFFFFFFFF),
      textColor: Color(0xFF000000),
      subtitleColor: Color(0xFF333333),
      cardBorderColor: Color(0xFF000000),
    ),
    // 20: Personal Signature (Founders, VIPs, Directors)
    DigitalCardTemplate(
      id: 'template_20',
      number: 20,
      nameEn: 'Personal Signature',
      nameHi: 'पर्सनल सिग्नेचर वीआईपी',
      targetCategoryIds: ['prof_services', 'finance', 'legal'],
      styleFamily: 'signature',
      primaryColor: Color(0xFF002B1D),
      accentColor: Color(0xFFC5A059),
      backgroundColor: Color(0xFFFAFAF7),
      textColor: Color(0xFF111827),
      subtitleColor: Color(0xFF4B5563),
      cardBorderColor: Color(0xFFE5E7EB),
    ),
  ];

  /// Category-Aware Smart Recommendation Engine:
  /// Returns matching templates at the top, followed by all other templates.
  static List<DigitalCardTemplate> getTemplatesForCategory(String? categoryId) {
    if (categoryId == null || categoryId.isEmpty) return allTemplates;

    final recommended = allTemplates.where((t) => t.matchesCategory(categoryId)).toList();
    final others = allTemplates.where((t) => !t.matchesCategory(categoryId)).toList();
    return [...recommended, ...others];
  }

  static DigitalCardTemplate getTemplateById(String id) {
    return allTemplates.firstWhere(
      (t) => t.id == id,
      orElse: () => allTemplates.first,
    );
  }
}
