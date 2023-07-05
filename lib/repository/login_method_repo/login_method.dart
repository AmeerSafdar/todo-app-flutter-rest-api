// ignore_for_file: use_build_context_synchronously, unnecessary_cast

import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertodoapi/helper/constant/const.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../helper/extension/snackbar.dart';
import '../../model/user_model.dart';
import '../../presentation_layer/views/home_screen.dart';

class LoginMethodRepo {
  Future<int> signOut(BuildContext cntxt) async {
    int res = 0;
    userID = FirebaseAuth.instance.currentUser!.uid;
    UserModel? userData;
    await auth.signOut().then((value) {
      res = 1;
      userID = '';
      // cntxt.snaxkbar('Sign-Out');
      // Navigator.pushAndRemoveUntil(
      //     cntxt,
      //     MaterialPageRoute(
      //       builder: ((context) => LoginScreen()),
      //     ),
      //     (Route<dynamic> route) => false);
      // Navigator.pushReplacement(
      //     cntxt, MaterialPageRoute(builder: (context) => LoginScreen()));
    });
    userID = '';
    // showSnackbar(cntxt, 'Sign-Out');
    cntxt.snaxkbar('Sign-Out');
    return res;
  }

  Future<int> loginUser(
      String userEmail, String userPassword, BuildContext context) async {
    int res = 0;
    try {
      if (userEmail.isNotEmpty || userPassword.isNotEmpty) {
        await auth
            .signInWithEmailAndPassword(
                email: userEmail, password: userPassword)
            .then((value) => {res = 1, getUser(value.user!.uid)});
      }
    } catch (e) {
      // showSnackbar(context, e.toString());
      context.snaxkbar(e.toString());
    }
    return res;
  }

  Future<int> resetPassword(String email, BuildContext context) async {
    int res = 0;
    try {
      await auth.sendPasswordResetEmail(email: email).then((value) => {
            res = 1,
            // Navigator.pushAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(
            //       builder: ((context) => const HomeScreen()),
            //     ),
            //     (Route<dynamic> route) => false)
            Navigator.pop(context),
            context.snaxkbar("Password reset link sent")
          });
    } catch (e) {
      // showSnackbar(context, e.toString());
      context.snaxkbar(e.toString());
    }
    return res;
  }

  Future<int> signupUser(String userEmail, String userPassword, String name,
      String uName, BuildContext context, File img) async {
    int res = 0;
    try {
      if (userEmail.isNotEmpty || userPassword.isNotEmpty) {
        String urlImg = await uploadImagetoStorage(img);
        //save to model
        Map<String, dynamic> userinfo = {
          "email": userEmail,
          "username": uName,
          "name": name,
          "photo": urlImg,
          "password": "",
          // "photourl": "photoUrl",
          // "time": DateTime.now(),
        };
        await auth
            .createUserWithEmailAndPassword(
                email: userEmail, password: userPassword)
            .then((value) => {
                  res = 1,

                  ///save to firestore
                  firebaseFirestore
                      .collection("users")
                      .doc(value.user!.uid)
                      .set(userinfo)
                      .then((value1) {
                    getUser(value.user!.uid);
                    print("users added to firestore");
                  }),
                  //data user saved
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => const HomeScreen()),
                      ),
                      (Route<dynamic> route) => false)
                });
      }
    } catch (e) {
      // showSnackbar(context, e.toString());
      context.snaxkbar(e.toString());
    }
    return res;
  }

  Future<UserModel> getUser(String uid) async {
    DocumentSnapshot doc =
        await firebaseFirestore.collection("users").doc(uid).get();

    UserModel userVal = UserModel.fromJson(doc);
    data_user = userVal;
    return userVal;
    // print("user is = ${userVal.name}");

    // return
  }

  Future<String> uploadImagetoStorage(File file) async {
    Uint8List bytes = file.readAsBytesSync() as Uint8List;
    Reference ref = firebaseStorage
        .ref()
        .child("profilepic")
        .child(DateTime.now().toString());

    ref = ref.child(Uuid().v1());
    // if (isPost) {
    //   String id = Uuid().v1();
    //   ref = ref.child(id);
    // }
    UploadTask uploadTask = ref.putData(bytes);
    TaskSnapshot snap = await uploadTask;
    String downloadurl = await snap.ref.getDownloadURL();
    return downloadurl;
  }

  Future<File?> pickImage(ImageSource imageType) async {
    File? pickedImage;
    try {
      final photo = await ImagePicker().pickImage(source: imageType);
      final tempImage = File(photo!.path);
      pickedImage = tempImage;
    } catch (error) {
      throw error;
    }
    return pickedImage;
  }

  updateUserData(String name, String uName, File? file, String photoURL) async {
    String? imgURL;
    if (file != null) {
      imgURL = await uploadImagetoStorage(file);
    }
    firebaseFirestore.collection("users").doc(auth.currentUser!.uid).update({
      "name": name,
      "username": uName,
      "photo": imgURL ?? photoURL,
    });
  }
}
