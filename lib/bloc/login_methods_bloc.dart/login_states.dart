import 'dart:io';
import 'dart:typed_data';

import 'package:fluttertodoapi/enums/login.dart';
import 'package:fluttertodoapi/model/user_model.dart';

class LoginStates {
  LoginStates(
      {this.status = LoginStatus.initial,
      this.userModel,
      this.img,
      this.denied,
      this.permanent_denied});

  final LoginStatus status;

  UserModel? userModel;

  final File? img;
  bool? denied;
  bool? permanent_denied;

  LoginStates copyWith(
      {LoginStatus? status,
      UserModel? userModel,
      File? img,
      bool? denied,
      bool? permanent_denied}) {
    return LoginStates(
        status: status ?? this.status,
        userModel: userModel ?? this.userModel,
        img: img ?? this.img,
        denied: denied ?? this.denied,
        permanent_denied: permanent_denied ?? this.permanent_denied);
  }
}
