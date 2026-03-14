import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NamedTextField extends StatefulWidget {
  const NamedTextField({
    super.key,
    required this.name,
    this.hintText,
    this.controller,
    this.validator,
    this.keyboardType,
    this.visibilityButton = false,
  });

  final String name;
  final String? hintText;
  final bool visibilityButton;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  State<NamedTextField> createState() => _NamedTextFieldState();
}

class _NamedTextFieldState extends State<NamedTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(widget.name, style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: 5.h),
        TextFormField(
          obscureText: widget.visibilityButton ? _obscureText : false,
          obscuringCharacter: '*',
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          validator: _validatorPicker,
          cursorErrorColor: Theme.of(context).colorScheme.primary,
          style: Theme.of(context).textTheme.bodySmall,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Theme.of(context).colorScheme.primary.withAlpha(180),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.secondary,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
                width: 2,
              ),
            ),
            suffixIcon: widget.visibilityButton
                ? IconButton(
                    icon: SvgPicture.asset(
                      'assets/images/svgs/visibility_off.svg',
                    ),
                    onPressed: () {
                      setState(() => _obscureText = !_obscureText);
                    },
                  )
                : null,
          ),
        ),
      ],
    );
  }

  String? _validatorPicker(String? value) {
    if (widget.validator != null) {
      return widget.validator!(value);
    }
    return switch (widget.keyboardType) {
      TextInputType.emailAddress => _emailValidator(value),
      TextInputType.visiblePassword => _passwordValidator(value),
      TextInputType.name => _nameValidator(value),
      _ => _defaultValidator(value),
    };
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(
      r'^[A-Za-z0-9]+[A-Za-z0-9._%+-]*@[A-Za-z0-9]+(?:\.[A-Za-z0-9-]+)*\.[A-Za-z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  String? _nameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 3) {
      return 'Name must be at least 3 characters long';
    }
    final nameRegex = RegExp(r"^[A-Za-z]+(?:[ '\-][A-Za-z]+)*$");
    if (!nameRegex.hasMatch(value.trim())) {
      return 'Enter a valid name';
    }
    return null;
  }

  // String? _phoneValidator(String? value) {
  //   if (value == null || value.trim().isEmpty) {
  //     return 'Phone number is required';
  //   }
  //   final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
  //   if (!phoneRegex.hasMatch(value.trim())) {
  //     return 'Enter a valid phone number';
  //   }
  //   return null;
  // }

  String? _defaultValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }
}
