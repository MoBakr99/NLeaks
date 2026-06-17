class UserModel {
  final String name;
  final String email;
  final String? pictureUrl;
  final List<String> roles;
  final String company;

  UserModel({
    required this.name,
    required this.email,
    required this.company,
    this.pictureUrl,
    this.roles = const ['User'],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] as String,
      email: json['email'] as String,
      pictureUrl: json['profilePictureUrl'] as String?,
      roles: List<String>.from(json['role'] as List<dynamic>),
      company: json['company'] as String,
    );
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? pictureUrl,
    List<String>? roles,
    String? company,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      pictureUrl: pictureUrl ?? this.pictureUrl,
      roles: roles ?? this.roles,
      company: company ?? this.company,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      if (pictureUrl != null) 'profilePictureUrl': pictureUrl,
      'roles': roles,
      'company': company,
    };
  }
}
