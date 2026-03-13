import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:n_leaks/core/constants/app_routes.dart';
import 'package:n_leaks/core/widgets/named_text_field.dart';
import 'package:n_leaks/features/auth/widgets/app_button.dart';
import 'package:n_leaks/features/auth/widgets/or_divider.dart';
import 'package:n_leaks/features/auth/widgets/social_buttons.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool? _agreeTerms = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
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
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Sign up',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Let’s get you all st up so you can access your personal account.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: NamedTextField(
                          name: 'First Name',
                          hintText: 'John',
                          controller: _firstNameController,
                        ),
                      ),
                      SizedBox(width: 24.w),
                      Expanded(
                        child: NamedTextField(
                          name: 'Last Name',
                          hintText: 'Doe',
                          controller: _lastNameController,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: NamedTextField(
                          name: 'Email',
                          hintText: 'john.doe@example.com',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      SizedBox(width: 24.w),
                      Expanded(
                        child: NamedTextField(
                          name: 'Phone',
                          hintText: '123-456-7890',
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  NamedTextField(
                    name: 'Password',
                    hintText: 'Enter your password',
                    controller: _passController,
                    visibilityButton: true,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  SizedBox(height: 24.h),
                  NamedTextField(
                    name: 'Confirm Password',
                    hintText: 'Confirm your password',
                    controller: _confirmPassController,
                    visibilityButton: true,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Password is required';
                      }
                      if (value.trim().length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      if (value != _passController.text) {
                        return "Passwords don't match";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: _agreeTerms,
                        side: BorderSide(
                          width: 2.sp,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        onChanged: (value) {
                          setState(() => _agreeTerms = value);
                        },
                      ),
                      Text(
                        'I agree to all the ',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Terms',
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
                      Text(
                        ' and ',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Privacy Policy',
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
                  SizedBox(height: 48.h),
                  AppButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Perform signup action
                      }
                    },
                    text: 'Create Account',
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Already have an account?',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, loginRoute);
                        },
                        child: Text(
                          'Login',
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
                  OrDivider(login: false),
                  SizedBox(height: 20.h),
                  SocialButtons(
                    assets: <String>[
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
}
