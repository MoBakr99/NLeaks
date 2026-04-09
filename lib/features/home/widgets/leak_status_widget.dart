import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:n_leaks/core/constants/app_colors.dart';

class LeakStatusWidget extends StatelessWidget {
  const LeakStatusWidget({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Color>> statusColors = {
      'Unverified': [warningColorBack, warningColorFront],
      'Active': [dangerColorBack, dangerColorFront],
      'Inactive': [safeColorBack, safeColorFront],
    };
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: statusColors[status]![0],
        border: Border.all(color: statusColors[status]![1], width: 1.w),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            width: 9.w,
            height: 9.h,
            decoration: BoxDecoration(
              color: statusColors[status]![1],
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            status,
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
              color: statusColors[status]![1],
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
