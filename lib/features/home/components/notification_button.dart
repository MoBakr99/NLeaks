import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class NotificationButton extends StatefulWidget {
  const NotificationButton({super.key});

  @override
  State<NotificationButton> createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton> {
  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(
          Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.95),
        ),
        elevation: const WidgetStatePropertyAll(0),
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        ),
      ),
      alignmentOffset: Offset(-MediaQuery.sizeOf(context).width + 77.w, 10.h),
      menuChildren: <Widget>[
        MenuItemButton(
          closeOnActivate: false,
          style: ButtonStyle(
            minimumSize: WidgetStatePropertyAll(
              Size(MediaQuery.sizeOf(context).width - 40.w, 200.h),
            ),
            maximumSize: WidgetStatePropertyAll(
              Size(MediaQuery.sizeOf(context).width - 40.w, 600.h),
            ),
            padding: const WidgetStatePropertyAll(EdgeInsets.zero),
          ),
          child: PrimaryScrollController.none(
            child: SizedBox(
              height: 200.h,
              child: FutureBuilder(
                future: Future.delayed(const Duration(seconds: 1)),
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'No notifications yet',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        // SizedBox(width: 10.w),
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.refresh,
                            size: 20.w,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
      builder: (context, controller, child) {
        return IconButton(
          icon: SvgPicture.asset(
            'assets/images/svgs/notification_icon.svg',
            width: 40.w,
          ),
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
        );
      },
    );
  }
}
