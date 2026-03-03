import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ElevatedButton(
          onPressed: () {},
          child: SvgPicture.asset('assets/images/svgs/facebook_logo.svg'),
        ),
        ElevatedButton(
          onPressed: () {},
          child: SvgPicture.asset('assets/images/svgs/google_logo.svg'),
        ),
        ElevatedButton(
          onPressed: () {},
          child: SvgPicture.asset('assets/images/svgs/apple_logo.svg'),
        ),
      ],
    );
  }
}
