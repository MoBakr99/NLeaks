import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UsersAppBar extends StatelessWidget {
  const UsersAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
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
          onPressed: () {},
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
  final List<Map<String, String>> _users = List.generate(
    20,
    (index) => {
      'name': 'Francisco Miles',
      'email': 'user@acme.com',
      'photo': 'assets/images/pngs/user_photo.png',
    },
  );

  // const [
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _users.length,
      itemBuilder: (context, index) => Container(
        height: 96.h,
        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30.r,
            backgroundImage: AssetImage(_users[index]['photo']!),
          ),
          title: Text(
            _users[index]['name']!,
            style: Theme.of(context).textTheme.titleLarge,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            _users[index]['email']!,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(
                context,
              ).textTheme.bodyMedium!.color!.withValues(alpha: 0.8),
            ),
          ),
          trailing: Icon(
            Icons.more_vert,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ),
    );
  }
}
