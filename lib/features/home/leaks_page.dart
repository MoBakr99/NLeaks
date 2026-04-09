import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:n_leaks/features/home/widgets/leak_status_widget.dart';
import 'package:n_leaks/features/home/components/leaks_filter.dart';
import 'package:n_leaks/features/home/widgets/user_info_display.dart';

class LeaksAppBar extends StatefulWidget {
  const LeaksAppBar({super.key});

  @override
  State<LeaksAppBar> createState() => _LeaksAppBarState();
}

class _LeaksAppBarState extends State<LeaksAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      title: Text(
        'Leak Intelligence',
        style: Theme.of(context).textTheme.displayMedium,
      ),
    );
  }
}

class LeaksPage extends StatefulWidget {
  const LeaksPage({super.key});

  @override
  State<LeaksPage> createState() => _LeaksPageState();
}

class _LeaksPageState extends State<LeaksPage> {
  final List<Map<String, String>> _leaks = List.generate(
    20,
    (index) => {
      'name': 'Francisco Miles',
      'email': 'user@acme.com',
      'status': ['Unverified', 'Active', 'Inactive'][index % 3],
    },
  );

  DateTimeRange? _selectedDateRange;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 100.h,
          child: LeaksFilter(
            dateRange: _selectedDateRange,
            onStatusFilterPressed: _setStatusFilter,
            onDateRangeFilterPressed: _setDateRange,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _leaks.length,
            itemBuilder: (context, index) {
              final leak = _leaks[index];
              return Container(
                height: 80.h,
                padding: EdgeInsets.only(left: 16.w),
                margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: UserInfoDisplay(
                        name: leak['name']!,
                        email: leak['email']!,
                      ),
                    ),
                    LeakStatusWidget(status: leak['status']!),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.more_vert,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _setStatusFilter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter by Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Unverified', 'Active', 'Inactive']
              .map(
                (status) => CheckboxListTile(
                  title: Text(status),
                  value: false,
                  onChanged: (value) {},
                ),
              )
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _setDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
      initialDateRange: _selectedDateRange,
    );
    setState(() {
      _selectedDateRange = picked;
    });
  }
}
