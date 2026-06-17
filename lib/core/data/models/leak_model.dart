class LeakModel {
  final String name;
  final String email;
  final String? password;
  final DateTime detectionDate;
  final DateTime? verificationDate;
  final String severity;
  final String source;
  final String? description;

  LeakModel({
    required this.name,
    required this.email,
    required this.password,
    required this.detectionDate,
    required this.verificationDate,
    required this.severity,
    required this.source,
    this.description,
  });

  factory LeakModel.fromJson(Map<String, dynamic> json) {
    return LeakModel(
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String?,
      detectionDate: DateTime.parse(json['detectionDate'] as String),
      severity: json['severity'] as String,
      verificationDate: DateTime.parse(json['verificationDate'] as String),
      description: json['description'] as String?,
      source: json['source'] as String,
    );
  }

  LeakModel copyWith({
    String? name,
    String? email,
    String? password,
    DateTime? detectionDate,
    DateTime? verificationDate,
    String? severity,
    String? description,
    String? source,
  }) {
    return LeakModel(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      detectionDate: detectionDate ?? this.detectionDate,
      verificationDate: verificationDate ?? this.verificationDate,
      severity: severity ?? this.severity,
      description: description ?? this.description,
      source: source ?? this.source,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'detectionDate': detectionDate.toIso8601String(),
      'verificationDate': verificationDate?.toIso8601String(),
      'severity': severity,
      'source': source,
      if (description != null) 'description': description,
    };
  }
}
