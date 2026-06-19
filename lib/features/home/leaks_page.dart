import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:n_leaks/core/controllers/token_controller.dart';
import 'package:n_leaks/core/data/models/leak_model.dart';
import 'package:n_leaks/core/services/api_service.dart';
import 'package:n_leaks/features/home/leak_details_page.dart';
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
      toolbarHeight: 80.h,
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

  Future<List<LeakModel>?> _fetchLeaks() async {
    final response = await APIService().getLeaks(
      context.read<TokenController>().state!,
      limit: 100,
    );
    return List<LeakModel>.from(
      response.data['data'].map(
        (leak) => LeakModel(
          name: leak['username'],
          email: leak['email'],
          password: leak['password'],
          severity: leak['severity'],
          detectionDate: DateTime.parse(leak['source']['discoveredAt']),
          verificationDate: leak['verifiedAt'] != null
              ? DateTime.parse(leak['verifiedAt'])
              : null,
          source: leak['source']['name'],
          description: leak['source']['description'],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 100.h,
          child: LeaksFilter(
            dateRange: _selectedDateRange,
            searchController: _searchController,
            onSearchChanged: (value) => setState(() {}),
            statusOptions: const ['low', 'medium', 'high', 'critical'],
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
        FutureBuilder(
          future: _fetchLeaks(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Expanded(
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              return Expanded(
                child: Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              );
            }

            final leaks = snapshot.data!;

            final filteredLeaks = leaks.where((leak) {
              final inDateRange = _selectedDateRange == null
                  ? true
                  : !leak.detectionDate.isBefore(_selectedDateRange!.start) &&
                        !leak.detectionDate.isAfter(_selectedDateRange!.end);

              final matchesSearch =
                  _searchController.text.isEmpty ||
                  leak.name.toLowerCase().contains(
                    _searchController.text.toLowerCase(),
                  ) ||
                  leak.email.toLowerCase().contains(
                    _searchController.text.toLowerCase(),
                  );

              final matchesStatus =
                  _selectedStatuses.isEmpty ||
                  _selectedStatuses.contains(leak.severity);

              return inDateRange && matchesSearch && matchesStatus;
            }).toList();

            if (filteredLeaks.isEmpty) {
              return Expanded(
                child: Center(
                  child: Text(
                    'No leaks found for the selected filters.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              );
            }
            return Expanded(
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
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15.r),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LeakDetailsPage(leak: leak),
                          ),
                        );
                      },
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: UserInfoDisplay(
                              name: leak.name,
                              email: leak.email,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: LeakStatusWidget(status: leak.severity),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
