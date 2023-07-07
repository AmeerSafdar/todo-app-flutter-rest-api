import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertodoapi/helper/constant/string_helper.dart';
import 'package:fluttertodoapi/helper/extension/validation_helper.dart';
import 'package:fluttertodoapi/presentation_layer/views/phone_auth/verify_phone.dart';
import 'package:fluttertodoapi/presentation_layer/widgets/btn_widget.dart';
import 'package:fluttertodoapi/presentation_layer/widgets/sizedBox.dart';
import 'package:fluttertodoapi/presentation_layer/widgets/text_field.dart';

import '../../../helper/constant/const.dart';

class PhoneAuthScreen extends StatefulWidget {
  PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  TextEditingController _phonecontroller = TextEditingController();
  String prefix = '+39';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                CountryCodePicker(
                  onChanged: (value) {
                    print("country value is $value");
                    prefix = value.toString();
                  },
                  // // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                  // initialSelection: 'IT',
                  // favorite: const ['+39', 'FR'],
                  countryFilter: const ['IT', 'FR', 'PS', 'PK'],
                  // flag can be styled with BoxDecoration's `borderRadius` and `shape` fields
                  flagDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                Expanded(
                  child: MyTextField(
                    hint: StringHelper.PHONE,
                    cntrl: _phonecontroller,
                    validator: (v) =>
                        '$v'.isRequired() ? null : StringHelper.VALIDITY,
                  ),
                ),
              ],
            ),
            SizeBoxWidget(
              heights: 10,
            ),
            Container(
              width: double.infinity,
              child: ButtonWidget(
                  btnText: StringHelper.SEND_CODE,
                  press: () async {
                    try {
                      await auth.verifyPhoneNumber(
                        phoneNumber: "$prefix${_phonecontroller.text}",
                        verificationCompleted:
                            (PhoneAuthCredential credential) {
                          print("credential is ${credential.smsCode}");
                        },
                        verificationFailed: (FirebaseAuthException e) {
                          print("verify failed: ${e.toString()}");
                        },
                        codeSent: (String verificationId, int? resendToken) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => VerifyPhoneNumber(
                                        phoneNumber:
                                            "$prefix${_phonecontroller.text}",
                                        verificationID: verificationId,
                                      ))));
                          print(
                              "code send is : $verificationId  \n token is $resendToken");
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {},
                      );
                    } catch (e) {
                      print("error occurs: ${e.toString()}");
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
