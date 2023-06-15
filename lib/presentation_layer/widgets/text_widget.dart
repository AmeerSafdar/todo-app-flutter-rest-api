import 'package:flutter/material.dart';

class MyTextWidget extends StatelessWidget {
  String text;
  MyTextWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text);
  }
}
