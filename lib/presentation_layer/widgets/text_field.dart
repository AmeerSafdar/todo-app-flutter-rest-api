// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fluttertodoapi/helper/constant/dimensions.dart';

class MyTextField extends StatelessWidget {
  String hint;
  TextEditingController cntrl;
  int? maxLine;
  bool obsecureTxt;
  final String? Function(String? val) validator;
  MyTextField(
      {super.key,
      required this.hint,
      required this.cntrl,
      this.maxLine,
      required this.validator,
      this.obsecureTxt = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: cntrl,
      validator: validator,
      maxLines: obsecureTxt ? 1 : maxLine,
      obscureText: obsecureTxt,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
              vertical: Dimensions.D_0,
              horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          hintText: hint,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT))),
    );
  }
}
