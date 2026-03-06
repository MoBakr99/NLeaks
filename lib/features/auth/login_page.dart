import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:n_leaks/core/constants/app_routes.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
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
                        Text('Remember me'),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot Password',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
                      print('Success!\nEmail: ${_emailController.text}');
                      print('Password: ${_passController.text}');
                    }
                  },
                  text: 'Login',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
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
                OrDivider(login: true),
                SizedBox(height: 16.h),
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
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
  }
}
