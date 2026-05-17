import 'package:n_leaks/core/data/models/leak_model.dart';
import 'package:n_leaks/core/data/models/user_model.dart';

class CorpModel {
  final String name;
  final String logoUrl;
  final String industry;
  final DateTime subscriptionDate;
  final String subscriptionPlan;
  final String subscriptionStatus;
  final String domain;
  final int usersLimit;
  final UserModel currentUser;
  final List<UserModel> users;
  final List<LeakModel>? leaks;

  CorpModel({
    required this.name,
    required this.logoUrl,
    required this.industry,
    required this.subscriptionDate,
    required this.subscriptionPlan,
    required this.subscriptionStatus,
    required this.domain,
    required this.usersLimit,
    required this.currentUser,
    required this.users,
    this.leaks,
  });

  factory CorpModel.fromJson(Map<String, dynamic> json) {
    return CorpModel(
      name: json['name'] as String,
      logoUrl: json['logoUrl'] as String,
      industry: json['industry'] as String,
      subscriptionDate: DateTime.parse(json['subscriptionDate'] as String),
      subscriptionPlan: json['subscriptionPlan'] as String,
      subscriptionStatus: json['subscriptionStatus'] as String,
      domain: json['domain'] as String,
      usersLimit: json['usersLimit'] as int,
      currentUser: UserModel.fromJson(
        json['currentUser'] as Map<String, dynamic>,
      ),
      users: (json['users'] as List<dynamic>)
          .map(
            (userJson) => UserModel.fromJson(userJson as Map<String, dynamic>),
          )
          .toList(),
      leaks: (json['leaks'] as List<dynamic>?)
          ?.map(
            (leakJson) => LeakModel.fromJson(leakJson as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  CorpModel copyWith({
    String? name,
    String? logoUrl,
    String? industry,
    DateTime? subscriptionDate,
    String? subscriptionPlan,
    String? subscriptionStatus,
    String? domain,
    int? usersLimit,
    UserModel? currentUser,
    List<UserModel>? users,
    List<LeakModel>? leaks,
  }) {
    return CorpModel(
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      industry: industry ?? this.industry,
      subscriptionDate: subscriptionDate ?? this.subscriptionDate,
      subscriptionPlan: subscriptionPlan ?? this.subscriptionPlan,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      domain: domain ?? this.domain,
      usersLimit: usersLimit ?? this.usersLimit,
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
      'subscriptionPlan': subscriptionPlan,
      'subscriptionStatus': subscriptionStatus,
      'domain': domain,
      'usersLimit': usersLimit,
      'currentUser': currentUser.toJson(),
      'users': users.map((user) => user.toJson()).toList(),
      if (leaks != null) 'leaks': leaks!.map((leak) => leak.toJson()).toList(),
    };
  }
}
