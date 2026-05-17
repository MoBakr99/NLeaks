import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:n_leaks/core/constants/app_routes.dart';
import 'package:n_leaks/core/controllers/corp_controller.dart';
import 'package:n_leaks/core/data/models/corp_model.dart';
import 'package:n_leaks/core/data/models/leak_model.dart';
import 'package:n_leaks/core/data/models/user_model.dart';
import 'package:n_leaks/core/services/auth_service.dart';
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
          context.read<CorpController>().add(LogIn(corp!));
        }
      });
    }
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          corp == null ? loginRoute : homeRoute,
        );
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
    final Response usersResponse;
    final Response leaksResponse;
    try {
      userResponse = await AuthService().getUserProfile(accessToken);
      if (userResponse.statusCode != 200) {
        return null;
      }
      companyResponse = await AuthService().getCompanyInfo(accessToken);
      usersResponse = await AuthService().getUsers(accessToken);
      leaksResponse = await AuthService().getLeaks(accessToken);
    } catch (error) {
      return null;
    }

    return CorpModel(
      name: companyResponse.data['name'], // present
      logoUrl: 'assets/images/svgs/corporation_logo.svg', // to be added later
      contactEmail: '', // remove
      industry: companyResponse.data['industry'] ?? 'Tech', // present
      subscriptionDate: DateTime(2020), // not present
      subscriptionPlan: companyResponse.data['subscriptionType'], // present
      subscriptionStatus: '', // not present
      domains: [companyResponse.data['domain']], // change to String
      usersLimit: companyResponse.data['size'] ?? 130, // present
      currentUser: UserModel(
        id: userResponse.data['id'], // present
        name: userResponse.data['name'], // present
        username: '', // remove
        email: userResponse.data['email'], // present
        position: '', // not present
        company: companyResponse.data['name'], // present
        pictureUrl: 'assets/images/pngs/main_user_photo.png', // not present
        role: List<String>.from(
          userResponse.data['roles'],
        )[0], // change to List<String>
        gender: '', // not present
        language: '', // not present
        country: '', // not present
        phoneNumber: '', // not present
      ),
      users: List<UserModel>.from(
        usersResponse.data['data'].map(
          (user) => UserModel(
            id: user['id'], // present
            name: user['name'], // present
            username: '', // remove
            email: user['email'], // present
            position: '', // not present
            company: companyResponse.data['name'], // present
            pictureUrl: 'assets/images/pngs/user_photo.png', // not present
            role: List<String>.from(user['roles'])[0], // change to List<String>
          ),
        ),
      ),
      leaks: List<LeakModel>.from(
        leaksResponse.data['data'].map(
          (leak) => LeakModel(
            id: leak['id'], // present
            name: leak['username'], // present
            email: leak['email'], // present
            date: DateTime.parse(leak['source']['discoveredAt']), // present
            status: 'Unverified', // not present
            source: leak['source']['name'], // present
            description: leak['source']['description'], // present
          ),
        ),
      ),
    );
  }
}
