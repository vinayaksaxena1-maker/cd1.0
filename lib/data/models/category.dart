import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 0)
class Category extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String nameEn;

  @HiveField(2)
  final String nameHi;

  @HiveField(3)
  final int iconCode;

  @HiveField(4)
  final bool isCustom;

  @HiveField(5)
  final int cardCount;

  Category({
    required this.id,
    required this.nameEn,
    required this.nameHi,
    required this.iconCode,
    this.isCustom = false,
    this.cardCount = 0,
  });

  Category copyWith({
    String? id,
    String? nameEn,
    String? nameHi,
    int? iconCode,
    bool? isCustom,
    int? cardCount,
  }) {
    return Category(
      id: id ?? this.id,
      nameEn: nameEn ?? this.nameEn,
      nameHi: nameHi ?? this.nameHi,
      iconCode: iconCode ?? this.iconCode,
      isCustom: isCustom ?? this.isCustom,
      cardCount: cardCount ?? this.cardCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameEn': nameEn,
      'nameHi': nameHi,
      'iconCode': iconCode,
      'isCustom': isCustom,
      'cardCount': cardCount,
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      nameEn: json['nameEn'] as String,
      nameHi: json['nameHi'] as String,
      iconCode: json['iconCode'] as int? ?? 0xe19f, // default icons.business
      isCustom: json['isCustom'] as bool? ?? false,
      cardCount: json['cardCount'] as int? ?? 0,
    );
  }

  static List<Category> get defaultCategories => [
    Category(id: 'retail', nameEn: 'Retail', nameHi: 'रिटेल / खुदरा', iconCode: 0xe59c),
    Category(id: 'food_beverage', nameEn: 'Food & Beverage', nameHi: 'खाद्य एवं पेय', iconCode: 0xe532),
    Category(id: 'healthcare', nameEn: 'Healthcare', nameHi: 'स्वास्थ्य सेवा', iconCode: 0xe3f7),
    Category(id: 'education', nameEn: 'Education', nameHi: 'शिक्षा एवं प्रशिक्षण', iconCode: 0xe559),
    Category(id: 'it_software', nameEn: 'IT & Software', nameHi: 'सूचना प्रौद्योगिकी', iconCode: 0xe1b1),
    Category(id: 'finance', nameEn: 'Finance & Banking', nameHi: 'वित्त एवं बैंकिंग', iconCode: 0xe08f),
    Category(id: 'real_estate', nameEn: 'Real Estate', nameHi: 'रियल एस्टेट', iconCode: 0xe068),
    Category(id: 'manufacturing', nameEn: 'Manufacturing', nameHi: 'विनिर्माण / उत्पादन', iconCode: 0xe84f),
    Category(id: 'wholesale', nameEn: 'Wholesale', nameHi: 'थोक व्यापार', iconCode: 0xe30b),
    Category(id: 'transport', nameEn: 'Transport & Logistics', nameHi: 'परिवहन एवं रसद', iconCode: 0xe3b6),
    Category(id: 'agriculture', nameEn: 'Agriculture', nameHi: 'कृषि एवं संबद्ध', iconCode: 0xe070),
    Category(id: 'legal', nameEn: 'Legal Services', nameHi: 'कानूनी सेवाएं', iconCode: 0xe2e2),
    Category(id: 'prof_services', nameEn: 'Professional Services', nameHi: 'व्यावसायिक सेवाएं', iconCode: 0xe0ee),
    Category(id: 'marketing', nameEn: 'Marketing & Ads', nameHi: 'मार्केटिंग एवं विज्ञापन', iconCode: 0xe163),
    Category(id: 'hospitality', nameEn: 'Hospitality & Tourism', nameHi: 'आतिथ्य एवं पर्यटन', iconCode: 0xe318),
    Category(id: 'beauty_wellness', nameEn: 'Beauty & Wellness', nameHi: 'सौंदर्य एवं वेलनेस', iconCode: 0xe5fc),
    Category(id: 'home_services', nameEn: 'Home Services', nameHi: 'घरेलू सेवाएं', iconCode: 0xe317),
    Category(id: 'automotive', nameEn: 'Automotive', nameHi: 'ऑटोमोबाइल', iconCode: 0xe1d7),
    Category(id: 'govt_ngo', nameEn: 'Govt & NGO', nameHi: 'सरकारी / एनजीओ', iconCode: 0xe06e),
    Category(id: 'other', nameEn: 'Other Business', nameHi: 'अन्य व्यापार', iconCode: 0xe412),
  ];
}
