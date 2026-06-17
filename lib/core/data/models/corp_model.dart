import 'package:n_leaks/core/data/models/user_model.dart';

class CorpModel {
  final String name;
  final String logoUrl;
  final String industry;
  final DateTime subscriptionDate;
  final DateTime subscriptionEndDate;
  final String subscriptionPlan;
  final String subscriptionStatus;
  final List<String> domains;
  final UserModel currentUser;
  final int users;
  final int leaks;

  CorpModel({
    required this.name,
    required this.logoUrl,
    required this.industry,
    required this.subscriptionDate,
    required this.subscriptionEndDate,
    required this.subscriptionPlan,
    required this.subscriptionStatus,
    required this.domains,
    required this.currentUser,
    required this.users,
    required this.leaks,
  });

  factory CorpModel.fromJson(Map<String, dynamic> json) {
    return CorpModel(
      name: json['name'] as String,
      logoUrl: json['logoUrl'] as String,
      industry: json['industry'] as String,
      subscriptionDate: DateTime.parse(json['subscriptionDate'] as String),
      subscriptionEndDate: DateTime.parse(json['subscriptionEndDate'] as String),
      subscriptionPlan: json['subscriptionPlan'] as String,
      subscriptionStatus: json['subscriptionStatus'] as String,
      domains: List<String>.from(json['domains'] as List<dynamic>),
      currentUser: UserModel.fromJson(
        json['currentUser'] as Map<String, dynamic>,
      ),
      users: json['users'] as int,
      leaks: json['leaks'] as int,
    );
  }

  CorpModel copyWith({
    String? name,
    String? logoUrl,
    String? industry,
    DateTime? subscriptionDate,
    DateTime? subscriptionEndDate,
    String? subscriptionPlan,
    String? subscriptionStatus,
    List<String>? domains,
    UserModel? currentUser,
    int? users,
    int? leaks,
  }) {
    return CorpModel(
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      industry: industry ?? this.industry,
      subscriptionDate: subscriptionDate ?? this.subscriptionDate,
      subscriptionEndDate: subscriptionEndDate ?? this.subscriptionEndDate,
      subscriptionPlan: subscriptionPlan ?? this.subscriptionPlan,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      domains: domains ?? this.domains,
      currentUser: currentUser ?? this.currentUser,
      users: users ?? this.users,
      leaks: leaks ?? this.leaks,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'logoUrl': logoUrl,
      'industry': industry,
      'subscriptionDate': subscriptionDate.toIso8601String(),
      'subscriptionEndDate': subscriptionEndDate.toIso8601String(),
      'subscriptionPlan': subscriptionPlan,
      'subscriptionStatus': subscriptionStatus,
      'domains': domains,
      'currentUser': currentUser.toJson(),
      'users': users,
      'leaks': leaks,
    };
  }
}
