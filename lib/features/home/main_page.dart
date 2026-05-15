import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:n_leaks/features/home/components/app_nav_bar.dart';
import 'package:n_leaks/features/home/controllers/nav_bar_controller.dart';
import 'package:n_leaks/features/home/home_page.dart';
import 'package:n_leaks/features/home/leaks_page.dart';
import 'package:n_leaks/features/home/settings_page.dart';
import 'package:n_leaks/features/home/users_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<List<Widget>> _pages = const [
    [HomeAppBar(), HomePage()],
    [LeaksAppBar(), LeaksPage()],
    [UsersAppBar(), UsersPage()],
    [SettingsAppBar(), SettingsPage()],
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavBarController(0),
      child: BlocBuilder<NavBarController, int>(
        builder: (context, indexState) {
          return SafeArea(
            top: false,
            child: Scaffold(
              extendBody: true,
              extendBodyBehindAppBar: indexState == 0 || indexState == 2,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(80.h),
                child: _pages[indexState][0],
              ),
              body: _pages[indexState][1],
              bottomNavigationBar: const AppNavBar(),
            ),
          );
        },
      ),
    );
  }
}
