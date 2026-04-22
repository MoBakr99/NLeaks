import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:n_leaks/features/auth/controllers/timer_controller.dart';

class TimerButton extends StatelessWidget {
  const TimerButton({super.key, required this.onPressed});

  final Function() onPressed;

  void _startTimer(BuildContext context) async {
    context.read<TimerController>().add(
      StartTimer(const Duration(minutes: 1)),
    );
    for (int i = 0; i < 60; i++) {
      await Future.delayed(const Duration(seconds: 1), () {
        if (context.mounted) {
          context.read<TimerController>().add(DecreaseTimer());
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          TimerController(const Duration(minutes: 0)),
      child: BlocBuilder<TimerController, Duration>(
        builder: (context, durationState) {
          return durationState.inSeconds > 0
              ? Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Resend ',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      TextSpan(
                        text:
                            '${(durationState.inSeconds ~/ 60).toString().padLeft(2, '0')}:${(durationState.inSeconds % 60).toString().padLeft(2, '0')}',
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
                    _startTimer(context);
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
      ),
    );
  }
}
