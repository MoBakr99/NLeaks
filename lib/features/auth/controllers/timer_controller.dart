import 'package:flutter_bloc/flutter_bloc.dart';

class TimerEvent {}

class StartTimer extends TimerEvent {
  final Duration duration;

  StartTimer(this.duration);
}

class TimerController extends Bloc<TimerEvent, Duration> {
  TimerController([super.initialState = const Duration(minutes: 0)]) {
    on<StartTimer>((event, emit) async {
      emit(event.duration);
      for (int i = 1; i <= event.duration.inSeconds; i++) {
        await Future.delayed(const Duration(seconds: 1), () {
          if (state.inSeconds > 0) {
            emit(event.duration - Duration(seconds: i));
          }
        });
      }
    });
  }
}
