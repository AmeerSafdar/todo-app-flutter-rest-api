import 'package:flutter_bloc/flutter_bloc.dart';

import '../../enums/login.dart';
import '../../repository/login_method_repo/login_method.dart';
import 'login_events.dart';
import 'login_states.dart';

class LoginBloc extends Bloc<LoginEvents, LoginStates> {
  LoginMethodRepo loginMethodRepo = LoginMethodRepo();
  LoginBloc() : super(LoginStates()) {
    on<LoginEvnts>(_loggingIn);
    on<LogoutEvents>(_logout);
    on<RegisterEvents>(_register);
    on<PassworsReset>(_passwordReset);
  }

  void _passwordReset(PassworsReset event, Emitter<LoginStates> emit) async {
    await loginMethodRepo.resetPassword(event.email, event.context);
  }

  void _register(RegisterEvents event, Emitter<LoginStates> emit) async {
    try {
      emit(state.copyWith(status: LoginStatus.loading));
      var res = await loginMethodRepo.signupUser(
          event.email, event.password, event.name, event.uName, event.context);

      emit(state.copyWith(status: LoginStatus.login));
      print("res is $res");
    } catch (e) {
      print("error sinup: ${e.toString()}");
    }
  }

  void _logout(LogoutEvents event, Emitter<LoginStates> emit) {
    try {
      emit(state.copyWith(status: LoginStatus.loading));
      loginMethodRepo.signOut(event.cntxt);
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.error));
    }
  }

  void _loggingIn(LoginEvnts event, Emitter<LoginStates> emit) async {
    try {
      print("login method called");
      emit(state.copyWith(status: LoginStatus.loading));
      int res = await loginMethodRepo.loginUser(
          event.email, event.password, event.contxt);
      if (res == 1) {
        emit(state.copyWith(status: LoginStatus.login));
      }
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.error));
    }
  }
}
