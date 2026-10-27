import '../../data/models/extracted_card_data.dart';

class CardParserService {
  // 15-character Indian GSTIN Regex: 2 digits + 5 letters (PAN) + 4 digits + 1 letter + 1 char + Z + 1 char
  static final RegExp _gstinRegex = RegExp(
    r'\b[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}\b',
    caseSensitive: true,
  );

  // 10-character Indian PAN Regex: 5 letters + 4 digits + 1 letter
  static final RegExp _panRegex = RegExp(
    r'\b[A-Z]{5}[0-9]{4}[A-Z]{1}\b',
    caseSensitive: true,
  );

  // Email Regex
  static final RegExp _emailRegex = RegExp(
    r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}',
  );

  // Website Regex
  static final RegExp _websiteRegex = RegExp(
    r'(?:https?:\/\/|www\.)[a-zA-Z0-9][-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z()]{2,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&//=]*)',
    caseSensitive: false,
  );

  // Common Indian Domain Extensions
  static final RegExp _domainRegex = RegExp(
    r'\b[a-zA-Z0-9-]+\.(?:com|in|co\.in|org|net|biz|tech|store|shop|online|info)\b',
    caseSensitive: false,
  );

  // 6-digit Indian PIN Code
  static final RegExp _pinRegex = RegExp(r'\b[1-9][0-9]{5}\b');

  // Common Business Designations (English + Hindi)
  static final List<String> _designations = [
    'managing director', 'director', 'proprietor', 'prop.', 'partner',
    'founder', 'co-founder', 'ceo', 'cto', 'coo', 'general manager',
    'manager', 'consultant', 'physician', 'surgeon', 'chartered accountant',
    'advocate', 'architect', 'engineer', 'executive', 'associate',
    'sales manager', 'marketing manager', 'specialist',
    // Hindi Designations
    'निदेशक', 'प्रबंध निदेशक', 'प्रोप्राइटर', 'प्रो.', 'मालिक', 'संस्थापक',
    'सह-संस्थापक', 'भागीदार', 'साझेदार', 'प्रबंधक', 'सलाहकार',
    'अधिवक्ता', 'डॉक्टर', 'अभियंता', 'संचालक', 'व्यवस्थापक', 'अध्यक्ष', 'सचिव'
  ];

  // Name Honorifics
  static final List<String> _nameHonorifics = [
    'dr.', 'dr ', 'ca ', 'adv.', 'adv ', 'er.', 'er ', 'shri ', 'smt ', 'mr.', 'ms.', 'mrs.',
    'श्री ', 'श्रीमती ', 'डॉ. ', 'सीए ', 'एड. '
  ];

  // Common Business / Company Suffixes
  static final List<String> _companyKeywords = [
    'pvt. ltd.', 'pvt ltd', 'private limited', 'ltd.', 'ltd', 'llp',
    'enterprises', 'traders', 'brothers', 'bros', 'sons', 'agency',
    'jewellers', 'textiles', 'fabrics', 'stores', 'mart', 'foods',
    'sweets', 'steels', 'motors', 'automobiles', 'logistics', 'hospital',
    'clinic', 'diagnostic', 'academy', 'classes', 'infotech', 'software',
    'solutions', 'services', 'studio', 'builders', 'developers', 'industries',
    // Hindi Company Keywords
    'प्रा. लि.', 'लिमिटेड', 'ट्रेडर्स', 'एंटरप्राइजेज', 'ब्रदर्स', 'संस',
    'ज्वेलर्स', 'टेक्सटाइल्स', 'स्वीट्स', 'स्टोर्स', 'मार्ट', 'एजेंसी', 'उद्योग',
    'वस्त्र भंडार', 'किराना स्टोर', 'मिष्ठान भंडार', 'हैंडलूम', 'कंस्ट्रक्शन'
  ];

  /// Normalizes Hindi numerals (०-९) and clears decorative calligraphy swashes
  static String normalizeHindiNumerals(String text) {
    const hindiDigits = {
      '०': '0', '१': '1', '२': '2', '३': '3', '४': '4',
      '५': '5', '६': '6', '७': '7', '८': '8', '९': '9'
    };
    var result = text;
    hindiDigits.forEach((k, v) {
      result = result.replaceAll(k, v);
    });
    // Sanitize zero-width chars and decorative divider strokes
    result = result.replaceAll(RegExp(r'[\u200B-\u200D\uFEFF]'), '');
    result = result.replaceAll(RegExp(r'[-—_~]{3,}'), ' ');
    return result;
  }

  /// Parses raw OCR multi-line text into structured [ExtractedCardData]
  static ExtractedCardData parseText(
    String rawText, {
    String? photoFrontPath,
    String? photoBackPath,
  }) {
    if (rawText.trim().isEmpty) {
      return ExtractedCardData(
        photoFrontPath: photoFrontPath,
        photoBackPath: photoBackPath,
      );
    }

    final normalized = normalizeHindiNumerals(rawText);

    final lines = normalized
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    String gstin = '';
    String? pan;
    String email = '';
    String website = '';
    final phones = <String>{};
    String designation = '';
    String name = '';
    String company = '';
    final addressLines = <String>[];

    int designationLineIndex = -1;

    // 1. Pass 1: Extract Structured Entities (GSTIN, PAN, Email, Website, Phones)
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      // GSTIN Check
      if (gstin.isEmpty) {
        final gstinMatch = _gstinRegex.firstMatch(line.toUpperCase());
        if (gstinMatch != null) {
          gstin = gstinMatch.group(0)!;
          // Extract PAN from GSTIN (chars 3 to 12)
          if (gstin.length == 15) {
            pan = gstin.substring(2, 12);
          }
        }
      }

      // Standalone PAN Check
      if (pan == null) {
        final panMatch = _panRegex.firstMatch(line.toUpperCase());
        if (panMatch != null && gstin.isEmpty) {
          pan = panMatch.group(0)!;
        }
      }

      // Email Check
      if (email.isEmpty) {
        final emailMatch = _emailRegex.firstMatch(line);
        if (emailMatch != null) {
          email = emailMatch.group(0)!;
        }
      }

      // Website Check (skip lines containing @ which are emails)
      if (website.isEmpty && !line.contains('@')) {
        final webMatch = _websiteRegex.firstMatch(line);
        if (webMatch != null) {
          website = webMatch.group(0)!;
        } else {
          final domainMatch = _domainRegex.firstMatch(line);
          if (domainMatch != null) {
            website = domainMatch.group(0)!;
          }
        }
      }

      // Phones Extraction
      _extractPhonesFromLine(line, phones);

      // Designation Check
      if (designation.isEmpty) {
        final lowerLine = line.toLowerCase();
        for (final des in _designations) {
          if (lowerLine == des || lowerLine.contains(' $des') || lowerLine.contains('$des ')) {
            if ((des == 'प्रो.' || des == 'prop.' || des == 'proprietor') && lowerLine.startsWith('$des ')) {
              final remainder = line.substring(des.length).trim();
              if (remainder.isNotEmpty && _looksLikePersonName(remainder)) {
                designation = des;
                if (name.isEmpty) {
                  name = remainder;
                }
                designationLineIndex = i;
                break;
              }
            }
            designation = line;
            designationLineIndex = i;
            break;
          }
        }
      }
    }

    // 2. Pass 2: Extract Name, Company, and Address
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      // Skip lines that are purely contacts, emails, websites, or GSTIN
      if (line == gstin ||
          line == email ||
          line == website ||
          line == designation ||
          _isPhoneNumberLine(line)) {
        continue;
      }

      // Detect Company Name first if it has clear company keyword (pvt ltd, technologies, etc.)
      if (company.isEmpty && _isCompanyLine(line)) {
        company = line;
        continue;
      }

      // Detect Address Lines (contains PIN code or common address tokens)
      if (_isAddressLine(line)) {
        addressLines.add(line);
        continue;
      }

      // Detect Person Name with Honorific (Dr., CA, Adv., etc.)
      if (name.isEmpty && _hasNameHonorific(line)) {
        name = line;
        continue;
      }

      // Detect Person Name
      if (name.isEmpty) {
        // If designation was found, line immediately above or below is very likely the name
        if (designationLineIndex != -1) {
          if (i == designationLineIndex - 1 || i == designationLineIndex + 1) {
            name = line;
            continue;
          }
        }

        // Fallback: name is typically 2 to 4 words, alphabetic, not an address or company
        if (_looksLikePersonName(line)) {
          name = line;
        }
      }
    }

    // If company not found, use first prominent line that isn't name, designation, or address
    if (company.isEmpty) {
      for (final line in lines) {
        if (line != name &&
            line != designation &&
            line != gstin &&
            line != email &&
            line != website &&
            !_isPhoneNumberLine(line) &&
            !_isAddressLine(line) &&
            line.length >= 4) {
          company = line;
          break;
        }
      }
    }

    final suggestedCat = _suggestCategory('$company $designation $rawText');

    return ExtractedCardData(
      name: name,
      company: company,
      jobTitle: designation,
      phones: phones.toList(),
      email: email,
      website: website,
      address: addressLines.join(', '),
      gstin: gstin,
      pan: pan,
      suggestedCategoryId: suggestedCat,
      rawText: rawText,
      photoFrontPath: photoFrontPath,
      photoBackPath: photoBackPath,
    );
  }

  static void _extractPhonesFromLine(String line, Set<String> phones) {
    // Look for Indian 10-digit mobile numbers with optional +91, 0, or spaces
    final phoneRegex = RegExp(
      r'(?:\+91[\-\s]?)?[6-9]\d{4}[\-\s]?\d{5}|(?:\+91[\-\s]?)?[6-9]\d{9}|\b0\d{2,4}[\-\s]?\d{6,8}\b',
    );

    for (final match in phoneRegex.allMatches(line)) {
      final raw = match.group(0)!;
      final clean = raw.replaceAll(RegExp(r'\D'), '');
      // Ensure it's not a 6-digit PIN code
      if (clean.length == 10 || clean.length == 12 || clean.length == 11) {
        phones.add(raw.trim());
      }
    }
  }

  static bool _isPhoneNumberLine(String line) {
    final digitsCount = line.replaceAll(RegExp(r'\D'), '').length;
    if (digitsCount < 10) return false;
    final lower = line.toLowerCase();
    if (lower.contains('ph:') ||
        lower.contains('ph.') ||
        lower.contains('mob') ||
        lower.contains('tel') ||
        lower.contains('मो.') ||
        lower.contains('दूरभाष') ||
        lower.contains('सम्पर्क') ||
        lower.contains('फोन') ||
        lower.contains('+91')) {
      return true;
    }
    return digitsCount >= 10 && line.length <= 40;
  }

  static bool _isAddressLine(String line) {
    if (_pinRegex.hasMatch(line)) return true;
    final lower = line.toLowerCase();
    final addressTokens = [
      'road', 'marg', 'street', 'nagar', 'colony', 'sector',
      'phase', 'floor', 'complex', 'plaza', 'chowk', 'market', 'bazar',
      'opp.', 'near', 'behind', 'dist.', 'pin:', 'pin code',
      // Hindi address tokens
      'मार्ग', 'रोड', 'नगर', 'कॉलोनी', 'सेक्टर', 'चौक', 'बाज़ार', 'पास', 'निकट'
    ];
    if (addressTokens.any((t) => lower.contains(t))) return true;

    // Word-boundary checks for short abbreviations to avoid matching inside words like "Card" or "Textiles"
    return RegExp(r'\b(rd\.|st\.|sec\.|rd|st)\b').hasMatch(lower);
  }

  static bool _isCompanyLine(String line) {
    final lower = line.toLowerCase();
    return _companyKeywords.any((k) => lower.contains(k));
  }

  static bool _hasNameHonorific(String line) {
    final lower = line.toLowerCase();
    return _nameHonorifics.any((h) => lower.startsWith(h));
  }

  static bool _looksLikePersonName(String line) {
    // Avoid lines with numbers, emails, addresses, or too many words
    if (RegExp(r'[0-9@\/\\]').hasMatch(line)) return false;
    if (line.contains('&') || line.contains('+') || line.contains('|') || line.contains(',')) return false;
    final lower = line.toLowerCase();
    if (_designations.any((d) => lower == d || lower.contains('$d ') || lower.contains(' $d'))) return false;
    final words = line.trim().split(RegExp(r'\s+'));
    return words.isNotEmpty && words.length <= 4 && line.length >= 3;
  }

  static String _suggestCategory(String text) {
    final lower = text.toLowerCase();
    if (lower.contains('textile') || lower.contains('jewel') || lower.contains('retail') ||
        lower.contains('store') || lower.contains('shop') || lower.contains('सूट') || lower.contains('साड़ी') ||
        lower.contains('वस्त्र') || lower.contains('कपड़ा') || lower.contains('गारमेंट')) {
      return 'retail';
    }
    if (lower.contains('sweet') || lower.contains('restaurant') || lower.contains('cafe') ||
        lower.contains('food') || lower.contains('hotel') || lower.contains('मिठाई') ||
        lower.contains('स्वीट्स') || lower.contains('अल्पाहार') || lower.contains('भोजन') ||
        lower.contains('रेस्टोरेंट') || lower.contains('होटल')) {
      return 'food_beverage';
    }
    if (lower.contains('doctor') || lower.contains('dr.') || lower.contains('clinic') ||
        lower.contains('hospital') || lower.contains('pharma') || lower.contains('चिकित्सा') || lower.contains('डॉक्टर')) {
      return 'healthcare';
    }
    if (lower.contains('school') || lower.contains('college') || lower.contains('classes') ||
        lower.contains('academy') || lower.contains('education') || lower.contains('शिक्षा')) {
      return 'education';
    }
    if (lower.contains('software') || lower.contains('tech') || lower.contains('infotech') ||
        lower.contains('digital') || lower.contains('it solutions')) {
      return 'it_software';
    }
    if (lower.contains('finance') || lower.contains('bank') || lower.contains('ca ') ||
        lower.contains('chartered') || lower.contains('tax') || lower.contains('बीमा')) {
      return 'finance';
    }
    if (lower.contains('real estate') || lower.contains('builder') || lower.contains('developer') ||
        lower.contains('properties') || lower.contains('हाउसिंग')) {
      return 'real_estate';
    }
    if (lower.contains('manufacturing') || lower.contains('industry') || lower.contains('factory') ||
        lower.contains('steel') || lower.contains('उद्योग') || lower.contains('उत्पादन')) {
      return 'manufacturing';
    }
    if (lower.contains('wholesale') || lower.contains('distributor') || lower.contains('trader') ||
        lower.contains('थोक')) {
      return 'wholesale';
    }
    if (lower.contains('transport') || lower.contains('logistics') || lower.contains('cargo') ||
        lower.contains('परिवहन')) {
      return 'transport';
    }
    if (lower.contains('agri') || lower.contains('seed') || lower.contains('fertilizer') ||
        lower.contains('कृषि') || lower.contains('किसान')) {
      return 'agriculture';
    }
    if (lower.contains('advocate') || lower.contains('law') || lower.contains('legal') ||
        lower.contains('अधिवक्ता') || lower.contains('वकील')) {
      return 'legal';
    }
    if (lower.contains('salon') || lower.contains('beauty') || lower.contains('spa') ||
        lower.contains('wellness') || lower.contains('सौंदर्य')) {
      return 'beauty_wellness';
    }
    if (lower.contains('automobile') || lower.contains('motors') || lower.contains('auto') ||
        lower.contains('मोटर्स')) {
      return 'automotive';
    }
    return 'other';
  }
}
