import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:n_leaks/core/controllers/token_controller.dart';
import 'package:n_leaks/core/data/models/user_model.dart';
import 'package:n_leaks/core/services/api_service.dart';
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
  Future<List<UserModel>> _fetchUsers() async {
    final response = await APIService().getCompanyInfo(
      context.read<TokenController>().state!,
    );
    return List<UserModel>.from(
      response.data['users'].map(
        (user) => UserModel(
          name: user['name'],
          email: user['email'],
          company: response.data['name'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final users = snapshot.data!;
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
              ],
            ),
          ),
        );
      },
    );
  }
}
