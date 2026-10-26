class ExtractedCardData {
  final String name;
  final String company;
  final String jobTitle;
  final List<String> phones;
  final String email;
  final String website;
  final String address;
  final String gstin;
  final String? pan;
  final String? suggestedCategoryId;
  final String rawText;
  final String? photoFrontPath;
  final String? photoBackPath;

  const ExtractedCardData({
    this.name = '',
    this.company = '',
    this.jobTitle = '',
    this.phones = const [],
    this.email = '',
    this.website = '',
    this.address = '',
    this.gstin = '',
    this.pan,
    this.suggestedCategoryId,
    this.rawText = '',
    this.photoFrontPath,
    this.photoBackPath,
  });

  ExtractedCardData copyWith({
    String? name,
    String? company,
    String? jobTitle,
    List<String>? phones,
    String? email,
    String? website,
    String? address,
    String? gstin,
    String? pan,
    String? suggestedCategoryId,
    String? rawText,
    String? photoFrontPath,
    String? photoBackPath,
  }) {
    return ExtractedCardData(
      name: name ?? this.name,
      company: company ?? this.company,
      jobTitle: jobTitle ?? this.jobTitle,
      phones: phones ?? this.phones,
      email: email ?? this.email,
      website: website ?? this.website,
      address: address ?? this.address,
      gstin: gstin ?? this.gstin,
      pan: pan ?? this.pan,
      suggestedCategoryId: suggestedCategoryId ?? this.suggestedCategoryId,
      rawText: rawText ?? this.rawText,
      photoFrontPath: photoFrontPath ?? this.photoFrontPath,
      photoBackPath: photoBackPath ?? this.photoBackPath,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'company': company,
      'jobTitle': jobTitle,
      'phones': phones,
      'email': email,
      'website': website,
      'address': address,
      'gstin': gstin,
      'pan': pan,
      'suggestedCategoryId': suggestedCategoryId,
      'rawText': rawText,
      'photoFrontPath': photoFrontPath,
      'photoBackPath': photoBackPath,
    };
  }

  factory ExtractedCardData.fromJson(Map<String, dynamic> json) {
    return ExtractedCardData(
      name: json['name'] as String? ?? '',
      company: json['company'] as String? ?? '',
      jobTitle: json['jobTitle'] as String? ?? '',
      phones: (json['phones'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      email: json['email'] as String? ?? '',
      website: json['website'] as String? ?? '',
      address: json['address'] as String? ?? '',
      gstin: json['gstin'] as String? ?? '',
      pan: json['pan'] as String?,
      suggestedCategoryId: json['suggestedCategoryId'] as String?,
      rawText: json['rawText'] as String? ?? '',
      photoFrontPath: json['photoFrontPath'] as String?,
      photoBackPath: json['photoBackPath'] as String?,
    );
  }
}
