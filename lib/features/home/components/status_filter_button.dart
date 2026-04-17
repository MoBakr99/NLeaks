import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:n_leaks/features/home/widgets/filter_button.dart';

class StatusFilterButton extends StatefulWidget {
  const StatusFilterButton({
    super.key,
    required this.options,
    this.selectedOptions = const <String>{},
    this.onSelectionChanged,
  });

  final List<String> options;
  final Set<String> selectedOptions;
  final ValueChanged<List<String>>? onSelectionChanged;

  @override
  State<StatusFilterButton> createState() => _StatusFilterButtonState();
}

class _StatusFilterButtonState extends State<StatusFilterButton> {
  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(
          Theme.of(context).colorScheme.secondary.withValues(alpha: 0.9),
        ),
        elevation: const WidgetStatePropertyAll(0),
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        ),
      ),
      alignmentOffset: Offset(0, 4.h),
      menuChildren:
          widget.options
              .map(
                (status) => MenuItemButton(
                  closeOnActivate: false,
                  onPressed: () => _toggleValue(status),
                  style: ButtonStyle(
                    padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    ),
                  ),
                  child: SizedBox(
                    width: 200.w,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            status,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        if (widget.selectedOptions.contains(status))
                          SvgPicture.asset(
                            'assets/images/svgs/success_icon.svg',
                          ),
                      ],
                    ),
                  ),
                ),
              )
              .expand(
                (element) => [
                  element,
                  Divider(height: 1, indent: 12.w, endIndent: 12.w),
                ],
              )
              .toList()
            ..removeLast(),
      builder: (context, controller, child) => FilterButton(
        text:  widget.selectedOptions.isEmpty
            ? 'Status'
            : 'Status (${widget.selectedOptions.length})',
        onPressed: () {
          if (controller.isOpen) {
            controller.close();
          } else {
            controller.open();
          }
        },
      ),
    );
  }

  void _toggleValue(String status) {
    setState(() {
      if (widget.selectedOptions.contains(status)) {
        widget.selectedOptions.remove(status);
      } else {
        widget.selectedOptions.add(status);
      }
    });
    widget.onSelectionChanged?.call(widget.selectedOptions.toList());
  }
}
