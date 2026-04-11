import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:n_leaks/features/home/components/leaks_graph.dart';
import 'package:n_leaks/features/home/components/subscription_card.dart';
import 'package:n_leaks/features/home/widgets/overview_card.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  final String _userName = 'Salah Ahmad';

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(
        context,
      ).colorScheme.surface.withValues(alpha: 0.8),
      surfaceTintColor: Theme.of(
        context,
      ).colorScheme.surface.withValues(alpha: 0.8),
      leadingWidth: 90.w,
      leading: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 20.w, top: 4.h),
          child: CircleAvatar(
            radius: 32.r,
            backgroundImage: const AssetImage(
              'assets/images/pngs/main_user_photo.png',
            ),
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hello!', style: Theme.of(context).textTheme.titleSmall),
          SizedBox(height: 5.h),
          Text(_userName, style: Theme.of(context).textTheme.displayMedium),
        ],
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
  final List<Map<String, String>> _overviewData = [
    {
      'title': 'Total Users',
      'value': '124',
      'iconPath': 'assets/images/svgs/users_card_icon.svg',
      'scaleUp': 'true',
    },
    {
      'title': 'Total Leaks',
      'value': '12',
      'iconPath': 'assets/images/svgs/warning_icon.svg',
    },
    {
      'title': 'High Risk Leaks',
      'value': '3',
      'iconPath': 'assets/images/svgs/danger_icon.svg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 120.h),
        child: Column(
          spacing: 10.h,
          children: <Widget>[
            const SubscriptionCard(),
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
              child: ListView.builder(
                itemCount: _overviewData.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(left: index != 0 ? 20.w : 0),
                    child: OverviewCard(
                      cardTitle: _overviewData[index]['title']!,
                      cardValue: _overviewData[index]['value']!,
                      cardIconPath: _overviewData[index]['iconPath']!,
                      scaleUp: _overviewData[index]['scaleUp'] == 'true',
                    ),
                  );
                },
              ),
            ),
            const LeaksGraph(),
          ],
        ),
      ),
    );
  }
}
