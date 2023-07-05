import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

abstract class LoginEvents {}

class LoginEvnts extends LoginEvents {
  String email, password;
  BuildContext contxt;
  LoginEvnts(this.email, this.password, this.contxt);
}

class UserDataEvent extends LoginEvents {}

class PickImagesEvent extends LoginEvents {
  ImageSource? imgSRC;
  PickImagesEvent({this.imgSRC});
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
  File? img;
  BuildContext context;
  RegisterEvents(
      {required this.name,
      required this.uName,
      required this.email,
      required this.password,
      this.img,
      required this.context});
}

class UpdateUser extends LoginEvents {
  String name, uName;
  File? img;
  String photoURL;
  UpdateUser(
      {required this.name,
      required this.uName,
      this.img,
      required this.photoURL});
}
