class LeakModel {
  final String id;
  final String name;
  final String email;
  final DateTime date;
  final String status;
  final String? description;
  final String? source;

  LeakModel({
    required this.id,
    required this.name,
    required this.email,
    required this.date,
    required this.status,
    this.description,
    this.source,
  });

  factory LeakModel.fromJson(Map<String, dynamic> json) {
    return LeakModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      date: DateTime.parse(json['date'] as String),
      status: json['status'] as String,
      description: json['description'] as String?,
      source: json['source'] as String?,
    );
  }

  LeakModel copyWith({
    String? id,
    String? name,
    String? email,
    DateTime? date,
    String? status,
    String? description,
    String? source,
  }) {
    return LeakModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      date: date ?? this.date,
      status: status ?? this.status,
      description: description ?? this.description,
      source: source ?? this.source,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'date': date.toIso8601String(),
      'status': status,
      if (description != null) 'description': description,
      if (source != null) 'source': source,
    };
  }
}
