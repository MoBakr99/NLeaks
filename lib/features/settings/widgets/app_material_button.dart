import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppMaterialButton extends StatelessWidget {
  const AppMaterialButton({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {},
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      color: Theme.of(context).colorScheme.secondary,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
        child: child,
      ),
    );
  }
}
