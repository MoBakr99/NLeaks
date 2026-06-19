import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:n_leaks/core/constants/app_routes.dart';
import 'package:n_leaks/core/controllers/corp_controller.dart';
import 'package:n_leaks/core/data/models/corp_model.dart';
import 'package:n_leaks/core/widgets/subscription_card.dart';
import 'package:n_leaks/features/home/components/notification_button.dart';
import 'package:n_leaks/features/home/components/leaks_dashboard_section.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

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
      title: InkWell(
        onTap: () {
          Navigator.pushNamed(context, profileRoute);
        },
        child: Row(
          spacing: 10.w,
          children: <Widget>[
            if (context.watch<CorpController>().state!.currentUser.pictureUrl !=
                null)
              CircleAvatar(
                radius: 32.r,
                backgroundImage: AssetImage(
                  context
                      .watch<CorpController>()
                      .state!
                      .currentUser
                      .pictureUrl!,
                ),
              )
            else
              SvgPicture.asset(
                'assets/images/svgs/user_logo.svg',
                width: 64.w,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.tertiary,
                  BlendMode.srcIn,
                ),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hello!', style: Theme.of(context).textTheme.titleSmall),
                SizedBox(height: 5.h),
                Text(
                  context.watch<CorpController>().state!.currentUser.name,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ],
            ),
          ],
        ),
      ),
      actions: const [NotificationButton()],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final CorpModel corpInfo = context.watch<CorpController>().state!;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 120.h),
        child: Column(
          spacing: 10.h,
          children: <Widget>[
            SubscriptionCard(
              corporationLogoPath: corpInfo.logoUrl,
              corporationName: corpInfo.name,
              subscriptionPlan: corpInfo.subscriptionPlan,
              subscriptionDate: corpInfo.subscriptionDate,
              subscriptionStatus: corpInfo.subscriptionStatus,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'OverView',
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  width: 93.w,
                  height: 41.h,
                  child: MaterialButton(
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    color: Theme.of(context).colorScheme.secondary,
                    child: Row(
                      spacing: 5.w,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/svgs/save_icon.svg',
                          width: 10.w,
                        ),
                        Text(
                          'Report',
                          style: Theme.of(context).textTheme.bodySmall!
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            LeaksDashboardSection(
              totalUsers: corpInfo.users,
              totalLeaks: corpInfo.leaks,
            ),
          ],
        ),
      ),
    );
  }
}
