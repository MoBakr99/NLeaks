import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DomainsInputField extends StatefulWidget {
  const DomainsInputField({super.key, required this.domains, this.controller});

  final List<String> domains;
  final TextEditingController? controller;

  @override
  State<DomainsInputField> createState() => _DomainsInputFieldState();
}

class _DomainsInputFieldState extends State<DomainsInputField> {
  late final List<String> _domains;
  @override
  void initState() {
    super.initState();
    _domains = List<String>.from(widget.domains);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Domain Management',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 10.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              ..._domains.map(
                (domain) => Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.w,
                    vertical: 13.h,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        domain,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      SizedBox(width: 10.w),
                      InkWell(
                        onTap: () => setState(() => _domains.remove(domain)),
                        child: Icon(
                          Icons.close,
                          size: 15.sp,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: TextField(
                  controller: widget.controller,
                  cursorColor: Theme.of(context).colorScheme.primary,
                  onSubmitted: (value) {
                    final String normalized = value.trim().toLowerCase();
                    if (normalized.isEmpty || _domains.contains(normalized)) {
                      widget.controller?.clear();
                      return;
                    }
                    setState(() {
                      _domains.add(normalized);
                      widget.controller?.clear();
                    });
                  },
                  style: Theme.of(context).textTheme.bodySmall,
                  decoration: InputDecoration(
                    hintText: 'Add a domain...',
                    hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.tertiary.withValues(alpha: 0.8),
                    ),
                    isDense: true,
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
