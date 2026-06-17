import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:n_leaks/core/constants/app_routes.dart';
import 'package:n_leaks/core/services/api_service.dart';
import 'package:n_leaks/core/widgets/named_text_field.dart';
import 'package:n_leaks/features/auth/controllers/timer_controller.dart';
import 'package:n_leaks/features/auth/widgets/app_button.dart';

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
    _formKey.currentState?.dispose();
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
                style: Theme.of(context).textTheme.labelMedium,
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
                  'Don’t worry, happens to all of us. Enter your email below to recover your password.',
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
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final sent = await _sendOTP(_emailController.text.trim());
                    if (sent && context.mounted) {
                      context.read<TimerController>().add(
                        StartTimer(const Duration(minutes: 1)),
                      );
                      Navigator.pushReplacementNamed(
                        context,
                        verifyCodeRoute,
                        arguments: _emailController.text.trim(),
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

  Future<bool> _sendOTP(String email) async {
    try {
      final response = await APIService().sendOTP(email);
      if (response.statusCode != 200 && mounted) {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text('Failed to send OTP'),
              content: Text(
                response.data['message'] ?? 'Check your email and try again.',
              ),
              titleTextStyle: Theme.of(context).textTheme.titleLarge,
              backgroundColor: Theme.of(context).colorScheme.onSurface,
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return false;
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text('Failed to send OTP'),
              content: Text('Error: $e'),
              titleTextStyle: Theme.of(context).textTheme.titleLarge,
              backgroundColor: Theme.of(context).colorScheme.onSurface,
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
    return true;
  }
}
