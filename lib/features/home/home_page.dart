import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:n_leaks/core/constants/app_routes.dart';
import 'package:n_leaks/core/controllers/corp_controller.dart';
import 'package:n_leaks/core/controllers/token_controller.dart';
import 'package:n_leaks/core/data/models/corp_model.dart';
import 'package:n_leaks/core/services/api_service.dart';
// import 'package:n_leaks/features/home/components/leaks_graph.dart';
import 'package:n_leaks/core/widgets/subscription_card.dart';
import 'package:n_leaks/features/home/widgets/overview_card.dart';

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
      actions: [
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            'assets/images/svgs/notification_icon.svg',
            width: 40.w,
          ),
        ),
      ],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Map<String, String>>> _overviewCardsData(
    int users,
    int leaks,
  ) async {
    final response = await APIService().getLeaks(
      context.read<TokenController>().state!,
    );
    final criticalLeaks = List.from(
      response.data['data'].where((leak) => leak['severity'] == 'critical'),
    ).length;
    return [
      {
        'title': 'Total Users',
        'value': users.toString(),
        'iconPath': 'assets/images/svgs/users_card_icon.svg',
        'scaleUp': 'true',
      },
      {
        'title': 'Total Leaks',
        'value': leaks.toString(),
        'iconPath': 'assets/images/svgs/warning_icon.svg',
      },
      {
        'title': 'Critical Leaks',
        'value': criticalLeaks.toString(),
        'iconPath': 'assets/images/svgs/danger_icon.svg',
      },
    ];
  }

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
            SizedBox(
              height: 135.h,
              child: FutureBuilder(
                future: _overviewCardsData(corpInfo.users, corpInfo.leaks),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final overviewDataCards = snapshot.data!;
                  return ListView.builder(
                    itemCount: overviewDataCards.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(left: index != 0 ? 20.w : 0),
                        child: OverviewCard(
                          cardTitle: overviewDataCards[index]['title']!,
                          cardValue: overviewDataCards[index]['value']!,
                          cardIconPath: overviewDataCards[index]['iconPath']!,
                          scaleUp:
                              overviewDataCards[index]['scaleUp'] == 'true',
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            // LeaksGraph(leaks: corpInfo.leaks ?? []),
          ],
        ),
      ),
    );
  }
}
