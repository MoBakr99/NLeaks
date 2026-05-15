import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:n_leaks/core/constants/app_colors.dart';

class SubscriptionCard extends StatefulWidget {
  const SubscriptionCard({
    super.key,
    required this.corporationLogoPath,
    required this.corporationName,
    required this.subscriptionPlan,
    required this.subscriptionDate,
    required this.subscriptionStatus,
  });

  final String corporationLogoPath;
  final String corporationName;
  final String subscriptionPlan;
  final DateTime subscriptionDate;
  final String subscriptionStatus;

  @override
  State<SubscriptionCard> createState() => _SubscriptionCardState();
}

class _SubscriptionCardState extends State<SubscriptionCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10.h,
          children: <Widget>[
            SvgPicture.asset(widget.corporationLogoPath, height: 80.h),
            Text(
              widget.corporationName,
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                widget.subscriptionPlan,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.surface,
                  fontWeight: FontWeight.w700,
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
                    text: DateFormat(
                      'MMM dd, yyyy',
                    ).format(widget.subscriptionDate),
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
                        text: widget.subscriptionStatus,
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
