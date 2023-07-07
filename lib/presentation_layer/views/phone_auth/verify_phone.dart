import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertodoapi/presentation_layer/widgets/btn_widget.dart';
import 'package:fluttertodoapi/presentation_layer/widgets/sizedBox.dart';
import 'package:fluttertodoapi/presentation_layer/widgets/text_widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../helper/constant/const.dart';
import '../home_screen.dart';

class VerifyPhoneNumber extends StatefulWidget {
  String phoneNumber = '', verificationID = '';
  VerifyPhoneNumber(
      {super.key, required this.phoneNumber, required this.verificationID});

  @override
  State<VerifyPhoneNumber> createState() => _VerifyPhoneNumberState();
}

class _VerifyPhoneNumberState extends State<VerifyPhoneNumber> {
  TextEditingController textEditingController = TextEditingController();

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Form(
          key: formKey,
          child: Column(
              //
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyTextWidget(text: "Code sent to: ${widget.phoneNumber}"),
                SizeBoxWidget(),
                SizeBoxWidget(),
                PinCodeTextField(
                  appContext: context,

                  enablePinAutofill: true,
                  autoDismissKeyboard: true,
                  pastedTextStyle: TextStyle(
                    color: Colors.green.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                  length: 6,
                  obscureText: true,
                  obscuringCharacter: '*',
                  // obscuringWidget: const FlutterLogo(
                  //   size: 24,
                  // ),
                  blinkWhenObscuring: true,
                  animationType: AnimationType.fade,
                  validator: (v) {
                    if (v!.length < 3) {
                      return "I'm from validator";
                    } else {
                      return null;
                    }
                  },
                  pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                      inactiveFillColor: Colors.green),
                  cursorColor: Colors.black,
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  // errorAnimationController: errorController,
                  controller: textEditingController,
                  keyboardType: TextInputType.number,
                  boxShadows: const [
                    BoxShadow(
                      offset: Offset(0, 1),
                      color: Colors.black12,
                      blurRadius: 10,
                    )
                  ],
                  onCompleted: (v) {
                    debugPrint("Completed");
                  },
                  // onTap: () {
                  //   print("Pressed");
                  // },
                  onChanged: (value) {
                    debugPrint(value);
                    setState(() {
                      currentText = value;
                    });
                  },
                  beforeTextPaste: (text) {
                    debugPrint("Allowing to paste $text");
                    return true;
                  },
                ),
                SizeBoxWidget(),
                Container(
                  width: double.infinity,
                  child: ButtonWidget(
                      btnText: "Verify",
                      press: () {
                        if (formKey.currentState!.validate()) {
                          AuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: widget.verificationID,
                                  smsCode: textEditingController.text);

                          auth.signInWithCredential(credential).then((result) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) => const HomeScreen()),
                                ),
                                (Route<dynamic> route) => false);
                          }).catchError((e) {
                            print(e);
                          });
                          // _credential = PhoneAuthProvider.getCredential(
                          //         verificationId: widget.verificationID, smsCode: textEditingController.text);
                        }
                      }),
                )
              ]),
        ),
      ),
    );
  }
}
