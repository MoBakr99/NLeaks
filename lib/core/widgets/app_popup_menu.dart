import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppPopupMenu extends StatefulWidget {
  const AppPopupMenu({
    super.key,
    required this.options,
    required this.child,
    this.onSelected,
  });

  final Widget child;
  final void Function(String)? onSelected;
  final List<String> options;

  @override
  State<AppPopupMenu> createState() => _AppPopupMenuState();
}

class _AppPopupMenuState extends State<AppPopupMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: widget.child,
      color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.8),
      elevation: 0,
      padding: EdgeInsets.zero,
      menuPadding: EdgeInsets.zero,
      offset: Offset(0, 50.h),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      constraints: BoxConstraints(minWidth: 220.w),
      onSelected: widget.onSelected,
      itemBuilder: (context) {
        final List<PopupMenuEntry<String>> items = <PopupMenuEntry<String>>[];
        for (var index = 0; index < widget.options.length; index++) {
          final option = widget.options[index];
          items.add(
            PopupMenuItem<String>(
              value: option,
              height: 40.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Center(
                child: Text(
                  option,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          );
          if (index != widget.options.length - 1) {
            items.add(
              PopupMenuDivider(height: 1, indent: 16.w, endIndent: 16.w),
            );
          }
        }
        return items;
      },
    );
  }
}
