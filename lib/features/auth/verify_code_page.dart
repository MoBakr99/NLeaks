import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:n_leaks/core/constants/app_routes.dart';
import 'package:n_leaks/core/services/api_service.dart';
import 'package:n_leaks/core/widgets/named_text_field.dart';
import 'package:n_leaks/features/auth/widgets/app_button.dart';
import 'package:n_leaks/features/auth/widgets/timer_button.dart';

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
    _formKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String email = ModalRoute.of(context)!.settings.arguments as String;
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
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: <Widget>[
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
                  maxLength: 6,
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: <Widget>[
                  Text(
                    "Didn't receive a code? ",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  TimerButton(
                    onPressed: () {
                      APIService().sendOTP(email);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Verification code resent!',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.onSurface,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              AppButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final verified = await APIService().verifyOTP(
                      email,
                      _codeController.text.trim(),
                    );
                    if (verified.statusCode == 200 && context.mounted) {
                      Navigator.pushReplacementNamed(context, resetPassRoute);
                    } else if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Verification Failed'),
                          content: const Text('Check your OTP and try again.'),
                          titleTextStyle: Theme.of(
                            context,
                          ).textTheme.titleLarge,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.onSurface,
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
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
