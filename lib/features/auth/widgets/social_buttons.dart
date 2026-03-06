import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({
    super.key,
    this.assets = const [
      'assets/images/svgs/google_logo.svg',
      'assets/images/svgs/facebook_logo.svg',
      'assets/images/svgs/apple_logo.svg',
    ],
    required this.onPressed,
  });

  final List<String> assets;
  final List<void Function()> onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(assets.length, (int index) {
        return SizedBox(
          width: 120.w,
          height: 50.h,
          child: ElevatedButton(
            onPressed: onPressed[index],
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
                side: BorderSide(
                  width: 1,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            child: SvgPicture.asset(assets[index], width: 24.w, height: 24.h),
          ),
        );
      }),
    );
  }
}
