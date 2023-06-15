// ignore_for_file: prefer_const_constructors, sort_child_properties_last, sized_box_for_whitespace, unnecessary_string_interpolations, unused_local_variable, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:fluttertodoapi/helper/constant/string_helper.dart';
import 'package:fluttertodoapi/presentation_layer/widgets/text_widget.dart';

import '../../presentation_layer/widgets/sizedBox.dart';
import '../../presentation_layer/widgets/text_field.dart';
import '../constant/const.dart';
import '../constant/dimensions.dart';
import '../constant/screen_percentage.dart';

class DialogUtils {
  TextEditingController updateController = TextEditingController();

  static dialogBox(BuildContext context, String txt, String description) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
        title: MyTextWidget(text: StringHelper.UPDATE),
        content: SingleChildScrollView(
            child: Column(children: <Widget>[
          Container(
            height: size.height * ScreenPercentage.SCREEN_SIZE_25,
            child: Padding(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyTextField(
                    cntrl: titleUpdatecontroller..text = '$txt',
                    hint: '',
                  ),
                  SizeBoxWidget(),
                  MyTextField(
                    cntrl: desCUpdatecontroller..text = '$description',
                    hint: '',
                  ),
                  SizeBoxWidget(),
                  Row(
                    children: [
                      SizedBox(
                        width: size.width * ScreenPercentage.SCREEN_SIZE_25,
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context, -1),
                            child: MyTextWidget(
                              text: StringHelper.CANCEL,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * ScreenPercentage.SCREEN_SIZE_30,
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              if (titleUpdatecontroller.text.isNotEmpty &&
                                  desCUpdatecontroller.text.isNotEmpty) {
                                Navigator.pop(context, 1);
                              }
                            },
                            child: MyTextWidget(
                              text: StringHelper.UPDATE,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ])));
  }
}
