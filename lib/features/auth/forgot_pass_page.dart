import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:n_leaks/core/constants/app_routes.dart';
import 'package:n_leaks/core/widgets/named_text_field.dart';
import 'package:n_leaks/features/auth/widgets/app_button.dart';
import 'package:n_leaks/features/auth/widgets/or_divider.dart';
import 'package:n_leaks/features/auth/widgets/social_buttons.dart';

class ForgotPassPage extends StatefulWidget {
  const ForgotPassPage({super.key});

  @override
  State<ForgotPassPage> createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Forgot your password?',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
              SizedBox(height: 16.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Let’s get you all set up so you can access your personal account.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              SizedBox(height: 40.h),
              Form(
                key: _formKey,
                child: NamedTextField(
                  name: 'Email',
                  hintText: 'Enter your email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              SizedBox(height: 24.h),
              AppButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Handle forgot password logic here
                    Navigator.pushReplacementNamed(context, verifyCodeRoute);
                  }
                },
                text: 'Submit',
              ),
              SizedBox(height: 40.h),
              const OrDivider(login: true),
              SizedBox(height: 20.h),
              SocialButtons(onPressed: [() {}, () {}, () {}]),
            ],
          ),
        ),
      ),
    );
  }
}
