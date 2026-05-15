import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:n_leaks/core/constants/app_routes.dart';
import 'package:n_leaks/core/controllers/corp_controller.dart';
import 'package:n_leaks/core/data/models/user_model.dart';
import 'package:n_leaks/core/services/auth_service.dart';
import 'package:n_leaks/features/auth/controllers/timer_controller.dart';

class SettingsAppBar extends StatelessWidget {
  const SettingsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 80.h,
      title: Text('Settings', style: Theme.of(context).textTheme.displayMedium),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserModel user = context.watch<CorpController>().state!.currentUser;
    return SingleChildScrollView(
      child: Column(
        children: [
          ListTile(
            title: Text(
              'Profile',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 14.sp,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 30.w),
            onTap: () {
              Navigator.pushNamed(context, profileRoute);
            },
          ),
          ListTile(
            title: Text(
              'Notification Preferences',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 14.sp,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 30.w),
            onTap: () {},
          ),
          if (user.role == 'ADMIN')
            ListTile(
              title: Text(
                'Subscription',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 14.sp,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 30.w),
              onTap: () {
                Navigator.pushNamed(context, subscriptionRoute);
              },
            ),
          ListTile(
            title: Text(
              'Change Password',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 14.sp,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 30.w),
            onTap: () {
              if (context.read<TimerController>().state.inSeconds == 0) {
                AuthService().sendOTP(user.email);
                context.read<TimerController>().add(
                  StartTimer(const Duration(minutes: 1)),
                );
              }
              Navigator.pushNamed(
                context,
                verifyCodeRoute,
                arguments: user.email,
              );
            },
          ),
          if (user.role == 'ADMIN')
            ListTile(
              title: Text(
                'Add Payment Method',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              trailing: Icon(
                Icons.add,
                size: 16.sp,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 30.w),
              onTap: () {},
            ),
        ],
      ),
    );
  }
}
