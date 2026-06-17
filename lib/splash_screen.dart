import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:n_leaks/core/constants/app_routes.dart';
import 'package:n_leaks/core/controllers/corp_controller.dart';
import 'package:n_leaks/core/controllers/token_controller.dart';
import 'package:n_leaks/core/data/models/corp_model.dart';
import 'package:n_leaks/core/data/models/user_model.dart';
import 'package:n_leaks/core/services/api_service.dart';
import 'package:n_leaks/core/data/preferences/preference_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    CorpModel? corp;
    final accessToken = PreferenceManager().getString('access_token');
    if (accessToken != null) {
      _getSession(accessToken).then((value) {
        corp = value;
        if (mounted) {
          context.read<CorpController>().add(LogIn(corp));
        }
      });
    }
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          corp == null ? loginRoute : homeRoute,
        );
        context.read<TokenController>().add(SetToken(accessToken));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/pngs/app_logo.png', scale: 3.2),
      ),
    );
  }

  Future<CorpModel?> _getSession(String accessToken) async {
    final Response userResponse;
    final Response companyResponse;
    try {
      userResponse = await APIService().getUserProfile(accessToken);
      if (userResponse.statusCode != 200) {
        return null;
      }
      companyResponse = await APIService().getCompanyInfo(accessToken);
    } catch (error) {
      return null;
    }

    return CorpModel(
      name: companyResponse.data['name'], // present
      logoUrl: 'assets/images/svgs/corporation_logo.svg', // to be added later
      industry: companyResponse.data['industry'] ?? 'Tech', // present
      subscriptionDate: DateTime.parse(
        companyResponse.data['createdAt'],
      ), // present
      subscriptionEndDate: DateTime.parse(
        companyResponse.data['subscriptionEndsAt'],
      ), // present
      subscriptionPlan: companyResponse.data['subscriptionType'], // present
      subscriptionStatus: companyResponse.data['status'], // present
      domains: List<String>.from(
        companyResponse.data['domains'] as List<dynamic>,
      ), // present
      currentUser: UserModel(
        name: userResponse.data['name'], // present
        email: userResponse.data['email'], // present
        company: companyResponse.data['name'], // present
        roles: List<String>.from(userResponse.data['roles']), // present
      ),
      users: companyResponse.data['users'].length, // present
      // leaks: leaksResponse.data['total'], // present
      leaks: companyResponse.data['_count']['breachData'], // present
    );
  }
}
