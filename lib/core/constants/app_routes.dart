import 'package:flutter/widgets.dart';
import 'package:n_leaks/features/auth/forgot_pass_page.dart';
import 'package:n_leaks/features/auth/set_pass_page.dart';
import 'package:n_leaks/features/auth/verify_code_page.dart';
import 'package:n_leaks/splash_screen.dart';
import 'package:n_leaks/features/auth/login_page.dart';
import 'package:n_leaks/features/auth/signup_page.dart';

const String splashRoute = '/splash';
const String homeRoute = '/home';
const String loginRoute = '/login';
const String signupRoute = '/signup';
const String forgotPassRoute = '/forgot-pass';
const String verifyCodeRoute = '/verify-code';
const String resetPassRoute = '/reset-pass';
const String profileRoute = '/profile';
const String settingsRoute = '/settings';

Map<String, Widget Function(BuildContext)> get appRoutes => {
  splashRoute: (context) => const SplashScreen(),
  homeRoute: (context) => const LoginPage(),
  loginRoute: (context) => const LoginPage(),
  signupRoute: (context) => const SignupPage(),
  forgotPassRoute: (context) => const ForgotPassPage(),
  verifyCodeRoute: (context) => const VerifyCodePage(),
  resetPassRoute: (context) => const SetPassPage(),
};
