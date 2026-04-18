import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:n_leaks/core/controllers/corp_controller.dart';
import 'package:n_leaks/core/data/models/leak_model.dart';
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
  DateTimeRange? _selectedDateRange;
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selectedStatuses = <String>{};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<LeakModel>? leaks = context.watch<CorpController>().state!.leaks;

    final filteredLeaks = leaks?.where((leak) {
      final inDateRange = _selectedDateRange == null
          ? true
          : !leak.date.isBefore(_selectedDateRange!.start) &&
                !leak.date.isAfter(_selectedDateRange!.end);

      final matchesSearch =
          _searchController.text.isEmpty ||
          leak.name.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          ) ||
          leak.email.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          );

      final matchesStatus =
          _selectedStatuses.isEmpty || _selectedStatuses.contains(leak.status);

      return inDateRange && matchesSearch && matchesStatus;
    }).toList();
    return Column(
      children: <Widget>[
        SizedBox(
          height: 100.h,
          child: LeaksFilter(
            dateRange: _selectedDateRange,
            searchController: _searchController,
            onSearchChanged: (value) => setState(() {}),
            statusOptions: const ['Unverified', 'Active', 'Inactive'],
            selectedStatuses: _selectedStatuses,
            onStatusSelectionChanged: (values) {
              setState(() {
                _selectedStatuses
                  ..clear()
                  ..addAll(values);
              });
            },
            onDateRangeSelected: (start, end) {
              setState(() {
                if (start != null && end != null) {
                  _selectedDateRange = DateTimeRange(start: start, end: end);
                } else {
                  _selectedDateRange = null;
                }
              });
            },
          ),
        ),
        filteredLeaks == null || filteredLeaks.isEmpty
            ? Expanded(
                child: Center(
                  child: Text(
                    'No leaks found for the selected filters.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              )
            : Expanded(
                child: ListView.builder(
                  itemCount: filteredLeaks.length,
                  itemBuilder: (context, index) {
                    final leak = filteredLeaks[index];
                    return Container(
                      height: 80.h,
                      padding: EdgeInsets.only(left: 16.w),
                      margin: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSurface,
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: UserInfoDisplay(
                              name: leak.name,
                              email: leak.email,
                            ),
                          ),
                          LeakStatusWidget(status: leak.status),
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
}
