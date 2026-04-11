import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:n_leaks/core/constants/app_colors.dart';

class SubscriptionCard extends StatefulWidget {
  const SubscriptionCard({super.key});

  @override
  State<SubscriptionCard> createState() => _SubscriptionCardState();
}

class _SubscriptionCardState extends State<SubscriptionCard> {
  final DateTime _subscriptionDate = DateTime(2024, 1, 12);
  final String _subscriptionStatus = 'Active';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270.h,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10.h,
          children: <Widget>[
            SvgPicture.asset(
              'assets/images/svgs/corporation_logo.svg',
              height: 80.h,
            ),
            Text(
              'Acme Corporation',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            Container(
              width: 43.w,
              height: 30.h,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Text(
                  'Pro',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.surface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Text.rich(
              TextSpan(
                text: 'Member Since ',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w700),
                children: [
                  TextSpan(
                    text: DateFormat('MMM dd, yyyy').format(_subscriptionDate),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.tertiaryFixed,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8.w,
              children: <Widget>[
                SvgPicture.asset('assets/images/svgs/success_icon.svg'),
                Text.rich(
                  TextSpan(
                    text: 'Status: ',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    children: [
                      TextSpan(
                        text: _subscriptionStatus,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.copyWith(color: successColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
