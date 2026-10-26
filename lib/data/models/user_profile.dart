import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 3)
class UserProfile extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String designation;

  @HiveField(2)
  final String company;

  @HiveField(3)
  final String phone;

  @HiveField(4)
  final String email;

  @HiveField(5)
  final String website;

  @HiveField(6)
  final String address;

  @HiveField(7)
  final String? logoPath;

  @HiveField(8)
  final String? vCardString;

  UserProfile({
    required this.name,
    this.designation = '',
    this.company = '',
    this.phone = '',
    this.email = '',
    this.website = '',
    this.address = '',
    this.logoPath,
    this.vCardString,
  });

  UserProfile copyWith({
    String? name,
    String? designation,
    String? company,
    String? phone,
    String? email,
    String? website,
    String? address,
    String? logoPath,
    String? vCardString,
  }) {
    return UserProfile(
      name: name ?? this.name,
      designation: designation ?? this.designation,
      company: company ?? this.company,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      address: address ?? this.address,
      logoPath: logoPath ?? this.logoPath,
      vCardString: vCardString ?? this.vCardString,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'designation': designation,
      'company': company,
      'phone': phone,
      'email': email,
      'website': website,
      'address': address,
      'logoPath': logoPath,
      'vCardString': vCardString ?? toVCard(),
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String,
      designation: json['designation'] as String? ?? '',
      company: json['company'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      website: json['website'] as String? ?? '',
      address: json['address'] as String? ?? '',
      logoPath: json['logoPath'] as String?,
      vCardString: json['vCardString'] as String?,
    );
  }

  /// Exports standard RFC 6350 vCard text
  String toVCard() {
    final buffer = StringBuffer();
    buffer.writeln('BEGIN:VCARD');
    buffer.writeln('VERSION:3.0');
    buffer.writeln('FN:$name');
    if (company.isNotEmpty) buffer.writeln('ORG:$company');
    if (designation.isNotEmpty) buffer.writeln('TITLE:$designation');
    if (phone.isNotEmpty) buffer.writeln('TEL;TYPE=CELL:$phone');
    if (email.isNotEmpty) buffer.writeln('EMAIL:$email');
    if (website.isNotEmpty) buffer.writeln('URL:$website');
    if (address.isNotEmpty) buffer.writeln('ADR;TYPE=WORK:;;$address;;;;');
    buffer.writeln('END:VCARD');
    return buffer.toString();
  }
}
