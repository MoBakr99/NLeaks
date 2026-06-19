import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class OverviewCard extends StatelessWidget {
  const OverviewCard({
    super.key,
    required this.cardTitle,
    required this.cardValue,
    required this.cardIconPath,
    this.scaleUp = false,
  });

  final String cardTitle;
  final int cardValue;
  final String cardIconPath;
  final bool scaleUp; // Flag to determine if the icon should be scaled up

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 175.w,
      height: 135.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(cardTitle, style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                cardValue < 999 ? cardValue.toString() : '999+',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium!.copyWith(fontSize: 32.sp),
              ),
              const Spacer(),
              SvgPicture.asset(cardIconPath, width: scaleUp ? 50.w : 35.w),
            ],
          ),
        ],
      ),
    );
  }
}
