import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertodoapi/helper/constant/const.dart';
import 'package:fluttertodoapi/model/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../enums/login.dart';
import '../../repository/login_method_repo/login_method.dart';
import 'login_events.dart';
import 'login_states.dart';

class LoginBloc extends Bloc<LoginEvents, LoginStates> {
  LoginMethodRepo loginMethodRepo = LoginMethodRepo();
  File? data;
  LoginBloc() : super(LoginStates()) {
    on<LoginEvnts>(_loggingIn);
    on<LogoutEvents>(_logout);
    on<RegisterEvents>(_register);
    on<PassworsReset>(_passwordReset);
    on<UserDataEvent>(_getUserData);
    on<PickImagesEvent>(_pickImage);
    on<UpdateUser>(_updateUser);
  }

  Future<void> _updateUser(UpdateUser event, Emitter<LoginStates> emit) async {
    try {
      loginMethodRepo.updateUserData(
          event.name, event.uName, event.img, event.photoURL);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _pickImage(
      PickImagesEvent event, Emitter<LoginStates> emit) async {
    Future<PermissionStatus> status = event.imgSRC == ImageSource.gallery
        ? permissionUtils.askCameraPermission(Permission.storage)
        : permissionUtils.askCameraPermission(Permission.camera);
    try {
      // data = await loginMethodRepo.pickImage(event.imgSRC!);
      if (await status.isDenied) {
        emit(state.copyWith(denied: true));
      }

      if (await status.isPermanentlyDenied) {
        emit(state.copyWith(permanent_denied: true, denied: false));
      } else if (await status.isGranted) {
        data = await loginMethodRepo.pickImage(event.imgSRC!);
        emit(
            state.copyWith(img: data!, denied: false, permanent_denied: false));
      }
    } catch (e) {
      emit(state.copyWith(permanent_denied: false, img: data));
    }
  }

  void _passwordReset(PassworsReset event, Emitter<LoginStates> emit) async {
    await loginMethodRepo.resetPassword(event.email, event.context);
  }

  void _getUserData(UserDataEvent event, Emitter<LoginStates> emit) async {
    try {
      UserModel user = await loginMethodRepo.getUser(userID);
      emit(state.copyWith(userModel: user));
    } catch (e) {
      print(e.toString());
    }
  }

  void _register(RegisterEvents event, Emitter<LoginStates> emit) async {
    try {
      emit(state.copyWith(status: LoginStatus.loading));
      var res = await loginMethodRepo.signupUser(event.email, event.password,
          event.name, event.uName, event.context, event.img!);

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
