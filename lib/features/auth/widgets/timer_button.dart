import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:n_leaks/features/auth/controllers/timer_controller.dart';

class TimerButton extends StatelessWidget {
  const TimerButton({super.key, required this.onPressed});

  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerController, Duration>(
      builder: (context, durationState) {
        final seconds = durationState.inSeconds;
        return seconds > 0
            ? Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Resend ',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    TextSpan(
                      text:
                          '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              )
            : TextButton(
                onPressed: () {
                  // _startTimer(context);
                  context.read<TimerController>().add(
                    StartTimer(const Duration(minutes: 1)),
                  );
                  onPressed();
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Resend',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
      },
    );
  }
}
