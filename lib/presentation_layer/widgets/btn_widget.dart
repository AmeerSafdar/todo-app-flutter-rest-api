// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../helper/constant/dimensions.dart';
import 'text_widget.dart';

class ButtonWidget extends StatelessWidget {
  ButtonWidget({super.key, required this.btnText, required this.press});

  String btnText;
  VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(Dimensions.RADIUS_EXTRA_LARGE))),
        onPressed: press,
        child: MyTextWidget(text: btnText));
  }
}
