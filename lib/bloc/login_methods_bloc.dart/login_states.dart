import 'package:fluttertodoapi/enums/login.dart';

class LoginStates {
  LoginStates({
    this.status = LoginStatus.initial,
  });

  final LoginStatus status;

  LoginStates copyWith({
    LoginStatus? status,
  }) {
    return LoginStates(
      status: status ?? this.status,
    );
  }
}
