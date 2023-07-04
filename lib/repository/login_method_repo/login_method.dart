// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertodoapi/helper/constant/const.dart';

import '../../helper/extension/snackbar.dart';
import '../../presentation_layer/views/home_screen.dart';

class LoginMethodRepo {
  Future<int> signOut(BuildContext cntxt) async {
    int res = 0;
    userID = FirebaseAuth.instance.currentUser!.uid;
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
            .then((value) => {
                  res = 1,
                });
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
      String uName, BuildContext context) async {
    int res = 0;
    try {
      if (userEmail.isNotEmpty || userPassword.isNotEmpty) {
        await auth
            .createUserWithEmailAndPassword(
                email: userEmail, password: userPassword)
            .then((value) => {
                  res = 1,
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
}
