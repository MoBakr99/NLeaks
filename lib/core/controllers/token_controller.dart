import 'package:flutter_bloc/flutter_bloc.dart';

abstract class TokenEvent {}

class SetToken extends TokenEvent {
  final String? token;

  SetToken(this.token);
}

class ClearToken extends TokenEvent {}

class TokenController extends Bloc<TokenEvent, String?> {
  TokenController([super.initialState]) {
    on<SetToken>((event, emit) {
      emit(event.token);
    });

    on<ClearToken>((event, emit) {
      emit(null);
    });
  }
}
