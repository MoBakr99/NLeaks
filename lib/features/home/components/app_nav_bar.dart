import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:n_leaks/features/home/controllers/nav_bar_controller.dart';

class AppNavBar extends StatelessWidget {
  const AppNavBar({super.key});

  final List<Map<String, String>> _assets = const [
    {
      'label': 'Home',
      'solid': 'assets/images/svgs/home_solid.svg',
      'outlined': 'assets/images/svgs/home_outlined.svg',
    },
    {
      'label': 'Leaks',
      'solid': 'assets/images/svgs/user_solid.svg',
      'outlined': 'assets/images/svgs/user_outlined.svg',
    },
    {
      'label': 'Users',
      'solid': 'assets/images/svgs/users_solid.svg',
      'outlined': 'assets/images/svgs/users_outlined.svg',
    },
    {
      'label': 'Settings',
      'solid': 'assets/images/svgs/settings_solid.svg',
      'outlined': 'assets/images/svgs/settings_outlined.svg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95.h,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      clipBehavior: Clip.antiAlias,
      child: BlocBuilder<NavBarController, int>(
        builder: (context, indexState) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Theme.of(
              context,
            ).colorScheme.surface.withValues(alpha: 0.8),
            currentIndex: indexState,
            onTap: (index) =>
                context.read<NavBarController>().add(SetIndex(index)),
            selectedLabelStyle: Theme.of(context).textTheme.displayMedium
                ?.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700),
            unselectedLabelStyle: Theme.of(context).textTheme.displayMedium
                ?.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w500),
            unselectedItemColor: Theme.of(context).colorScheme.tertiary,
            items: List.generate(
              4,
              (index) => BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 6.h),
                  child: SvgPicture.asset(
                    indexState == index
                        ? _assets[index]['solid']!
                        : _assets[index]['outlined']!,
                    width: 24.w,
                    height: 24.h,
                  ),
                ),
                label: _assets[index]['label']!,
              ),
            ),
          );
        },
      ),
    );
  }
}
