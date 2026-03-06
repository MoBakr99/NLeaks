import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:n_leaks/core/constants/app_routes.dart';
import 'package:n_leaks/core/widgets/named_text_field.dart';
import 'package:n_leaks/features/auth/widgets/app_button.dart';

class VerifyCodePage extends StatefulWidget {
  const VerifyCodePage({super.key});

  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _codeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 120.w,
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(padding: EdgeInsets.only(left: 15.w)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.arrow_back_ios_new_outlined,
                size: 16.sp,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(width: 4.w),
              Text(
                'Back to login',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Verify Code',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
              SizedBox(height: 16.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'An authentication code has been sent to your email.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              SizedBox(height: 40.h),
              Form(
                key: _formKey,
                child: NamedTextField(
                  name: 'Enter Code',
                  hintText: 'Enter the code sent to your email',
                  controller: _codeController,
                ),
              ),
              Row(
                children: <Widget>[
                  Text(
                    "Didn't receive a code?",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Handle resend code logic here
                    },
                    child: Text(
                      'Resend',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall!.copyWith(color: Color(0xFFFF8682)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              AppButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Handle forgot password logic here
                    Navigator.pushReplacementNamed(context, resetPassRoute);
                  }
                },
                text: 'Submit',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
