import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:n_leaks/core/constants/app_routes.dart';
import 'package:n_leaks/core/controllers/corp_controller.dart';
import 'package:n_leaks/core/data/models/corp_model.dart';
import 'package:n_leaks/core/data/models/leak_model.dart';
import 'package:n_leaks/core/data/models/user_model.dart';
import 'package:n_leaks/core/data/preferences/preference_manager.dart';
import 'package:n_leaks/core/services/auth_service.dart';
import 'package:n_leaks/core/widgets/named_text_field.dart';
import 'package:n_leaks/features/auth/widgets/app_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool? _rememberUser = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
    _formKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: AlignmentGeometry.centerLeft,
                    child: Text(
                      'Login',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Align(
                    alignment: AlignmentGeometry.centerLeft,
                    child: Text(
                      'Login to access your travel wise account',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  SizedBox(height: 35.h),
                  NamedTextField(
                    name: 'Email',
                    hintText: 'Enter your email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 24.h),
                  NamedTextField(
                    name: 'Password',
                    hintText: 'Enter your password',
                    controller: _passController,
                    visibilityButton: true,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: _rememberUser,
                            side: BorderSide(
                              width: 2.sp,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                            onChanged: (value) {
                              setState(() => _rememberUser = value);
                            },
                          ),
                          const Text('Remember me'),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, forgotPassRoute);
                        },
                        child: Text(
                          'Forgot Password',
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                decoration: TextDecoration.underline,
                                decorationColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                              ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),
                  AppButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final CorpModel? corp = await _login(
                          _emailController.text,
                          _passController.text,
                        );
                        if (corp != null && context.mounted) {
                          context.read<CorpController>().add(LogIn(corp));
                          Navigator.pushReplacementNamed(context, homeRoute);
                        }
                      }
                    },
                    text: 'Login',
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<CorpModel?> _login(String email, String password) async {
    final Response userResponse;
    final Response companyResponse;
    final Response usersResponse;
    final Response leaksResponse;
    try {
      userResponse = await AuthService().login(email, password);
      if (userResponse.statusCode != 200 && mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Login Failed'),
            content: Text(
              userResponse.data['message'] ??
                  'Check your credentials and try again.',
            ),
            titleTextStyle: Theme.of(context).textTheme.titleLarge,
            backgroundColor: Theme.of(context).colorScheme.onSurface,
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return null;
      }
      companyResponse = await AuthService().getCompanyInfo(
        userResponse.data['data']['access_token'],
      );
      usersResponse = await AuthService().getUsers(
        userResponse.data['data']['access_token'],
      );
      leaksResponse = await AuthService().getLeaks(
        userResponse.data['data']['access_token'],
      );
      if (_rememberUser == true) {
        await PreferenceManager().setString(
          'access_token',
          userResponse.data['data']['access_token'],
        );
      }
    } catch (error) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Login Failed'),
            content: Text('Error: $error'),
            titleTextStyle: Theme.of(context).textTheme.titleLarge,
            backgroundColor: Theme.of(context).colorScheme.onSurface,
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      return null;
    }

    final user = userResponse.data['data']['user'];

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
        id: user['id'], // present
        name: user['name'], // present
        username: '', // remove
        email: user['email'], // present
        position: '', // not present
        company: companyResponse.data['name'], // present
        pictureUrl: 'assets/images/pngs/main_user_photo.png', // not present
        role: List<String>.from(user['roles'])[0], // change to List<String>
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
