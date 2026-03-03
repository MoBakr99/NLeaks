import 'package:flutter/material.dart';

class NamedTextField extends StatefulWidget {
  const NamedTextField({
    super.key,
    required this.name,
    this.hintText,
    this.controller,
    this.validator,
    this.visibilityButton = false,
  });

  final String name;
  final String? hintText;
  final bool visibilityButton;
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
      children: [
        Text(widget.name),
        TextFormField(
          obscureText: widget.visibilityButton ? _obscureText : false,
          controller: widget.controller,
          validator:
              widget.validator ??
              (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'This field is required';
                }
                return null;
              },
          decoration: InputDecoration(
            hintText: widget.hintText,
            suffixIcon: widget.visibilityButton
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.black,
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
}
