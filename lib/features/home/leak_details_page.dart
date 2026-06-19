import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:n_leaks/core/data/models/leak_model.dart';
import 'package:n_leaks/features/home/widgets/leak_status_widget.dart';

class LeakDetailsPage extends StatelessWidget {
  const LeakDetailsPage({super.key, required this.leak});

  final LeakModel leak;

  @override
  Widget build(BuildContext context) {
    final String detectionDate = DateFormat(
      'MMM d, yyyy - h:mm a',
    ).format(leak.detectionDate);
    final String verificationDate = leak.verificationDate == null
        ? 'Not verified yet'
        : DateFormat('MMM d, yyyy - h:mm a').format(leak.verificationDate!);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Theme.of(context).colorScheme.tertiary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Leak Details',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          leak.name,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ),
                      LeakStatusWidget(status: leak.severity),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    leak.email,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            _DetailSection(
              title: 'Leak Information',
              children: <Widget>[
                _DetailRow(
                  label: 'Password',
                  value: leak.password ?? 'Not available',
                ),
                _DetailRow(label: 'Source', value: leak.source),
                _DetailRow(label: 'Detected', value: detectionDate),
                _DetailRow(label: 'Verified', value: verificationDate),
                _DetailRow(
                  label: 'Description',
                  value: leak.description?.trim().isNotEmpty == true
                      ? leak.description!
                      : 'No description available',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 16.h),
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          SizedBox(height: 4.h),
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
