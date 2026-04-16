import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:n_leaks/core/data/models/corp_model.dart';
import 'package:n_leaks/core/data/models/user_model.dart';

abstract class AccountEvent {}

class LogIn extends AccountEvent {
  final CorpModel account;

  LogIn(this.account);
}

class LogOut extends AccountEvent {}

class AddUser extends AccountEvent {
  final UserModel newUser;

  AddUser(this.newUser);
}

class UpdateUserInfo extends AccountEvent {
  final UserModel updatedUserInfo;

  UpdateUserInfo(this.updatedUserInfo);
}

class CorpController extends Bloc<AccountEvent, CorpModel?> {
  CorpController() : super(null) {
    on<LogIn>((event, emit) {
      emit(event.account);
    });

    on<LogOut>((event, emit) {
      emit(null);
    });

    on<UpdateUserInfo>((event, emit) {
      emit(state?.copyWith(currentUser: event.updatedUserInfo));
    });
  }
}
