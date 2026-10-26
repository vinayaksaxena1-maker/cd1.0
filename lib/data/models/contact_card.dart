import 'package:hive/hive.dart';

part 'contact_card.g.dart';

@HiveType(typeId: 1)
class ContactCard extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String company;

  @HiveField(3)
  final String jobTitle;

  @HiveField(4)
  final List<String> phones;

  @HiveField(5)
  final String email;

  @HiveField(6)
  final String address;

  @HiveField(7)
  final String gstin;

  @HiveField(8)
  final String categoryId;

  @HiveField(9)
  final String? voiceMemoPath;

  @HiveField(10)
  final String notes;

  @HiveField(11)
  final List<String> tags;

  @HiveField(12)
  final String? photoFrontPath;

  @HiveField(13)
  final String? photoBackPath;

  @HiveField(14)
  final DateTime createdAt;

  @HiveField(15)
  final DateTime? updatedAt;

  @HiveField(16)
  final String website;

  ContactCard({
    required this.id,
    required this.name,
    this.company = '',
    this.jobTitle = '',
    this.phones = const [],
    this.email = '',
    this.address = '',
    this.gstin = '',
    this.categoryId = 'other',
    this.voiceMemoPath,
    this.notes = '',
    this.tags = const [],
    this.photoFrontPath,
    this.photoBackPath,
    required this.createdAt,
    this.updatedAt,
    this.website = '',
  });

  ContactCard copyWith({
    String? id,
    String? name,
    String? company,
    String? jobTitle,
    List<String>? phones,
    String? email,
    String? address,
    String? gstin,
    String? categoryId,
    String? voiceMemoPath,
    String? notes,
    List<String>? tags,
    String? photoFrontPath,
    String? photoBackPath,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? website,
  }) {
    return ContactCard(
      id: id ?? this.id,
      name: name ?? this.name,
      company: company ?? this.company,
      jobTitle: jobTitle ?? this.jobTitle,
      phones: phones ?? this.phones,
      email: email ?? this.email,
      address: address ?? this.address,
      gstin: gstin ?? this.gstin,
      categoryId: categoryId ?? this.categoryId,
      voiceMemoPath: voiceMemoPath ?? this.voiceMemoPath,
      notes: notes ?? this.notes,
      tags: tags ?? this.tags,
      photoFrontPath: photoFrontPath ?? this.photoFrontPath,
      photoBackPath: photoBackPath ?? this.photoBackPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      website: website ?? this.website,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'company': company,
      'jobTitle': jobTitle,
      'phones': phones,
      'email': email,
      'address': address,
      'gstin': gstin,
      'categoryId': categoryId,
      'voiceMemoPath': voiceMemoPath,
      'notes': notes,
      'tags': tags,
      'photoFrontPath': photoFrontPath,
      'photoBackPath': photoBackPath,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'website': website,
    };
  }

  factory ContactCard.fromJson(Map<String, dynamic> json) {
    return ContactCard(
      id: json['id'] as String,
      name: json['name'] as String,
      company: json['company'] as String? ?? '',
      jobTitle: json['jobTitle'] as String? ?? '',
      phones: (json['phones'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      email: json['email'] as String? ?? '',
      address: json['address'] as String? ?? '',
      gstin: json['gstin'] as String? ?? '',
      categoryId: json['categoryId'] as String? ?? 'other',
      voiceMemoPath: json['voiceMemoPath'] as String?,
      notes: json['notes'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      photoFrontPath: json['photoFrontPath'] as String?,
      photoBackPath: json['photoBackPath'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
      website: json['website'] as String? ?? '',
    );
  }
}
