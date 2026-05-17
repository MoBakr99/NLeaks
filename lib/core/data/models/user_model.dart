class UserModel {
  final String id;
  final String name;
  final String email;
  final String? pictureUrl;
  final String role;
  final String gender;
  final String? phoneNumber;
  final String? country;
  final String language;
  final String position;
  final String company;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.position,
    required this.company,
    this.pictureUrl,
    this.phoneNumber,
    this.country,
    this.role = 'User',
    this.gender = 'Male',
    this.language = 'English',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      pictureUrl: json['profilePictureUrl'] as String?,
      role: json['role'] as String,
      gender: json['gender'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      country: json['country'] as String?,
      language: json['language'] as String,
      position: json['position'] as String,
      company: json['company'] as String,
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? pictureUrl,
    String? role,
    String? gender,
    String? phoneNumber,
    String? country,
    String? language,
    String? position,
    String? company,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      pictureUrl: pictureUrl ?? this.pictureUrl,
      role: role ?? this.role,
      gender: gender ?? this.gender,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      country: country ?? this.country,
      language: language ?? this.language,
      position: position ?? this.position,
      company: company ?? this.company,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      if (pictureUrl != null) 'profilePictureUrl': pictureUrl,
      'role': role,
      'gender': gender,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (country != null) 'country': country,
      'language': language,
      'position': position,
      'company': company,
    };
  }
}
