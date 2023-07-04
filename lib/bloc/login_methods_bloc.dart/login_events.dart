import 'package:flutter/material.dart';

abstract class LoginEvents {}

class LoginEvnts extends LoginEvents {
  String email, password;
  BuildContext contxt;
  LoginEvnts(this.email, this.password, this.contxt);
}

class PassworsReset extends LoginEvents {
  String email;
  BuildContext context;
  PassworsReset({required this.email, required this.context});
}

class LogoutEvents extends LoginEvents {
  BuildContext cntxt;
  LogoutEvents({required this.cntxt});
}

class RegisterEvents extends LoginEvents {
  String name, uName, email, password;
  BuildContext context;
  RegisterEvents(
      {required this.name,
      required this.uName,
      required this.email,
      required this.password,
      required this.context});
}
