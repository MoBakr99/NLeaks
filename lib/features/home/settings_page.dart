import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
            onTap: () {},
          ),
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
