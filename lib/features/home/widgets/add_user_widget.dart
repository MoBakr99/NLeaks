import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:n_leaks/core/controllers/corp_controller.dart';
import 'package:n_leaks/core/data/models/user_model.dart';
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
                        name: 'Username',
                        hintText: 'Enter user username',
                        controller: _controllers[1],
                      ),
                      NamedTextField(
                        name: 'Email',
                        hintText: 'Enter user email',
                        controller: _controllers[2],
                        keyboardType: TextInputType.emailAddress,
                      ),
                      NamedTextField(
                        name: 'Position',
                        hintText: 'Enter user position',
                        controller: _controllers[3],
                      ),
                      NamedTextField(
                        name: 'Gender',
                        hintText: 'Enter user gender',
                        controller: _controllers[4],
                        options: const ['Male', 'Female'],
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
                      context.read<CorpController>().add(
                        AddUser(
                          UserModel(
                            id: DateTime.now().millisecondsSinceEpoch
                                .toString(),
                            name: _controllers[0].text.trim(),
                            username: _controllers[1].text.trim(),
                            email: _controllers[2].text.trim(),
                            position: _controllers[3].text.trim(),
                            company: context.read<CorpController>().state!.name,
                            gender: _controllers[4].text.trim(),
                          ),
                        ),
                      );
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
