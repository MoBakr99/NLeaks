import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:n_leaks/features/home/components/calendar_date_range_selector.dart';
import 'package:n_leaks/features/home/widgets/filter_button.dart';

class DateFilterButton extends StatefulWidget {
  const DateFilterButton({super.key, this.dateRange, this.onDateRangeSelected});

  final DateTimeRange? dateRange;
  final Function(DateTime?, DateTime?)? onDateRangeSelected;

  @override
  State<DateFilterButton> createState() => _DateFilterButtonState();
}

class _DateFilterButtonState extends State<DateFilterButton> {
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
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        ),
      ),
      alignmentOffset: Offset(0, 4.h),
      menuChildren: [
        MenuItemButton(
          closeOnActivate: false,
          style: const ButtonStyle(
            padding: WidgetStatePropertyAll(EdgeInsets.zero),
          ),
          child: PrimaryScrollController.none(
            child: CalendarDateRangeSelector(
              initialStartDate: widget.dateRange?.start,
              initialEndDate: widget.dateRange?.end,
              onDateRangeChanged: (start, end) {
                widget.onDateRangeSelected?.call(start, end);
              },
            ),
          ),
        ),
      ],
      builder: (context, controller, child) => FilterButton(
        text: widget.dateRange == null
            ? 'Time Range'
            : '${DateFormat('dd MMM yy').format(widget.dateRange!.start)} - ${DateFormat('dd MMM yy').format(widget.dateRange!.end)}',
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
}
