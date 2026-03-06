import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key, required this.login});

  final bool login;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            thickness: 1,
            color: Theme.of(context).colorScheme.tertiary.withAlpha(127),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Or ${login ? 'login' : 'Sign up'} with',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: Theme.of(context).colorScheme.tertiary.withAlpha(127),
            ),
          ),
        ),
        Expanded(
          child: Divider(
            thickness: 1,
            color: Theme.of(context).colorScheme.tertiary.withAlpha(127),
          ),
        ),
      ],
    );
  }
}
