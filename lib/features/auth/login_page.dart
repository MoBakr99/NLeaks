import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:n_leaks/core/constants/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:n_leaks/core/controllers/corp_controller.dart';
import 'package:n_leaks/core/data/models/corp_model.dart';
import 'package:n_leaks/core/data/models/leak_model.dart';
import 'package:n_leaks/core/data/models/user_model.dart';
import 'package:n_leaks/core/widgets/named_text_field.dart';
import 'package:n_leaks/features/auth/widgets/app_button.dart';
import 'package:n_leaks/features/auth/widgets/or_divider.dart';
import 'package:n_leaks/features/auth/widgets/social_buttons.dart';

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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Perform login action
                        final CorpModel? corp = _login(
                          _emailController.text,
                          _passController.text,
                        );
                        if (corp != null) {
                          context.read<CorpController>().add(LogIn(corp));
                          Navigator.pushReplacementNamed(context, homeRoute);
                        }
                      }
                    },
                    text: 'Login',
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Don't have an account?",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, signupRoute);
                        },
                        child: Text(
                          'Sign up',
                          style: Theme.of(context).textTheme.bodySmall!
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
                  const OrDivider(login: true),
                  SizedBox(height: 16.h),
                  SocialButtons(
                    assets: const <String>[
                      'assets/images/svgs/facebook_logo.svg',
                      'assets/images/svgs/google_logo.svg',
                      'assets/images/svgs/apple_logo.svg',
                    ],
                    onPressed: <void Function()>[() {}, () {}, () {}],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  CorpModel? _login(String email, String password) {
    // Simulate login logic

    // Dummy Data
    Random random = Random();

    final List<String> fNames = [
      'Ahmed',
      'Ezz',
      'Fares',
      'Mazen',
      'Mohammad',
      'Mustafa',
      'Omar',
    ]..shuffle(random);

    final List<String> lNames = [
      'Adel',
      'Bakr',
      'Daif',
      'Farahat',
      'Hasan',
      'Nayel',
      'Othman',
      'Ragab',
      'Yahia',
    ]..shuffle(random);

    final List<String> names = List.generate(
      30,
      (index) =>
          '${fNames[random.nextInt(fNames.length)]} ${lNames[random.nextInt(lNames.length)]}',
    );

    final List<String> positions = [
      'Backend Developer',
      'Cybersecurity',
      'Data Scientist',
      'Flutter Developer',
      'Frontend Developer',
      'Product Manager',
      'Software Engineer',
      'UI/UX Designer',
    ];

    return CorpModel(
      name: 'Acme Corporation',
      logoUrl: 'assets/images/svgs/corporation_logo.svg',
      contactEmail: 'security@acme.inc',
      industry: 'Technology',
      subscriptionDate: DateTime(2024, 1, 12),
      subscriptionPlan: 'Pro',
      subscriptionStatus: 'Active',
      domains: ['acme.com', 'acme.inc', 'acme-labs.io'],
      usersLimit: 130,
      currentUser: UserModel(
        id: '22010232',
        name: 'Mohammad Bakr',
        username: 'MoBakr99',
        email: email,
        position: 'Software Engineer',
        company: 'Acme Corporation',
        pictureUrl: 'assets/images/pngs/main_user_photo.png',
        role: 'Admin',
      ),
      users: List.generate(
        30,
        (index) => UserModel(
          id: '${index + 22010201}',
          name: names[index],
          username: '${names[index]}_$index',
          email: '${names[index]}${index + 11}@acme.com',
          position: positions[index % positions.length],
          company: 'Acme Corporation',
          pictureUrl: 'assets/images/pngs/user_photo.png',
          country: 'Egypt',
        ),
      ),
      leaks: List.generate(
        100,
        (index) => LeakModel(
          id: '$index',
          name: names.reversed.toList()[(index) % names.length],
          email:
              '${names.reversed.toList()[(index) % names.length]}${index + 11}@acme.com',
          date: DateTime(
            2025,
            1,
            22,
          ).add(Duration(days: random.nextInt(50) * 10)),
          status: ['Active', 'Inactive', 'Unverified'][random.nextInt(3)],
        ),
      ),
    );
  }
}
