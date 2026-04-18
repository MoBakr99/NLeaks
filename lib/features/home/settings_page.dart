import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:n_leaks/core/constants/app_routes.dart';
import 'package:n_leaks/core/controllers/corp_controller.dart';

class SettingsAppBar extends StatelessWidget {
  const SettingsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Settings', style: Theme.of(context).textTheme.displayMedium),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String role = context.watch<CorpController>().state!.currentUser.role;
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
              Navigator.pushNamed(context, '/profile');
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
          if (role == 'Admin')
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
                Navigator.pushNamed(context, '/subscription');
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
              // Handle sending verification code logic here
              Navigator.pushNamed(context, verifyCodeRoute);
            },
          ),
          if (role == 'Admin')
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
