import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:n_leaks/features/home/widgets/filter_button.dart';

class LeaksFilter extends StatefulWidget {
  const LeaksFilter({
    super.key,
    this.dateRange,
    this.onStatusFilterPressed,
    this.onDateRangeFilterPressed,
  });

  final DateTimeRange? dateRange;
  final Function()? onStatusFilterPressed;
  final Function()? onDateRangeFilterPressed;

  @override
  State<LeaksFilter> createState() => _LeaksFilterState();
}

class _LeaksFilterState extends State<LeaksFilter> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 43.h,
            child: TextFormField(
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Search for anything',
                hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.tertiary.withValues(alpha: 0.6),
                ),
                suffixIcon: Icon(
                  Icons.search,
                  color: Theme.of(
                    context,
                  ).colorScheme.tertiary.withValues(alpha: 0.6),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              FilterButton(
                text: 'Status',
                onPressed: widget.onStatusFilterPressed,
              ),
              SizedBox(width: 18.w),
              FilterButton(
                text: widget.dateRange == null
                    ? 'Time Range'
                    : '${DateFormat('dd MMM yy').format(widget.dateRange!.start)} - ${DateFormat('dd MMM yy').format(widget.dateRange!.end)}',
                onPressed: widget.onDateRangeFilterPressed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
