import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:n_leaks/core/constants/app_routes.dart';
import 'package:n_leaks/core/controllers/corp_controller.dart';
import 'package:n_leaks/core/controllers/token_controller.dart';
import 'package:n_leaks/core/data/models/corp_model.dart';
import 'package:n_leaks/core/data/models/user_model.dart';
import 'package:n_leaks/core/data/preferences/preference_manager.dart';
import 'package:n_leaks/core/services/api_service.dart';
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
    final String accessToken;

    try {
      userResponse = await APIService().login(email, password);
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
      accessToken = userResponse.data['data']['access_token'];
      companyResponse = await APIService().getCompanyInfo(accessToken);
      if (mounted) {
        context.read<TokenController>().add(SetToken(accessToken));
      }
      if (_rememberUser == true) {
        await PreferenceManager().setString('access_token', accessToken);
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
        name: user['name'], // present
        email: user['email'], // present
        company: companyResponse.data['name'], // present
        roles: List<String>.from(user['roles']), // present
      ),
      users: companyResponse.data['users'].length, // present
      // leaks: leaksResponse.data['total'], // present
      leaks: companyResponse.data['_count']['breachData'], // present
    );
  }
}
