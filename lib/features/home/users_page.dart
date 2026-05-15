import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:n_leaks/core/controllers/corp_controller.dart';
import 'package:n_leaks/features/home/widgets/add_user_widget.dart';
import 'package:n_leaks/features/home/widgets/user_info_display.dart';

class UsersAppBar extends StatelessWidget {
  const UsersAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(
        context,
      ).colorScheme.surface.withValues(alpha: 0.8),
      surfaceTintColor: Theme.of(
        context,
      ).colorScheme.surface.withValues(alpha: 0.8),
      toolbarHeight: 80.h,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Team Members',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          Text(
            'Manage access and roles',
            style: Theme.of(
              context,
            ).textTheme.titleSmall!.copyWith(fontSize: 12.sp),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            showDialog<void>(
              context: context,
              builder: (_) => const AddNewUserDialog(),
            );
          },
          icon: Image.asset('assets/images/pngs/add_user_photo.png'),
        ),
      ],
    );
  }
}

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    final users = context.watch<CorpController>().state!.users;
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) => Container(
        height: 96.h,
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 16.w),
        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: UserInfoDisplay(
                name: users[index].name,
                email: users[index].email,
                avatarUrl: users[index].pictureUrl,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
