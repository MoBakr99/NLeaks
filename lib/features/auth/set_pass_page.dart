import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:n_leaks/core/constants/app_routes.dart';
import 'package:n_leaks/core/widgets/named_text_field.dart';
import 'package:n_leaks/features/auth/widgets/app_button.dart';

class SetPassPage extends StatefulWidget {
  const SetPassPage({super.key});

  @override
  State<SetPassPage> createState() => _SetPassPageState();
}

class _SetPassPageState extends State<SetPassPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
            child: Form(
              key: _formKey,
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
                  NamedTextField(
                    name: 'Password',
                    hintText: 'Enter your new password',
                    controller: _passController,
                    keyboardType: TextInputType.visiblePassword,
                    visibilityButton: true,
                  ),
                  SizedBox(height: 32.h),
                  NamedTextField(
                    name: 'Confirm Password',
                    hintText: 'Confirm your new password',
                    controller: _confirmPassController,
                    keyboardType: TextInputType.visiblePassword,
                    visibilityButton: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Password is required';
                      }
                      if (value.trim().length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      if (value != _passController.text) {
                        return "Passwords don't match";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24.h),
                  AppButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Handle forgot password logic here
                        Navigator.pushReplacementNamed(context, loginRoute);
                      }
                    },
                    text: 'Submit',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
