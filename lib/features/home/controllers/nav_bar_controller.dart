import 'package:flutter_bloc/flutter_bloc.dart';

abstract class NavBarEvent {}

class SetIndex extends NavBarEvent {
  final int index;

  SetIndex(this.index);
}

class NavBarController extends Bloc<NavBarEvent, int> {
  NavBarController(super.initialState) {
    on<SetIndex>((event, emit) => emit(event.index));
  }
}