import 'package:flutter/widgets.dart';
import 'package:n_leaks/features/auth/login_page.dart';
import 'package:n_leaks/features/auth/signup_page.dart';

const String homeRoute = '/home';
const String loginRoute = '/login';
const String signupRoute = '/signup';
const String forgotPassRoute = '/forgot-pass';
const String verifyCodeRoute = '/verify-code';
const String resetPassRoute = '/reset-pass';
const String profileRoute = '/profile';
const String settingsRoute = '/settings';

Map<String, Widget Function(BuildContext)> get appRoutes => {
  homeRoute: (context) => const LoginPage(),
  loginRoute: (context) => const LoginPage(),
  signupRoute: (context) => const SignupPage(),
  forgotPassRoute: (context) => const LoginPage(),
  verifyCodeRoute: (context) => const LoginPage(),
  resetPassRoute: (context) => const LoginPage(),
};