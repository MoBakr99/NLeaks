import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:n_leaks/core/widgets/named_text_field.dart';
import 'package:n_leaks/features/settings/widgets/app_material_button.dart';

class AddNewUserDialog extends StatefulWidget {
  const AddNewUserDialog({super.key});

  @override
  State<AddNewUserDialog> createState() => _AddNewUserDialogState();
}

class _AddNewUserDialogState extends State<AddNewUserDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  void dispose() {
    _controllers.map((controller) => controller.dispose());
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        alignment: Alignment.center,
        width: 380.w,
        height: 500.h,
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Add New User',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    size: 24.sp,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ],
            ),
            Divider(
              color: Theme.of(context).colorScheme.tertiary,
              height: 20.h,
            ),
            SizedBox(
              height: 310.h,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    spacing: 20.h,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NamedTextField(
                        name: 'Name',
                        hintText: 'Enter user name',
                        controller: _controllers[0],
                        keyboardType: TextInputType.name,
                      ),
                      NamedTextField(
                        name: 'Email',
                        hintText: 'Enter user email',
                        controller: _controllers[1],
                        keyboardType: TextInputType.emailAddress,
                      ),
                      NamedTextField(
                        name: 'Role',
                        hintText: 'Enter user role',
                        controller: _controllers[2],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Divider(
              color: Theme.of(context).colorScheme.tertiary,
              height: 20.h,
            ),
            Row(
              spacing: 10.w,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppMaterialButton(
                  child: Text(
                    'Cancel',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                AppMaterialButton(
                  child: Row(
                    spacing: 10.w,
                    children: [
                      SvgPicture.asset(
                        'assets/images/svgs/send_icon.svg',
                        width: 15.w,
                      ),
                      Text(
                        'Send Invitation',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Simulate sending invitation to the server
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
