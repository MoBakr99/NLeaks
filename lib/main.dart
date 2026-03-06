import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:n_leaks/core/constants/app_routes.dart';
import 'package:n_leaks/core/themes/theme.dart';
import 'package:n_leaks/features/auth/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(440, 956),
      minTextAdapt: true,
      builder: (context, child) => MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: appTheme,
          routes: appRoutes,
          home: const LoginPage(),
        ),
    );
  }
}
